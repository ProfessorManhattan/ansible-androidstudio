"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const utils_1 = require("../utils");
const case_variation_1 = require("../utils/regexp-ast/case-variation");
const mention_1 = require("../utils/mention");
const get_usage_of_pattern_1 = require("../utils/get-usage-of-pattern");
const ELEMENT_ORDER = {
    Character: 1,
    CharacterClassRange: 2,
    CharacterSet: 3,
};
function findUseless(elements, getCharSet, other) {
    const cache = new Map();
    function get(e) {
        let cached = cache.get(e);
        if (cached === undefined) {
            cached = getCharSet(e);
            cache.set(e, cached);
        }
        return cached;
    }
    const sortedElements = [...elements]
        .reverse()
        .sort((a, b) => ELEMENT_ORDER[a.type] - ELEMENT_ORDER[b.type]);
    const useless = new Set();
    for (const e of sortedElements) {
        const cs = get(e);
        if (cs.isSubsetOf(other)) {
            useless.add(e);
            continue;
        }
        const otherElements = elements.filter((o) => o !== e && !useless.has(o));
        const total = other.union(...otherElements.map(get));
        if (cs.isSubsetOf(total)) {
            useless.add(e);
            continue;
        }
    }
    return useless;
}
function without(iter, set) {
    const result = [];
    for (const item of iter) {
        if (!set.has(item)) {
            result.push(item);
        }
    }
    return result;
}
function removeAll(fixer, patternSource, ranges) {
    const sorted = [...ranges].sort((a, b) => b.start - a.start);
    let pattern = patternSource.value;
    for (const { start, end } of sorted) {
        pattern = pattern.slice(0, start) + pattern.slice(end);
    }
    const range = patternSource.getReplaceRange({
        start: 0,
        end: patternSource.value.length,
    });
    if (range) {
        return range.replace(fixer, pattern);
    }
    return null;
}
exports.default = (0, utils_1.createRule)("use-ignore-case", {
    meta: {
        docs: {
            description: "use the `i` flag if it simplifies the pattern",
            category: "Best Practices",
            recommended: false,
        },
        fixable: "code",
        schema: [],
        messages: {
            unexpected: "The character class(es) {{ classes }} can be simplified using the `i` flag.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor(regexpContext) {
            const { node, flags, ownsFlags, flagsString, patternAst, patternSource, getUsageOfPattern, getFlagsLocation, fixReplaceFlags, } = regexpContext;
            if (!ownsFlags || flagsString === null) {
                return {};
            }
            if (flags.ignoreCase) {
                return {};
            }
            if (getUsageOfPattern() === get_usage_of_pattern_1.UsageOfPattern.partial) {
                return {};
            }
            if ((0, case_variation_1.isCaseVariant)(patternAst, flags)) {
                return {};
            }
            const uselessElements = [];
            const ccs = [];
            return {
                onCharacterClassEnter(ccNode) {
                    const invariantElement = ccNode.elements.filter((e) => !(0, case_variation_1.isCaseVariant)(e, flags));
                    if (invariantElement.length === ccNode.elements.length) {
                        return;
                    }
                    const invariant = regexp_ast_analysis_1.Chars.empty(flags).union(...invariantElement.map((e) => (0, regexp_ast_analysis_1.toCharSet)(e, flags)));
                    let variantElements = without(ccNode.elements, new Set(invariantElement));
                    const alwaysUseless = findUseless(variantElements, (e) => (0, regexp_ast_analysis_1.toCharSet)(e, flags), invariant);
                    variantElements = without(variantElements, alwaysUseless);
                    const iFlags = (0, case_variation_1.getIgnoreCaseFlags)(flags);
                    const useless = findUseless(variantElements, (e) => (0, regexp_ast_analysis_1.toCharSet)(e, iFlags), invariant);
                    uselessElements.push(...useless);
                    ccs.push(ccNode);
                },
                onPatternLeave() {
                    if (uselessElements.length === 0) {
                        return;
                    }
                    context.report({
                        node,
                        loc: getFlagsLocation(),
                        messageId: "unexpected",
                        data: {
                            classes: ccs.map((cc) => (0, mention_1.mention)(cc)).join(", "),
                        },
                        fix(fixer) {
                            const patternFix = removeAll(fixer, patternSource, uselessElements);
                            if (!patternFix) {
                                return null;
                            }
                            const flagsFix = fixReplaceFlags(`${flagsString}i`, false)(fixer);
                            if (!flagsFix) {
                                return null;
                            }
                            const fix = [patternFix];
                            if (Array.isArray(flagsFix)) {
                                fix.push(...flagsFix);
                            }
                            else {
                                fix.push(flagsFix);
                            }
                            return fix;
                        },
                    });
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

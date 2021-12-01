"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const refa_1 = require("refa");
const reorder_alternatives_1 = require("../utils/reorder-alternatives");
const regexp_ast_1 = require("../utils/regexp-ast");
const alternative_prefix_1 = require("../utils/regexp-ast/alternative-prefix");
const cache = new Map();
function getAllowedChars(flags) {
    const cacheKey = (flags.ignoreCase ? "i" : "") + (flags.unicode ? "u" : "");
    let result = cache.get(cacheKey);
    if (result === undefined) {
        result = {
            allowed: refa_1.JS.createCharSet([
                { kind: "word", negate: false },
                { min: utils_1.CP_SPACE, max: utils_1.CP_SPACE },
                { min: utils_1.CP_PLUS, max: utils_1.CP_PLUS },
                { min: utils_1.CP_MINUS, max: utils_1.CP_MINUS },
                { min: utils_1.CP_STAR, max: utils_1.CP_STAR },
                { min: utils_1.CP_SLASH, max: utils_1.CP_SLASH },
                { min: utils_1.CP_APOSTROPHE, max: utils_1.CP_APOSTROPHE },
                { min: utils_1.CP_QUESTION, max: utils_1.CP_QUESTION },
            ], flags),
            required: regexp_ast_analysis_1.Chars.word(flags),
        };
        cache.set(cacheKey, result);
    }
    return result;
}
function containsOnlyLiterals(element) {
    return !(0, regexp_ast_analysis_1.hasSomeDescendant)(element, (d) => {
        return (d.type === "Backreference" ||
            d.type === "CharacterSet" ||
            (d.type === "Quantifier" && d.max === Infinity) ||
            (d.type === "CharacterClass" && d.negate));
    }, (d) => d.type !== "Assertion");
}
function compareByteOrder(a, b) {
    if (a === b) {
        return 0;
    }
    return a < b ? -1 : +1;
}
function compareCharSets(a, b) {
    if (a.isEmpty) {
        return 1;
    }
    else if (b.isEmpty) {
        return -1;
    }
    if (a.ranges[0].min !== b.ranges[0].min) {
        return a.ranges[0].min - b.ranges[0].min;
    }
    const symDiff = a.union(b).without(a.intersect(b));
    if (symDiff.isEmpty) {
        return 0;
    }
    const min = symDiff.ranges[0].min;
    if (a.has(min)) {
        return -1;
    }
    return 1;
}
function compareCharSetStrings(a, b) {
    const l = Math.min(a.length, b.length);
    for (let i = 0; i < l; i++) {
        const diff = compareCharSets(a[i], b[i]);
        if (diff !== 0) {
            return diff;
        }
    }
    return a.length - b.length;
}
function sortAlternatives(alternatives, flags) {
    const firstChars = new Map();
    for (const a of alternatives) {
        const chars = (0, regexp_ast_analysis_1.getFirstConsumedChar)(a, "ltr", flags);
        const char = chars.empty || chars.char.isEmpty
            ? Infinity
            : chars.char.ranges[0].min;
        firstChars.set(a, char);
    }
    alternatives.sort((a, b) => {
        const prefixDiff = compareCharSetStrings((0, alternative_prefix_1.getLongestPrefix)(a, "ltr", flags), (0, alternative_prefix_1.getLongestPrefix)(b, "ltr", flags));
        if (prefixDiff !== 0) {
            return prefixDiff;
        }
        if (flags.ignoreCase) {
            return (compareByteOrder(a.raw.toUpperCase(), b.raw.toUpperCase()) ||
                compareByteOrder(a.raw, b.raw));
        }
        return compareByteOrder(a.raw, b.raw);
    });
}
function isIntegerString(str) {
    return /^(?:0|[1-9]\d*)$/u.test(str);
}
function trySortNumberAlternatives(alternatives) {
    const runs = getRuns(alternatives, (a) => isIntegerString(a.raw));
    for (const { startIndex, elements } of runs) {
        elements.sort((a, b) => {
            return Number(a.raw) - Number(b.raw);
        });
        alternatives.splice(startIndex, elements.length, ...elements);
    }
}
function getReorderingBounds(original, reorder) {
    if (original.length !== reorder.length) {
        return undefined;
    }
    const len = original.length;
    let first = 0;
    for (; first < len && original[first] === reorder[first]; first++)
        ;
    if (first === len) {
        return undefined;
    }
    let last = len - 1;
    for (; last >= 0 && original[last] === reorder[last]; last--)
        ;
    return [first, last];
}
function getRuns(iter, condFn) {
    const runs = [];
    let elements = [];
    let index = 0;
    for (const item of iter) {
        if (condFn(item)) {
            elements.push(item);
        }
        else {
            if (elements.length > 0) {
                runs.push({ startIndex: index - elements.length, elements });
                elements = [];
            }
        }
        index++;
    }
    if (elements.length > 0) {
        runs.push({ startIndex: index - elements.length, elements });
        elements = [];
    }
    return runs;
}
exports.default = (0, utils_1.createRule)("sort-alternatives", {
    meta: {
        docs: {
            description: "sort alternatives if order doesn't matter",
            category: "Best Practices",
            recommended: false,
        },
        fixable: "code",
        schema: [],
        messages: {
            sort: "The alternatives of this group can be sorted without affecting the regex.",
        },
        type: "suggestion",
    },
    create(context) {
        const sliceMinLength = 3;
        function createVisitor(regexpContext) {
            const { node, getRegexpLocation, fixReplaceNode, flags } = regexpContext;
            const allowedChars = getAllowedChars(flags);
            const possibleCharsCache = new Map();
            function getPossibleChars(a) {
                let chars = possibleCharsCache.get(a);
                if (chars === undefined) {
                    chars = (0, regexp_ast_1.getPossiblyConsumedChar)(a, flags).char;
                    possibleCharsCache.set(a, chars);
                }
                return chars;
            }
            function trySortRun(run) {
                const alternatives = run.elements;
                if ((0, reorder_alternatives_1.canReorder)(alternatives, flags)) {
                    sortAlternatives(alternatives, flags);
                    trySortNumberAlternatives(alternatives);
                }
                else {
                    const consumedChars = regexp_ast_analysis_1.Chars.empty(flags).union(...alternatives.map(getPossibleChars));
                    if (!consumedChars.isDisjointWith(regexp_ast_analysis_1.Chars.digit(flags))) {
                        const runs = getRuns(alternatives, (a) => isIntegerString(a.raw));
                        for (const { startIndex: index, elements } of runs) {
                            if (elements.length > 1 &&
                                (0, reorder_alternatives_1.canReorder)(elements, flags)) {
                                trySortNumberAlternatives(elements);
                                alternatives.splice(index, elements.length, ...elements);
                            }
                        }
                    }
                }
                enforceSorted(run);
            }
            function enforceSorted(run) {
                const sorted = run.elements;
                const parent = sorted[0].parent;
                const unsorted = parent.alternatives.slice(run.startIndex, run.startIndex + sorted.length);
                const bounds = getReorderingBounds(unsorted, sorted);
                if (!bounds) {
                    return;
                }
                const loc = getRegexpLocation({
                    start: unsorted[bounds[0]].start,
                    end: unsorted[bounds[1]].end,
                });
                context.report({
                    node,
                    loc,
                    messageId: "sort",
                    fix: fixReplaceNode(parent, () => {
                        const prefix = parent.raw.slice(0, unsorted[0].start - parent.start);
                        const suffix = parent.raw.slice(unsorted[unsorted.length - 1].end - parent.start);
                        return (prefix + sorted.map((a) => a.raw).join("|") + suffix);
                    }),
                });
            }
            function onParent(parent) {
                if (parent.alternatives.length < 2) {
                    return;
                }
                const runs = getRuns(parent.alternatives, (a) => {
                    if (!containsOnlyLiterals(a)) {
                        return false;
                    }
                    const consumedChars = getPossibleChars(a);
                    if (consumedChars.isEmpty) {
                        return false;
                    }
                    if (!consumedChars.isSubsetOf(allowedChars.allowed)) {
                        return false;
                    }
                    if (consumedChars.isDisjointWith(allowedChars.required)) {
                        return false;
                    }
                    return true;
                });
                if (runs.length === 1 &&
                    runs[0].elements.length === parent.alternatives.length) {
                    trySortRun(runs[0]);
                }
                else {
                    for (const run of runs) {
                        if (run.elements.length >= sliceMinLength &&
                            run.elements.length >= 2) {
                            trySortRun(run);
                        }
                    }
                }
            }
            return {
                onGroupEnter: onParent,
                onPatternEnter: onParent,
                onCapturingGroupEnter: onParent,
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

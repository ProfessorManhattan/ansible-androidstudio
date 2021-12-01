"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
function findIndex(arr, condFn) {
    return arr.findIndex(condFn);
}
function findLastIndex(arr, condFn) {
    for (let i = arr.length - 1; i >= 0; i--) {
        if (condFn(arr[i], i)) {
            return i;
        }
    }
    return -1;
}
function elementsToCharacterClass(elements) {
    let result = "[";
    elements.forEach((e, i) => {
        switch (e.type) {
            case "Character":
                if (e.raw === "-") {
                    if (i === 0 || i === elements.length - 1) {
                        result += "-";
                    }
                    else {
                        result += "\\-";
                    }
                }
                else if (e.raw === "^") {
                    if (i === 0) {
                        result += "\\^";
                    }
                    else {
                        result += "^";
                    }
                }
                else if (e.raw === "]") {
                    result += "\\]";
                }
                else {
                    result += e.raw;
                }
                break;
            case "CharacterClassRange":
                if (e.min.raw === "^" && i === 0) {
                    result += `\\^-${e.max.raw}`;
                }
                else {
                    result += `${e.min.raw}-${e.max.raw}`;
                }
                break;
            case "CharacterSet":
                result += e.raw;
                break;
            default:
                throw new Error(e);
        }
    });
    result += "]";
    return result;
}
function categorizeRawAlts(alternatives, flags) {
    return alternatives.map((alternative) => {
        if (alternative.elements.length === 1) {
            const element = alternative.elements[0];
            if (element.type === "Character" ||
                element.type === "CharacterClass" ||
                element.type === "CharacterSet") {
                return {
                    isCharacter: true,
                    alternative,
                    element,
                    char: (0, regexp_ast_analysis_1.toCharSet)(element, flags),
                };
            }
        }
        return {
            isCharacter: false,
            alternative,
        };
    });
}
function containsCharacterClass(alts) {
    for (const alt of alts) {
        if (alt.isCharacter && alt.alternative.elements.length === 1) {
            const e = alt.alternative.elements[0];
            if (e.type === "CharacterClass" && !e.negate) {
                return true;
            }
        }
    }
    return false;
}
function toCharacterClassElement(element) {
    if (element.type === "CharacterSet") {
        if (element.kind === "any") {
            return null;
        }
        return [element];
    }
    else if (element.type === "CharacterClass") {
        if (element.negate) {
            return null;
        }
        return element.elements;
    }
    else if (element.type === "Character") {
        return [element];
    }
    return null;
}
function parseRawAlts(alternatives, flags) {
    return alternatives.map((a) => {
        if (a.isCharacter) {
            const elements = toCharacterClassElement(a.element);
            if (elements) {
                return {
                    isCharacter: true,
                    elements,
                    char: (0, regexp_ast_analysis_1.toCharSet)(a.element, flags),
                    raw: a.alternative.raw,
                };
            }
        }
        return {
            isCharacter: false,
            firstChar: (0, regexp_ast_analysis_1.getFirstConsumedChar)(a.alternative, (0, regexp_ast_analysis_1.getMatchingDirection)(a.alternative), flags),
            raw: a.alternative.raw,
        };
    });
}
function optimizeCharacterAlts(alternatives) {
    function merge(a, b) {
        const elements = [...a.elements, ...b.elements];
        return {
            isCharacter: true,
            char: a.char.union(b.char),
            elements,
            raw: elementsToCharacterClass(elements),
        };
    }
    for (let i = 0; i < alternatives.length - 1; i++) {
        let curr = alternatives[i];
        if (!curr.isCharacter) {
            continue;
        }
        let nonCharTotal = undefined;
        for (let j = i + 1; j < alternatives.length; j++) {
            const far = alternatives[j];
            if (far.isCharacter) {
                if (nonCharTotal === undefined ||
                    far.char.isDisjointWith(nonCharTotal)) {
                    curr = merge(curr, far);
                    alternatives.splice(j, 1);
                    j--;
                }
                else {
                    break;
                }
            }
            else {
                if (!far.firstChar.empty) {
                    if (nonCharTotal === undefined) {
                        nonCharTotal = far.firstChar.char;
                    }
                    else {
                        nonCharTotal = nonCharTotal.union(far.firstChar.char);
                    }
                    if (nonCharTotal.isAll) {
                        break;
                    }
                }
                else {
                    break;
                }
            }
        }
        alternatives[i] = curr;
    }
}
function findNonDisjointAlt(alternatives) {
    let total = undefined;
    for (const a of alternatives) {
        if (a.isCharacter) {
            if (total === undefined) {
                total = a.char;
            }
            else {
                if (!total.isDisjointWith(a.char)) {
                    return a;
                }
                total = total.union(a.char);
            }
        }
    }
    return null;
}
function totalIsAll(alternatives, { flags }) {
    let total = undefined;
    for (const a of alternatives) {
        if (a.isCharacter) {
            if (total === undefined) {
                total = (0, regexp_ast_analysis_1.toCharSet)(a.element, flags);
            }
            else {
                total = total.union((0, regexp_ast_analysis_1.toCharSet)(a.element, flags));
            }
        }
    }
    return total !== undefined && total.isAll;
}
function getParentPrefixAndSuffix(parent) {
    switch (parent.type) {
        case "Assertion":
            return [
                `(?${parent.kind === "lookahead" ? "" : "<"}${parent.negate ? "!" : "="}`,
                ")",
            ];
        case "CapturingGroup":
            if (parent.name !== null) {
                return [`(?<${parent.name}>`, ")"];
            }
            return ["(", ")"];
        case "Group":
            return ["(?:", ")"];
        case "Pattern":
            return ["", ""];
        default:
            throw new Error(parent);
    }
}
function minPos(a, b) {
    if (a.column < b.column) {
        return a;
    }
    else if (b.column < a.column) {
        return b;
    }
    return a.line < b.line ? a : b;
}
function maxPos(a, b) {
    if (a.column > b.column) {
        return a;
    }
    else if (b.column > a.column) {
        return b;
    }
    return a.line > b.line ? a : b;
}
exports.default = (0, utils_1.createRule)("prefer-character-class", {
    meta: {
        docs: {
            description: "enforce using character class",
            category: "Stylistic Issues",
            recommended: true,
        },
        fixable: "code",
        schema: [],
        messages: {
            unexpected: "Unexpected the disjunction of single element alternatives. Use character class '[...]' instead.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor(regexpContext) {
            const { node, flags, getRegexpLocation, fixReplaceNode } = regexpContext;
            function fixReplaceAlternatives(n, newAlternatives) {
                const [prefix, suffix] = getParentPrefixAndSuffix(n);
                return fixReplaceNode(n, prefix + newAlternatives + suffix);
            }
            function unionRegexpLocations(elements) {
                let { start, end } = getRegexpLocation(elements[0]);
                for (let i = 1; i < elements.length; i++) {
                    const other = getRegexpLocation(elements[1]);
                    start = minPos(start, other.start);
                    end = maxPos(end, other.end);
                }
                return { start, end };
            }
            function process(n) {
                if (n.alternatives.length < 2) {
                    return;
                }
                const alts = categorizeRawAlts(n.alternatives, flags);
                const characterAltsCount = alts.filter((a) => a.isCharacter).length;
                if (characterAltsCount < 2) {
                    return;
                }
                if (alts.every((a) => a.isCharacter) &&
                    totalIsAll(alts, regexpContext)) {
                    context.report({
                        node,
                        loc: getRegexpLocation(n),
                        messageId: "unexpected",
                        fix: fixReplaceAlternatives(n, "[^]"),
                    });
                    return;
                }
                const parsedAlts = parseRawAlts(alts, flags);
                if (characterAltsCount >= 3 ||
                    containsCharacterClass(alts) ||
                    totalIsAll(alts, regexpContext) ||
                    findNonDisjointAlt(parsedAlts)) {
                    optimizeCharacterAlts(parsedAlts);
                    if (parsedAlts.length !== alts.length) {
                        const firstChanged = findIndex(parsedAlts, (a, i) => a.raw !== n.alternatives[i].raw);
                        const lastChanged = findLastIndex(parsedAlts, (a, i) => {
                            const index = n.alternatives.length +
                                i -
                                parsedAlts.length;
                            return a.raw !== n.alternatives[index].raw;
                        });
                        const changedNodes = [
                            n.alternatives[firstChanged],
                            n.alternatives[n.alternatives.length +
                                lastChanged -
                                parsedAlts.length],
                        ];
                        context.report({
                            node,
                            loc: unionRegexpLocations(changedNodes),
                            messageId: "unexpected",
                            fix: fixReplaceAlternatives(n, parsedAlts.map((a) => a.raw).join("|")),
                        });
                    }
                }
            }
            return {
                onPatternEnter: process,
                onGroupEnter: process,
                onCapturingGroupEnter: process,
                onAssertionEnter(aNode) {
                    if (aNode.kind === "lookahead" ||
                        aNode.kind === "lookbehind") {
                        process(aNode);
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

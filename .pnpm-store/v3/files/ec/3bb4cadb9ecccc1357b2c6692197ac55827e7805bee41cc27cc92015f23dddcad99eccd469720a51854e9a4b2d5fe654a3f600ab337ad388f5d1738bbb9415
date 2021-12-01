"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const regexp_ast_1 = require("../utils/regexp-ast");
const mention_1 = require("../utils/mention");
function hasCapturingGroup(node) {
    return (0, regexp_ast_analysis_1.hasSomeDescendant)(node, (d) => d.type === "CapturingGroup");
}
const EMPTY_UTF16 = {
    char: regexp_ast_analysis_1.Chars.empty({}),
    complete: false,
};
const EMPTY_UNICODE = {
    char: regexp_ast_analysis_1.Chars.empty({ unicode: true }),
    complete: false,
};
function getSingleConsumedChar(element, flags) {
    const empty = flags.unicode ? EMPTY_UNICODE : EMPTY_UTF16;
    switch (element.type) {
        case "Alternative":
            if (element.elements.length === 1) {
                return getSingleConsumedChar(element.elements[0], flags);
            }
            return empty;
        case "Character":
        case "CharacterSet":
        case "CharacterClass":
            return {
                char: (0, regexp_ast_analysis_1.toCharSet)(element, flags),
                complete: true,
            };
        case "Group":
        case "CapturingGroup": {
            const results = element.alternatives.map((a) => getSingleConsumedChar(a, flags));
            return {
                char: empty.char.union(...results.map((r) => r.char)),
                complete: results.every((r) => r.complete),
            };
        }
        default:
            return empty;
    }
}
function quantAddConst(quant, constant) {
    return {
        min: quant.min + constant,
        max: quant.max + constant,
        greedy: quant.greedy,
    };
}
function quantize(element, quant) {
    if (quant.min === 0 && quant.max === 0) {
        return "";
    }
    if (quant.min === 1 && quant.max === 1) {
        return element.raw;
    }
    return element.raw + (0, utils_1.quantToString)(quant);
}
function isGroupOrCharacter(element) {
    switch (element.type) {
        case "Group":
        case "CapturingGroup":
        case "Character":
        case "CharacterClass":
        case "CharacterSet":
            return true;
        default:
            return false;
    }
}
function getQuantifiersReplacement(left, right, flags) {
    if (left.min === left.max || right.min === right.max) {
        return null;
    }
    if (left.greedy !== right.greedy) {
        return null;
    }
    const lSingle = getSingleConsumedChar(left.element, flags);
    const rSingle = getSingleConsumedChar(right.element, flags);
    const lPossibleChar = lSingle.complete
        ? lSingle.char
        : (0, regexp_ast_1.getPossiblyConsumedChar)(left.element, flags).char;
    const rPossibleChar = rSingle.complete
        ? rSingle.char
        : (0, regexp_ast_1.getPossiblyConsumedChar)(right.element, flags).char;
    const greedy = left.greedy;
    let lQuant, rQuant;
    if (lSingle.complete &&
        rSingle.complete &&
        lSingle.char.equals(rSingle.char)) {
        lQuant = {
            min: left.min + right.min,
            max: left.max + right.max,
            greedy,
        };
        rQuant = { min: 0, max: 0, greedy };
    }
    else if (right.max === Infinity &&
        rSingle.char.isSupersetOf(lPossibleChar)) {
        lQuant = {
            min: left.min,
            max: left.min,
            greedy,
        };
        rQuant = right;
    }
    else if (left.max === Infinity &&
        lSingle.char.isSupersetOf(rPossibleChar)) {
        lQuant = left;
        rQuant = {
            min: right.min,
            max: right.min,
            greedy,
        };
    }
    else {
        return null;
    }
    const raw = quantize(left.element, lQuant) + quantize(right.element, rQuant);
    let messageId;
    if (lQuant.max === 0 &&
        right.max === rQuant.max &&
        right.min === rQuant.min) {
        messageId = "removeLeft";
    }
    else if (rQuant.max === 0 &&
        left.max === lQuant.max &&
        left.min === lQuant.min) {
        messageId = "removeRight";
    }
    else {
        messageId = "replace";
    }
    return { type: "Both", raw, messageId };
}
function asRepeatedElement(element) {
    if (element.type === "Quantifier") {
        if (element.min === element.max &&
            element.min > 0 &&
            isGroupOrCharacter(element.element)) {
            return {
                type: "Repeated",
                element: element.element,
                min: element.min,
            };
        }
    }
    else if (isGroupOrCharacter(element)) {
        return { type: "Repeated", element, min: 1 };
    }
    return null;
}
function getQuantifierRepeatedElementReplacement(pair, flags) {
    const [left, right] = pair;
    const lSingle = getSingleConsumedChar(left.element, flags);
    if (!lSingle.complete) {
        return null;
    }
    const rSingle = getSingleConsumedChar(right.element, flags);
    if (!rSingle.complete) {
        return null;
    }
    if (!rSingle.char.equals(lSingle.char)) {
        return null;
    }
    let elementRaw, quant;
    if (left.type === "Quantifier") {
        elementRaw = left.element.raw;
        quant = quantAddConst(left, right.min);
    }
    else if (right.type === "Quantifier") {
        elementRaw = right.element.raw;
        quant = quantAddConst(right, left.min);
    }
    else {
        throw new Error();
    }
    const raw = elementRaw + (0, utils_1.quantToString)(quant);
    return { type: "Both", messageId: "combine", raw };
}
function getNestedReplacement(dominate, nested, flags) {
    if (dominate.greedy !== nested.greedy) {
        return null;
    }
    if (dominate.max < Infinity || nested.min === nested.max) {
        return null;
    }
    const single = getSingleConsumedChar(dominate.element, flags);
    if (single.char.isEmpty) {
        return null;
    }
    const nestedPossible = (0, regexp_ast_1.getPossiblyConsumedChar)(nested.element, flags);
    if (single.char.isSupersetOf(nestedPossible.char)) {
        const { min } = nested;
        if (min === 0) {
            return {
                type: "Nested",
                messageId: "nestedRemove",
                raw: "",
                nested,
                dominate,
            };
        }
        return {
            type: "Nested",
            messageId: "nestedReplace",
            raw: quantize(nested.element, Object.assign(Object.assign({}, nested), { max: min })),
            nested,
            dominate,
        };
    }
    return null;
}
function* nestedQuantifiers(root, direction) {
    switch (root.type) {
        case "Alternative":
            if (root.elements.length > 0) {
                const index = direction === "start" ? 0 : root.elements.length - 1;
                yield* nestedQuantifiers(root.elements[index], direction);
            }
            break;
        case "CapturingGroup":
        case "Group":
            for (const a of root.alternatives) {
                yield* nestedQuantifiers(a, direction);
            }
            break;
        case "Quantifier":
            yield root;
            if (root.max === 1) {
                yield* nestedQuantifiers(root.element, direction);
            }
            break;
        default:
            break;
    }
}
function ignoreReplacement(left, right, result) {
    if (left.type === "Quantifier") {
        if (left.raw.length + right.raw.length <= result.raw.length &&
            isGroupOrCharacter(right) &&
            left.min === 0 &&
            left.max === 1) {
            return true;
        }
    }
    if (right.type === "Quantifier") {
        if (left.raw.length + right.raw.length <= result.raw.length &&
            isGroupOrCharacter(left) &&
            right.min === 0 &&
            right.max === 1) {
            return true;
        }
    }
    return false;
}
function getReplacement(left, right, flags) {
    if (left.type === "Quantifier" && right.type === "Quantifier") {
        const result = getQuantifiersReplacement(left, right, flags);
        if (result && !ignoreReplacement(left, right, result))
            return result;
    }
    if (left.type === "Quantifier") {
        const rightRep = asRepeatedElement(right);
        if (rightRep) {
            const result = getQuantifierRepeatedElementReplacement([left, rightRep], flags);
            if (result && !ignoreReplacement(left, right, result))
                return result;
        }
    }
    if (right.type === "Quantifier") {
        const leftRep = asRepeatedElement(left);
        if (leftRep) {
            const result = getQuantifierRepeatedElementReplacement([leftRep, right], flags);
            if (result && !ignoreReplacement(left, right, result))
                return result;
        }
    }
    if (left.type === "Quantifier" && left.max === Infinity) {
        for (const nested of nestedQuantifiers(right, "start")) {
            const result = getNestedReplacement(left, nested, flags);
            if (result)
                return result;
        }
    }
    if (right.type === "Quantifier" && right.max === Infinity) {
        for (const nested of nestedQuantifiers(left, "end")) {
            const result = getNestedReplacement(right, nested, flags);
            if (result)
                return result;
        }
    }
    return null;
}
function getLoc(left, right, { patternSource }) {
    return patternSource.getAstLocation({
        start: Math.min(left.start, right.start),
        end: Math.max(left.end, right.end),
    });
}
exports.default = (0, utils_1.createRule)("optimal-quantifier-concatenation", {
    meta: {
        docs: {
            description: "require optimal quantifiers for concatenated quantifiers",
            category: "Best Practices",
            recommended: true,
        },
        fixable: "code",
        schema: [],
        messages: {
            combine: "{{left}} and {{right}} can be combined into one quantifier {{fix}}.{{cap}}",
            removeLeft: "{{left}} can be removed because it is already included by {{right}}.{{cap}}",
            removeRight: "{{right}} can be removed because it is already included by {{left}}.{{cap}}",
            replace: "{{left}} and {{right}} can be replaced with {{fix}}.{{cap}}",
            nestedRemove: "{{nested}} can be removed because of {{dominate}}.{{cap}}",
            nestedReplace: "{{nested}} can be replaced with {{fix}} because of {{dominate}}.{{cap}}",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor(regexpContext) {
            const { node, flags, getRegexpLocation, fixReplaceNode } = regexpContext;
            return {
                onAlternativeEnter(aNode) {
                    for (let i = 0; i < aNode.elements.length - 1; i++) {
                        const left = aNode.elements[i];
                        const right = aNode.elements[i + 1];
                        const replacement = getReplacement(left, right, flags);
                        if (!replacement) {
                            continue;
                        }
                        const involvesCapturingGroup = hasCapturingGroup(left) || hasCapturingGroup(right);
                        const cap = involvesCapturingGroup
                            ? " This cannot be fixed automatically because it might change or remove a capturing group."
                            : "";
                        if (replacement.type === "Both") {
                            context.report({
                                node,
                                loc: getLoc(left, right, regexpContext),
                                messageId: replacement.messageId,
                                data: {
                                    left: (0, mention_1.mention)(left),
                                    right: (0, mention_1.mention)(right),
                                    fix: (0, mention_1.mention)(replacement.raw),
                                    cap,
                                },
                                fix: fixReplaceNode(aNode, () => {
                                    if (involvesCapturingGroup) {
                                        return null;
                                    }
                                    const before = aNode.raw.slice(0, left.start - aNode.start);
                                    const after = aNode.raw.slice(right.end - aNode.start);
                                    return before + replacement.raw + after;
                                }),
                            });
                        }
                        else {
                            context.report({
                                node,
                                loc: getRegexpLocation(replacement.nested),
                                messageId: replacement.messageId,
                                data: {
                                    nested: (0, mention_1.mention)(replacement.nested),
                                    dominate: (0, mention_1.mention)(replacement.dominate),
                                    fix: (0, mention_1.mention)(replacement.raw),
                                    cap,
                                },
                                fix: fixReplaceNode(replacement.nested, () => {
                                    if (involvesCapturingGroup) {
                                        return null;
                                    }
                                    return replacement.raw;
                                }),
                            });
                        }
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

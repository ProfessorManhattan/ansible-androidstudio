"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const mention_1 = require("../utils/mention");
const DEFAULT_ORDER = [
    "\\s",
    "\\w",
    "\\d",
    "\\p",
    "*",
];
function getCharacterClassElementKind(node) {
    if (node.type === "CharacterSet") {
        return node.kind === "word"
            ? "\\w"
            : node.kind === "digit"
                ? "\\d"
                : node.kind === "space"
                    ? "\\s"
                    : "\\p";
    }
    return "*";
}
exports.default = (0, utils_1.createRule)("sort-character-class-elements", {
    meta: {
        docs: {
            description: "enforces elements order in character class",
            category: "Stylistic Issues",
            recommended: false,
        },
        fixable: "code",
        schema: [
            {
                type: "object",
                properties: {
                    order: {
                        type: "array",
                        items: { enum: ["\\w", "\\d", "\\s", "\\p", "*"] },
                    },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            sortElements: "Expected character class elements to be in ascending order. {{next}} should be before {{prev}}.",
        },
        type: "layout",
    },
    create(context) {
        var _a, _b;
        const orderOption = { "*": Infinity };
        ((_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.order) !== null && _b !== void 0 ? _b : DEFAULT_ORDER).forEach((o, i) => {
            orderOption[o] = i + 1;
        });
        function createVisitor({ node, getRegexpLocation, patternSource, }) {
            return {
                onCharacterClassEnter(ccNode) {
                    const prevList = [];
                    for (const next of ccNode.elements) {
                        if (prevList.length) {
                            const prev = prevList[0];
                            if (!isValidOrder(prev, next)) {
                                let moveTarget = prev;
                                for (const p of prevList) {
                                    if (isValidOrder(p, next)) {
                                        break;
                                    }
                                    else {
                                        moveTarget = p;
                                    }
                                }
                                context.report({
                                    node,
                                    loc: getRegexpLocation(next),
                                    messageId: "sortElements",
                                    data: {
                                        next: (0, mention_1.mention)(next),
                                        prev: (0, mention_1.mention)(moveTarget),
                                    },
                                    *fix(fixer) {
                                        const nextRange = patternSource.getReplaceRange(next);
                                        const targetRange = patternSource.getReplaceRange(moveTarget);
                                        if (!targetRange || !nextRange) {
                                            return;
                                        }
                                        yield targetRange.insertBefore(fixer, escapeRaw(next, moveTarget));
                                        yield nextRange.remove(fixer);
                                    },
                                });
                            }
                        }
                        prevList.unshift(next);
                    }
                },
            };
        }
        function isValidOrder(prev, next) {
            var _a, _b;
            const prevKind = getCharacterClassElementKind(prev);
            const nextKind = getCharacterClassElementKind(next);
            const prevOrder = (_a = orderOption[prevKind]) !== null && _a !== void 0 ? _a : orderOption["*"];
            const nextOrder = (_b = orderOption[nextKind]) !== null && _b !== void 0 ? _b : orderOption["*"];
            if (prevOrder < nextOrder) {
                return true;
            }
            else if (prevOrder > nextOrder) {
                return false;
            }
            if (prev.type === "CharacterSet" && prev.kind === "property") {
                if (next.type === "CharacterSet") {
                    if (next.kind === "property") {
                        return isValidOrderForUnicodePropertyCharacterSet(prev, next);
                    }
                    return false;
                }
                return true;
            }
            else if (next.type === "CharacterSet" &&
                next.kind === "property") {
                if (prev.type === "CharacterSet") {
                    return true;
                }
                return false;
            }
            if (prev.type === "CharacterSet" && next.type === "CharacterSet") {
                if (prev.kind === "word" && next.kind === "digit") {
                    return true;
                }
                if (prev.kind === "digit" && next.kind === "word") {
                    return false;
                }
            }
            const prevCP = getTargetCodePoint(prev);
            const nextCP = getTargetCodePoint(next);
            if (prevCP <= nextCP) {
                return true;
            }
            return false;
        }
        function isValidOrderForUnicodePropertyCharacterSet(prev, next) {
            if (prev.key < next.key) {
                return true;
            }
            else if (prev.key > next.key) {
                return false;
            }
            if (prev.value) {
                if (next.value) {
                    if (prev.value <= next.value) {
                        return true;
                    }
                    return false;
                }
                return false;
            }
            return true;
        }
        function getTargetCodePoint(node) {
            if (node.type === "CharacterSet") {
                if (node.kind === "digit" || node.kind === "word") {
                    return utils_1.CP_DIGIT_ZERO;
                }
                if (node.kind === "space") {
                    return utils_1.CP_SPACE;
                }
                return Infinity;
            }
            if (node.type === "CharacterClassRange") {
                return node.min.value;
            }
            return node.value;
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});
function escapeRaw(node, target) {
    let raw = node.raw;
    if (raw.startsWith("-")) {
        const parent = target.parent;
        const prev = parent.elements[parent.elements.indexOf(target) - 1];
        if (prev &&
            (prev.type === "Character" || prev.type === "CharacterSet")) {
            raw = `\\${raw}`;
        }
    }
    if (target.raw.startsWith("-")) {
        if (node.type === "Character" || node.type === "CharacterSet") {
            raw = `${raw}\\`;
        }
    }
    return raw;
}

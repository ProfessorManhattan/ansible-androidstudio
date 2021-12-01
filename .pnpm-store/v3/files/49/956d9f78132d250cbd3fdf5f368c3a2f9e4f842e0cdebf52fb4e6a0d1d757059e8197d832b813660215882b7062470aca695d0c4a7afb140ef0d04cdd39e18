"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("no-useless-character-class", {
    meta: {
        docs: {
            description: "disallow character class with one character",
            category: "Best Practices",
            recommended: true,
        },
        fixable: "code",
        schema: [
            {
                type: "object",
                properties: {
                    ignores: {
                        type: "array",
                        items: {
                            type: "string",
                            minLength: 1,
                        },
                        uniqueItems: true,
                    },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            unexpected: "Unexpected character class with one {{type}}. Can remove brackets{{additional}}.",
        },
        type: "suggestion",
    },
    create(context) {
        var _a, _b;
        const ignores = (_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.ignores) !== null && _b !== void 0 ? _b : ["="];
        function createVisitor({ node, flags, fixReplaceNode, getRegexpLocation, }) {
            return {
                onCharacterClassEnter(ccNode) {
                    if (ccNode.elements.length !== 1) {
                        return;
                    }
                    if (ccNode.negate) {
                        return;
                    }
                    const element = ccNode.elements[0];
                    if (ignores.length > 0 && ignores.includes(element.raw)) {
                        return;
                    }
                    if (element.type === "Character") {
                        if (element.raw === "\\b") {
                            return;
                        }
                        if (/^\\\d+$/u.test(element.raw) &&
                            !element.raw.startsWith("\\0")) {
                            return;
                        }
                        if (ignores.length > 0 &&
                            ignores.includes(String.fromCodePoint(element.value))) {
                            return;
                        }
                        if (!(0, utils_1.canUnwrapped)(ccNode, element.raw)) {
                            return;
                        }
                    }
                    else if (element.type === "CharacterClassRange") {
                        if (element.min.value !== element.max.value) {
                            return;
                        }
                    }
                    else if (element.type !== "CharacterSet") {
                        return;
                    }
                    context.report({
                        node,
                        loc: getRegexpLocation(ccNode),
                        messageId: "unexpected",
                        data: {
                            type: element.type === "Character"
                                ? "character"
                                : element.type === "CharacterClassRange"
                                    ? "character class range"
                                    : "character class escape",
                            additional: element.type === "CharacterClassRange"
                                ? " and range"
                                : "",
                        },
                        fix: fixReplaceNode(ccNode, () => {
                            let text = element.type === "CharacterClassRange"
                                ? element.min.raw
                                : element.raw;
                            if (element.type === "Character" ||
                                element.type === "CharacterClassRange") {
                                if (/^[$()*+./?[{|]$/u.test(text) ||
                                    (flags.unicode && text === "}")) {
                                    text = `\\${text}`;
                                }
                            }
                            return text;
                        }),
                    });
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

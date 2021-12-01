"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const REGEX_CHAR_CLASS_ESCAPES = new Set([
    utils_1.CP_BACK_SLASH,
    utils_1.CP_CLOSING_BRACKET,
    utils_1.CP_MINUS,
]);
const REGEX_ESCAPES = new Set([
    utils_1.CP_BACK_SLASH,
    utils_1.CP_SLASH,
    utils_1.CP_CARET,
    utils_1.CP_DOT,
    utils_1.CP_DOLLAR,
    utils_1.CP_STAR,
    utils_1.CP_PLUS,
    utils_1.CP_QUESTION,
    utils_1.CP_OPENING_BRACKET,
    utils_1.CP_CLOSING_BRACKET,
    utils_1.CP_OPENING_BRACE,
    utils_1.CP_CLOSING_BRACE,
    utils_1.CP_PIPE,
    utils_1.CP_OPENING_PAREN,
    utils_1.CP_CLOSING_PAREN,
]);
const POTENTIAL_ESCAPE_SEQUENCE = new Set("uxkpP");
exports.default = (0, utils_1.createRule)("no-useless-escape", {
    meta: {
        docs: {
            description: "disallow unnecessary escape characters in RegExp",
            category: "Stylistic Issues",
            recommended: true,
        },
        fixable: "code",
        schema: [],
        messages: {
            unnecessary: "Unnecessary escape character: \\{{character}}.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, fixReplaceNode, }) {
            function report(cNode, offset, character, fix) {
                context.report({
                    node,
                    loc: getRegexpLocation(cNode, [offset, offset + 1]),
                    messageId: "unnecessary",
                    data: {
                        character,
                    },
                    fix: fix ? fixReplaceNode(cNode, character) : null,
                });
            }
            let inCharacterClass = false;
            return {
                onCharacterClassEnter() {
                    inCharacterClass = true;
                },
                onCharacterClassLeave() {
                    inCharacterClass = false;
                },
                onCharacterEnter(cNode) {
                    if (cNode.raw.startsWith("\\")) {
                        const char = cNode.raw.slice(1);
                        if (char === String.fromCodePoint(cNode.value)) {
                            const allowedEscapes = inCharacterClass
                                ? REGEX_CHAR_CLASS_ESCAPES
                                : REGEX_ESCAPES;
                            if (allowedEscapes.has(cNode.value)) {
                                return;
                            }
                            if (inCharacterClass && cNode.value === utils_1.CP_CARET) {
                                const target = cNode.parent.type === "CharacterClassRange"
                                    ? cNode.parent
                                    : cNode;
                                const parent = target.parent;
                                if (parent.type === "CharacterClass") {
                                    if (parent.elements.indexOf(target) === 0) {
                                        return;
                                    }
                                }
                            }
                            if (!(0, utils_1.canUnwrapped)(cNode, char)) {
                                return;
                            }
                            report(cNode, 0, char, !POTENTIAL_ESCAPE_SEQUENCE.has(char));
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

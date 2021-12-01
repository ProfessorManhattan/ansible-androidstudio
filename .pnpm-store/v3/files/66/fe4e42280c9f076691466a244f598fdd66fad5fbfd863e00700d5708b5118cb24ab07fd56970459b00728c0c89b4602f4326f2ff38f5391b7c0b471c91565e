"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mention_1 = require("../utils/mention");
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("prefer-t", {
    meta: {
        docs: {
            description: "enforce using `\\t`",
            category: "Stylistic Issues",
            recommended: false,
            replacedBy: ["control-character-escape"],
        },
        fixable: "code",
        schema: [],
        messages: {
            unexpected: "Unexpected character {{expr}}. Use '\\t' instead.",
        },
        type: "suggestion",
        deprecated: true,
    },
    create(context) {
        function createVisitor(regexpContext, allows) {
            const { node, getRegexpLocation, fixReplaceNode } = regexpContext;
            return {
                onCharacterEnter(cNode) {
                    if (cNode.value === utils_1.CP_TAB &&
                        cNode.raw !== "\\t" &&
                        !allows.includes(cNode.raw)) {
                        context.report({
                            node,
                            loc: getRegexpLocation(cNode),
                            messageId: "unexpected",
                            data: {
                                expr: (0, mention_1.mention)(cNode),
                            },
                            fix: fixReplaceNode(cNode, "\\t"),
                        });
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createLiteralVisitor(regexpContext) {
                return createVisitor(regexpContext, []);
            },
            createSourceVisitor(regexpContext) {
                return createVisitor(regexpContext, ["\t"]);
            },
        });
    },
});

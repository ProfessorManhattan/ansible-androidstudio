"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("no-escape-backspace", {
    meta: {
        docs: {
            description: "disallow escape backspace (`[\\b]`)",
            category: "Possible Errors",
            recommended: true,
        },
        schema: [],
        messages: {
            unexpected: "Unexpected '[\\b]'. Use '\\u0008' instead.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, }) {
            return {
                onCharacterEnter(cNode) {
                    if (cNode.value === utils_1.CP_BACKSPACE && cNode.raw === "\\b") {
                        context.report({
                            node,
                            loc: getRegexpLocation(cNode),
                            messageId: "unexpected",
                        });
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

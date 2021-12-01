"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("no-useless-exactly-quantifier", {
    meta: {
        docs: {
            description: "disallow unnecessary exactly quantifier",
            category: "Best Practices",
            recommended: false,
            replacedBy: ["no-useless-quantifier", "no-zero-quantifier"],
        },
        schema: [],
        messages: {
            unexpected: "Unexpected quantifier '{{expr}}'.",
        },
        type: "suggestion",
        deprecated: true,
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, }) {
            return {
                onQuantifierEnter(qNode) {
                    if (qNode.min === qNode.max &&
                        (qNode.min === 0 || qNode.min === 1)) {
                        const [startOffset, endOffset] = (0, utils_1.getQuantifierOffsets)(qNode);
                        const text = qNode.raw.slice(startOffset, endOffset);
                        context.report({
                            node,
                            loc: getRegexpLocation(qNode, [
                                startOffset,
                                endOffset,
                            ]),
                            messageId: "unexpected",
                            data: {
                                expr: text,
                            },
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

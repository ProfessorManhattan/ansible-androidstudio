"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
exports.default = (0, utils_1.createRule)("confusing-quantifier", {
    meta: {
        docs: {
            description: "disallow confusing quantifiers",
            category: "Best Practices",
            recommended: true,
            default: "warn",
        },
        schema: [],
        messages: {
            confusing: "This quantifier is confusing because its minimum is {{min}} but it can match the empty string. Maybe replace it with `{{proposal}}` to reflect that it can match the empty string?",
        },
        type: "problem",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, }) {
            return {
                onQuantifierEnter(qNode) {
                    if (qNode.min > 0 && (0, regexp_ast_analysis_1.isPotentiallyEmpty)(qNode.element)) {
                        const proposal = (0, utils_1.quantToString)(Object.assign(Object.assign({}, qNode), { min: 0 }));
                        context.report({
                            node,
                            loc: getRegexpLocation(qNode, (0, utils_1.getQuantifierOffsets)(qNode)),
                            messageId: "confusing",
                            data: {
                                min: String(qNode.min),
                                proposal,
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

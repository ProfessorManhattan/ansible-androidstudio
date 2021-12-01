"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("no-empty-alternative", {
    meta: {
        docs: {
            description: "disallow alternatives without elements",
            category: "Possible Errors",
            recommended: true,
            default: "warn",
        },
        schema: [],
        messages: {
            empty: "No empty alternatives. Use quantifiers instead.",
        },
        type: "problem",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, }) {
            function verifyAlternatives(regexpNode) {
                if (regexpNode.alternatives.length >= 2) {
                    for (let i = 0; i < regexpNode.alternatives.length; i++) {
                        const alt = regexpNode.alternatives[i];
                        const last = i === regexpNode.alternatives.length - 1;
                        if (alt.elements.length === 0) {
                            const index = alt.start;
                            const loc = last
                                ? getRegexpLocation({
                                    start: index - 1,
                                    end: index,
                                })
                                : getRegexpLocation({
                                    start: index,
                                    end: index + 1,
                                });
                            context.report({
                                node,
                                loc,
                                messageId: "empty",
                            });
                            return;
                        }
                    }
                }
            }
            return {
                onGroupEnter: verifyAlternatives,
                onCapturingGroupEnter: verifyAlternatives,
                onPatternEnter: verifyAlternatives,
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

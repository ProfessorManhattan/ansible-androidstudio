"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const get_usage_of_pattern_1 = require("../utils/get-usage-of-pattern");
function* extractLazyEndQuantifiers(alternatives) {
    for (const { elements } of alternatives) {
        if (elements.length > 0) {
            const last = elements[elements.length - 1];
            switch (last.type) {
                case "Quantifier":
                    if (!last.greedy && last.min !== last.max) {
                        yield last;
                    }
                    else if (last.max === 1) {
                        const element = last.element;
                        if (element.type === "Group" ||
                            element.type === "CapturingGroup") {
                            yield* extractLazyEndQuantifiers(element.alternatives);
                        }
                    }
                    break;
                case "CapturingGroup":
                case "Group":
                    yield* extractLazyEndQuantifiers(last.alternatives);
                    break;
                default:
                    break;
            }
        }
    }
}
exports.default = (0, utils_1.createRule)("no-lazy-ends", {
    meta: {
        docs: {
            description: "disallow lazy quantifiers at the end of an expression",
            category: "Possible Errors",
            recommended: true,
            default: "warn",
        },
        schema: [
            {
                type: "object",
                properties: {
                    ignorePartial: { type: "boolean" },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            uselessElement: "The quantifier and the quantified element can be removed because the quantifier is lazy and has a minimum of 0.",
            uselessQuantifier: "The quantifier can be removed because the quantifier is lazy and has a minimum of 1.",
            uselessRange: "The quantifier can be replaced with '{{{min}}}' because the quantifier is lazy and has a minimum of {{min}}.",
        },
        type: "problem",
    },
    create(context) {
        var _a, _b;
        const ignorePartial = (_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.ignorePartial) !== null && _b !== void 0 ? _b : true;
        function createVisitor({ node, getRegexpLocation, getUsageOfPattern, }) {
            if (ignorePartial) {
                const usageOfPattern = getUsageOfPattern();
                if (usageOfPattern !== get_usage_of_pattern_1.UsageOfPattern.whole) {
                    return {};
                }
            }
            return {
                onPatternEnter(pNode) {
                    for (const lazy of extractLazyEndQuantifiers(pNode.alternatives)) {
                        if (lazy.min === 0) {
                            context.report({
                                node,
                                loc: getRegexpLocation(lazy),
                                messageId: "uselessElement",
                            });
                        }
                        else if (lazy.min === 1) {
                            context.report({
                                node,
                                loc: getRegexpLocation(lazy),
                                messageId: "uselessQuantifier",
                            });
                        }
                        else {
                            context.report({
                                node,
                                loc: getRegexpLocation(lazy),
                                messageId: "uselessRange",
                                data: {
                                    min: String(lazy.min),
                                },
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

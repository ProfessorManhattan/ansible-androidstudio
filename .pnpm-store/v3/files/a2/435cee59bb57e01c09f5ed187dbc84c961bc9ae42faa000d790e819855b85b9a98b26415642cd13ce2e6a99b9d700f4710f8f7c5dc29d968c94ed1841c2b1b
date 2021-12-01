"use strict";
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids using the `shareReplay` operator.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "shareReplay is forbidden.",
            forbiddenWithoutConfig: "shareReplay is forbidden unless a config argument is passed.",
        },
        schema: [
            {
                properties: {
                    allowConfig: { type: "boolean" },
                },
                type: "object",
            },
        ],
        type: "problem",
    },
    name: "no-sharereplay",
    create: (context, unused) => {
        const [config = {}] = context.options;
        const { allowConfig = true } = config;
        return {
            "CallExpression[callee.name='shareReplay']": (node) => {
                let report = true;
                if (allowConfig) {
                    report =
                        node.arguments.length !== 1 ||
                            node.arguments[0].type !== "ObjectExpression";
                }
                if (report) {
                    context.report({
                        messageId: allowConfig ? "forbiddenWithoutConfig" : "forbidden",
                        node: node.callee,
                    });
                }
            },
        };
    },
});
module.exports = rule;

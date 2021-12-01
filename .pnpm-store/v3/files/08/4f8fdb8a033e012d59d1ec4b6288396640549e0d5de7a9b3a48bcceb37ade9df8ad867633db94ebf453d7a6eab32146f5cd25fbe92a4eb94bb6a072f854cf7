"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids using `ReplaySubject`, `publishReplay` or `shareReplay` without specifying the buffer size.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Ignoring the buffer size is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-ignored-replay-buffer",
    create: (context) => {
        function checkNode(node, { arguments: args }) {
            if (!args || args.length === 0) {
                context.report({
                    messageId: "forbidden",
                    node,
                });
            }
        }
        return {
            "NewExpression > Identifier[name='ReplaySubject']": (node) => {
                const newExpression = (0, eslint_etc_1.getParent)(node);
                checkNode(node, newExpression);
            },
            "NewExpression > MemberExpression > Identifier[name='ReplaySubject']": (node) => {
                const memberExpression = (0, eslint_etc_1.getParent)(node);
                const newExpression = (0, eslint_etc_1.getParent)(memberExpression);
                checkNode(node, newExpression);
            },
            "CallExpression > Identifier[name=/^(publishReplay|shareReplay)$/]": (node) => {
                const callExpression = (0, eslint_etc_1.getParent)(node);
                checkNode(node, callExpression);
            },
        };
    },
});
module.exports = rule;

"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids the passing separate handlers to `subscribe` and `tap`.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Passing separate handlers is forbidden; pass an observer instead.",
        },
        schema: [
            {
                properties: {
                    allowNext: { type: "boolean" },
                },
                type: "object",
            },
        ],
        type: "problem",
    },
    name: "prefer-observer",
    create: (context, unused) => {
        const { couldBeFunction, couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        const [config = {}] = context.options;
        const { allowNext = true } = config;
        function checkArgs(callExpression, reportNode) {
            const { arguments: args, callee } = callExpression;
            if ((0, eslint_etc_1.isMemberExpression)(callee) && !couldBeObservable(callee.object)) {
                return;
            }
            if (args.length > 1) {
                context.report({
                    messageId: "forbidden",
                    node: reportNode,
                });
            }
            else if (args.length === 1 && !allowNext) {
                const [arg] = args;
                if ((0, eslint_etc_1.isArrowFunctionExpression)(arg) ||
                    (0, eslint_etc_1.isFunctionExpression)(arg) ||
                    couldBeFunction(arg)) {
                    context.report({
                        messageId: "forbidden",
                        node: reportNode,
                    });
                }
            }
        }
        return {
            "CallExpression[callee.property.name='pipe'] > CallExpression[callee.name='tap']": (node) => checkArgs(node, node.callee),
            "CallExpression[callee.property.name='subscribe']": (node) => checkArgs(node, node.callee.property),
        };
    },
});
module.exports = rule;

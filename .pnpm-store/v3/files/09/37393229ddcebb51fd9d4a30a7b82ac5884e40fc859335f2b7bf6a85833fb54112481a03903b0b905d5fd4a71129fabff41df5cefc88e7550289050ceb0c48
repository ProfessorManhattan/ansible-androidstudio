"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids operators that return connectable observables.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Connectable observables are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-connectable",
    create: (context) => {
        const { couldBeFunction } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "CallExpression[callee.name='multicast']": (node) => {
                if (node.arguments.length === 1) {
                    context.report({
                        messageId: "forbidden",
                        node: node.callee,
                    });
                }
            },
            "CallExpression[callee.name=/^(publish|publishBehavior|publishLast|publishReplay)$/]": (node) => {
                if (!node.arguments.some((arg) => couldBeFunction(arg))) {
                    context.report({
                        messageId: "forbidden",
                        node: node.callee,
                    });
                }
            },
        };
    },
});
module.exports = rule;

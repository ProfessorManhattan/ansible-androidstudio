"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the passing of handlers to `subscribe`.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Passing handlers to subscribe is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-subscribe-handlers",
    create: (context) => {
        const { couldBeObservable, couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "CallExpression[arguments.length > 0][callee.property.name='subscribe']": (node) => {
                const callee = node.callee;
                if (couldBeObservable(callee.object) ||
                    couldBeType(callee.object, "Subscribable")) {
                    context.report({
                        messageId: "forbidden",
                        node: callee.property,
                    });
                }
            },
        };
    },
});
module.exports = rule;

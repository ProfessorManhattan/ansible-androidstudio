"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids ignoring the subscription returned by `subscribe`.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Ignoring returned subscriptions is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-ignored-subscription",
    create: (context) => {
        const { couldBeObservable, couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "ExpressionStatement > CallExpression > MemberExpression[property.name='subscribe']": (node) => {
                if (couldBeObservable(node.object)) {
                    const callExpression = (0, eslint_etc_1.getParent)(node);
                    if (callExpression.arguments.length === 1 &&
                        couldBeType(callExpression.arguments[0], "Subscriber")) {
                        return;
                    }
                    context.report({
                        messageId: "forbidden",
                        node: node.property,
                    });
                }
            },
        };
    },
});
module.exports = rule;

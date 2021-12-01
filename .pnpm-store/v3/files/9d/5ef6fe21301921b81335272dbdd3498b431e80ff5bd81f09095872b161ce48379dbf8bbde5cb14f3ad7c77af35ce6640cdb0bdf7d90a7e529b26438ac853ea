"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the calling of `subscribe` without specifying an error handler.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Calling subscribe without an error handler is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-ignored-error",
    create: (context) => {
        const { couldBeObservable, couldBeFunction } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "CallExpression[arguments.length > 0] > MemberExpression > Identifier[name='subscribe']": (node) => {
                const memberExpression = (0, eslint_etc_1.getParent)(node);
                const callExpression = (0, eslint_etc_1.getParent)(memberExpression);
                if (callExpression.arguments.length < 2 &&
                    couldBeObservable(memberExpression.object) &&
                    couldBeFunction(callExpression.arguments[0])) {
                    context.report({
                        messageId: "forbidden",
                        node,
                    });
                }
            },
        };
    },
});
module.exports = rule;

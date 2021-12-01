"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the calling of `subscribe` without specifying arguments.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Calling subscribe without arguments is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-ignored-subscribe",
    create: (context) => {
        const { couldBeObservable, couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "CallExpression[arguments.length = 0][callee.property.name='subscribe']": (node) => {
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

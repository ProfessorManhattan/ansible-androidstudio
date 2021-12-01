"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids calling the `unsubscribe` method of a subject instance.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Calling unsubscribe on a subject is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-subject-unsubscribe",
    create: (context) => {
        const { couldBeSubject, couldBeSubscription } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "MemberExpression[property.name='unsubscribe']": (node) => {
                if (couldBeSubject(node.object)) {
                    context.report({
                        messageId: "forbidden",
                        node: node.property,
                    });
                }
            },
            "CallExpression[callee.property.name='add'][arguments.length > 0]": (node) => {
                const memberExpression = node.callee;
                if (couldBeSubscription(memberExpression.object)) {
                    const [arg] = node.arguments;
                    if (couldBeSubject(arg)) {
                        context.report({
                            messageId: "forbidden",
                            node: arg,
                        });
                    }
                }
            },
        };
    },
});
module.exports = rule;

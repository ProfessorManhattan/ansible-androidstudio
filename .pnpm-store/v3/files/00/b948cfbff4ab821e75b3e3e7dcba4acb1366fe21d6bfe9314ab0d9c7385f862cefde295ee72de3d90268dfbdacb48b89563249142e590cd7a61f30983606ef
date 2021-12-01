"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids accessing the `value` property of a `BehaviorSubject` instance.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Accessing the value property of a BehaviorSubject is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-subject-value",
    create: (context) => {
        const { couldBeBehaviorSubject } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "Identifier[name=/^(value|getValue)$/]": (node) => {
                const parent = (0, eslint_etc_1.getParent)(node);
                if (!parent || !("object" in parent)) {
                    return;
                }
                if (couldBeBehaviorSubject(parent.object)) {
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

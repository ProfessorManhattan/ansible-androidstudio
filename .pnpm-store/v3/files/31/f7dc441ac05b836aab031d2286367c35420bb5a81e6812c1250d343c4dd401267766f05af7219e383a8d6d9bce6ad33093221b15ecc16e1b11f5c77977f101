"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the calling of `subscribe` within a `subscribe` callback.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Nested subscribe calls are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-nested-subscribe",
    create: (context) => {
        const { couldBeObservable, couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        const argumentsMap = new WeakMap();
        return {
            [`CallExpression > MemberExpression[property.name='subscribe']`]: (node) => {
                if (!couldBeObservable(node.object) &&
                    !couldBeType(node.object, "Subscribable")) {
                    return;
                }
                const callExpression = (0, eslint_etc_1.getParent)(node);
                let parent = (0, eslint_etc_1.getParent)(callExpression);
                while (parent) {
                    if (argumentsMap.has(parent)) {
                        context.report({
                            messageId: "forbidden",
                            node: node.property,
                        });
                        return;
                    }
                    parent = (0, eslint_etc_1.getParent)(parent);
                }
                for (const arg of callExpression.arguments) {
                    argumentsMap.set(arg);
                }
            },
        };
    },
});
module.exports = rule;

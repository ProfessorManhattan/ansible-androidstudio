"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the passing of unbound methods.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Unbound methods are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-unbound-methods",
    create: (context) => {
        const { couldBeObservable, couldBeSubscription, getType } = (0, eslint_etc_1.getTypeServices)(context);
        const nodeMap = new WeakMap();
        function mapArguments(node) {
            node.arguments.filter(eslint_etc_1.isMemberExpression).forEach((arg) => {
                const argType = getType(arg);
                if (argType.getCallSignatures().length > 0) {
                    nodeMap.set(arg);
                }
            });
        }
        function isObservableOrSubscription(node, action) {
            if (!(0, eslint_etc_1.isMemberExpression)(node.callee)) {
                return;
            }
            if (couldBeObservable(node.callee.object) ||
                couldBeSubscription(node.callee.object)) {
                action(node);
            }
        }
        return {
            "CallExpression[callee.property.name='pipe']": (node) => {
                isObservableOrSubscription(node, ({ arguments: args }) => {
                    args.filter(eslint_etc_1.isCallExpression).forEach(mapArguments);
                });
            },
            "CallExpression[callee.property.name=/^(add|subscribe)$/]": (node) => {
                isObservableOrSubscription(node, mapArguments);
            },
            "NewExpression[callee.name='Subscription']": mapArguments,
            ThisExpression: (node) => {
                let parent = (0, eslint_etc_1.getParent)(node);
                while (parent) {
                    if (nodeMap.has(parent)) {
                        context.report({
                            messageId: "forbidden",
                            node: parent,
                        });
                        return;
                    }
                    parent = (0, eslint_etc_1.getParent)(parent);
                }
            },
        };
    },
});
module.exports = rule;

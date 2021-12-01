"use strict";
const common_tags_1 = require("common-tags");
const eslint_etc_1 = require("eslint-etc");
const constants_1 = require("../constants");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids unsafe `first`/`take` usage in effects and epics.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Unsafe first and take usage in effects and epics are forbidden.",
        },
        schema: [
            {
                properties: {
                    observable: { type: "string" },
                },
                type: "object",
                description: (0, common_tags_1.stripIndent) `
          An optional object with an optional \`observable\` property.
          The property can be specified as a regular expression string and is used to identify the action observables from which effects and epics are composed.`,
            },
        ],
        type: "problem",
    },
    name: "no-unsafe-first",
    create: (context, unused) => {
        const invalidOperatorsRegExp = /^(take|first)$/;
        const [config = {}] = context.options;
        const { observable = constants_1.defaultObservable } = config;
        const observableRegExp = new RegExp(observable);
        const { couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        const nodes = [];
        function checkNode(node) {
            if (!node.arguments || !couldBeObservable(node)) {
                return;
            }
            node.arguments.forEach((arg) => {
                if ((0, eslint_etc_1.isCallExpression)(arg) && (0, eslint_etc_1.isIdentifier)(arg.callee)) {
                    if (invalidOperatorsRegExp.test(arg.callee.name)) {
                        context.report({
                            messageId: "forbidden",
                            node: arg.callee,
                        });
                    }
                }
            });
        }
        return {
            [`CallExpression[callee.property.name='pipe'][callee.object.name=${observableRegExp}]`]: (node) => {
                if (nodes.push(node) === 1) {
                    checkNode(node);
                }
            },
            [`CallExpression[callee.property.name='pipe'][callee.object.name=${observableRegExp}]:exit`]: () => {
                nodes.pop();
            },
            [`CallExpression[callee.property.name='pipe'][callee.object.property.name=${observableRegExp}]`]: (node) => {
                if (nodes.push(node) === 1) {
                    checkNode(node);
                }
            },
            [`CallExpression[callee.property.name='pipe'][callee.object.property.name=${observableRegExp}]:exit`]: () => {
                nodes.pop();
            },
        };
    },
});
module.exports = rule;

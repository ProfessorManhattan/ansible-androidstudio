"use strict";
const common_tags_1 = require("common-tags");
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids the application of operators after `takeUntil`.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Applying operators after takeUntil is forbidden.",
        },
        schema: [
            {
                properties: {
                    alias: { type: "array", items: { type: "string" } },
                    allow: { type: "array", items: { type: "string" } },
                },
                type: "object",
                description: (0, common_tags_1.stripIndent) `
          An optional object with optional \`alias\` and \`allow\` properties.
          The \`alias\` property is an array containing the names of operators that aliases for \`takeUntil\`.
          The \`allow\` property is an array containing the names of the operators that are allowed to follow \`takeUntil\`.`,
            },
        ],
        type: "problem",
    },
    name: "no-unsafe-takeuntil",
    create: (context, unused) => {
        let checkedOperatorsRegExp = /^takeUntil$/;
        const allowedOperators = [
            "count",
            "defaultIfEmpty",
            "endWith",
            "every",
            "finalize",
            "finally",
            "isEmpty",
            "last",
            "max",
            "min",
            "publish",
            "publishBehavior",
            "publishLast",
            "publishReplay",
            "reduce",
            "share",
            "shareReplay",
            "skipLast",
            "takeLast",
            "throwIfEmpty",
            "toArray",
        ];
        const [config = {}] = context.options;
        const { alias, allow = allowedOperators } = config;
        if (alias) {
            checkedOperatorsRegExp = new RegExp(`^(${alias.concat("takeUntil").join("|")})$`);
        }
        const { couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            [`CallExpression[callee.property.name='pipe'] > CallExpression[callee.name=${checkedOperatorsRegExp}]`]: (node) => {
                const pipeCallExpression = (0, eslint_etc_1.getParent)(node);
                if (!pipeCallExpression.arguments ||
                    !couldBeObservable(pipeCallExpression)) {
                    return;
                }
                pipeCallExpression.arguments.reduceRight((state, arg) => {
                    if (state === "taken") {
                        return state;
                    }
                    if (!(0, eslint_etc_1.isCallExpression)(arg) || !(0, eslint_etc_1.isIdentifier)(arg.callee)) {
                        return "disallowed";
                    }
                    if (checkedOperatorsRegExp.test(arg.callee.name)) {
                        if (state === "disallowed") {
                            context.report({
                                messageId: "forbidden",
                                node: arg.callee,
                            });
                        }
                        return "taken";
                    }
                    if (!allow.includes(arg.callee.name)) {
                        return "disallowed";
                    }
                    return state;
                }, "allowed");
            },
        };
    },
});
module.exports = rule;

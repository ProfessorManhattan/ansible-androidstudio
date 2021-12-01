"use strict";
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
function isParenthesised(sourceCode, node) {
    const before = sourceCode.getTokenBefore(node);
    const after = sourceCode.getTokenAfter(node);
    return (before &&
        after &&
        before.value === "(" &&
        before.range[1] <= node.range[0] &&
        after.value === ")" &&
        after.range[0] >= node.range[1]);
}
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids implicit `any` error parameters in `catchError` operators.",
            recommended: "error",
            suggestion: true,
        },
        fixable: "code",
        hasSuggestions: true,
        messages: {
            explicitAny: "Explicit `any` in `catchError`.",
            implicitAny: "Implicit `any` in `catchError`.",
            narrowed: "Error type must be `unknown` or `any`.",
            suggestExplicitUnknown: "Use `unknown` instead, this will force you to explicitly and safely assert the type is correct.",
        },
        schema: [
            {
                additionalProperties: false,
                properties: {
                    allowExplicitAny: {
                        type: "boolean",
                    },
                },
                type: "object",
            },
        ],
        type: "suggestion",
    },
    name: "no-implicit-any-catch",
    create: (context, unused) => {
        const [config = {}] = context.options;
        const { allowExplicitAny = false } = config;
        const { couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        const sourceCode = context.getSourceCode();
        function checkCallback(callback) {
            if ((0, eslint_etc_1.isArrowFunctionExpression)(callback) ||
                (0, eslint_etc_1.isFunctionExpression)(callback)) {
                const [param] = callback.params;
                if (!param) {
                    return;
                }
                if ((0, eslint_etc_1.hasTypeAnnotation)(param)) {
                    const { typeAnnotation } = param;
                    const { typeAnnotation: { type }, } = typeAnnotation;
                    if (type === experimental_utils_1.AST_NODE_TYPES.TSAnyKeyword) {
                        if (allowExplicitAny) {
                            return;
                        }
                        function fix(fixer) {
                            return fixer.replaceText(typeAnnotation, ": unknown");
                        }
                        context.report({
                            fix,
                            messageId: "explicitAny",
                            node: param,
                            suggest: [
                                {
                                    messageId: "suggestExplicitUnknown",
                                    fix,
                                },
                            ],
                        });
                    }
                    else if (type !== experimental_utils_1.AST_NODE_TYPES.TSUnknownKeyword) {
                        function fix(fixer) {
                            return fixer.replaceText(typeAnnotation, ": unknown");
                        }
                        context.report({
                            messageId: "narrowed",
                            node: param,
                            suggest: [
                                {
                                    messageId: "suggestExplicitUnknown",
                                    fix,
                                },
                            ],
                        });
                    }
                }
                else {
                    function fix(fixer) {
                        if (isParenthesised(sourceCode, param)) {
                            return fixer.insertTextAfter(param, ": unknown");
                        }
                        return [
                            fixer.insertTextBefore(param, "("),
                            fixer.insertTextAfter(param, ": unknown)"),
                        ];
                    }
                    context.report({
                        fix,
                        messageId: "implicitAny",
                        node: param,
                        suggest: [
                            {
                                messageId: "suggestExplicitUnknown",
                                fix,
                            },
                        ],
                    });
                }
            }
        }
        return {
            "CallExpression[callee.name='catchError']": (node) => {
                const [callback] = node.arguments;
                if (!callback) {
                    return;
                }
                checkCallback(callback);
            },
            "CallExpression[callee.property.name='subscribe'],CallExpression[callee.name='tap']": (node) => {
                const { callee } = node;
                if ((0, eslint_etc_1.isMemberExpression)(callee) && !couldBeObservable(callee.object)) {
                    return;
                }
                const [observer, callback] = node.arguments;
                if (callback) {
                    checkCallback(callback);
                }
                else if (observer && (0, eslint_etc_1.isObjectExpression)(observer)) {
                    const errorProperty = observer.properties.find((property) => (0, eslint_etc_1.isProperty)(property) &&
                        (0, eslint_etc_1.isIdentifier)(property.key) &&
                        property.key.name === "error");
                    if (errorProperty) {
                        checkCallback(errorProperty.value);
                    }
                }
            },
        };
    },
});
module.exports = rule;

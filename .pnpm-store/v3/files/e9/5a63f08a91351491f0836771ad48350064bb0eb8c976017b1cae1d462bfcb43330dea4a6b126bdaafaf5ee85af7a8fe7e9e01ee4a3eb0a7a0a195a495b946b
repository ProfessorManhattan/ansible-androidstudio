"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const defaultAllowedTypesRegExp = /^EventEmitter$/;
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids exposed (i.e. non-private) subjects.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Subject '{{subject}}' must be private.",
            forbiddenAllowProtected: "Subject '{{subject}}' must be private or protected.",
        },
        schema: [
            {
                properties: {
                    allowProtected: { type: "boolean" },
                },
                type: "object",
            },
        ],
        type: "problem",
    },
    name: "no-exposed-subjects",
    create: (context, unused) => {
        const [config = {}] = context.options;
        const { allowProtected = false } = config;
        const { couldBeSubject, couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        const messageId = allowProtected ? "forbiddenAllowProtected" : "forbidden";
        const accessibilityRexExp = allowProtected
            ? /^(private|protected)$/
            : /^private$/;
        function isSubject(node) {
            return (couldBeSubject(node) && !couldBeType(node, defaultAllowedTypesRegExp));
        }
        return {
            [`PropertyDefinition[accessibility!=${accessibilityRexExp}]`]: (node) => {
                if (isSubject(node)) {
                    const { key } = node;
                    if ((0, eslint_etc_1.isIdentifier)(key)) {
                        context.report({
                            messageId,
                            node: key,
                            data: {
                                subject: key.name,
                            },
                        });
                    }
                }
            },
            [`MethodDefinition[kind='constructor'] > FunctionExpression > TSParameterProperty[accessibility!=${accessibilityRexExp}] > Identifier`]: (node) => {
                if (isSubject(node)) {
                    const { loc } = node;
                    context.report({
                        messageId,
                        loc: {
                            ...loc,
                            end: {
                                ...loc.start,
                                column: loc.start.column + node.name.length,
                            },
                        },
                        data: {
                            subject: node.name,
                        },
                    });
                }
            },
            [`MethodDefinition[accessibility!=${accessibilityRexExp}][kind=/^(get|set)$/]`]: (node) => {
                if (isSubject(node)) {
                    const key = node.key;
                    context.report({
                        messageId,
                        node: key,
                        data: {
                            subject: key.name,
                        },
                    });
                }
            },
            [`MethodDefinition[accessibility!=${accessibilityRexExp}][kind='method']`]: (node) => {
                const functionExpression = node.value;
                const returnType = functionExpression.returnType;
                if (!returnType) {
                    return;
                }
                const typeAnnotation = returnType.typeAnnotation;
                if (!typeAnnotation) {
                    return;
                }
                if (isSubject(typeAnnotation)) {
                    const key = node.key;
                    context.report({
                        messageId,
                        node: key,
                        data: {
                            subject: key.name,
                        },
                    });
                }
            },
        };
    },
});
module.exports = rule;

"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids redundant notifications from completed or errored observables.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Redundant notifications are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-redundant-notify",
    create: (context) => {
        const sourceCode = context.getSourceCode();
        const { couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            "ExpressionStatement[expression.callee.property.name=/^(complete|error)$/] + ExpressionStatement[expression.callee.property.name=/^(next|complete|error)$/]": (node) => {
                const parent = (0, eslint_etc_1.getParent)(node);
                if (!parent) {
                    return;
                }
                if (!(0, eslint_etc_1.isBlockStatement)(parent) && !(0, eslint_etc_1.isProgram)(parent)) {
                    return;
                }
                const { body } = parent;
                const index = body.indexOf(node);
                const sibling = body[index - 1];
                if (getExpressionText(sibling, sourceCode) !==
                    getExpressionText(node, sourceCode)) {
                    return;
                }
                if (!isExpressionObserver(sibling, couldBeType) ||
                    !isExpressionObserver(node, couldBeType)) {
                    return;
                }
                const { expression } = node;
                if ((0, eslint_etc_1.isCallExpression)(expression)) {
                    const { callee } = expression;
                    if ((0, eslint_etc_1.isMemberExpression)(callee)) {
                        const { property } = callee;
                        if ((0, eslint_etc_1.isIdentifier)(property)) {
                            context.report({
                                messageId: "forbidden",
                                node: property,
                            });
                        }
                    }
                }
            },
        };
    },
});
function getExpressionText(expressionStatement, sourceCode) {
    if (!(0, eslint_etc_1.isCallExpression)(expressionStatement.expression)) {
        return undefined;
    }
    const callExpression = expressionStatement.expression;
    if (!(0, eslint_etc_1.isMemberExpression)(callExpression.callee)) {
        return undefined;
    }
    const { object } = callExpression.callee;
    return sourceCode.getText(object);
}
function isExpressionObserver(expressionStatement, couldBeType) {
    if (!(0, eslint_etc_1.isCallExpression)(expressionStatement.expression)) {
        return false;
    }
    const callExpression = expressionStatement.expression;
    if (!(0, eslint_etc_1.isMemberExpression)(callExpression.callee)) {
        return false;
    }
    const { object } = callExpression.callee;
    return couldBeType(object, /^(Subject|Subscriber)$/);
}
module.exports = rule;

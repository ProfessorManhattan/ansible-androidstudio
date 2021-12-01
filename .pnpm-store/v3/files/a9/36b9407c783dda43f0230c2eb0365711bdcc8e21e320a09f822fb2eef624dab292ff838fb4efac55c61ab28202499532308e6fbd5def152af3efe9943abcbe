"use strict";
const tslib_1 = require("tslib");
const common_tags_1 = require("common-tags");
const eslint_etc_1 = require("eslint-etc");
const typescript_1 = (0, tslib_1.__importDefault)(require("typescript"));
const constants_1 = require("../constants");
const utils_1 = require("../utils");
function isTypeReference(type) {
    return Boolean(type.target);
}
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids effects and epics that re-emit filtered actions.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Effects and epics that re-emit filtered actions are forbidden.",
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
    name: "no-cyclic-action",
    create: (context, unused) => {
        const [config = {}] = context.options;
        const { observable = constants_1.defaultObservable } = config;
        const observableRegExp = new RegExp(observable);
        const { getType, typeChecker } = (0, eslint_etc_1.getTypeServices)(context);
        function checkNode(pipeCallExpression) {
            const operatorCallExpression = pipeCallExpression.arguments.find((arg) => (0, eslint_etc_1.isCallExpression)(arg) &&
                (0, eslint_etc_1.isIdentifier)(arg.callee) &&
                arg.callee.name === "ofType");
            if (!operatorCallExpression) {
                return;
            }
            const operatorType = getType(operatorCallExpression);
            const [signature] = typeChecker.getSignaturesOfType(operatorType, typescript_1.default.SignatureKind.Call);
            if (!signature) {
                return;
            }
            const operatorReturnType = typeChecker.getReturnTypeOfSignature(signature);
            if (!isTypeReference(operatorReturnType)) {
                return;
            }
            const [operatorElementType] = typeChecker.getTypeArguments(operatorReturnType);
            if (!operatorElementType) {
                return;
            }
            const pipeType = getType(pipeCallExpression);
            if (!isTypeReference(pipeType)) {
                return;
            }
            const [pipeElementType] = typeChecker.getTypeArguments(pipeType);
            if (!pipeElementType) {
                return;
            }
            const operatorActionTypes = getActionTypes(operatorElementType);
            const pipeActionTypes = getActionTypes(pipeElementType);
            for (const actionType of operatorActionTypes) {
                if (pipeActionTypes.includes(actionType)) {
                    context.report({
                        messageId: "forbidden",
                        node: pipeCallExpression.callee,
                    });
                    return;
                }
            }
        }
        function getActionTypes(type) {
            if (type.isUnion()) {
                const memberActionTypes = [];
                for (const memberType of type.types) {
                    memberActionTypes.push(...getActionTypes(memberType));
                }
                return memberActionTypes;
            }
            const symbol = typeChecker.getPropertyOfType(type, "type");
            if (!symbol || !symbol.valueDeclaration) {
                return [];
            }
            const actionType = typeChecker.getTypeOfSymbolAtLocation(symbol, symbol.valueDeclaration);
            return [typeChecker.typeToString(actionType)];
        }
        return {
            [`CallExpression[callee.property.name='pipe'][callee.object.name=${observableRegExp}]`]: checkNode,
            [`CallExpression[callee.property.name='pipe'][callee.object.property.name=${observableRegExp}]`]: checkNode,
        };
    },
});
module.exports = rule;

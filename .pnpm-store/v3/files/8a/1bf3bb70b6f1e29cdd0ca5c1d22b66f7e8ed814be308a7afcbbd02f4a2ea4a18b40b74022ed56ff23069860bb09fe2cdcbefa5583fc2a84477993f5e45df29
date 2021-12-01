"use strict";
const tslib_1 = require("tslib");
const eslint_etc_1 = require("eslint-etc");
const tsutils = (0, tslib_1.__importStar)(require("tsutils"));
const tsutils_etc_1 = require("tsutils-etc");
const ts = (0, tslib_1.__importStar)(require("typescript"));
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids unsafe optional `next` calls.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Unsafe optional next calls are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-unsafe-subject-next",
    create: (context) => {
        const { esTreeNodeToTSNodeMap } = (0, eslint_etc_1.getParserServices)(context);
        const { typeChecker } = (0, eslint_etc_1.getTypeServices)(context);
        return {
            [`CallExpression[callee.property.name='next']`]: (node) => {
                if (node.arguments.length === 0 && (0, eslint_etc_1.isMemberExpression)(node.callee)) {
                    const type = typeChecker.getTypeAtLocation(esTreeNodeToTSNodeMap.get(node.callee.object));
                    if ((0, tsutils_etc_1.isReferenceType)(type) && (0, tsutils_etc_1.couldBeType)(type, "Subject")) {
                        const [typeArg] = typeChecker.getTypeArguments(type);
                        if (tsutils.isTypeFlagSet(typeArg, ts.TypeFlags.Any)) {
                            return;
                        }
                        if (tsutils.isTypeFlagSet(typeArg, ts.TypeFlags.Unknown)) {
                            return;
                        }
                        if (tsutils.isTypeFlagSet(typeArg, ts.TypeFlags.Void)) {
                            return;
                        }
                        if ((0, tsutils_etc_1.isUnionType)(typeArg) &&
                            typeArg.types.some((t) => tsutils.isTypeFlagSet(t, ts.TypeFlags.Void))) {
                            return;
                        }
                        context.report({
                            messageId: "forbidden",
                            node: node.callee.property,
                        });
                    }
                }
            },
        };
    },
});
module.exports = rule;

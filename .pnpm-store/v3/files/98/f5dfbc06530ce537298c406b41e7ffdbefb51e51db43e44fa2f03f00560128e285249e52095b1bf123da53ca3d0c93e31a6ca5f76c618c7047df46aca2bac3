"use strict";
const eslint_etc_1 = require("eslint-etc");
const tsutils_etc_1 = require("tsutils-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Enforces the passing of `Error` values to error notifications.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Passing non-Error values are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "throw-error",
    create: (context) => {
        const { esTreeNodeToTSNodeMap, program } = (0, eslint_etc_1.getParserServices)(context);
        const { couldBeObservable, getType } = (0, eslint_etc_1.getTypeServices)(context);
        function checkNode(node) {
            let type = getType(node);
            if ((0, tsutils_etc_1.couldBeFunction)(type)) {
                const tsNode = esTreeNodeToTSNodeMap.get(node);
                const annotation = tsNode.type;
                const body = tsNode.body;
                type = program.getTypeChecker().getTypeAtLocation(annotation !== null && annotation !== void 0 ? annotation : body);
            }
            if (!(0, tsutils_etc_1.isAny)(type) &&
                !(0, tsutils_etc_1.isUnknown)(type) &&
                !(0, tsutils_etc_1.couldBeType)(type, /^(Error|DOMException)$/)) {
                context.report({
                    messageId: "forbidden",
                    node,
                });
            }
        }
        return {
            "ThrowStatement > *": checkNode,
            "CallExpression[callee.name='throwError']": (node) => {
                if (couldBeObservable(node)) {
                    const [arg] = node.arguments;
                    if (arg) {
                        checkNode(arg);
                    }
                }
            },
        };
    },
});
module.exports = rule;

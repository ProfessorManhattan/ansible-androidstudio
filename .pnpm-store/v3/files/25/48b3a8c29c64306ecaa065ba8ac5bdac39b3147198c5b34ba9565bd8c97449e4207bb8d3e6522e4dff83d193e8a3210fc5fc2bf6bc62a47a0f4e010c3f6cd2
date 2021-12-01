"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids passing `async` functions to `subscribe`.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Passing async functions to subscribe is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-async-subscribe",
    create: (context) => {
        const { couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        function checkNode(node) {
            const parentNode = (0, eslint_etc_1.getParent)(node);
            const callee = parentNode.callee;
            if (couldBeObservable(callee.object)) {
                const { loc } = node;
                const asyncLoc = {
                    ...loc,
                    end: {
                        ...loc.start,
                        column: loc.start.column + 5,
                    },
                };
                context.report({
                    messageId: "forbidden",
                    loc: asyncLoc,
                });
            }
        }
        return {
            "CallExpression[callee.property.name='subscribe'] > FunctionExpression[async=true]": checkNode,
            "CallExpression[callee.property.name='subscribe'] > ArrowFunctionExpression[async=true]": checkNode,
        };
    },
});
module.exports = rule;

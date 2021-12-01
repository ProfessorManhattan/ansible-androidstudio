"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids ignoring the value within `takeWhile`.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Ignoring the value within takeWhile is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-ignored-takewhile-value",
    create: (context) => {
        function checkNode(expression) {
            const scope = context.getScope();
            if (!(0, eslint_etc_1.isImport)(scope, "takeWhile", /^rxjs\/?/)) {
                return;
            }
            let ignored = true;
            const [param] = expression.params;
            if (param && (0, eslint_etc_1.isIdentifier)(param)) {
                const variable = scope.variables.find(({ name }) => name === param.name);
                if (variable && variable.references.length > 0) {
                    ignored = false;
                }
            }
            if (ignored) {
                context.report({
                    messageId: "forbidden",
                    node: expression,
                });
            }
        }
        return {
            "CallExpression[callee.name='takeWhile'] > ArrowFunctionExpression": (node) => checkNode(node),
            "CallExpression[callee.name='takeWhile'] > FunctionExpression": (node) => checkNode(node),
        };
    },
});
module.exports = rule;

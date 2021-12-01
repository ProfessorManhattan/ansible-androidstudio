"use strict";
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the importation from index modules.",
            recommended: "error",
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "RxJS imports from index modules are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-index",
    create: (context) => {
        return {
            [String.raw `ImportDeclaration Literal[value=/^rxjs(?:\u002f\w+)?\u002findex/]`]: (node) => {
                context.report({
                    messageId: "forbidden",
                    node,
                });
            },
        };
    },
});
module.exports = rule;

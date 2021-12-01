"use strict";
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids importation from locations that depend upon `rxjs-compat`.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "'rxjs-compat'-dependent import locations are forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-compat",
    create: (context) => {
        return {
            [String.raw `ImportDeclaration Literal[value=/^rxjs\u002f/]:not(Literal[value=/^rxjs\u002f(ajax|fetch|operators|testing|webSocket)/])`]: (node) => {
                context.report({
                    messageId: "forbidden",
                    node,
                });
            },
        };
    },
});
module.exports = rule;

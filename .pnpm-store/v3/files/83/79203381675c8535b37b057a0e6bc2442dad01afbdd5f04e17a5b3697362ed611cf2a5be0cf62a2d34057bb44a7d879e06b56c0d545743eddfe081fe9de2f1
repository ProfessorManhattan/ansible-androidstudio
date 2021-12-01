"use strict";
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Enforces the use of the RxJS Tools Babel macro.",
            recommended: false,
        },
        fixable: "code",
        hasSuggestions: false,
        messages: {
            macro: "Use the RxJS Tools Babel macro.",
        },
        schema: [],
        type: "problem",
    },
    name: "macro",
    create: (context) => {
        let hasFailure = false;
        let hasMacroImport = false;
        let program = undefined;
        function fix(fixer) {
            return fixer.insertTextBefore(program, `import "babel-plugin-rxjs-tools/macro";\n`);
        }
        return {
            "CallExpression[callee.property.name=/^(pipe|subscribe)$/]": (node) => {
                if (hasFailure || hasMacroImport) {
                    return;
                }
                hasFailure = true;
                context.report({
                    fix,
                    messageId: "macro",
                    node: node.callee,
                });
            },
            "ImportDeclaration[source.value='babel-plugin-rxjs-tools/macro']": (node) => {
                hasMacroImport = true;
            },
            [String.raw `ImportDeclaration[source.value=/^rxjs(\u002f|$)/]`]: (node) => {
                if (hasFailure || hasMacroImport) {
                    return;
                }
                hasFailure = true;
                context.report({
                    fix,
                    messageId: "macro",
                    node,
                });
            },
            Program: (node) => {
                program = node;
            },
        };
    },
});
module.exports = rule;

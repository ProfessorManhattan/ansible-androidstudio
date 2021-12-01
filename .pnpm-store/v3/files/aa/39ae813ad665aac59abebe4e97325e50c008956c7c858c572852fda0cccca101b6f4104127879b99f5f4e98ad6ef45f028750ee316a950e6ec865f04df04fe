"use strict";
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids the importation of internals.",
            recommended: "error",
        },
        fixable: "code",
        hasSuggestions: true,
        messages: {
            forbidden: "RxJS imports from internal are forbidden.",
            suggest: "Import from a non-internal location.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-internal",
    create: (context) => {
        function getReplacement(location) {
            const match = location.match(/^\s*('|")/);
            if (!match) {
                return undefined;
            }
            const [, quote] = match;
            if (/^['"]rxjs\/internal\/ajax/.test(location)) {
                return `${quote}rxjs/ajax${quote}`;
            }
            if (/^['"]rxjs\/internal\/observable\/dom\/fetch/.test(location)) {
                return `${quote}rxjs/fetch${quote}`;
            }
            if (/^['"]rxjs\/internal\/observable\/dom\/webSocket/i.test(location)) {
                return `${quote}rxjs/webSocket${quote}`;
            }
            if (/^['"]rxjs\/internal\/observable/.test(location)) {
                return `${quote}rxjs${quote}`;
            }
            if (/^['"]rxjs\/internal\/operators/.test(location)) {
                return `${quote}rxjs/operators${quote}`;
            }
            if (/^['"]rxjs\/internal\/scheduled/.test(location)) {
                return `${quote}rxjs${quote}`;
            }
            if (/^['"]rxjs\/internal\/scheduler/.test(location)) {
                return `${quote}rxjs${quote}`;
            }
            if (/^['"]rxjs\/internal\/testing/.test(location)) {
                return `${quote}rxjs/testing${quote}`;
            }
            return undefined;
        }
        return {
            [String.raw `ImportDeclaration Literal[value=/^rxjs\u002finternal/]`]: (node) => {
                const replacement = getReplacement(node.raw);
                if (replacement) {
                    function fix(fixer) {
                        return fixer.replaceText(node, replacement);
                    }
                    context.report({
                        fix,
                        messageId: "forbidden",
                        node,
                        suggest: [{ fix, messageId: "suggest" }],
                    });
                }
                else {
                    context.report({
                        messageId: "forbidden",
                        node,
                    });
                }
            },
        };
    },
});
module.exports = rule;

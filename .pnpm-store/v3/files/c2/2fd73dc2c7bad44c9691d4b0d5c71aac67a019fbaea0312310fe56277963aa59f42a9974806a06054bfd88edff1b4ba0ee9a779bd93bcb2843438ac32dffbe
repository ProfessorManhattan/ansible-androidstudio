"use strict";
const common_tags_1 = require("common-tags");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids the use of banned observables.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "RxJS observable is banned: {{name}}{{explanation}}.",
        },
        schema: [
            {
                type: "object",
                description: (0, common_tags_1.stripIndent) `
          An object containing keys that are names of observable factory functions
          and values that are either booleans or strings containing the explanation for the ban.`,
            },
        ],
        type: "problem",
    },
    name: "ban-observables",
    create: (context, unused) => {
        let bans = [];
        const [config] = context.options;
        if (!config) {
            return {};
        }
        Object.entries(config).forEach(([key, value]) => {
            if (value !== false) {
                bans.push({
                    explanation: typeof value === "string" ? value : "",
                    regExp: new RegExp(`^${key}$`),
                });
            }
        });
        function getFailure(name) {
            for (let b = 0, length = bans.length; b < length; ++b) {
                const ban = bans[b];
                if (ban.regExp.test(name)) {
                    const explanation = ban.explanation ? `: ${ban.explanation}` : "";
                    return {
                        messageId: "forbidden",
                        data: { name, explanation },
                    };
                }
            }
            return undefined;
        }
        return {
            "ImportDeclaration[source.value='rxjs'] > ImportSpecifier": (node) => {
                const identifier = node.imported;
                const failure = getFailure(identifier.name);
                if (failure) {
                    context.report({
                        ...failure,
                        node: identifier,
                    });
                }
            },
        };
    },
});
module.exports = rule;

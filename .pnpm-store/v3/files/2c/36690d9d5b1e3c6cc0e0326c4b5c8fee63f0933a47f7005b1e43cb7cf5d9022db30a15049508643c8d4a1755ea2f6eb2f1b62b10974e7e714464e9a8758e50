"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const rule = (0, utils_1.ruleCreator)({
    defaultOptions: [],
    meta: {
        docs: {
            description: "Forbids subclassing RxJS classes.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Subclassing RxJS classes is forbidden.",
        },
        schema: [],
        type: "problem",
    },
    name: "no-subclass",
    create: (context) => {
        const { couldBeType } = (0, eslint_etc_1.getTypeServices)(context);
        const queryNames = [
            "AsyncSubject",
            "BehaviorSubject",
            "Observable",
            "ReplaySubject",
            "Scheduler",
            "Subject",
            "Subscriber",
        ];
        return {
            [`ClassDeclaration[superClass.name=/^(${queryNames.join("|")})$/] > Identifier.superClass`]: (node) => {
                if (queryNames.some((name) => couldBeType(node, name, { name: /[\/\\]rxjs[\/\\]/ }))) {
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

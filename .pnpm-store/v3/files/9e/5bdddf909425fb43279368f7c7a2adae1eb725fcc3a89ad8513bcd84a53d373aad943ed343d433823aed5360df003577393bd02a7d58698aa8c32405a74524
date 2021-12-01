"use strict";
const tslib_1 = require("tslib");
const common_tags_1 = require("common-tags");
const decamelize_1 = (0, tslib_1.__importDefault)(require("decamelize"));
const eslint_etc_1 = require("eslint-etc");
const constants_1 = require("../constants");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Forbids unsafe `switchMap` usage in effects and epics.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            forbidden: "Unsafe switchMap usage in effects and epics is forbidden.",
        },
        schema: [
            {
                properties: {
                    allow: {
                        oneOf: [
                            { type: "string" },
                            { type: "array", items: { type: "string" } },
                        ],
                    },
                    disallow: {
                        oneOf: [
                            { type: "string" },
                            { type: "array", items: { type: "string" } },
                        ],
                    },
                    observable: {
                        oneOf: [
                            { type: "string" },
                            { type: "array", items: { type: "string" } },
                        ],
                    },
                },
                type: "object",
                description: (0, common_tags_1.stripIndent) `
          An optional object with optional \`allow\`, \`disallow\` and \`observable\` properties.
          The properties can be specified as regular expression strings or as arrays of words.
          The \`allow\` or \`disallow\` properties are mutually exclusive. Whether or not
          \`switchMap\` is allowed will depend upon the matching of action types with \`allow\` or \`disallow\`.
          The \`observable\` property is used to identify the action observables from which effects and epics are composed.
        `,
            },
        ],
        type: "problem",
    },
    name: "no-unsafe-switchmap",
    create: (context, unused) => {
        var _a, _b, _c;
        const defaultDisallow = [
            "add",
            "create",
            "delete",
            "post",
            "put",
            "remove",
            "set",
            "update",
        ];
        let allowRegExp;
        let disallowRegExp;
        let observableRegExp;
        const [config = {}] = context.options;
        if (config.allow || config.disallow) {
            allowRegExp = (0, utils_1.createRegExpForWords)((_a = config.allow) !== null && _a !== void 0 ? _a : []);
            disallowRegExp = (0, utils_1.createRegExpForWords)((_b = config.disallow) !== null && _b !== void 0 ? _b : []);
            observableRegExp = new RegExp((_c = config.observable) !== null && _c !== void 0 ? _c : constants_1.defaultObservable);
        }
        else {
            allowRegExp = undefined;
            disallowRegExp = (0, utils_1.createRegExpForWords)(defaultDisallow);
            observableRegExp = new RegExp(constants_1.defaultObservable);
        }
        const { couldBeObservable } = (0, eslint_etc_1.getTypeServices)(context);
        function shouldDisallow(args) {
            const names = args
                .map((arg) => {
                if ((0, eslint_etc_1.isLiteral)(arg) && typeof arg.value === "string") {
                    return arg.value;
                }
                if ((0, eslint_etc_1.isIdentifier)(arg)) {
                    return arg.name;
                }
                if ((0, eslint_etc_1.isMemberExpression)(arg) && (0, eslint_etc_1.isIdentifier)(arg.property)) {
                    return arg.property.name;
                }
                return "";
            })
                .map((name) => (0, decamelize_1.default)(name));
            if (allowRegExp) {
                return !names.every((name) => allowRegExp === null || allowRegExp === void 0 ? void 0 : allowRegExp.test(name));
            }
            if (disallowRegExp) {
                return names.some((name) => disallowRegExp === null || disallowRegExp === void 0 ? void 0 : disallowRegExp.test(name));
            }
            return false;
        }
        function checkNode(node) {
            if (!node.arguments || !couldBeObservable(node)) {
                return;
            }
            const hasUnsafeOfType = node.arguments.some((arg) => {
                if ((0, eslint_etc_1.isCallExpression)(arg) &&
                    (0, eslint_etc_1.isIdentifier)(arg.callee) &&
                    arg.callee.name === "ofType") {
                    return shouldDisallow(arg.arguments);
                }
                return false;
            });
            if (!hasUnsafeOfType) {
                return;
            }
            node.arguments.forEach((arg) => {
                if ((0, eslint_etc_1.isCallExpression)(arg) &&
                    (0, eslint_etc_1.isIdentifier)(arg.callee) &&
                    arg.callee.name === "switchMap") {
                    context.report({
                        messageId: "forbidden",
                        node: arg.callee,
                    });
                }
            });
        }
        return {
            [`CallExpression[callee.property.name='pipe'][callee.object.name=${observableRegExp}]`]: checkNode,
            [`CallExpression[callee.property.name='pipe'][callee.object.property.name=${observableRegExp}]`]: checkNode,
        };
    },
});
module.exports = rule;

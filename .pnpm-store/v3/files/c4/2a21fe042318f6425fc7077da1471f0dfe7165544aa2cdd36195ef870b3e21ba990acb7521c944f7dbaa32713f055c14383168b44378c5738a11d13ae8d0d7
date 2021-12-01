"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const natural_compare_1 = __importDefault(require("natural-compare"));
const utils_1 = require("../utils");
const eslint_utils_1 = require("eslint-utils");
const jsonc_eslint_parser_1 = require("jsonc-eslint-parser");
function getPropertyName(node) {
    const prop = node.key;
    if (prop.type === "JSONIdentifier") {
        return prop.name;
    }
    return String((0, jsonc_eslint_parser_1.getStaticJSONValue)(prop));
}
function isCompatibleWithESLintOptions(options) {
    if (options.length === 0) {
        return true;
    }
    if (typeof options[0] === "string" || options[0] == null) {
        return true;
    }
    return false;
}
function buildValidatorFromType(order, insensitive, natural) {
    let compare = natural
        ? ([a, b]) => (0, natural_compare_1.default)(a, b) <= 0
        : ([a, b]) => a <= b;
    if (insensitive) {
        const baseCompare = compare;
        compare = ([a, b]) => baseCompare([a.toLowerCase(), b.toLowerCase()]);
    }
    if (order === "desc") {
        const baseCompare = compare;
        compare = (args) => baseCompare(args.reverse());
    }
    return (a, b) => compare([a, b]);
}
function parseOptions(options) {
    var _a, _b, _c;
    if (isCompatibleWithESLintOptions(options)) {
        const type = (_a = options[0]) !== null && _a !== void 0 ? _a : "asc";
        const obj = (_b = options[1]) !== null && _b !== void 0 ? _b : {};
        const insensitive = obj.caseSensitive === false;
        const natural = Boolean(obj.natural);
        const minKeys = (_c = obj.minKeys) !== null && _c !== void 0 ? _c : 2;
        return [
            {
                isTargetObject: () => true,
                ignore: () => false,
                isValidOrder: buildValidatorFromType(type, insensitive, natural),
                minKeys,
                orderText: `${natural ? "natural " : ""}${insensitive ? "insensitive " : ""}${type}ending`,
            },
        ];
    }
    return options.map((opt) => {
        var _a, _b, _c;
        const order = opt.order;
        const pathPattern = new RegExp(opt.pathPattern);
        const hasProperties = (_a = opt.hasProperties) !== null && _a !== void 0 ? _a : [];
        const minKeys = (_b = opt.minKeys) !== null && _b !== void 0 ? _b : 2;
        if (!Array.isArray(order)) {
            const type = (_c = order.type) !== null && _c !== void 0 ? _c : "asc";
            const insensitive = order.caseSensitive === false;
            const natural = Boolean(order.natural);
            return {
                isTargetObject,
                ignore: () => false,
                isValidOrder: buildValidatorFromType(type, insensitive, natural),
                minKeys,
                orderText: `${natural ? "natural " : ""}${insensitive ? "insensitive " : ""}${type}ending`,
            };
        }
        return {
            isTargetObject,
            ignore: (s) => !order.includes(s),
            isValidOrder(a, b) {
                const aIndex = order.indexOf(a);
                const bIndex = order.indexOf(b);
                return aIndex <= bIndex;
            },
            minKeys,
            orderText: "specified",
        };
        function isTargetObject(node) {
            if (hasProperties.length > 0) {
                const names = new Set(node.properties.map(getPropertyName));
                if (!hasProperties.every((name) => names.has(name))) {
                    return false;
                }
            }
            let path = "";
            let curr = node;
            let p = curr.parent;
            while (p) {
                if (p.type === "JSONProperty") {
                    const name = getPropertyName(p);
                    if (/^[$_a-z][\w$]*$/iu.test(name)) {
                        path = `.${name}${path}`;
                    }
                    else {
                        path = `[${JSON.stringify(name)}]${path}`;
                    }
                }
                else if (p.type === "JSONArrayExpression") {
                    const index = p.elements.indexOf(curr);
                    path = `[${index}]${path}`;
                }
                curr = p;
                p = curr.parent;
            }
            if (path.startsWith(".")) {
                path = path.slice(1);
            }
            return pathPattern.test(path);
        }
    });
}
const allowOrderTypes = ["asc", "desc"];
exports.default = (0, utils_1.createRule)("sort-keys", {
    meta: {
        docs: {
            description: "require object keys to be sorted",
            recommended: null,
            extensionRule: true,
            layout: false,
        },
        fixable: "code",
        schema: {
            oneOf: [
                {
                    type: "array",
                    items: {
                        type: "object",
                        properties: {
                            pathPattern: { type: "string" },
                            hasProperties: {
                                type: "array",
                                items: { type: "string" },
                            },
                            order: {
                                oneOf: [
                                    {
                                        type: "array",
                                        items: { type: "string" },
                                        uniqueItems: true,
                                    },
                                    {
                                        type: "object",
                                        properties: {
                                            type: {
                                                enum: allowOrderTypes,
                                            },
                                            caseSensitive: {
                                                type: "boolean",
                                            },
                                            natural: {
                                                type: "boolean",
                                            },
                                        },
                                        additionalProperties: false,
                                    },
                                ],
                            },
                            minKeys: {
                                type: "integer",
                                minimum: 2,
                            },
                        },
                        required: ["pathPattern", "order"],
                        additionalProperties: false,
                    },
                    minItems: 1,
                },
                {
                    type: "array",
                    items: [
                        {
                            enum: allowOrderTypes,
                        },
                        {
                            type: "object",
                            properties: {
                                caseSensitive: {
                                    type: "boolean",
                                },
                                natural: {
                                    type: "boolean",
                                },
                                minKeys: {
                                    type: "integer",
                                    minimum: 2,
                                },
                            },
                            additionalProperties: false,
                        },
                    ],
                    additionalItems: false,
                },
            ],
        },
        messages: {
            sortKeys: "Expected object keys to be in {{orderText}} order. '{{thisName}}' should be before '{{prevName}}'.",
        },
        type: "suggestion",
    },
    create(context) {
        if (!context.parserServices.isJSON) {
            return {};
        }
        const parsedOptions = parseOptions(context.options);
        let stack = {
            upper: null,
            prevList: [],
            numKeys: 0,
            option: null,
        };
        return {
            JSONObjectExpression(node) {
                stack = {
                    upper: stack,
                    prevList: [],
                    numKeys: node.properties.length,
                    option: parsedOptions.find((o) => o.isTargetObject(node)) ||
                        null,
                };
            },
            "JSONObjectExpression:exit"() {
                stack = stack.upper;
            },
            JSONProperty(node) {
                const option = stack.option;
                if (!option) {
                    return;
                }
                const thisName = getPropertyName(node);
                if (option.ignore(thisName)) {
                    return;
                }
                const prevList = stack.prevList;
                const numKeys = stack.numKeys;
                stack.prevList = [
                    {
                        name: thisName,
                        node,
                    },
                    ...prevList,
                ];
                if (prevList.length === 0 || numKeys < option.minKeys) {
                    return;
                }
                const prevName = prevList[0].name;
                if (!option.isValidOrder(prevName, thisName)) {
                    context.report({
                        loc: node.key.loc,
                        messageId: "sortKeys",
                        data: {
                            thisName,
                            prevName,
                            orderText: option.orderText,
                        },
                        *fix(fixer) {
                            const sourceCode = context.getSourceCode();
                            let moveTarget = prevList[0].node;
                            for (const prev of prevList) {
                                if (option.isValidOrder(prev.name, thisName)) {
                                    break;
                                }
                                else {
                                    moveTarget = prev.node;
                                }
                            }
                            const beforeToken = sourceCode.getTokenBefore(node);
                            const afterToken = sourceCode.getTokenAfter(node);
                            const hasAfterComma = (0, eslint_utils_1.isCommaToken)(afterToken);
                            const codeStart = beforeToken.range[1];
                            const codeEnd = hasAfterComma
                                ? afterToken.range[1]
                                : node.range[1];
                            const removeStart = hasAfterComma
                                ? codeStart
                                : beforeToken.range[0];
                            const insertCode = sourceCode.text.slice(codeStart, codeEnd) +
                                (hasAfterComma ? "" : ",");
                            const insertTarget = sourceCode.getTokenBefore(moveTarget);
                            yield fixer.insertTextAfterRange(insertTarget.range, insertCode);
                            yield fixer.removeRange([removeStart, codeEnd]);
                        },
                    });
                }
            },
        };
    },
});

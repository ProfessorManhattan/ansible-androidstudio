"use strict";
const eslint_etc_1 = require("eslint-etc");
const utils_1 = require("../utils");
const defaultOptions = [];
const rule = (0, utils_1.ruleCreator)({
    defaultOptions,
    meta: {
        docs: {
            description: "Enforces the use of Finnish notation.",
            recommended: false,
        },
        fixable: undefined,
        hasSuggestions: false,
        messages: {
            shouldBeFinnish: "Finnish notation should be used here.",
            shouldNotBeFinnish: "Finnish notation should not be used here.",
        },
        schema: [
            {
                properties: {
                    functions: { type: "boolean" },
                    methods: { type: "boolean" },
                    names: { type: "object" },
                    parameters: { type: "boolean" },
                    properties: { type: "boolean" },
                    strict: { type: "boolean" },
                    types: { type: "object" },
                    variables: { type: "boolean" },
                },
                type: "object",
            },
        ],
        type: "problem",
    },
    name: "finnish",
    create: (context, unused) => {
        const { esTreeNodeToTSNodeMap } = (0, eslint_etc_1.getParserServices)(context);
        const { couldBeObservable, couldBeType, couldReturnObservable, couldReturnType, } = (0, eslint_etc_1.getTypeServices)(context);
        const [config = {}] = context.options;
        const { strict = false } = config;
        const validate = {
            functions: true,
            methods: true,
            parameters: true,
            properties: true,
            variables: true,
            ...config,
        };
        const names = [];
        if (config.names) {
            Object.entries(config.names).forEach(([key, validate]) => {
                names.push({ regExp: new RegExp(key), validate });
            });
        }
        else {
            names.push({
                regExp: /^(canActivate|canActivateChild|canDeactivate|canLoad|intercept|resolve|validate)$/,
                validate: false,
            });
        }
        const types = [];
        if (config.types) {
            Object.entries(config.types).forEach(([key, validate]) => {
                types.push({ regExp: new RegExp(key), validate });
            });
        }
        else {
            types.push({
                regExp: /^EventEmitter$/,
                validate: false,
            });
        }
        function checkNode(nameNode, typeNode) {
            let tsNode = esTreeNodeToTSNodeMap.get(nameNode);
            const text = tsNode.getText();
            const hasFinnish = /\$$/.test(text);
            if (hasFinnish && !strict) {
                return;
            }
            const shouldBeFinnish = hasFinnish
                ? () => { }
                : () => context.report({
                    loc: (0, eslint_etc_1.getLoc)(tsNode),
                    messageId: "shouldBeFinnish",
                });
            const shouldNotBeFinnish = hasFinnish
                ? () => context.report({
                    loc: (0, eslint_etc_1.getLoc)(tsNode),
                    messageId: "shouldNotBeFinnish",
                })
                : () => { };
            if (couldBeObservable(typeNode || nameNode) ||
                couldReturnObservable(typeNode || nameNode)) {
                for (const name of names) {
                    const { regExp, validate } = name;
                    if (regExp.test(text) && !validate) {
                        shouldNotBeFinnish();
                        return;
                    }
                }
                for (const type of types) {
                    const { regExp, validate } = type;
                    if ((couldBeType(typeNode || nameNode, regExp) ||
                        couldReturnType(typeNode || nameNode, regExp)) &&
                        !validate) {
                        shouldNotBeFinnish();
                        return;
                    }
                }
                shouldBeFinnish();
            }
            else {
                shouldNotBeFinnish();
            }
        }
        return {
            "ArrayPattern > Identifier": (node) => {
                const found = (0, eslint_etc_1.findParent)(node, "ArrowFunctionExpression", "FunctionDeclaration", "FunctionExpression", "VariableDeclarator");
                if (!found) {
                    return;
                }
                if (!validate.variables && found.type === "VariableDeclarator") {
                    return;
                }
                if (!validate.parameters) {
                    return;
                }
                checkNode(node);
            },
            "ArrowFunctionExpression > Identifier": (node) => {
                if (validate.parameters) {
                    const parent = (0, eslint_etc_1.getParent)(node);
                    if (node !== parent.body) {
                        checkNode(node);
                    }
                }
            },
            "PropertyDefinition[computed=false]": (node) => {
                if (validate.properties) {
                    checkNode(node.key);
                }
            },
            "FunctionDeclaration > Identifier": (node) => {
                const parent = (0, eslint_etc_1.getParent)(node);
                if (node === parent.id) {
                    if (validate.functions) {
                        checkNode(node, parent);
                    }
                }
                else {
                    if (validate.parameters) {
                        checkNode(node);
                    }
                }
            },
            "FunctionExpression > Identifier": (node) => {
                const parent = (0, eslint_etc_1.getParent)(node);
                if (node === parent.id) {
                    if (validate.functions) {
                        checkNode(node, parent);
                    }
                }
                else {
                    if (validate.parameters) {
                        checkNode(node);
                    }
                }
            },
            "MethodDefinition[kind='get'][computed=false]": (node) => {
                if (validate.properties) {
                    checkNode(node.key, node);
                }
            },
            "MethodDefinition[kind='method'][computed=false]": (node) => {
                if (validate.methods) {
                    checkNode(node.key, node);
                }
            },
            "MethodDefinition[kind='set'][computed=false]": (node) => {
                if (validate.properties) {
                    checkNode(node.key, node);
                }
            },
            "ObjectExpression > Property[computed=false] > Identifier": (node) => {
                if (validate.properties) {
                    const parent = (0, eslint_etc_1.getParent)(node);
                    if (node === parent.key) {
                        checkNode(node);
                    }
                }
            },
            "ObjectPattern > Property > Identifier": (node) => {
                const found = (0, eslint_etc_1.findParent)(node, "ArrowFunctionExpression", "FunctionDeclaration", "FunctionExpression", "VariableDeclarator");
                if (!found) {
                    return;
                }
                if (!validate.variables && found.type === "VariableDeclarator") {
                    return;
                }
                if (!validate.parameters) {
                    return;
                }
                const parent = (0, eslint_etc_1.getParent)(node);
                if (node === parent.value) {
                    checkNode(node);
                }
            },
            "TSCallSignatureDeclaration > Identifier": (node) => {
                if (validate.parameters) {
                    checkNode(node);
                }
            },
            "TSConstructSignatureDeclaration > Identifier": (node) => {
                if (validate.parameters) {
                    checkNode(node);
                }
            },
            "TSMethodSignature[computed=false]": (node) => {
                if (validate.methods) {
                    checkNode(node.key, node);
                }
                if (validate.parameters) {
                    node.params.forEach((param) => checkNode(param));
                }
            },
            "TSParameterProperty > Identifier": (node) => {
                if (validate.parameters || validate.properties) {
                    checkNode(node);
                }
            },
            "TSPropertySignature[computed=false]": (node) => {
                if (validate.properties) {
                    checkNode(node.key);
                }
            },
            "VariableDeclarator > Identifier": (node) => {
                const parent = (0, eslint_etc_1.getParent)(node);
                if (validate.variables && node === parent.id) {
                    checkNode(node);
                }
            },
        };
    },
});
module.exports = rule;

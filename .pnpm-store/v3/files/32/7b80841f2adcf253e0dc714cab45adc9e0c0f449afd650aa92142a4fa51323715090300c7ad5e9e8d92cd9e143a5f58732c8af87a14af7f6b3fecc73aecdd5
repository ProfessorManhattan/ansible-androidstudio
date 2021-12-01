"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const natural_compare_1 = __importDefault(require("natural-compare"));
const utils_1 = require("../utils");
const ast_utils_1 = require("../utils/ast-utils");
function isNewLine(char) {
    return (char === "\n" || char === "\r" || char === "\u2028" || char === "\u2029");
}
function getPropertyName(node, sourceCode) {
    const prop = node.key;
    if (prop == null) {
        return "";
    }
    const target = prop.type === "YAMLWithMeta" ? prop.value : prop;
    if (target == null) {
        return "";
    }
    if (target.type === "YAMLScalar" && typeof target.value === "string") {
        return target.value;
    }
    return sourceCode.text.slice(...target.range);
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
function parseOptions(options, sourceCode) {
    var _a, _b, _c;
    if (isCompatibleWithESLintOptions(options)) {
        const type = (_a = options[0]) !== null && _a !== void 0 ? _a : "asc";
        const obj = (_b = options[1]) !== null && _b !== void 0 ? _b : {};
        const insensitive = obj.caseSensitive === false;
        const natural = Boolean(obj.natural);
        const minKeys = (_c = obj.minKeys) !== null && _c !== void 0 ? _c : 2;
        return [
            {
                isTargetMapping: () => true,
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
                isTargetMapping,
                ignore: () => false,
                isValidOrder: buildValidatorFromType(type, insensitive, natural),
                minKeys,
                orderText: `${natural ? "natural " : ""}${insensitive ? "insensitive " : ""}${type}ending`,
            };
        }
        return {
            isTargetMapping,
            ignore: (s) => !order.includes(s),
            isValidOrder(a, b) {
                const aIndex = order.indexOf(a);
                const bIndex = order.indexOf(b);
                return aIndex <= bIndex;
            },
            minKeys,
            orderText: "specified",
        };
        function isTargetMapping(node) {
            if (hasProperties.length > 0) {
                const names = new Set(node.pairs.map((p) => getPropertyName(p, sourceCode)));
                if (!hasProperties.every((name) => names.has(name))) {
                    return false;
                }
            }
            let path = "";
            let curr = node;
            let p = curr.parent;
            while (p) {
                if (p.type === "YAMLPair") {
                    const name = getPropertyName(p, sourceCode);
                    if (/^[$_a-z][\w$]*$/iu.test(name)) {
                        path = `.${name}${path}`;
                    }
                    else {
                        path = `[${JSON.stringify(name)}]${path}`;
                    }
                }
                else if (p.type === "YAMLSequence") {
                    const index = p.entries.indexOf(curr);
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
            description: "require mapping keys to be sorted",
            categories: null,
            extensionRule: "sort-keys",
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
            sortKeys: "Expected mapping keys to be in {{orderText}} order. '{{thisName}}' should be before '{{prevName}}'.",
        },
        type: "suggestion",
    },
    create(context) {
        const sourceCode = context.getSourceCode();
        if (!context.parserServices.isYAML) {
            return {};
        }
        const parsedOptions = parseOptions(context.options, sourceCode);
        let mappingStack = {
            upper: null,
            prevList: [],
            numKeys: 0,
            option: null,
        };
        let pairStack = {
            upper: null,
            anchors: new Set(),
            aliases: new Set(),
        };
        function isValidOrder(prevData, thisData, option) {
            if (option.isValidOrder(prevData.name, thisData.name)) {
                return true;
            }
            for (const aliasName of thisData.aliases) {
                if (prevData.anchors.has(aliasName)) {
                    return true;
                }
            }
            for (const anchorName of thisData.anchors) {
                if (prevData.aliases.has(anchorName)) {
                    return true;
                }
            }
            return false;
        }
        return {
            YAMLMapping(node) {
                mappingStack = {
                    upper: mappingStack,
                    prevList: [],
                    numKeys: node.pairs.length,
                    option: parsedOptions.find((o) => o.isTargetMapping(node)) ||
                        null,
                };
            },
            "YAMLMapping:exit"() {
                mappingStack = mappingStack.upper;
            },
            YAMLPair() {
                pairStack = {
                    upper: pairStack,
                    anchors: new Set(),
                    aliases: new Set(),
                };
            },
            YAMLAnchor(node) {
                if (pairStack) {
                    pairStack.anchors.add(node.name);
                }
            },
            YAMLAlias(node) {
                if (pairStack) {
                    pairStack.aliases.add(node.name);
                }
            },
            "YAMLPair:exit"(node) {
                var _a, _b;
                const { anchors, aliases } = pairStack;
                pairStack = pairStack.upper;
                pairStack.anchors = new Set([...pairStack.anchors, ...anchors]);
                pairStack.aliases = new Set([...pairStack.aliases, ...aliases]);
                if (!node.key && !node.value) {
                    return;
                }
                const option = mappingStack.option;
                if (!option) {
                    return;
                }
                const thisName = getPropertyName(node, sourceCode);
                if (option.ignore(thisName)) {
                    return;
                }
                const prevList = mappingStack.prevList;
                const numKeys = mappingStack.numKeys;
                const thisData = {
                    name: thisName,
                    node,
                    anchors,
                    aliases,
                };
                mappingStack.prevList = [thisData, ...prevList];
                if (prevList.length === 0 || numKeys < option.minKeys) {
                    return;
                }
                if (!isValidOrder(prevList[0], thisData, option)) {
                    context.report({
                        loc: (_b = (_a = node.key) === null || _a === void 0 ? void 0 : _a.loc) !== null && _b !== void 0 ? _b : node.loc,
                        messageId: "sortKeys",
                        data: {
                            thisName,
                            prevName: prevList[0].name,
                            orderText: option.orderText,
                        },
                        *fix(fixer) {
                            let moveTarget = prevList[0].node;
                            for (const prev of prevList) {
                                if (isValidOrder(prev, thisData, option)) {
                                    break;
                                }
                                else {
                                    moveTarget = prev.node;
                                }
                            }
                            if (node.parent.style === "flow") {
                                yield* fixForFlow(fixer, node, moveTarget);
                            }
                            else {
                                yield* fixForBlock(fixer, node, moveTarget);
                            }
                        },
                    });
                }
            },
        };
        function* fixForFlow(fixer, node, moveTarget) {
            const beforeCommaToken = sourceCode.getTokenBefore(node);
            let insertCode, removeRange, insertTargetToken;
            const afterCommaToken = sourceCode.getTokenAfter(node);
            const moveTargetBeforeToken = sourceCode.getTokenBefore(moveTarget);
            if ((0, ast_utils_1.isComma)(afterCommaToken)) {
                removeRange = [
                    beforeCommaToken.range[1],
                    afterCommaToken.range[1],
                ];
                insertCode = sourceCode.text.slice(...removeRange);
                insertTargetToken = moveTargetBeforeToken;
            }
            else {
                removeRange = [beforeCommaToken.range[0], node.range[1]];
                if ((0, ast_utils_1.isComma)(moveTargetBeforeToken)) {
                    insertCode = sourceCode.text.slice(...removeRange);
                    insertTargetToken = sourceCode.getTokenBefore(moveTargetBeforeToken);
                }
                else {
                    insertCode = `${sourceCode.text.slice(beforeCommaToken.range[1], node.range[1])},`;
                    insertTargetToken = moveTargetBeforeToken;
                }
            }
            yield fixer.insertTextAfterRange(insertTargetToken.range, insertCode);
            yield fixer.removeRange(removeRange);
        }
        function* fixForBlock(fixer, node, moveTarget) {
            const nodeLocs = getPairRangeForBlock(node);
            const moveTargetLocs = getPairRangeForBlock(moveTarget);
            if (moveTargetLocs.loc.start.column === 0) {
                const removeRange = [
                    getNewlineStartIndex(nodeLocs.range[0]),
                    nodeLocs.range[1],
                ];
                const moveTargetRange = [
                    getNewlineStartIndex(moveTargetLocs.range[0]),
                    moveTargetLocs.range[1],
                ];
                const insertCode = sourceCode.text.slice(...removeRange);
                yield fixer.insertTextBeforeRange(moveTargetRange, `${insertCode}${moveTargetLocs.loc.start.line === 1 ? "\n" : ""}`);
                yield fixer.removeRange(removeRange);
            }
            else {
                const diffIndent = nodeLocs.indentColumn - moveTargetLocs.indentColumn;
                const insertCode = `${sourceCode.text.slice(nodeLocs.range[0] + diffIndent, nodeLocs.range[1])}\n${sourceCode.text.slice(nodeLocs.range[0], nodeLocs.range[0] + diffIndent)}`;
                yield fixer.insertTextBeforeRange(moveTargetLocs.range, `${insertCode}${moveTargetLocs.loc.start.line === 1 ? "\n" : ""}`);
                const removeRange = [
                    getNewlineStartIndex(nodeLocs.range[0]),
                    nodeLocs.range[1],
                ];
                yield fixer.removeRange(removeRange);
            }
        }
        function getNewlineStartIndex(nextIndex) {
            for (let index = nextIndex; index >= 0; index--) {
                const char = sourceCode.text[index];
                if (isNewLine(sourceCode.text[index])) {
                    const prev = sourceCode.text[index - 1];
                    if (prev === "\r" && char === "\n") {
                        return index - 1;
                    }
                    return index;
                }
            }
            return 0;
        }
        function getPairRangeForBlock(node) {
            let endOfRange, end;
            const afterToken = sourceCode.getTokenAfter(node, {
                includeComments: true,
                filter: (t) => !(0, ast_utils_1.isCommentToken)(t) || node.loc.end.line < t.loc.start.line,
            });
            if (!afterToken || node.loc.end.line < afterToken.loc.start.line) {
                const line = afterToken
                    ? afterToken.loc.start.line - 1
                    : node.loc.end.line;
                const lineText = sourceCode.lines[line - 1];
                end = {
                    line,
                    column: lineText.length,
                };
                endOfRange = sourceCode.getIndexFromLoc(end);
            }
            else {
                endOfRange = node.range[1];
                end = node.loc.end;
            }
            const beforeToken = sourceCode.getTokenBefore(node);
            if (beforeToken) {
                const next = sourceCode.getTokenAfter(beforeToken, {
                    includeComments: true,
                });
                if (beforeToken.loc.end.line < next.loc.start.line ||
                    beforeToken.loc.end.line < node.loc.start.line) {
                    const start = {
                        line: beforeToken.loc.end.line < next.loc.start.line
                            ? next.loc.start.line
                            : node.loc.start.line,
                        column: 0,
                    };
                    const startOfRange = sourceCode.getIndexFromLoc(start);
                    return {
                        range: [startOfRange, endOfRange],
                        loc: { start, end },
                        indentColumn: next.loc.start.column,
                    };
                }
                const start = beforeToken.loc.end;
                const startOfRange = beforeToken.range[1];
                return {
                    range: [startOfRange, endOfRange],
                    loc: { start, end },
                    indentColumn: node.range[0] - beforeToken.range[1],
                };
            }
            let next = node;
            for (const beforeComment of sourceCode
                .getTokensBefore(node, {
                includeComments: true,
            })
                .reverse()) {
                if (beforeComment.loc.end.line + 1 < next.loc.start.line) {
                    const start = {
                        line: next.loc.start.line,
                        column: 0,
                    };
                    const startOfRange = sourceCode.getIndexFromLoc(start);
                    return {
                        range: [startOfRange, endOfRange],
                        loc: { start, end },
                        indentColumn: next.loc.start.column,
                    };
                }
                next = beforeComment;
            }
            const start = {
                line: node.loc.start.line,
                column: 0,
            };
            const startOfRange = sourceCode.getIndexFromLoc(start);
            return {
                range: [startOfRange, endOfRange],
                loc: { start, end },
                indentColumn: node.loc.start.column,
            };
        }
    },
});

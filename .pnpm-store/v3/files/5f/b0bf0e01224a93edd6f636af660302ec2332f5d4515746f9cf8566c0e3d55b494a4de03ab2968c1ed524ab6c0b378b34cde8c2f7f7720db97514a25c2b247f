'use strict';

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var experimentalUtils = require('@typescript-eslint/experimental-utils');
var assert = _interopDefault(require('assert'));
var naturalCompare = _interopDefault(require('natural-compare-lite'));

var recommended = {
    plugins: ['typescript-sort-keys'],
    rules: {
        'typescript-sort-keys/interface': 'error',
        'typescript-sort-keys/string-enum': 'error',
    },
};

const nameToIndexSignature = (x) => `[index: ${x}]`;
const indexSignatureRegexp = new RegExp(`^${nameToIndexSignature('.+')}`.replace('[', '\\[').replace(']', '\\]'));
const indexSignature = {
    create: nameToIndexSignature,
    regex: indexSignatureRegexp,
};

function getObjectBody(node) {
    switch (node.type) {
        case experimentalUtils.AST_NODE_TYPES.TSInterfaceDeclaration:
            return node.body.body;
        case experimentalUtils.AST_NODE_TYPES.TSEnumDeclaration:
        case experimentalUtils.AST_NODE_TYPES.TSTypeLiteral:
            return node.members;
    }
}
function getProperty(node) {
    switch (node.type) {
        case experimentalUtils.AST_NODE_TYPES.TSIndexSignature: {
            const [identifier] = node.parameters;
            return Object.assign(Object.assign({}, identifier), { 
                // Override name for error message readability and weight calculation
                name: indexSignature.create(identifier.name) });
        }
        case experimentalUtils.AST_NODE_TYPES.TSPropertySignature:
        case experimentalUtils.AST_NODE_TYPES.TSMethodSignature:
            return node.key;
        case experimentalUtils.AST_NODE_TYPES.TSEnumMember:
            return node.id;
        default:
            return undefined;
    }
}
/**
 * Gets the property name of the given `Property` node.
 *
 * - If the property's key is an `Identifier` node, this returns the key's name
 *   whether it's a computed property or not.
 * - If the property has a static name, this returns the static name.
 * - Otherwise, this returns undefined.
 *
 *     a.b           // => "b"
 *     a["b"]        // => "b"
 *     a['b']        // => "b"
 *     a[`b`]        // => "b"
 *     a[100]        // => "100"
 *     a[b]          // => undefined
 *     a["a" + "b"]  // => undefined
 *     a[tag`b`]     // => undefined
 *     a[`${b}`]     // => undefined
 *
 *     let a = {b: 1}            // => "b"
 *     let a = {["b"]: 1}        // => "b"
 *     let a = {['b']: 1}        // => "b"
 *     let a = {[`b`]: 1}        // => "b"
 *     let a = {[100]: 1}        // => "100"
 *     let a = {[b]: 1}          // => undefined
 *     let a = {["a" + "b"]: 1}  // => undefined
 *     let a = {[tag`b`]: 1}     // => undefined
 *     let a = {[`${b}`]: 1}     // => undefined
 */
function getPropertyName(node) {
    const property = getProperty(node);
    if (!property) {
        return undefined;
    }
    switch (property.type) {
        case experimentalUtils.AST_NODE_TYPES.Literal:
            return String(property.value);
        case experimentalUtils.AST_NODE_TYPES.Identifier:
            return property.name;
        default:
            return undefined;
    }
}
function getPropertyIsOptional(node) {
    switch (node.type) {
        case experimentalUtils.AST_NODE_TYPES.TSMethodSignature:
        case experimentalUtils.AST_NODE_TYPES.TSPropertySignature:
            return Boolean(node.optional);
    }
    return false;
}

var SortingOrder;
(function (SortingOrder) {
    SortingOrder["Ascending"] = "asc";
    SortingOrder["Descending"] = "desc";
})(SortingOrder || (SortingOrder = {}));
const sortingOrderOptionSchema = {
    enum: [SortingOrder.Ascending, SortingOrder.Descending],
};
var ErrorMessage;
(function (ErrorMessage) {
    ErrorMessage["InterfaceInvalidOrder"] = "Expected interface keys to be in {{ requiredFirst }}{{ natural }}{{ insensitive }}{{ order }}ending order. '{{ thisName }}' should be before '{{ prevName }}'.";
    ErrorMessage["StringEnumInvalidOrder"] = "Expected string enum members to be in {{ natural }}{{ insensitive }}{{ order }}ending order. '{{ thisName }}' should be before '{{ prevName }}'.";
})(ErrorMessage || (ErrorMessage = {}));

function charCompare(a, b) {
    if (a < b) {
        return -1;
    }
    if (b < a) {
        return 1;
    }
    return 0;
}
function getWeight(value) {
    switch (true) {
        // Custom name for index signature used here
        case indexSignature.regex.test(value):
            return 100;
        default:
            return 0;
    }
}
function weightedCompare(a, b, compareFn) {
    return compareFn(a, b) - getWeight(a) + getWeight(b);
}
const ascending = (a, b) => {
    return weightedCompare(a, b, charCompare);
};
const ascendingInsensitive = (a, b) => {
    return weightedCompare(a.toLowerCase(), b.toLowerCase(), charCompare);
};
const ascendingNatural = (a, b) => {
    return weightedCompare(a, b, naturalCompare);
};
const ascendingInsensitiveNatural = (a, b) => {
    return weightedCompare(a.toLowerCase(), b.toLowerCase(), naturalCompare);
};
/**
 * Functions which check that the given 2 names are in specific order.
 */
const compareFn = (isAscending, isInsensitive, isNatural) => (...args) => {
    if (args.filter(Boolean).length !== 2) {
        return 0;
    }
    const input = (isAscending ? args : args.reverse());
    if (isInsensitive && isNatural) {
        return ascendingInsensitiveNatural(...input);
    }
    if (!isInsensitive && isNatural) {
        return ascendingNatural(...input);
    }
    if (isInsensitive && !isNatural) {
        return ascendingInsensitive(...input);
    }
    return ascending(...input);
};

function createNodeSwapper(context) {
    const sourceCode = context.getSourceCode();
    /**
     * Returns the indent range of a node if it's the first on its line.
     * Otherwise, returns a range starting immediately after the previous sibling.
     */
    function getIndentRange(node) {
        const prevSibling = sourceCode.getTokenBefore(node);
        const end = node.range[0];
        const start = prevSibling && prevSibling.loc.start.line === node.loc.start.line
            ? prevSibling.range[1] + 1
            : node.range[0] - node.loc.start.column;
        return [start, end];
    }
    function getRangeWithIndent(node) {
        return [getIndentRange(node)[0], node.range[1]];
    }
    /**
     * Returns the range for the entire line, including EOL, if node is the only
     * token on its lines. Otherwise, returns the node range.
     */
    function getLineRange(node) {
        const [start] = getRangeWithIndent(node);
        const index = sourceCode.lineStartIndices.findIndex(n => start === n);
        if (index < 0) {
            // Node is not at the beginning of the line
            return node.range;
        }
        const lines = 1 + node.loc.end.line - node.loc.start.line;
        return [
            sourceCode.lineStartIndices[index],
            sourceCode.lineStartIndices[index + lines],
        ];
    }
    function getIndentText(node) {
        return sourceCode.text.slice(...getIndentRange(node));
    }
    function getNodePunctuator(node) {
        const punctuator = sourceCode.getTokenAfter(node, {
            filter: n => n.type === experimentalUtils.AST_TOKEN_TYPES.Punctuator && n.value !== ':',
            includeComments: false,
        });
        // Check the punctuator value outside of filter because we
        // want to stop traversal on any terminating punctuator
        return punctuator && /^[,;]$/.test(punctuator.value) ? punctuator : undefined;
    }
    return (fixer, nodePositions, currentNode, replaceNode) => [currentNode, replaceNode].reduce((acc, node) => {
        var _a, _b, _c;
        const otherNode = node === currentNode ? replaceNode : currentNode;
        const comments = sourceCode.getCommentsBefore(node);
        const nextSibling = sourceCode.getTokenAfter(node);
        const isLastReplacingLast = ((_a = nodePositions.get(node)) === null || _a === void 0 ? void 0 : _a.final) === nodePositions.size - 1 &&
            ((_b = nodePositions.get(node)) === null || _b === void 0 ? void 0 : _b.final) === ((_c = nodePositions.get(otherNode)) === null || _c === void 0 ? void 0 : _c.initial);
        let text = [
            comments.length ? getIndentText(node) : '',
            sourceCode.getText(node),
        ].join('');
        // If nextSibling is the node punctuator, remove it
        if (nextSibling === getNodePunctuator(node)) {
            acc.push(fixer.remove(nextSibling));
        }
        if (!/[,;]$/.test(text)) {
            // Add a punctuator if the node doesn't already have one
            text += ',';
        }
        if (isLastReplacingLast) {
            // If we're moving the last node to its final destination, we can remove the punctuator
            text = text.replace(/,$/, '');
        }
        if (comments.length) {
            // Insert leading comments above the other node
            acc.push(fixer.insertTextBefore(otherNode, comments
                .map(comment => sourceCode.getText(comment))
                .concat('')
                .join('\n')));
        }
        acc.push(
        // Insert the node before the other node
        fixer.insertTextBefore(otherNode, text), 
        // Remove the original instance of node
        fixer.remove(node), 
        // Remove the original instances of node comments
        ...comments.map(n => fixer.removeRange(getLineRange(n))));
        return acc;
    }, []);
}
function createReporter(context, createReportObject) {
    // Parse options.
    const order = context.options[0] || SortingOrder.Ascending;
    const options = context.options[1];
    const isAscending = order === SortingOrder.Ascending;
    const isInsensitive = (options && options.caseSensitive) === false;
    const isNatural = Boolean(options && options.natural);
    const isRequiredFirst = (options && options.requiredFirst) === true;
    const compare = compareFn(isAscending, isInsensitive, isNatural);
    const swapNodes = createNodeSwapper(context);
    return (body) => {
        const sortedBody = isRequiredFirst
            ? [
                ...body
                    .slice(0)
                    .filter(node => !getPropertyIsOptional(node))
                    .sort((a, b) => compare(getPropertyName(a), getPropertyName(b))),
                ...body
                    .slice(0)
                    .filter(node => getPropertyIsOptional(node))
                    .sort((a, b) => compare(getPropertyName(a), getPropertyName(b))),
            ]
            : body.slice(0).sort((a, b) => compare(getPropertyName(a), getPropertyName(b)));
        const nodePositions = new Map(body.map(n => [n, { initial: body.indexOf(n), final: sortedBody.indexOf(n) }]));
        for (let i = 1; i < body.length; i += 1) {
            const prevNode = body[i - 1];
            const currentNode = body[i];
            const prevNodeName = getPropertyName(prevNode);
            const currentNodeName = getPropertyName(currentNode);
            if ((!isRequiredFirst && compare(prevNodeName, currentNodeName) > 0) ||
                (isRequiredFirst &&
                    getPropertyIsOptional(prevNode) === getPropertyIsOptional(currentNode) &&
                    compare(prevNodeName, currentNodeName) > 0) ||
                (isRequiredFirst &&
                    getPropertyIsOptional(prevNode) !== getPropertyIsOptional(currentNode) &&
                    getPropertyIsOptional(prevNode))) {
                const targetPosition = sortedBody.indexOf(currentNode);
                const replaceNode = body[targetPosition];
                const { loc, messageId } = createReportObject(currentNode);
                // Sanity check
                assert(loc, 'createReportObject return value must include a node location');
                assert(messageId, 'createReportObject return value must include a problem message');
                context.report({
                    loc,
                    messageId,
                    node: currentNode,
                    data: {
                        thisName: currentNodeName,
                        prevName: prevNodeName,
                        order,
                        insensitive: isInsensitive ? 'insensitive ' : '',
                        natural: isNatural ? 'natural ' : '',
                        requiredFirst: isRequiredFirst ? 'required first ' : '',
                    },
                    fix: fixer => {
                        if (currentNode !== replaceNode) {
                            return swapNodes(fixer, nodePositions, currentNode, replaceNode);
                        }
                        return null;
                    },
                });
            }
        }
    };
}

/**
 * Create a rule.
 */
function createRule(data) {
    return experimentalUtils.ESLintUtils.RuleCreator(name => `https://github.com/infctr/eslint-plugin-typescript-sort-keys/blob/master/docs/rules/${name}.md`)(data);
}

/**
 * The name of this rule.
 */
const name = 'interface';
const sortingParamsOptionSchema = {
    type: 'object',
    properties: {
        caseSensitive: {
            type: 'boolean',
        },
        natural: {
            type: 'boolean',
        },
        requiredFirst: {
            type: 'boolean',
        },
    },
    additionalProperties: false,
};
/**
 * The schema for the rule options.
 */
const schema = [sortingOrderOptionSchema, sortingParamsOptionSchema];
/**
 * The default options for the rule.
 */
const defaultOptions = [
    SortingOrder.Ascending,
    { caseSensitive: true, natural: false, requiredFirst: false },
];
/**
 * The possible error messages.
 */
const errorMessages = {
    invalidOrder: ErrorMessage.InterfaceInvalidOrder,
};
/**
 * The meta data for this rule.
 */
const meta = {
    type: 'suggestion',
    docs: {
        description: 'require interface keys to be sorted',
        recommended: 'warn',
    },
    messages: errorMessages,
    fixable: 'code',
    schema,
};
/**
 * Create the rule.
 */
const rule = createRule({
    name,
    meta,
    defaultOptions,
    create(context) {
        const compareNodeListAndReport = createReporter(context, ({ loc }) => ({
            loc,
            messageId: 'invalidOrder',
        }));
        return {
            TSInterfaceDeclaration(node) {
                const body = getObjectBody(node);
                return compareNodeListAndReport(body);
            },
            TSTypeLiteral(node) {
                const body = getObjectBody(node);
                return compareNodeListAndReport(body);
            },
        };
    },
});

/**
 * The name of this rule.
 */
const name$1 = 'string-enum';
const sortingParamsOptionSchema$1 = {
    type: 'object',
    properties: {
        caseSensitive: {
            type: 'boolean',
        },
        natural: {
            type: 'boolean',
        },
    },
    additionalProperties: false,
};
/**
 * The schema for the rule options.
 */
const schema$1 = [sortingOrderOptionSchema, sortingParamsOptionSchema$1];
/**
 * The default options for the rule.
 */
const defaultOptions$1 = [
    SortingOrder.Ascending,
    { caseSensitive: true, natural: false },
];
/**
 * The possible error messages.
 */
const errorMessages$1 = {
    invalidOrder: ErrorMessage.StringEnumInvalidOrder,
};
/**
 * The meta data for this rule.
 */
const meta$1 = {
    type: 'suggestion',
    docs: {
        description: 'require string enum members to be sorted',
        recommended: 'warn',
    },
    messages: errorMessages$1,
    fixable: 'code',
    schema: schema$1,
};
/**
 * Create the rule.
 */
const rule$1 = createRule({
    name: name$1,
    meta: meta$1,
    defaultOptions: defaultOptions$1,
    create(context) {
        const compareNodeListAndReport = createReporter(context, ({ loc }) => ({
            loc,
            messageId: 'invalidOrder',
        }));
        return {
            TSEnumDeclaration(node) {
                const body = getObjectBody(node);
                const isStringEnum = body.every((member) => member.initializer &&
                    member.initializer.type === experimentalUtils.AST_NODE_TYPES.Literal &&
                    typeof member.initializer.value === 'string');
                if (isStringEnum) {
                    compareNodeListAndReport(body);
                }
            },
        };
    },
});

const rules = {
    [name]: rule,
    [name$1]: rule$1,
};

const config = {
    rules,
    configs: {
        recommended,
    },
};

module.exports = config;

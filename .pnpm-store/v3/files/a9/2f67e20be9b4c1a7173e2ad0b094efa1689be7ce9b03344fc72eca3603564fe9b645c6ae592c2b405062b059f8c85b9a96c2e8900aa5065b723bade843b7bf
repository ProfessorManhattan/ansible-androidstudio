"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.dereferenceVariable = exports.dereferenceOwnedVariable = exports.astRangeToLocation = exports.getPropertyName = exports.isStringLiteral = exports.isRegexpLiteral = exports.getStringValueRange = exports.parseReplacements = exports.isKnownMethodCall = exports.findFunction = exports.getScope = exports.getStaticValue = exports.getStringIfConstant = exports.findVariable = exports.getParent = void 0;
const eslintUtils = __importStar(require("eslint-utils"));
const string_literal_parser_1 = require("../string-literal-parser");
const replacements_utils_1 = require("../replacements-utils");
function getParent(node) {
    if (!node) {
        return null;
    }
    return node.parent;
}
exports.getParent = getParent;
function findVariable(context, node) {
    return eslintUtils.findVariable(getScope(context, node), node);
}
exports.findVariable = findVariable;
function findSimpleVariable(context, identifier) {
    const variable = findVariable(context, identifier);
    if (!variable || variable.defs.length !== 1) {
        return null;
    }
    const def = variable.defs[0];
    if (def.type !== "Variable" || def.node.id.type !== "Identifier") {
        return null;
    }
    return variable;
}
function getStringIfConstant(context, node) {
    if (node.type === "BinaryExpression" ||
        node.type === "MemberExpression" ||
        node.type === "Identifier" ||
        node.type === "TemplateLiteral") {
        const evaluated = getStaticValue(context, node);
        return evaluated && String(evaluated.value);
    }
    return eslintUtils.getStringIfConstant(node, getScope(context, node));
}
exports.getStringIfConstant = getStringIfConstant;
function getStaticValue(context, node) {
    if (node.type === "BinaryExpression") {
        if (node.operator === "+") {
            const left = getStaticValue(context, node.left);
            if (left == null) {
                return null;
            }
            const right = getStaticValue(context, node.right);
            if (right == null) {
                return null;
            }
            return {
                value: left.value + right.value,
            };
        }
    }
    else if (node.type === "MemberExpression") {
        const propName = getPropertyName(node, context);
        if (propName === "source") {
            const object = getStaticValue(context, node.object);
            if (object && object.value instanceof RegExp) {
                return { value: object.value.source };
            }
        }
    }
    else if (node.type === "TemplateLiteral") {
        const expressions = [];
        for (const expr of node.expressions) {
            const exprValue = getStaticValue(context, expr);
            if (!exprValue) {
                return null;
            }
            expressions.push(exprValue);
        }
        let value = node.quasis[0].value.cooked;
        for (let i = 0; i < expressions.length; ++i) {
            value += String(expressions[i].value);
            value += node.quasis[i + 1].value.cooked;
        }
        return { value };
    }
    else if (node.type === "Identifier") {
        const deRef = dereferenceVariable(context, node);
        if (deRef !== node) {
            return getStaticValue(context, deRef);
        }
    }
    return eslintUtils.getStaticValue(node, getScope(context, node));
}
exports.getStaticValue = getStaticValue;
function getScope(context, currentNode) {
    const scopeManager = context.getSourceCode()
        .scopeManager;
    let node = currentNode;
    for (; node; node = node.parent || null) {
        const scope = scopeManager.acquire(node, false);
        if (scope) {
            if (scope.type === "function-expression-name") {
                return scope.childScopes[0];
            }
            return scope;
        }
    }
    return scopeManager.scopes[0];
}
exports.getScope = getScope;
function findFunction(context, id) {
    let target = id;
    const set = new Set();
    for (;;) {
        if (set.has(target)) {
            return null;
        }
        set.add(target);
        const calleeVariable = findVariable(context, target);
        if (!calleeVariable) {
            return null;
        }
        if (calleeVariable.defs.length === 1) {
            const def = calleeVariable.defs[0];
            if (def.node.type === "FunctionDeclaration") {
                return def.node;
            }
            if (def.type === "Variable" &&
                def.parent.kind === "const" &&
                def.node.init) {
                if (def.node.init.type === "FunctionExpression" ||
                    def.node.init.type === "ArrowFunctionExpression") {
                    return def.node.init;
                }
                if (def.node.init.type === "Identifier") {
                    target = def.node.init;
                    continue;
                }
            }
        }
        return null;
    }
}
exports.findFunction = findFunction;
function isKnownMethodCall(node, methods) {
    const mem = node.callee;
    if (mem.type !== "MemberExpression" ||
        mem.computed ||
        mem.property.type !== "Identifier") {
        return false;
    }
    const argLength = methods[mem.property.name];
    if (node.arguments.length !== argLength) {
        return false;
    }
    if (node.arguments.some((arg) => arg.type === "SpreadElement")) {
        return false;
    }
    const object = mem.object;
    if (object.type === "Super") {
        return false;
    }
    return true;
}
exports.isKnownMethodCall = isKnownMethodCall;
function parseReplacements(context, node) {
    const stringLiteral = (0, string_literal_parser_1.parseStringLiteral)(context.getSourceCode().text, {
        start: node.range[0],
        end: node.range[1],
    });
    const tokens = stringLiteral.tokens.filter((t) => t.value);
    return (0, replacements_utils_1.baseParseReplacements)(tokens, (start, end) => {
        return {
            range: [start.range[0], end.range[1]],
        };
    });
}
exports.parseReplacements = parseReplacements;
function getStringValueRange(sourceCode, node, startOffset, endOffset) {
    if (!node.range) {
        return null;
    }
    if (node.value.length < endOffset) {
        return null;
    }
    try {
        const raw = sourceCode.text.slice(node.range[0] + 1, node.range[1] - 1);
        let valueIndex = 0;
        let start = null;
        for (const t of (0, string_literal_parser_1.parseStringTokens)(raw)) {
            const endIndex = valueIndex + t.value.length;
            if (start == null &&
                valueIndex <= startOffset &&
                startOffset < endIndex) {
                start = t.range[0];
            }
            if (start != null &&
                valueIndex < endOffset &&
                endOffset <= endIndex) {
                const end = t.range[1];
                const nodeStart = node.range[0] + 1;
                return [nodeStart + start, nodeStart + end];
            }
            valueIndex = endIndex;
        }
    }
    catch (_a) {
    }
    return null;
}
exports.getStringValueRange = getStringValueRange;
function isRegexpLiteral(node) {
    return node.type === "Literal" && "regex" in node;
}
exports.isRegexpLiteral = isRegexpLiteral;
function isStringLiteral(node) {
    return node.type === "Literal" && typeof node.value === "string";
}
exports.isStringLiteral = isStringLiteral;
function getPropertyName(node, context) {
    const prop = node.property;
    if (prop.type === "PrivateIdentifier") {
        return null;
    }
    if (!node.computed) {
        return prop.name;
    }
    if (context) {
        return getStringIfConstant(context, prop);
    }
    if (isStringLiteral(prop)) {
        return prop.value;
    }
    return null;
}
exports.getPropertyName = getPropertyName;
function astRangeToLocation(sourceCode, range) {
    return {
        start: sourceCode.getLocFromIndex(range[0]),
        end: sourceCode.getLocFromIndex(range[1]),
    };
}
exports.astRangeToLocation = astRangeToLocation;
function dereferenceOwnedVariable(context, expression) {
    if (expression.type === "Identifier") {
        const variable = findSimpleVariable(context, expression);
        if (!variable) {
            return expression;
        }
        const def = variable.defs[0];
        const grandParent = getParent(def.parent);
        if (grandParent && grandParent.type === "ExportNamedDeclaration") {
            return expression;
        }
        if (variable.references.length !== 2) {
            return expression;
        }
        const [initRef, thisRef] = variable.references;
        if (!(initRef.init &&
            initRef.writeExpr &&
            initRef.writeExpr === def.node.init) ||
            thisRef.identifier !== expression) {
            return expression;
        }
        return dereferenceOwnedVariable(context, def.node.init);
    }
    return expression;
}
exports.dereferenceOwnedVariable = dereferenceOwnedVariable;
function dereferenceVariable(context, expression) {
    if (expression.type === "Identifier") {
        const variable = findSimpleVariable(context, expression);
        if (variable) {
            const def = variable.defs[0];
            if (def.node.init) {
                if (def.parent.kind === "const") {
                    return dereferenceVariable(context, def.node.init);
                }
                const refs = variable.references;
                const inits = refs.filter((r) => r.init).length;
                const reads = refs.filter((r) => r.isReadOnly()).length;
                if (inits === 1 && reads + inits === refs.length) {
                    return dereferenceVariable(context, def.node.init);
                }
            }
        }
    }
    return expression;
}
exports.dereferenceVariable = dereferenceVariable;

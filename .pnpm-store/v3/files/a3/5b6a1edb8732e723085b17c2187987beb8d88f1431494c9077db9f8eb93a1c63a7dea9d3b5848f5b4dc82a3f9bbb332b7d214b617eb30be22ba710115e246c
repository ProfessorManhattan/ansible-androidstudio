"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTypeTracker = void 0;
const utils_1 = require("./utils");
const type_data_1 = require("./type-data");
const jsdoc_1 = require("./jsdoc");
const iterable_1 = require("./type-data/iterable");
const ast_utils_1 = require("../ast-utils");
const ts_utils_1 = require("../ts-utils");
const ts = (0, ts_utils_1.getTypeScript)();
const cacheTypeTracker = new WeakMap();
function createTypeTracker(context) {
    const programNode = context.getSourceCode().ast;
    const cache = cacheTypeTracker.get(programNode);
    if (cache) {
        return cache;
    }
    const { tsNodeMap, checker, usedTS } = (0, ts_utils_1.getTypeScriptTools)(context);
    const cacheTypeInfo = new WeakMap();
    const tracker = {
        isString,
        maybeString,
        isRegExp,
        getTypes,
    };
    cacheTypeTracker.set(programNode, tracker);
    return tracker;
    function isString(node) {
        return (0, type_data_1.hasType)(getType(node), "String");
    }
    function maybeString(node) {
        if (isString(node)) {
            return true;
        }
        if (usedTS) {
            return false;
        }
        return getType(node) == null;
    }
    function isRegExp(node) {
        return (0, type_data_1.hasType)(getType(node), "RegExp");
    }
    function getTypes(node) {
        const result = getType(node);
        if (result == null) {
            return [];
        }
        if (typeof result === "string") {
            return [result];
        }
        return result.typeNames();
    }
    function getType(node) {
        var _a;
        if (cacheTypeInfo.has(node)) {
            return (_a = cacheTypeInfo.get(node)) !== null && _a !== void 0 ? _a : null;
        }
        cacheTypeInfo.set(node, null);
        try {
            const type = getTypeWithoutCache(node);
            cacheTypeInfo.set(node, type);
            return type;
        }
        catch (_b) {
            return null;
        }
    }
    function getTypeWithoutCache(node) {
        var _a, _b, _c, _d, _e, _f;
        if (node.type === "Literal") {
            if (typeof node.value === "string") {
                return type_data_1.STRING;
            }
            if (typeof node.value === "boolean") {
                return type_data_1.BOOLEAN;
            }
            if (typeof node.value === "number") {
                return type_data_1.NUMBER;
            }
            if ("regex" in node && node.regex) {
                return type_data_1.REGEXP;
            }
            if ("bigint" in node && node.bigint) {
                return type_data_1.BIGINT;
            }
            if (node.value == null) {
                return "null";
            }
        }
        else if (node.type === "TemplateLiteral") {
            return type_data_1.STRING;
        }
        if (usedTS) {
            return getTypeByTs(node);
        }
        const jsdoc = (0, jsdoc_1.getJSDoc)(node, context);
        if (jsdoc) {
            if ((0, utils_1.isParenthesized)(context, node)) {
                const type = typeTextToTypeInfo((_a = jsdoc.getTag("type")) === null || _a === void 0 ? void 0 : _a.type);
                if (type) {
                    return type;
                }
            }
        }
        if (node.type === "ArrowFunctionExpression" ||
            node.type === "FunctionExpression") {
            if (jsdoc) {
                const type = typeTextToTypeInfo((_b = jsdoc.getTag("returns")) === null || _b === void 0 ? void 0 : _b.type);
                if (type) {
                    return new type_data_1.TypeFunction(() => type);
                }
            }
        }
        if (node.type === "FunctionExpression") {
            return type_data_1.UNKNOWN_FUNCTION;
        }
        if (node.type === "ArrowFunctionExpression") {
            if (node.body.type !== "BlockStatement") {
                const body = node.body;
                return new type_data_1.TypeFunction(() => getType(body));
            }
            return type_data_1.UNKNOWN_FUNCTION;
        }
        if (node.type === "ArrayExpression") {
            return new type_data_1.TypeArray(function* () {
                for (const element of node.elements) {
                    if (!element) {
                        yield null;
                    }
                    else if (element.type !== "SpreadElement") {
                        yield getType(element);
                    }
                    else {
                        const argType = getType(element.argument);
                        if ((0, type_data_1.isTypeClass)(argType)) {
                            yield argType.iterateType();
                        }
                        else {
                            yield null;
                        }
                    }
                }
            }, node.elements.every((e) => e && e.type !== "SpreadElement"));
        }
        else if (node.type === "ObjectExpression") {
            return new type_data_1.TypeObject(function* () {
                for (let index = node.properties.length - 1; index >= 0; index--) {
                    const property = node.properties[index];
                    if (property.type !== "SpreadElement") {
                        if (property.value.type === "ObjectPattern" ||
                            property.value.type === "ArrayPattern" ||
                            property.value.type === "RestElement" ||
                            property.value.type === "AssignmentPattern")
                            continue;
                        const name = (0, utils_1.getPropertyName)(context, property);
                        if (name != null) {
                            const value = property.value;
                            yield [name, () => getType(value)];
                        }
                    }
                    else {
                        const spreadType = getType(property.argument);
                        if ((0, type_data_1.isTypeClass)(spreadType) &&
                            spreadType.type === "Object") {
                            yield* spreadType.allProperties();
                        }
                    }
                }
            });
        }
        else if (node.type === "BinaryExpression") {
            const type = type_data_1.BI_OPERATOR_TYPES[node.operator];
            if (type) {
                return type(() => [getType(node.left), getType(node.right)]);
            }
        }
        else if (node.type === "UnaryExpression") {
            const type = type_data_1.UN_OPERATOR_TYPES[node.operator];
            if (type) {
                return type(() => getType(node.argument));
            }
        }
        else if (node.type === "AssignmentExpression") {
            return getType(node.right);
        }
        else if (node.type === "SequenceExpression") {
            return getType(node.expressions[node.expressions.length - 1]);
        }
        else if (node.type === "ChainExpression") {
            return getType(node.expression);
        }
        else if (node.type === "ClassExpression") {
            return null;
        }
        else if (node.type === "Identifier") {
            const variable = (0, utils_1.findVariable)(context, node);
            if (variable) {
                if (variable.defs.length === 1) {
                    const def = variable.defs[0];
                    if (def.type === "Variable") {
                        const idJsdoc = (0, jsdoc_1.getJSDoc)(def.node, context);
                        if (idJsdoc) {
                            const type = typeTextToTypeInfo((_c = idJsdoc.getTag("type")) === null || _c === void 0 ? void 0 : _c.type);
                            if (type) {
                                return type;
                            }
                            const returnType = typeTextToTypeInfo((_d = idJsdoc.getTag("returns")) === null || _d === void 0 ? void 0 : _d.type);
                            if (returnType) {
                                return new type_data_1.TypeFunction(() => returnType);
                            }
                        }
                        if (def.parent.kind === "const") {
                            if (def.node.init) {
                                const type = getType(def.node.init);
                                if (type) {
                                    return type;
                                }
                            }
                            else {
                                const parent = (0, ast_utils_1.getParent)(def.parent);
                                if (parent) {
                                    if ((parent === null || parent === void 0 ? void 0 : parent.type) === "ForOfStatement") {
                                        const rightType = getType(parent.right);
                                        if ((0, type_data_1.isTypeClass)(rightType)) {
                                            const type = rightType.iterateType();
                                            if (type) {
                                                return type;
                                            }
                                        }
                                    }
                                    else if ((parent === null || parent === void 0 ? void 0 : parent.type) === "ForInStatement") {
                                        return type_data_1.STRING;
                                    }
                                }
                            }
                        }
                    }
                    else if (def.type === "Parameter") {
                        const fnJsdoc = (0, jsdoc_1.getJSDoc)(def.node, context);
                        if (fnJsdoc) {
                            const jsdocParams = fnJsdoc.parseParams();
                            if (!jsdocParams.isEmpty()) {
                                const type = typeTextToTypeInfo((_e = jsdocParams.get(getParamPath(def.name.name, def.name, context))) === null || _e === void 0 ? void 0 : _e.type);
                                if (type) {
                                    return type;
                                }
                            }
                        }
                        const parent = (0, ast_utils_1.getParent)(def.name);
                        if (parent) {
                            if (parent.type === "RestElement") {
                                const pp = (0, ast_utils_1.getParent)(parent);
                                if (pp) {
                                    if (pp.type === "ArrayPattern") {
                                        return type_data_1.UNKNOWN_ARRAY;
                                    }
                                    if (pp.type === "ObjectPattern") {
                                        return type_data_1.UNKNOWN_OBJECT;
                                    }
                                    if (pp.type === "FunctionExpression" ||
                                        pp.type === "FunctionDeclaration" ||
                                        pp.type === "ArrowFunctionExpression") {
                                        return type_data_1.UNKNOWN_ARRAY;
                                    }
                                }
                            }
                            else if (parent.type === "AssignmentPattern") {
                                return getType(parent.right);
                            }
                        }
                    }
                    else if (def.type === "FunctionName") {
                        const fnJsdoc = (0, jsdoc_1.getJSDoc)(def.node, context);
                        if (fnJsdoc) {
                            const type = typeTextToTypeInfo((_f = fnJsdoc.getTag("returns")) === null || _f === void 0 ? void 0 : _f.type);
                            if (type) {
                                return new type_data_1.TypeFunction(() => type);
                            }
                        }
                        return type_data_1.UNKNOWN_FUNCTION;
                    }
                }
                else if (variable.defs.length === 0) {
                    const type = type_data_1.GLOBAL.propertyType(node.name);
                    if (type) {
                        return type;
                    }
                }
            }
        }
        else if (node.type === "NewExpression") {
            if (node.callee.type !== "Super") {
                const type = getType(node.callee);
                if ((0, type_data_1.isTypeClass)(type)) {
                    const argTypes = [];
                    for (const arg of node.arguments) {
                        argTypes.push(arg.type === "SpreadElement"
                            ? null
                            : () => {
                                return getType(arg);
                            });
                    }
                    return type.returnType(null, argTypes, {
                        isConstructor: true,
                    });
                }
            }
        }
        else if (node.type === "CallExpression" ||
            node.type === "TaggedTemplateExpression") {
            const argTypes = [];
            if (node.type === "CallExpression") {
                for (const arg of node.arguments) {
                    argTypes.push(arg.type === "SpreadElement"
                        ? null
                        : () => {
                            return getType(arg);
                        });
                }
            }
            const callee = node.type === "CallExpression" ? node.callee : node.tag;
            if (callee.type === "MemberExpression") {
                const mem = callee;
                if (mem.object.type !== "Super") {
                    let propertyName = null;
                    if (!mem.computed) {
                        if (mem.property.type === "Identifier") {
                            propertyName = mem.property.name;
                        }
                    }
                    else {
                        const propertyType = getType(mem.property);
                        if ((0, type_data_1.hasType)(propertyType, "Number")) {
                            propertyName = "0";
                        }
                    }
                    if (propertyName != null) {
                        if (propertyName === "toString" ||
                            propertyName === "toLocaleString") {
                            return type_data_1.STRING;
                        }
                        const objectType = getType(mem.object);
                        if ((0, type_data_1.isTypeClass)(objectType)) {
                            const type = objectType.propertyType(propertyName);
                            if ((0, type_data_1.isTypeClass)(type)) {
                                return type.returnType(() => objectType, argTypes);
                            }
                        }
                    }
                }
            }
            else if (callee.type !== "Super") {
                const type = getType(callee);
                if ((0, type_data_1.isTypeClass)(type)) {
                    return type.returnType(null, argTypes);
                }
            }
        }
        else if (node.type === "MemberExpression") {
            if (node.object.type !== "Super") {
                let propertyName = null;
                if (!node.computed) {
                    if (node.property.type === "Identifier") {
                        propertyName = node.property.name;
                    }
                }
                else {
                    const propertyType = getType(node.property);
                    if ((0, type_data_1.hasType)(propertyType, "Number")) {
                        propertyName = "0";
                    }
                }
                if (propertyName != null) {
                    const objectType = getType(node.object);
                    if ((0, type_data_1.isTypeClass)(objectType)) {
                        const type = objectType.propertyType(propertyName);
                        if (type) {
                            return type;
                        }
                    }
                }
            }
        }
        return usedTS ? getTypeByTs(node) : null;
    }
    function getTypeByTs(node) {
        const tsNode = tsNodeMap.get(node);
        const tsType = (tsNode && (checker === null || checker === void 0 ? void 0 : checker.getTypeAtLocation(tsNode))) || null;
        return tsType && getTypeFromTsType(tsType);
    }
    function getTypeFromTsType(tsType) {
        var _a, _b;
        if ((0, ts_utils_1.isStringLine)(tsType)) {
            return type_data_1.STRING;
        }
        if ((0, ts_utils_1.isNumberLike)(tsType)) {
            return type_data_1.NUMBER;
        }
        if ((0, ts_utils_1.isBooleanLike)(tsType)) {
            return type_data_1.BOOLEAN;
        }
        if ((0, ts_utils_1.isBigIntLike)(tsType)) {
            return type_data_1.BIGINT;
        }
        if ((0, ts_utils_1.isAny)(tsType) || (0, ts_utils_1.isUnknown)(tsType)) {
            return null;
        }
        if ((0, ts_utils_1.isArrayLikeObject)(tsType)) {
            return type_data_1.UNKNOWN_ARRAY;
        }
        if ((0, ts_utils_1.isReferenceObject)(tsType) && tsType.target !== tsType) {
            return getTypeFromTsType(tsType.target);
        }
        if ((0, ts_utils_1.isTypeParameter)(tsType)) {
            const constraintType = getConstraintType(tsType);
            if (constraintType) {
                return getTypeFromTsType(constraintType);
            }
            return null;
        }
        if ((0, ts_utils_1.isUnionOrIntersection)(tsType)) {
            return type_data_1.TypeUnionOrIntersection.buildType(function* () {
                for (const t of tsType.types) {
                    const tn = getTypeFromTsType(t);
                    if (tn) {
                        yield tn;
                    }
                }
            });
        }
        if ((0, ts_utils_1.isClassOrInterface)(tsType)) {
            const name = tsType.symbol.escapedName;
            const typeName = (_b = (_a = /^Readonly(?<typeName>.*)/u.exec(name)) === null || _a === void 0 ? void 0 : _a.groups.typeName) !== null && _b !== void 0 ? _b : name;
            return typeName === "Array" ? type_data_1.UNKNOWN_ARRAY : typeName;
        }
        if ((0, ts_utils_1.isObject)(tsType)) {
            return type_data_1.UNKNOWN_OBJECT;
        }
        return checker ? checker.typeToString(tsType) : null;
    }
    function getConstraintType(tsType) {
        const symbol = tsType.symbol;
        const declarations = symbol && symbol.declarations;
        const declaration = declarations && declarations[0];
        if (declaration &&
            ts.isTypeParameterDeclaration(declaration) &&
            declaration.constraint != null) {
            return checker === null || checker === void 0 ? void 0 : checker.getTypeFromTypeNode(declaration.constraint);
        }
        return undefined;
    }
}
exports.createTypeTracker = createTypeTracker;
function typeTextToTypeInfo(typeText) {
    if (typeText == null) {
        return null;
    }
    return jsDocTypeNodeToTypeInfo((0, jsdoc_1.parseTypeText)(typeText));
}
function jsDocTypeNodeToTypeInfo(node) {
    if (node == null) {
        return null;
    }
    if (node.type === "NAME") {
        return typeNameToTypeInfo(node.name);
    }
    if (node.type === "STRING_VALUE") {
        return type_data_1.STRING;
    }
    if (node.type === "NUMBER_VALUE") {
        return type_data_1.NUMBER;
    }
    if (node.type === "OPTIONAL" ||
        node.type === "NULLABLE" ||
        node.type === "NOT_NULLABLE" ||
        node.type === "PARENTHESIS") {
        return jsDocTypeNodeToTypeInfo(node.value);
    }
    if (node.type === "VARIADIC") {
        return new type_data_1.TypeArray(function* () {
            if (node.value) {
                yield jsDocTypeNodeToTypeInfo(node.value);
            }
            else {
                yield null;
            }
        });
    }
    if (node.type === "UNION" || node.type === "INTERSECTION") {
        return type_data_1.TypeUnionOrIntersection.buildType(function* () {
            const left = jsDocTypeNodeToTypeInfo(node.left);
            if (left) {
                yield left;
            }
            const right = jsDocTypeNodeToTypeInfo(node.right);
            if (right) {
                yield right;
            }
        });
    }
    if (node.type === "GENERIC") {
        const subject = jsDocTypeNodeToTypeInfo(node.subject);
        if ((0, type_data_1.hasType)(subject, "Array")) {
            return new type_data_1.TypeArray(function* () {
                yield jsDocTypeNodeToTypeInfo(node.objects[0]);
            });
        }
        if ((0, type_data_1.hasType)(subject, "Map")) {
            return new type_data_1.TypeMap(() => jsDocTypeNodeToTypeInfo(node.objects[0]), () => jsDocTypeNodeToTypeInfo(node.objects[1]));
        }
        if ((0, type_data_1.hasType)(subject, "Set")) {
            return new type_data_1.TypeSet(() => jsDocTypeNodeToTypeInfo(node.objects[0]));
        }
        if (subject === iterable_1.UNKNOWN_ITERABLE) {
            return new iterable_1.TypeIterable(() => jsDocTypeNodeToTypeInfo(node.objects[0]));
        }
        return subject;
    }
    if (node.type === "RECORD") {
        return new type_data_1.TypeObject(function* () {
            for (const entry of node.entries) {
                yield [entry.key, () => jsDocTypeNodeToTypeInfo(entry.value)];
            }
        });
    }
    if (node.type === "ANY" || node.type === "UNKNOWN") {
        return null;
    }
    if (node.type === "MEMBER" ||
        node.type === "INNER_MEMBER" ||
        node.type === "INSTANCE_MEMBER" ||
        node.type === "EXTERNAL" ||
        node.type === "FILE_PATH" ||
        node.type === "MODULE") {
        return null;
    }
    return null;
}
function typeNameToTypeInfo(name) {
    if (name === "String" || name === "string") {
        return type_data_1.STRING;
    }
    if (name === "Number" || name === "number") {
        return type_data_1.NUMBER;
    }
    if (name === "Boolean" || name === "boolean") {
        return type_data_1.BOOLEAN;
    }
    if (name === "BigInt" || name === "bigint") {
        return type_data_1.BIGINT;
    }
    if (name === "RegExp") {
        return type_data_1.REGEXP;
    }
    if (name === "Array" || name === "array") {
        return type_data_1.UNKNOWN_ARRAY;
    }
    if (name === "Function" || name === "function") {
        return type_data_1.UNKNOWN_FUNCTION;
    }
    if (name === "Object" || name === "object") {
        return type_data_1.UNKNOWN_OBJECT;
    }
    if (name === "Record") {
        return type_data_1.UNKNOWN_OBJECT;
    }
    if (name === "Map") {
        return type_data_1.UNKNOWN_MAP;
    }
    if (name === "Set") {
        return type_data_1.UNKNOWN_SET;
    }
    if (name === "Generator" ||
        name === "Iterable" ||
        name === "IterableIterator") {
        return iterable_1.UNKNOWN_ITERABLE;
    }
    return null;
}
function getParamPath(name, node, context) {
    const parent = (0, ast_utils_1.getParent)(node);
    if (!parent) {
        return [{ name, index: null }];
    }
    if (parent.type === "FunctionDeclaration" ||
        parent.type === "ArrowFunctionExpression" ||
        parent.type === "FunctionExpression") {
        return [{ name, index: parent.params.indexOf(node) }];
    }
    if (parent.type === "AssignmentPattern") {
        return getParamPath(name, parent, context);
    }
    if (parent.type === "ArrayPattern") {
        const path = {
            name,
            index: parent.elements.indexOf(node),
        };
        return getParamPath(null, parent, context).concat([path]);
    }
    if (parent.type === "Property") {
        const object = (0, ast_utils_1.getParent)(parent);
        const path = {
            name: (0, utils_1.getPropertyName)(context, parent),
            index: object.properties.indexOf(parent),
        };
        return getParamPath(null, object, context).concat([path]);
    }
    if (parent.type === "RestElement") {
        return getParamPath(name, parent, context);
    }
    return [{ name, index: null }];
}

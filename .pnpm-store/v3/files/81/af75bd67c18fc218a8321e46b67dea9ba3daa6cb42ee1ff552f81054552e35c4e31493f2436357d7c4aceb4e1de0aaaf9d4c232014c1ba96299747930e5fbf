"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildBigIntConstructor = exports.BIGINT = exports.TypeBigInt = void 0;
const string_1 = require("./string");
const common_1 = require("./common");
const function_1 = require("./function");
const object_1 = require("./object");
class TypeBigInt {
    constructor() {
        this.type = "BigInt";
    }
    has(type) {
        return type === "BigInt";
    }
    paramType() {
        return null;
    }
    propertyType(name) {
        return getPrototypes()[name] || null;
    }
    iterateType() {
        return null;
    }
    returnType() {
        return null;
    }
    typeNames() {
        return ["BigInt"];
    }
    equals(o) {
        return o.type === "BigInt";
    }
}
exports.TypeBigInt = TypeBigInt;
exports.BIGINT = new TypeBigInt();
function buildBigIntConstructor() {
    const BIGINT_TYPES = (0, common_1.createObject)({
        asIntN: function_1.RETURN_BIGINT,
        asUintN: function_1.RETURN_BIGINT,
        prototype: null,
    });
    return new function_1.TypeGlobalFunction(() => exports.BIGINT, BIGINT_TYPES);
}
exports.buildBigIntConstructor = buildBigIntConstructor;
const getPrototypes = (0, common_1.cache)(() => (0, common_1.createObject)(Object.assign(Object.assign({}, (0, object_1.getObjectPrototypes)()), { toString: function_1.RETURN_STRING, toLocaleString: function_1.RETURN_STRING, valueOf: function_1.RETURN_BIGINT, [Symbol.toStringTag]: string_1.STRING })));

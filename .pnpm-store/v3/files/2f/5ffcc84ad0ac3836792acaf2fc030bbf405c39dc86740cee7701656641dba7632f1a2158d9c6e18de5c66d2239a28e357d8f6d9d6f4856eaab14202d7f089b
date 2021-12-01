"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const path_1 = __importDefault(require("path"));
const base = require.resolve("./base");
const baseExtend = path_1.default.extname(`${base}`) === ".ts" ? "plugin:jsonc/base" : base;
module.exports = {
    extends: [baseExtend],
    rules: {
        "jsonc/comma-dangle": "error",
        "jsonc/no-bigint-literals": "error",
        "jsonc/no-comments": "error",
        "jsonc/no-dupe-keys": "error",
        "jsonc/no-floating-decimal": "error",
        "jsonc/no-multi-str": "error",
        "jsonc/no-number-props": "error",
        "jsonc/no-numeric-separators": "error",
        "jsonc/no-regexp-literals": "error",
        "jsonc/no-sparse-arrays": "error",
        "jsonc/no-template-literals": "error",
        "jsonc/no-undefined-value": "error",
        "jsonc/no-useless-escape": "error",
        "jsonc/quote-props": "error",
        "jsonc/quotes": "error",
        "jsonc/space-unary-ops": "error",
        "jsonc/valid-json-number": "error",
        "jsonc/vue-custom-block/no-parsing-error": "error",
    },
};

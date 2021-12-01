"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const parser_1 = require("@xml-tools/parser");
const parser = {
    parse(text) {
        const { lexErrors, parseErrors, cst } = parser_1.parse(text);
        if (lexErrors.length > 0 || parseErrors.length > 0) {
            throw Error("Error parsing XML");
        }
        return cst;
    },
    astFormat: "xml",
    locStart(node) {
        return node.location.startOffset;
    },
    locEnd(node) {
        return node.location.endOffset;
    }
};
exports.default = parser;

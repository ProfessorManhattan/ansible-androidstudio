"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const resolve_1 = __importDefault(require("eslint-module-utils/resolve"));
const parser_1 = require("@typescript-eslint/parser");
const fileCache = new Map();
var typeDeclarationTypes;
(function (typeDeclarationTypes) {
    typeDeclarationTypes[typeDeclarationTypes["TSInterfaceDeclaration"] = 0] = "TSInterfaceDeclaration";
    typeDeclarationTypes[typeDeclarationTypes["TSTypeAliasDeclaration"] = 1] = "TSTypeAliasDeclaration";
})(typeDeclarationTypes || (typeDeclarationTypes = {}));
/**
 * Checks if a node is an interface or a type.
 */
function isType(node) {
    return Object.keys(typeDeclarationTypes).includes(node.type);
}
/**
 * Given a file's contents this functions creates an AST and finds
 * all of the exported Types/Interfaces. The exported interfaces and types will
 * be stored in a cache.
 */
function parseTSTreeForExportedTypes(cacheKey, content) {
    const typeList = [];
    try {
        if (fileCache && fileCache.get(cacheKey)) {
            const ast = parser_1.parse(content, { sourceType: 'module' });
            const cache = fileCache.get(cacheKey);
            if (!cache) {
                return;
            }
            ast.body.forEach((node) => {
                if (node.type === 'ExportNamedDeclaration') {
                    const { declaration, specifiers } = node;
                    specifiers.forEach(specifier => {
                        if (specifier.local.name === specifier.exported.name) {
                            cache.add(specifier.local.name);
                        }
                        else {
                            cache.add(`${specifier.local.name} as ${specifier.exported.name}`);
                        }
                    });
                    if (declaration && isType(declaration)) {
                        cache.add(declaration.id.name);
                        typeList.push(declaration.id.name);
                    }
                }
                else if (node.type === 'ExportDefaultDeclaration' &&
                    node.declaration.type === 'Identifier') {
                    cache.add(node.declaration.name);
                }
                if (isType(node)) {
                    typeList.push(node.id.name);
                }
            });
            cache.forEach(exp => {
                if (!typeList.includes(exp.split(' as ')[0])) {
                    cache.delete(exp);
                }
            });
        }
    }
    catch (error) {
        return;
    }
}
/**
 * This functions checks the cache for the files typed exports. If the
 * file has not been parsed yet it will open the file and get the exported
 * types and interfaces.
 */
function parseFileForTypedExports(source, context) {
    const path = resolve_1.default(source, context);
    if (!path) {
        return;
    }
    try {
        const content = fs_1.default.readFileSync(path, { encoding: 'utf8' });
        const cacheKey = path;
        const cachedExports = fileCache.get(cacheKey);
        if (cachedExports) {
            return cachedExports;
        }
        if (!content || !fileCache) {
            return;
        }
        fileCache.set(cacheKey, new Set());
        parseTSTreeForExportedTypes(cacheKey, content);
        return fileCache.get(cacheKey);
    }
    catch (error) {
        return;
    }
}
exports.default = parseFileForTypedExports;
//# sourceMappingURL=getTypeExports.js.map
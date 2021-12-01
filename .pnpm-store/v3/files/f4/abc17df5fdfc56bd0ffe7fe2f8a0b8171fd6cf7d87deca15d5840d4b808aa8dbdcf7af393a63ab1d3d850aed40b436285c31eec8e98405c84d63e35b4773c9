"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const getTypeExports_1 = __importDefault(require("./getTypeExports"));
const getExports_1 = __importDefault(require("./getExports"));
const fix_1 = require("../fix");
function errorMessage(name) {
    return `Do not export '${name}' it is an imported type or interface.`;
}
function isTypeStatement(node) {
    return ((node.exportKind === 'type' ||
        node.importKind === 'type') &&
        node.type !== 'ExportDefaultDeclaration');
}
function isExport(exported) {
    return exported.exported !== undefined;
}
module.exports = {
    name: 'no-explicit-type-exports',
    meta: {
        type: 'problem',
        fixable: 'code',
    },
    create: function (context) {
        const AllTypedImports = [];
        const getTypeImports = (type) => (node) => {
            const { ast } = context.getSourceCode();
            const { source } = node;
            const sourceName = source && 'value' in source ? source.value : undefined;
            if (typeof sourceName === 'string') {
                const typedExports = getTypeExports_1.default(sourceName, context);
                const typedImports = [];
                const regularImports = [];
                if (typedExports) {
                    node.specifiers.forEach((specifier) => {
                        const { name } = specifier.local;
                        if (!typedExports.has(name)) {
                            regularImports.push(name);
                        }
                        else {
                            typedImports.push(name);
                            AllTypedImports.push(name);
                        }
                    });
                    getExports_1.default(ast).forEach(({ exp, node: expNode }) => {
                        if (typedImports.includes(exp) &&
                            !isTypeStatement(node) &&
                            !isTypeStatement(expNode)) {
                            const isExport = type === 'ExportNamedDeclaration';
                            context.report({
                                node,
                                message: errorMessage(exp),
                                fix: (fixer) => isExport
                                    ? fix_1.exportFixer(node, typedImports, regularImports, fixer)
                                    : fix_1.importFixer(node, typedImports, regularImports, fixer),
                            });
                        }
                    });
                }
            }
            else if (type === 'ExportNamedDeclaration') {
                const typedExports = [];
                const regularExports = [];
                node.specifiers.forEach((specifier) => {
                    const { name } = specifier.local;
                    let exportedName = name;
                    if (isExport(specifier)) {
                        exportedName = specifier.exported.name;
                    }
                    if (AllTypedImports.includes(name) ||
                        AllTypedImports.includes(`${name} as ${exportedName}`)) {
                        if (name === exportedName) {
                            typedExports.push(name);
                        }
                        else {
                            typedExports.push(`${name} as ${exportedName}`);
                        }
                    }
                    else {
                        regularExports.push(name);
                    }
                });
                if (typedExports.length && !isTypeStatement(node)) {
                    context.report({
                        node,
                        message: errorMessage(typedExports[0]),
                        fix: (fixer) => fix_1.exportFixer(node, typedExports, regularExports, fixer),
                    });
                }
            }
        };
        return {
            ImportDeclaration: getTypeImports('ImportDeclaration'),
            ExportNamedDeclaration: getTypeImports('ExportNamedDeclaration'),
        };
    },
};
//# sourceMappingURL=no-explicit-type-exports.js.map
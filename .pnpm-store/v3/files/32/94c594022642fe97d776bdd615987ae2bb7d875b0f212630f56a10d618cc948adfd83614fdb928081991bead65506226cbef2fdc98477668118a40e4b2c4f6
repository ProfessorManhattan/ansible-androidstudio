"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * A function that takes in an AST and returns a list of
 * the exported variables from ExportNamedDeclaration and
 * ExportDefaultDeclaration.
 */
function getExports(ast) {
    const exported = new Set();
    try {
        ast.body.forEach((node) => {
            if (node.type === 'ExportNamedDeclaration') {
                node.specifiers.forEach(specifier => {
                    exported.add({
                        node,
                        exp: specifier.local.name,
                    });
                });
            }
            else if (node.type === 'ExportDefaultDeclaration' &&
                node.declaration.type === 'Identifier') {
                exported.add({
                    node,
                    exp: node.declaration.name,
                });
            }
        });
    }
    catch (error) {
        return exported;
    }
    return exported;
}
exports.default = getExports;
//# sourceMappingURL=getExports.js.map
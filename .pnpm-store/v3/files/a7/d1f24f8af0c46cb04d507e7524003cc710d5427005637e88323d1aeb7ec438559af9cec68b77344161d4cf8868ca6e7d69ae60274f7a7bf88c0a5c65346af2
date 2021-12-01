"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const generateTypeFix = (type, variables, source) => {
    const spacedSource = source ? ` ${source}` : '';
    return `${type} type { ${variables.join(',')} }${spacedSource};\n`;
};
const generateNonTypeFix = (type, variables, source) => {
    const spacedSource = source ? ` ${source}` : '';
    return `${type} { ${variables.join(',')} }${spacedSource};`;
};
exports.exportFixer = (node, typedExports, regularExports, fixer) => {
    try {
        const source = node.source && node.source.raw
            ? 'from ' + node.source.raw
            : '';
        const exportTypes = typedExports.length
            ? generateTypeFix('export', typedExports, source)
            : '';
        const exportRegulars = regularExports.length
            ? generateNonTypeFix('export', regularExports, source)
            : '';
        return fixer.replaceText(node, exportTypes + exportRegulars);
    }
    catch (_a) {
        return;
    }
};
exports.importFixer = (node, typedImports, regularImports, fixer) => {
    try {
        const source = 'from ' + node.source.raw;
        const importTypes = typedImports.length
            ? generateTypeFix('import', typedImports, source)
            : '';
        const importRegulars = regularImports.length
            ? generateNonTypeFix('import', regularImports, source)
            : '';
        return fixer.replaceText(node, importTypes + importRegulars);
    }
    catch (_a) {
        return;
    }
};
//# sourceMappingURL=fix.js.map
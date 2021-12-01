"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isCaseVariant = exports.getCaseSensitiveFlags = exports.getIgnoreCaseFlags = void 0;
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const ignoreCaseFlagsCache = new WeakMap();
const caseSensitiveFlagsCache = new WeakMap();
function getIgnoreCaseFlags(flags) {
    if (flags.ignoreCase) {
        return flags;
    }
    let cached = ignoreCaseFlagsCache.get(flags);
    if (cached === undefined) {
        cached = (0, regexp_ast_analysis_1.toCache)(Object.assign(Object.assign({}, flags), { ignoreCase: true }));
        ignoreCaseFlagsCache.set(flags, cached);
    }
    return cached;
}
exports.getIgnoreCaseFlags = getIgnoreCaseFlags;
function getCaseSensitiveFlags(flags) {
    if (flags.ignoreCase === false) {
        return flags;
    }
    let cached = caseSensitiveFlagsCache.get(flags);
    if (cached === undefined) {
        cached = (0, regexp_ast_analysis_1.toCache)(Object.assign(Object.assign({}, flags), { ignoreCase: false }));
        caseSensitiveFlagsCache.set(flags, cached);
    }
    return cached;
}
exports.getCaseSensitiveFlags = getCaseSensitiveFlags;
function isCaseVariant(element, flags, wholeCharacterClass = true) {
    const { unicode = false } = flags;
    const iSet = getIgnoreCaseFlags(flags);
    const iUnset = getCaseSensitiveFlags(flags);
    function ccElementIsCaseVariant(e) {
        switch (e.type) {
            case "Character":
                return (0, regexp_ast_analysis_1.toCharSet)(e, iSet).size !== 1;
            case "CharacterClassRange":
                return !(0, regexp_ast_analysis_1.toCharSet)(e, iSet).equals((0, regexp_ast_analysis_1.toCharSet)(e, iUnset));
            case "CharacterSet":
                switch (e.kind) {
                    case "word":
                        return unicode;
                    case "property":
                        return !(0, regexp_ast_analysis_1.toCharSet)(e, iSet).equals((0, regexp_ast_analysis_1.toCharSet)(e, iUnset));
                    default:
                        return false;
                }
            default:
                throw new Error(`Unknown type: ${e}`);
        }
    }
    return (0, regexp_ast_analysis_1.hasSomeDescendant)(element, (d) => {
        switch (d.type) {
            case "Assertion":
                return unicode && d.kind === "word";
            case "Backreference":
                if ((0, regexp_ast_analysis_1.hasSomeDescendant)(element, d.resolved)) {
                    return false;
                }
                return (!(0, regexp_ast_analysis_1.isEmptyBackreference)(d) &&
                    isCaseVariant(d.resolved, flags));
            case "Character":
            case "CharacterClassRange":
            case "CharacterSet":
                return ccElementIsCaseVariant(d);
            case "CharacterClass":
                if (!wholeCharacterClass) {
                    return d.elements.some(ccElementIsCaseVariant);
                }
                return !(0, regexp_ast_analysis_1.toCharSet)(d, iSet).equals((0, regexp_ast_analysis_1.toCharSet)(d, iUnset));
            default:
                return false;
        }
    }, (d) => {
        return (d.type !== "CharacterClass" && d.type !== "CharacterClassRange");
    });
}
exports.isCaseVariant = isCaseVariant;

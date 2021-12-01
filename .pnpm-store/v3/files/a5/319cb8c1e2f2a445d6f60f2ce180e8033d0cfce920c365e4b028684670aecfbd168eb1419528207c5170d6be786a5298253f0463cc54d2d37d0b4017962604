"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getFirstConsumedCharPlusAfter = void 0;
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
function getFirstConsumedCharPlusAfter(element, direction, flags) {
    const consumed = (0, regexp_ast_analysis_1.getFirstConsumedChar)(element, direction, flags);
    if (!consumed.empty) {
        return consumed;
    }
    return regexp_ast_analysis_1.FirstConsumedChars.concat([consumed, (0, regexp_ast_analysis_1.getFirstConsumedCharAfter)(element, direction, flags)], flags);
}
exports.getFirstConsumedCharPlusAfter = getFirstConsumedCharPlusAfter;

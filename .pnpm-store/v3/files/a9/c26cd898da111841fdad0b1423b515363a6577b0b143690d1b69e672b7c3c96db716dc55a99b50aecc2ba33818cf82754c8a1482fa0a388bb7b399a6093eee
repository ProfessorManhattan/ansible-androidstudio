"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPossiblyConsumedChar = exports.extractCaptures = exports.getRegExpNodeFromExpression = exports.getFirstConsumedCharPlusAfter = void 0;
const regexpp_1 = require("regexpp");
const ast_utils_1 = require("../ast-utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
var common_1 = require("./common");
Object.defineProperty(exports, "getFirstConsumedCharPlusAfter", { enumerable: true, get: function () { return common_1.getFirstConsumedCharPlusAfter; } });
__exportStar(require("./is-covered"), exports);
__exportStar(require("./is-equals"), exports);
const parser = new regexpp_1.RegExpParser();
function getRegExpNodeFromExpression(node, context) {
    if (node.type === "Literal") {
        if ("regex" in node && node.regex) {
            try {
                return parser.parsePattern(node.regex.pattern, 0, node.regex.pattern.length, node.regex.flags.includes("u"));
            }
            catch (_a) {
                return null;
            }
        }
        return null;
    }
    const evaluated = (0, ast_utils_1.getStaticValue)(context, node);
    if (!evaluated || !(evaluated.value instanceof RegExp)) {
        return null;
    }
    try {
        return (0, regexpp_1.parseRegExpLiteral)(evaluated.value);
    }
    catch (_b) {
        return null;
    }
}
exports.getRegExpNodeFromExpression = getRegExpNodeFromExpression;
function extractCaptures(patternNode) {
    let count = 0;
    const names = new Set();
    (0, regexpp_1.visitRegExpAST)(patternNode, {
        onCapturingGroupEnter(cgNode) {
            count++;
            if (cgNode.name != null) {
                names.add(cgNode.name);
            }
        },
    });
    return { count, names };
}
exports.extractCaptures = extractCaptures;
function getPossiblyConsumedChar(element, flags) {
    const ranges = [];
    let exact = true;
    (0, regexp_ast_analysis_1.hasSomeDescendant)(element, (d) => {
        if (d.type === "Character" ||
            d.type === "CharacterClass" ||
            d.type === "CharacterSet") {
            const c = (0, regexp_ast_analysis_1.toCharSet)(d, flags);
            ranges.push(...c.ranges);
            exact = exact && !c.isEmpty;
        }
        else if (d.type === "Backreference" && !(0, regexp_ast_analysis_1.isEmptyBackreference)(d)) {
            const c = getPossiblyConsumedChar(d.resolved, flags);
            ranges.push(...c.char.ranges);
            exact = exact && c.exact && c.char.size < 2;
        }
        return false;
    }, (d) => {
        if (d.type === "CharacterClass") {
            return false;
        }
        if (d.type === "Assertion") {
            exact = false;
            return false;
        }
        return true;
    });
    const char = regexp_ast_analysis_1.Chars.empty(flags).union(ranges);
    return { char, exact };
}
exports.getPossiblyConsumedChar = getPossiblyConsumedChar;

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
exports.isEscapeSequence = exports.isUseHexEscape = exports.getEscapeSequenceKind = exports.EscapeSequenceKind = exports.isUnicodeCodePointEscape = exports.isUnicodeEscape = exports.isHexadecimalEscape = exports.isControlEscape = exports.isOctalEscape = exports.canUnwrapped = exports.mightCreateNewElement = exports.toCharSetSource = exports.quantToString = exports.getQuantifierOffsets = exports.getFlagsLocation = exports.getFlagsRange = exports.compositingVisitors = exports.defineRegexpVisitor = exports.createRule = exports.parseFlags = exports.FLAG_UNICODE = exports.FLAG_STICKY = exports.FLAG_MULTILINE = exports.FLAG_IGNORECASE = exports.FLAG_DOTALL = exports.FLAG_GLOBAL = void 0;
const regexpp_1 = require("regexpp");
const eslint_utils_1 = require("eslint-utils");
const ast_utils_1 = require("./ast-utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const refa_1 = require("refa");
const get_usage_of_pattern_1 = require("./get-usage-of-pattern");
const utils_1 = require("./ast-utils/utils");
const pattern_source_1 = require("./ast-utils/pattern-source");
const extract_capturing_group_references_1 = require("./extract-capturing-group-references");
const type_tracker_1 = require("./type-tracker");
__exportStar(require("./unicode"), exports);
const regexpRules = new WeakMap();
exports.FLAG_GLOBAL = "g";
exports.FLAG_DOTALL = "s";
exports.FLAG_IGNORECASE = "i";
exports.FLAG_MULTILINE = "m";
exports.FLAG_STICKY = "y";
exports.FLAG_UNICODE = "u";
const flagsCache = new Map();
function parseFlags(flags) {
    let cached = flagsCache.get(flags);
    if (cached === undefined) {
        cached = {
            dotAll: flags.includes(exports.FLAG_DOTALL),
            global: flags.includes(exports.FLAG_GLOBAL),
            ignoreCase: flags.includes(exports.FLAG_IGNORECASE),
            multiline: flags.includes(exports.FLAG_MULTILINE),
            sticky: flags.includes(exports.FLAG_STICKY),
            unicode: flags.includes(exports.FLAG_UNICODE),
        };
        flagsCache.set(flags, cached);
    }
    return cached;
}
exports.parseFlags = parseFlags;
function createRule(ruleName, rule) {
    return {
        meta: Object.assign(Object.assign({}, rule.meta), { docs: Object.assign(Object.assign({}, rule.meta.docs), { url: `https://ota-meshi.github.io/eslint-plugin-regexp/rules/${ruleName}.html`, ruleId: `regexp/${ruleName}`, ruleName }) }),
        create: rule.create,
    };
}
exports.createRule = createRule;
function defineRegexpVisitor(context, rule) {
    const programNode = context.getSourceCode().ast;
    let visitor;
    let rules = regexpRules.get(programNode);
    if (!rules) {
        rules = [];
        regexpRules.set(programNode, rules);
        visitor = buildRegexpVisitor(context, rules, () => {
            regexpRules.delete(programNode);
        });
    }
    else {
        visitor = {};
    }
    let createLiteralVisitor = undefined;
    let createSourceVisitor = undefined;
    if ("createVisitor" in rule) {
        createLiteralVisitor = rule.createVisitor;
        createSourceVisitor = rule.createVisitor;
    }
    else {
        createLiteralVisitor = rule.createLiteralVisitor;
        createSourceVisitor = rule.createSourceVisitor;
    }
    rules.push({
        createLiteralVisitor,
        createSourceVisitor,
        visitInvalid: rule.visitInvalid,
        visitUnknown: rule.visitUnknown,
    });
    return visitor;
}
exports.defineRegexpVisitor = defineRegexpVisitor;
function buildRegexpVisitor(context, rules, programExit) {
    const parser = new regexpp_1.RegExpParser();
    function verify(patternNode, flagsNode, regexpNode, patternSource, flagsString, ownsFlags, createVisitor) {
        const flags = parseFlags(flagsString || "");
        if (!patternSource) {
            visitUnknownForRules(rules, Object.assign({ pattern: null, patternSource: null }, buildUnparsableRegExpContextBase({
                patternSource,
                patternNode,
                regexpNode,
                context,
                flags,
                flagsString,
                flagsNode,
                ownsFlags,
            })));
            return;
        }
        let parsedPattern;
        try {
            parsedPattern = parser.parsePattern(patternSource.value, 0, patternSource.value.length, flags.unicode);
        }
        catch (error) {
            if (error instanceof SyntaxError) {
                visitInvalidForRules(rules, Object.assign({ pattern: patternSource.value, patternSource,
                    error }, buildUnparsableRegExpContextBase({
                    patternSource,
                    patternNode,
                    regexpNode,
                    context,
                    flags,
                    flagsString,
                    flagsNode,
                    ownsFlags,
                })));
            }
            return;
        }
        const helpers = buildRegExpContextBase({
            patternSource,
            regexpNode,
            flagsNode,
            context,
            flags,
            parsedPattern,
        });
        (0, regexpp_1.visitRegExpAST)(parsedPattern, createVisitor(helpers));
    }
    const ownedRegExpLiterals = new Set();
    return {
        "Program:exit": programExit,
        Literal(node) {
            if (!(0, utils_1.isRegexpLiteral)(node) || ownedRegExpLiterals.has(node)) {
                return;
            }
            const flagsString = node.regex.flags;
            const patternSource = pattern_source_1.PatternSource.fromRegExpLiteral(context, node);
            verify(node, node, node, patternSource, flagsString, true, (base) => {
                return createLiteralVisitorFromRules(rules, Object.assign({ node,
                    flagsString, ownsFlags: true, regexpNode: node }, base));
            });
        },
        Program() {
            const tracker = new eslint_utils_1.ReferenceTracker(context.getScope());
            const regexpDataList = [];
            for (const { node } of tracker.iterateGlobalReferences({
                RegExp: { [eslint_utils_1.CALL]: true, [eslint_utils_1.CONSTRUCT]: true },
            })) {
                const newOrCall = node;
                const args = newOrCall.arguments;
                const [patternArg, flagsArg] = args;
                if (!patternArg || patternArg.type === "SpreadElement") {
                    continue;
                }
                const patternSource = pattern_source_1.PatternSource.fromExpression(context, patternArg);
                patternSource === null || patternSource === void 0 ? void 0 : patternSource.getOwnedRegExpLiterals().forEach((n) => ownedRegExpLiterals.add(n));
                let flagsNode = null;
                let flagsString = null;
                let ownsFlags = false;
                if (flagsArg) {
                    if (flagsArg.type !== "SpreadElement") {
                        flagsNode = (0, utils_1.dereferenceOwnedVariable)(context, flagsArg);
                        flagsString = (0, ast_utils_1.getStringIfConstant)(context, flagsNode);
                        ownsFlags = (0, utils_1.isStringLiteral)(flagsNode);
                    }
                }
                else {
                    if (patternSource && patternSource.regexpValue) {
                        flagsString = patternSource.regexpValue.flags;
                        ownsFlags = Boolean(patternSource.regexpValue.ownedNode);
                        flagsNode = patternSource.regexpValue.ownedNode;
                    }
                    else {
                        flagsString = "";
                        ownsFlags = true;
                    }
                }
                regexpDataList.push({
                    call: newOrCall,
                    patternNode: patternArg,
                    patternSource,
                    flagsNode,
                    flagsString,
                    ownsFlags,
                });
            }
            for (const { call, patternNode, patternSource, flagsNode, flagsString, ownsFlags, } of regexpDataList) {
                verify(patternNode, flagsNode, call, patternSource, flagsString, ownsFlags, (base) => {
                    return createSourceVisitorFromRules(rules, Object.assign({ node: patternNode, flagsString,
                        ownsFlags, regexpNode: call }, base));
                });
            }
        },
    };
}
function createLiteralVisitorFromRules(rules, context) {
    const handlers = [];
    for (const rule of rules) {
        if (rule.createLiteralVisitor) {
            handlers.push(rule.createLiteralVisitor(context));
        }
    }
    return composeRegExpVisitors(handlers);
}
function createSourceVisitorFromRules(rules, context) {
    const handlers = [];
    for (const rule of rules) {
        if (rule.createSourceVisitor) {
            handlers.push(rule.createSourceVisitor(context));
        }
    }
    return composeRegExpVisitors(handlers);
}
function visitInvalidForRules(rules, context) {
    var _a;
    for (const rule of rules) {
        (_a = rule.visitInvalid) === null || _a === void 0 ? void 0 : _a.call(rule, context);
    }
}
function visitUnknownForRules(rules, context) {
    var _a;
    for (const rule of rules) {
        (_a = rule.visitUnknown) === null || _a === void 0 ? void 0 : _a.call(rule, context);
    }
}
function composeRegExpVisitors(handlers) {
    const handler = {};
    for (const visitor of handlers) {
        const entries = Object.entries(visitor);
        for (const [key, fn] of entries) {
            const orig = handler[key];
            if (orig) {
                handler[key] = (node) => {
                    orig(node);
                    fn(node);
                };
            }
            else {
                handler[key] = fn;
            }
        }
    }
    return handler;
}
function compositingVisitors(visitor, ...visitors) {
    for (const v of visitors) {
        for (const key in v) {
            const orig = visitor[key];
            if (orig) {
                visitor[key] = (...args) => {
                    orig(...args);
                    v[key](...args);
                };
            }
            else {
                visitor[key] = v[key];
            }
        }
    }
    return visitor;
}
exports.compositingVisitors = compositingVisitors;
function buildRegExpContextBase({ patternSource, regexpNode, flagsNode, context, flags, parsedPattern, }) {
    const sourceCode = context.getSourceCode();
    let cacheUsageOfPattern = null;
    const cacheCapturingGroupReferenceMap = new Map();
    let cacheAllCapturingGroups = null;
    return {
        getRegexpLocation: (range, offsets) => {
            if (offsets) {
                return patternSource.getAstLocation({
                    start: range.start + offsets[0],
                    end: range.start + offsets[1],
                });
            }
            return patternSource.getAstLocation(range);
        },
        getFlagsLocation: () => getFlagsLocation(sourceCode, regexpNode, flagsNode),
        getFlagLocation: (flag) => getFlagLocation(sourceCode, regexpNode, flagsNode, flag),
        fixReplaceNode: (node, replacement) => {
            return fixReplaceNode(patternSource, node, replacement);
        },
        fixReplaceQuant: (qNode, replacement) => {
            return fixReplaceQuant(patternSource, qNode, replacement);
        },
        fixReplaceFlags: (newFlags, includePattern) => {
            return fixReplaceFlags(patternSource, regexpNode, flagsNode, newFlags, includePattern !== null && includePattern !== void 0 ? includePattern : true);
        },
        getUsageOfPattern: () => (cacheUsageOfPattern !== null && cacheUsageOfPattern !== void 0 ? cacheUsageOfPattern : (cacheUsageOfPattern = (0, get_usage_of_pattern_1.getUsageOfPattern)(regexpNode, context))),
        getCapturingGroupReferences: (options) => {
            var _a;
            const strictTypes = Boolean((_a = options === null || options === void 0 ? void 0 : options.strictTypes) !== null && _a !== void 0 ? _a : true);
            const cacheCapturingGroupReference = cacheCapturingGroupReferenceMap.get(strictTypes);
            if (cacheCapturingGroupReference) {
                return cacheCapturingGroupReference;
            }
            const countOfCapturingGroup = getAllCapturingGroupsWithCache().length;
            const capturingGroupReferences = [
                ...(0, extract_capturing_group_references_1.extractCapturingGroupReferences)(regexpNode, flags, (0, type_tracker_1.createTypeTracker)(context), countOfCapturingGroup, context, { strictTypes }),
            ];
            cacheCapturingGroupReferenceMap.set(strictTypes, capturingGroupReferences);
            return capturingGroupReferences;
        },
        getAllCapturingGroups: getAllCapturingGroupsWithCache,
        pattern: parsedPattern.raw,
        patternAst: parsedPattern,
        patternSource,
        flags: (0, regexp_ast_analysis_1.toCache)(flags),
    };
    function getAllCapturingGroupsWithCache() {
        return (cacheAllCapturingGroups !== null && cacheAllCapturingGroups !== void 0 ? cacheAllCapturingGroups : (cacheAllCapturingGroups = getAllCapturingGroups(parsedPattern)));
    }
}
function buildUnparsableRegExpContextBase({ patternSource, patternNode, regexpNode, context, flags: originalFlags, flagsString, flagsNode, ownsFlags, }) {
    const sourceCode = context.getSourceCode();
    const flags = (0, regexp_ast_analysis_1.toCache)(originalFlags);
    return {
        regexpNode,
        node: patternNode,
        flags,
        flagsString,
        ownsFlags,
        getFlagsLocation: () => getFlagsLocation(sourceCode, regexpNode, flagsNode),
        getFlagLocation: (flag) => getFlagLocation(sourceCode, regexpNode, flagsNode, flag),
        fixReplaceFlags: (newFlags, includePattern) => {
            return fixReplaceFlags(patternSource, regexpNode, flagsNode, newFlags, includePattern !== null && includePattern !== void 0 ? includePattern : true);
        },
    };
}
function getFlagsRange(flagsNode) {
    if (!flagsNode) {
        return null;
    }
    if ((0, utils_1.isRegexpLiteral)(flagsNode)) {
        return [
            flagsNode.range[1] - flagsNode.regex.flags.length,
            flagsNode.range[1],
        ];
    }
    if ((0, utils_1.isStringLiteral)(flagsNode)) {
        return [flagsNode.range[0] + 1, flagsNode.range[1] - 1];
    }
    return null;
}
exports.getFlagsRange = getFlagsRange;
function getFlagsLocation(sourceCode, regexpNode, flagsNode) {
    var _a;
    const range = getFlagsRange(flagsNode);
    if (range == null) {
        return (_a = flagsNode === null || flagsNode === void 0 ? void 0 : flagsNode.loc) !== null && _a !== void 0 ? _a : regexpNode.loc;
    }
    if (range[0] === range[1]) {
        range[0]--;
    }
    return {
        start: sourceCode.getLocFromIndex(range[0]),
        end: sourceCode.getLocFromIndex(range[1]),
    };
}
exports.getFlagsLocation = getFlagsLocation;
function getFlagRange(sourceCode, flagsNode, flag) {
    if (!flagsNode || !flag) {
        return null;
    }
    if ((0, utils_1.isRegexpLiteral)(flagsNode)) {
        const index = flagsNode.regex.flags.indexOf(flag);
        if (index === -1) {
            return null;
        }
        const start = flagsNode.range[1] - flagsNode.regex.flags.length + index;
        return [start, start + 1];
    }
    if ((0, utils_1.isStringLiteral)(flagsNode)) {
        const index = flagsNode.value.indexOf(flag);
        if (index === -1) {
            return null;
        }
        return (0, utils_1.getStringValueRange)(sourceCode, flagsNode, index, index + 1);
    }
    return null;
}
function getFlagLocation(sourceCode, regexpNode, flagsNode, flag) {
    var _a;
    const range = getFlagRange(sourceCode, flagsNode, flag);
    if (range == null) {
        return (_a = flagsNode === null || flagsNode === void 0 ? void 0 : flagsNode.loc) !== null && _a !== void 0 ? _a : regexpNode.loc;
    }
    return {
        start: sourceCode.getLocFromIndex(range[0]),
        end: sourceCode.getLocFromIndex(range[1]),
    };
}
function fixReplaceNode(patternSource, regexpNode, replacement) {
    return (fixer) => {
        const range = patternSource.getReplaceRange(regexpNode);
        if (range == null) {
            return null;
        }
        let text;
        if (typeof replacement === "string") {
            text = replacement;
        }
        else {
            text = replacement();
            if (text == null) {
                return null;
            }
        }
        return range.replace(fixer, text);
    };
}
function fixReplaceQuant(patternSource, quantifier, replacement) {
    return (fixer) => {
        let text;
        if (typeof replacement !== "function") {
            text = replacement;
        }
        else {
            text = replacement();
            if (text == null) {
                return null;
            }
        }
        const offset = getQuantifierOffsets(quantifier);
        if (typeof text !== "string") {
            if (text.greedy !== undefined &&
                text.greedy !== quantifier.greedy) {
                offset[1] += 1;
            }
            text = quantToString(text);
        }
        const range = patternSource.getReplaceRange({
            start: quantifier.start + offset[0],
            end: quantifier.start + offset[1],
        });
        if (range == null) {
            return null;
        }
        return range.replace(fixer, text);
    };
}
function fixReplaceFlags(patternSource, regexpNode, flagsNode, replacement, includePattern) {
    return (fixer) => {
        let newFlags;
        if (typeof replacement === "string") {
            newFlags = replacement;
        }
        else {
            newFlags = replacement();
            if (newFlags == null) {
                return null;
            }
        }
        if (!/^[a-z]*$/iu.test(newFlags)) {
            return null;
        }
        if (includePattern && (0, utils_1.isRegexpLiteral)(regexpNode)) {
            return fixer.replaceText(regexpNode, `/${regexpNode.regex.pattern}/${newFlags}`);
        }
        let flagsFix;
        if ((0, utils_1.isRegexpLiteral)(regexpNode)) {
            flagsFix = fixer.replaceTextRange(getFlagsRange(regexpNode), newFlags);
        }
        else if (flagsNode) {
            const range = getFlagsRange(flagsNode);
            if (range == null) {
                return null;
            }
            flagsFix = fixer.replaceTextRange(range, newFlags);
        }
        else {
            if (regexpNode.arguments.length !== 1) {
                return null;
            }
            const end = regexpNode.range[1];
            flagsFix = fixer.replaceTextRange([end - 1, end], `, "${newFlags}")`);
        }
        if (!includePattern) {
            return flagsFix;
        }
        if (!patternSource) {
            return null;
        }
        const patternRange = patternSource.getReplaceRange({
            start: 0,
            end: patternSource.value.length,
        });
        if (patternRange == null) {
            return null;
        }
        const patternFix = patternRange.replace(fixer, patternSource.value);
        return [patternFix, flagsFix];
    };
}
function getQuantifierOffsets(qNode) {
    const startOffset = qNode.element.end - qNode.start;
    const endOffset = qNode.raw.length - (qNode.greedy ? 0 : 1);
    return [startOffset, endOffset];
}
exports.getQuantifierOffsets = getQuantifierOffsets;
function quantToString(quant) {
    if (quant.max < quant.min ||
        quant.min < 0 ||
        !Number.isInteger(quant.min) ||
        !(Number.isInteger(quant.max) || quant.max === Infinity)) {
        throw new Error(`Invalid quantifier { min: ${quant.min}, max: ${quant.max} }`);
    }
    let value;
    if (quant.min === 0 && quant.max === 1) {
        value = "?";
    }
    else if (quant.min === 0 && quant.max === Infinity) {
        value = "*";
    }
    else if (quant.min === 1 && quant.max === Infinity) {
        value = "+";
    }
    else if (quant.min === quant.max) {
        value = `{${quant.min}}`;
    }
    else if (quant.max === Infinity) {
        value = `{${quant.min},}`;
    }
    else {
        value = `{${quant.min},${quant.max}}`;
    }
    if (quant.greedy === false) {
        return `${value}?`;
    }
    return value;
}
exports.quantToString = quantToString;
function toCharSetSource(charSetOrChar, flags) {
    let charSet;
    if (typeof charSetOrChar === "number") {
        charSet = refa_1.JS.createCharSet([charSetOrChar], flags);
    }
    else {
        charSet = charSetOrChar;
    }
    return refa_1.JS.toLiteral({
        type: "Concatenation",
        elements: [{ type: "CharacterClass", characters: charSet }],
    }, { flags }).source;
}
exports.toCharSetSource = toCharSetSource;
function mightCreateNewElement(before, after) {
    if (before.endsWith("\\c") && /^[a-z]/iu.test(after)) {
        return true;
    }
    if (/(?:^|[^\\])(?:\\{2})*\\(?:x[\dA-Fa-f]?|u[\dA-Fa-f]{0,3})$/u.test(before) &&
        /^[\da-f]/iu.test(after)) {
        return true;
    }
    if ((/(?:^|[^\\])(?:\\{2})*\\u$/u.test(before) &&
        /^\{[\da-f]*(?:\}[\s\S]*)?$/iu.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\\u\{[\da-f]*$/u.test(before) &&
            /^(?:[\da-f]+\}?|\})/iu.test(after))) {
        return true;
    }
    if ((/(?:^|[^\\])(?:\\{2})*\\0[0-7]?$/u.test(before) &&
        /^[0-7]/u.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\\[1-7]$/u.test(before) && /^[0-7]/u.test(after))) {
        return true;
    }
    if ((/(?:^|[^\\])(?:\\{2})*\\[1-9]\d*$/u.test(before) &&
        /^\d/u.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\\k$/u.test(before) && after.startsWith("<")) ||
        /(?:^|[^\\])(?:\\{2})*\\k<[^<>]*$/u.test(before)) {
        return true;
    }
    if ((/(?:^|[^\\])(?:\\{2})*\\p$/iu.test(before) &&
        /^\{[\w=]*(?:\}[\s\S]*)?$/u.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\\p\{[\w=]*$/iu.test(before) &&
            /^[\w=]+(?:\}[\s\S]*)?$|^\}/u.test(after))) {
        return true;
    }
    if ((/(?:^|[^\\])(?:\\{2})*\{\d*$/u.test(before) &&
        /^[\d,}]/u.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\{\d+,$/u.test(before) &&
            /^(?:\d+(?:\}|$)|\})/u.test(after)) ||
        (/(?:^|[^\\])(?:\\{2})*\{\d+,\d*$/u.test(before) &&
            after.startsWith("}"))) {
        return true;
    }
    return false;
}
exports.mightCreateNewElement = mightCreateNewElement;
function canUnwrapped(node, text) {
    let textBefore, textAfter;
    const parent = node.parent;
    if (parent.type === "Alternative") {
        textBefore = parent.raw.slice(0, node.start - parent.start);
        textAfter = parent.raw.slice(node.end - parent.start);
    }
    else if (parent.type === "Quantifier") {
        const alt = parent.parent;
        textBefore = alt.raw.slice(0, node.start - alt.start);
        textAfter = alt.raw.slice(node.end - alt.start);
    }
    else {
        return true;
    }
    return (!mightCreateNewElement(textBefore, text) &&
        !mightCreateNewElement(text, textAfter));
}
exports.canUnwrapped = canUnwrapped;
function isOctalEscape(raw) {
    return /^\\[0-7]{1,3}$/u.test(raw);
}
exports.isOctalEscape = isOctalEscape;
function isControlEscape(raw) {
    return /^\\c[A-Za-z]$/u.test(raw);
}
exports.isControlEscape = isControlEscape;
function isHexadecimalEscape(raw) {
    return /^\\x[\dA-Fa-f]{2}$/u.test(raw);
}
exports.isHexadecimalEscape = isHexadecimalEscape;
function isUnicodeEscape(raw) {
    return /^\\u[\dA-Fa-f]{4}$/u.test(raw);
}
exports.isUnicodeEscape = isUnicodeEscape;
function isUnicodeCodePointEscape(raw) {
    return /^\\u\{[\dA-Fa-f]{1,8}\}$/u.test(raw);
}
exports.isUnicodeCodePointEscape = isUnicodeCodePointEscape;
var EscapeSequenceKind;
(function (EscapeSequenceKind) {
    EscapeSequenceKind["octal"] = "octal";
    EscapeSequenceKind["control"] = "control";
    EscapeSequenceKind["hexadecimal"] = "hexadecimal";
    EscapeSequenceKind["unicode"] = "unicode";
    EscapeSequenceKind["unicodeCodePoint"] = "unicode code point";
})(EscapeSequenceKind = exports.EscapeSequenceKind || (exports.EscapeSequenceKind = {}));
function getEscapeSequenceKind(raw) {
    if (!raw.startsWith("\\")) {
        return null;
    }
    if (isOctalEscape(raw)) {
        return EscapeSequenceKind.octal;
    }
    if (isControlEscape(raw)) {
        return EscapeSequenceKind.control;
    }
    if (isHexadecimalEscape(raw)) {
        return EscapeSequenceKind.hexadecimal;
    }
    if (isUnicodeEscape(raw)) {
        return EscapeSequenceKind.unicode;
    }
    if (isUnicodeCodePointEscape(raw)) {
        return EscapeSequenceKind.unicodeCodePoint;
    }
    return null;
}
exports.getEscapeSequenceKind = getEscapeSequenceKind;
function isUseHexEscape(raw) {
    const kind = getEscapeSequenceKind(raw);
    return (kind === EscapeSequenceKind.hexadecimal ||
        kind === EscapeSequenceKind.unicode ||
        kind === EscapeSequenceKind.unicodeCodePoint);
}
exports.isUseHexEscape = isUseHexEscape;
function isEscapeSequence(raw) {
    return Boolean(getEscapeSequenceKind(raw));
}
exports.isEscapeSequence = isEscapeSequence;
function getAllCapturingGroups(pattern) {
    const groups = [];
    (0, regexpp_1.visitRegExpAST)(pattern, {
        onCapturingGroupEnter(group) {
            groups.push(group);
        },
    });
    groups.sort((a, b) => a.start - b.start);
    return groups;
}

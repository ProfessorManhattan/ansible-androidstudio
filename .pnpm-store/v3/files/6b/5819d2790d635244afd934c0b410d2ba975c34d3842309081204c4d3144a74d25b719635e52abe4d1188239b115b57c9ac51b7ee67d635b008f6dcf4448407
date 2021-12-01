"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getLongestPrefix = void 0;
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const common_1 = require("./common");
const ltrCache = new WeakMap();
const rtlCache = new WeakMap();
function getLongestPrefix(alternative, direction, flags) {
    const cache = direction === "ltr" ? ltrCache : rtlCache;
    let cached = cache.get(alternative);
    if (cached === undefined) {
        cached = getLongestPrefixUncached(alternative, direction, flags);
        cache.set(alternative, cached);
    }
    return cached;
}
exports.getLongestPrefix = getLongestPrefix;
function getLongestPrefixUncached(alternative, direction, flags) {
    const prefix = getAlternativePrefix(alternative, direction, flags);
    let { chars } = prefix;
    if (prefix.complete) {
        chars.push((0, regexp_ast_analysis_1.getFirstCharAfter)(alternative, direction, flags).char);
    }
    for (let i = 0; i < chars.length; i++) {
        if (chars[i].isEmpty) {
            chars = chars.slice(0, i);
            break;
        }
    }
    return chars;
}
function getAlternativePrefix(alternative, direction, flags) {
    const { elements } = alternative;
    const chars = [];
    const first = direction === "ltr" ? 0 : elements.length - 1;
    const inc = direction === "ltr" ? +1 : -1;
    for (let i = first; i >= 0 && i < elements.length; i += inc) {
        const inner = getElementPrefix(elements[i], direction, flags);
        chars.push(...inner.chars);
        if (!inner.complete) {
            return { chars, complete: false };
        }
    }
    return { chars, complete: true };
}
function getElementPrefix(element, direction, flags) {
    switch (element.type) {
        case "Assertion":
            return { chars: [], complete: true };
        case "Character":
        case "CharacterClass":
        case "CharacterSet":
            return {
                chars: [(0, regexp_ast_analysis_1.toCharSet)(element, flags)],
                complete: true,
            };
        case "CapturingGroup":
        case "Group":
            return getGroupPrefix(element, direction, flags);
        case "Quantifier":
            return getQuantifierPrefix(element, direction, flags);
        case "Backreference": {
            if ((0, regexp_ast_analysis_1.isStrictBackreference)(element)) {
                const inner = getElementPrefix(element.resolved, direction, flags);
                if (inner.complete) {
                    return inner;
                }
            }
            const look = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, common_1.getFirstConsumedCharPlusAfter)(element, direction, flags));
            return { chars: [look.char], complete: false };
        }
        default:
            throw new Error("unreachable");
    }
}
function getGroupPrefix(element, direction, flags) {
    if (element.alternatives.length === 1) {
        return getAlternativePrefix(element.alternatives[0], direction, flags);
    }
    const alternatives = element.alternatives.map((a) => getAlternativePrefix(a, direction, flags));
    const chars = [];
    let complete = true;
    for (let i = 0; complete; i++) {
        const cs = [];
        let end = false;
        for (const a of alternatives) {
            if (i >= a.chars.length) {
                end = true;
            }
            else {
                cs.push(a.chars[i]);
                if (i === a.chars.length - 1 && !a.complete) {
                    complete = false;
                }
            }
        }
        if (cs.length === 0) {
            break;
        }
        if (end) {
            complete = false;
            cs.push((0, regexp_ast_analysis_1.getFirstCharAfter)(element, direction, flags).char);
        }
        const total = cs[0].union(...cs.slice(1));
        chars.push(total);
    }
    return { chars, complete };
}
function getQuantifierPrefix(element, direction, flags) {
    if ((0, regexp_ast_analysis_1.isZeroLength)(element)) {
        return { chars: [], complete: true };
    }
    if ((0, regexp_ast_analysis_1.isPotentiallyZeroLength)(element)) {
        const look = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, common_1.getFirstConsumedCharPlusAfter)(element, direction, flags));
        return { chars: [look.char], complete: false };
    }
    const inner = getElementPrefix(element.element, direction, flags);
    if (!inner.complete) {
        return inner;
    }
    const chars = [];
    for (let i = 0; i < element.min; i++) {
        chars.push(...inner.chars);
        if (chars.length > 100) {
            return { chars, complete: false };
        }
    }
    if (element.min === element.max) {
        return { chars, complete: true };
    }
    const look = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, regexp_ast_analysis_1.getFirstConsumedCharAfter)(element.element, direction, flags));
    chars.push(look.char);
    return { chars, complete: false };
}

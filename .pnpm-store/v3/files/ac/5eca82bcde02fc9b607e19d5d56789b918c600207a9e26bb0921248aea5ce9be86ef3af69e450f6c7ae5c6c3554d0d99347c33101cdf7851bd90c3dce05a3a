"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.detectFramework = exports.detectDangerousQuoteCombination = exports.makeString = exports.handleBracketSpacing = exports.isMultilineInterpolation = exports.isSingleLineWithInterpolation = exports.isQuoted = exports.isWrappedWith = exports.isStyleAttribute = exports.unwrapLineFeeds = exports.previousTypeAttributeToken = exports.previousNormalAttributeToken = exports.previousTagToken = void 0;
function previousTagToken(tokens, index) {
    for (let i = index - 1; i >= 0; i--) {
        const token = tokens[i];
        if (!token) {
            return;
        }
        if (token.type === 'tag') {
            return token;
        }
    }
    return;
}
exports.previousTagToken = previousTagToken;
function previousNormalAttributeToken(tokens, index) {
    for (let i = index - 1; i > 0; i--) {
        const token = tokens[i];
        if (!token || token.type === 'start-attributes') {
            return;
        }
        if (token.type === 'attribute') {
            if (token.name !== 'class' && token.name !== 'id') {
                return token;
            }
        }
    }
    return;
}
exports.previousNormalAttributeToken = previousNormalAttributeToken;
function previousTypeAttributeToken(tokens, index) {
    for (let i = index - 1; i > 0; i--) {
        const token = tokens[i];
        if (!token || token.type === 'start-attributes' || token.type === 'tag') {
            return;
        }
        if (token.type === 'attribute') {
            if (token.name === 'type') {
                return token;
            }
        }
    }
    return;
}
exports.previousTypeAttributeToken = previousTypeAttributeToken;
function unwrapLineFeeds(value) {
    return value.includes('\n')
        ? value
            .split('\n')
            .map((part) => part.trim())
            .map((part) => (part[0] === '.' ? '' : ' ') + part)
            .join('')
            .trim()
        : value;
}
exports.unwrapLineFeeds = unwrapLineFeeds;
function isStyleAttribute(name, val) {
    return name === 'style' && isQuoted(val);
}
exports.isStyleAttribute = isStyleAttribute;
function isWrappedWith(val, start, end, offset = 0) {
    return val.startsWith(start, offset) && val.endsWith(end, val.length - offset);
}
exports.isWrappedWith = isWrappedWith;
function isQuoted(val) {
    if (/^(["'`])(.*)\1$/.test(val)) {
        const regex = new RegExp(`${val[0]}(?<!\\\\${val[0]})`);
        return !regex.test(val.slice(1, -1));
    }
    return false;
}
exports.isQuoted = isQuoted;
function isSingleLineWithInterpolation(val) {
    return /^`[\s\S]*`$/.test(val) && val.includes('${');
}
exports.isSingleLineWithInterpolation = isSingleLineWithInterpolation;
function isMultilineInterpolation(val) {
    return /^`[\s\S]*`$/m.test(val) && val.includes('\n');
}
exports.isMultilineInterpolation = isMultilineInterpolation;
function handleBracketSpacing(bracketSpacing, code, [opening, closing] = ['{{', '}}']) {
    return bracketSpacing ? `${opening} ${code} ${closing}` : `${opening}${code}${closing}`;
}
exports.handleBracketSpacing = handleBracketSpacing;
function makeString(rawContent, enclosingQuote, unescapeUnnecessaryEscapes = false) {
    const otherQuote = enclosingQuote === '"' ? "'" : '"';
    const newContent = rawContent.replace(/\\([\s\S])|(['"])/g, (match, escaped, quote) => {
        if (escaped === otherQuote) {
            return escaped;
        }
        if (quote === enclosingQuote) {
            return `\\${quote}`;
        }
        if (quote) {
            return quote;
        }
        return unescapeUnnecessaryEscapes && /^[^\\nrvtbfux\r\n\u2028\u2029"'0-7]$/.test(escaped)
            ? escaped
            : `\\${escaped}`;
    });
    return enclosingQuote + newContent + enclosingQuote;
}
exports.makeString = makeString;
function detectDangerousQuoteCombination(code, quotes, otherQuotes, logger) {
    const q1 = code.indexOf(quotes);
    const q2 = code.indexOf(otherQuotes);
    const qb = code.indexOf('`');
    if (q1 >= 0 && q2 >= 0 && q2 > q1 && (qb < 0 || q1 < qb)) {
        logger.log({ code, quotes, otherQuotes, q1, q2, qb });
        return true;
    }
    return false;
}
exports.detectDangerousQuoteCombination = detectDangerousQuoteCombination;
function detectFramework() {
    try {
        const npmPackages = Object.keys(process.env)
            .filter((key) => key.startsWith('npm_package_'))
            .filter((key) => /(dev)?[Dd]ependencies_+/.test(key));
        if (npmPackages.some((pack) => pack.includes('vue') && !pack.includes('vuepress'))) {
            return 'vue';
        }
        else if (npmPackages.some((pack) => pack.includes('svelte'))) {
            return 'svelte';
        }
        else if (npmPackages.some((pack) => pack.includes('angular'))) {
            return 'angular';
        }
    }
    catch (_a) {
        return 'auto';
    }
    return 'auto';
}
exports.detectFramework = detectFramework;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiY29tbW9uLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vc3JjL3V0aWxzL2NvbW1vbi50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFXQSxTQUFnQixnQkFBZ0IsQ0FBQyxNQUE0QixFQUFFLEtBQWE7SUFDM0UsS0FBSyxJQUFJLENBQUMsR0FBVyxLQUFLLEdBQUcsQ0FBQyxFQUFFLENBQUMsSUFBSSxDQUFDLEVBQUUsQ0FBQyxFQUFFLEVBQUU7UUFDNUMsTUFBTSxLQUFLLEdBQXNCLE1BQU0sQ0FBQyxDQUFDLENBQUMsQ0FBQztRQUMzQyxJQUFJLENBQUMsS0FBSyxFQUFFO1lBQ1gsT0FBTztTQUNQO1FBQ0QsSUFBSSxLQUFLLENBQUMsSUFBSSxLQUFLLEtBQUssRUFBRTtZQUN6QixPQUFPLEtBQUssQ0FBQztTQUNiO0tBQ0Q7SUFDRCxPQUFPO0FBQ1IsQ0FBQztBQVhELDRDQVdDO0FBU0QsU0FBZ0IsNEJBQTRCLENBQUMsTUFBNEIsRUFBRSxLQUFhO0lBQ3ZGLEtBQUssSUFBSSxDQUFDLEdBQVcsS0FBSyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsQ0FBQyxFQUFFLENBQUMsRUFBRSxFQUFFO1FBQzNDLE1BQU0sS0FBSyxHQUFzQixNQUFNLENBQUMsQ0FBQyxDQUFDLENBQUM7UUFDM0MsSUFBSSxDQUFDLEtBQUssSUFBSSxLQUFLLENBQUMsSUFBSSxLQUFLLGtCQUFrQixFQUFFO1lBQ2hELE9BQU87U0FDUDtRQUNELElBQUksS0FBSyxDQUFDLElBQUksS0FBSyxXQUFXLEVBQUU7WUFDL0IsSUFBSSxLQUFLLENBQUMsSUFBSSxLQUFLLE9BQU8sSUFBSSxLQUFLLENBQUMsSUFBSSxLQUFLLElBQUksRUFBRTtnQkFDbEQsT0FBTyxLQUFLLENBQUM7YUFDYjtTQUNEO0tBQ0Q7SUFDRCxPQUFPO0FBQ1IsQ0FBQztBQWJELG9FQWFDO0FBU0QsU0FBZ0IsMEJBQTBCLENBQUMsTUFBNEIsRUFBRSxLQUFhO0lBQ3JGLEtBQUssSUFBSSxD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
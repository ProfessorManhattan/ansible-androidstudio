"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RIGHT_BRACE = exports.LEFT_BRACE = exports.LATIN_SMALL_Z = exports.LATIN_SMALL_X = exports.LATIN_SMALL_U = exports.LATIN_SMALL_T = exports.LATIN_SMALL_S = exports.LATIN_SMALL_R = exports.LATIN_SMALL_O = exports.LATIN_SMALL_N = exports.LATIN_SMALL_L = exports.LATIN_SMALL_I = exports.LATIN_SMALL_F = exports.LATIN_SMALL_E = exports.LATIN_SMALL_B = exports.LATIN_SMALL_A = exports.UNDERSCORE = exports.RIGHT_BRACKET = exports.BACKSLASH = exports.LEFT_BRACKET = exports.LATIN_CAPITAL_Z = exports.LATIN_CAPITAL_U = exports.LATIN_CAPITAL_T = exports.LATIN_CAPITAL_F = exports.LATIN_CAPITAL_E = exports.LATIN_CAPITAL_A = exports.EQUALS_SIGN = exports.COLON = exports.DIGIT_9 = exports.DIGIT_7 = exports.DIGIT_3 = exports.DIGIT_2 = exports.DIGIT_1 = exports.DIGIT_0 = exports.DOT = exports.DASH = exports.COMMA = exports.PLUS_SIGN = exports.SINGLE_QUOTE = exports.HASH = exports.QUOTATION_MARK = exports.SPACE = exports.US = exports.CARRIAGE_RETURN = exports.FORM_FEED = exports.LINE_FEED = exports.TABULATION = exports.BACKSPACE = exports.NULL = exports.EOF = void 0;
exports.isUnicodeScalarValue = exports.isLowSurrogate = exports.isHighSurrogate = exports.isOctalDig = exports.isHexDig = exports.isDigit = exports.isLetter = exports.isEOL = exports.isWhitespace = exports.isControl = exports.DELETE = void 0;
exports.EOF = -1;
exports.NULL = 0x00;
exports.BACKSPACE = 0x08;
exports.TABULATION = 0x09;
exports.LINE_FEED = 0x0a;
exports.FORM_FEED = 0x0c;
exports.CARRIAGE_RETURN = 0x0d;
exports.US = 0x1f;
exports.SPACE = 0x20;
exports.QUOTATION_MARK = 0x22;
exports.HASH = 0x23;
exports.SINGLE_QUOTE = 0x27;
exports.PLUS_SIGN = 0x2b;
exports.COMMA = 0x2c;
exports.DASH = 0x2d;
exports.DOT = 0x2e;
exports.DIGIT_0 = 0x30;
exports.DIGIT_1 = 0x31;
exports.DIGIT_2 = 0x32;
exports.DIGIT_3 = 0x33;
exports.DIGIT_7 = 0x37;
exports.DIGIT_9 = 0x39;
exports.COLON = 0x3a;
exports.EQUALS_SIGN = 0x3d;
exports.LATIN_CAPITAL_A = 0x41;
exports.LATIN_CAPITAL_E = 0x45;
exports.LATIN_CAPITAL_F = 0x46;
exports.LATIN_CAPITAL_T = 0x54;
exports.LATIN_CAPITAL_U = 0x55;
exports.LATIN_CAPITAL_Z = 0x5a;
exports.LEFT_BRACKET = 0x5b; // [
exports.BACKSLASH = 0x5c;
exports.RIGHT_BRACKET = 0x5d; // ]
exports.UNDERSCORE = 0x5f;
exports.LATIN_SMALL_A = 0x61;
exports.LATIN_SMALL_B = 0x62;
exports.LATIN_SMALL_E = 0x65;
exports.LATIN_SMALL_F = 0x66;
exports.LATIN_SMALL_I = 0x69;
exports.LATIN_SMALL_L = 0x6c;
exports.LATIN_SMALL_N = 0x6e;
exports.LATIN_SMALL_O = 0x6f;
exports.LATIN_SMALL_R = 0x72;
exports.LATIN_SMALL_S = 0x73;
exports.LATIN_SMALL_T = 0x74;
exports.LATIN_SMALL_U = 0x75;
exports.LATIN_SMALL_X = 0x78;
exports.LATIN_SMALL_Z = 0x7a;
exports.LEFT_BRACE = 0x7b; // {
exports.RIGHT_BRACE = 0x7d; // }
exports.DELETE = 0x7f;
/**
 * Check whether the code point is a control character.
 */
function isControl(cp) {
    return cp >= exports.NULL && cp <= exports.US;
}
exports.isControl = isControl;
/**
 * Check whether the code point is a whitespace.
 */
function isWhitespace(cp) {
    return cp === exports.TABULATION || cp === exports.SPACE;
}
exports.isWhitespace = isWhitespace;
/**
 * Check whether the code point is a end of line.
 */
function isEOL(cp) {
    return cp === exports.LINE_FEED || cp === exports.CARRIAGE_RETURN;
}
exports.isEOL = isEOL;
/**
 * Check whether the code point is an uppercase letter character.
 */
function isUpperLetter(cp) {
    return cp >= exports.LATIN_CAPITAL_A && cp <= exports.LATIN_CAPITAL_Z;
}
/**
 * Check whether the code point is a lowercase letter character.
 */
function isLowerLetter(cp) {
    return cp >= exports.LATIN_SMALL_A && cp <= exports.LATIN_SMALL_Z;
}
/**
 * Check whether the code point is a letter character.
 */
function isLetter(cp) {
    return isLowerLetter(cp) || isUpperLetter(cp);
}
exports.isLetter = isLetter;
/**
 * Check whether the code point is a digit character.
 */
function isDigit(cp) {
    return cp >= exports.DIGIT_0 && cp <= exports.DIGIT_9;
}
exports.isDigit = isDigit;
/**
 * Check whether the code point is a hex digit character.
 */
function isHexDig(cp) {
    return (isDigit(cp) ||
        (cp >= exports.LATIN_SMALL_A && cp <= exports.LATIN_SMALL_F) ||
        (cp >= exports.LATIN_CAPITAL_A && cp <= exports.LATIN_CAPITAL_F));
}
exports.isHexDig = isHexDig;
/**
 * Check whether the code point is a octal digit character.
 */
function isOctalDig(cp) {
    return cp >= exports.DIGIT_0 && cp <= exports.DIGIT_7;
}
exports.isOctalDig = isOctalDig;
/**
 * Check whether the code point is a high-surrogate code point.
 */
function isHighSurrogate(cp) {
    return cp >= 0xd800 && cp <= 0xdfff;
}
exports.isHighSurrogate = isHighSurrogate;
/**
 * Check whether the code point is a low-surrogate code point.
 */
function isLowSurrogate(cp) {
    return cp >= 0xdc00 && cp <= 0xdfff;
}
exports.isLowSurrogate = isLowSurrogate;
/**
 * Check whether the code point is valid code point.
 *
 * see
 * - https://unicode.org/glossary/#unicode_scalar_value
 * - https://toml.io/en/v1.0.0#string
 */
function isUnicodeScalarValue(cp) {
    return (cp >= 0 && cp <= 0xd7ff) || (cp >= 0xe000 && cp <= 0x10ffff);
}
exports.isUnicodeScalarValue = isUnicodeScalarValue;

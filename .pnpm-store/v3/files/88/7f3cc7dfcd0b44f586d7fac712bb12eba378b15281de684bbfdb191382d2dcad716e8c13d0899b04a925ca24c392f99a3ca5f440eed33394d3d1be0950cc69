"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CodePointIterator = void 0;
const code_point_1 = require("./code-point");
class CodePointIterator {
    /**
     * Initialize this char iterator.
     */
    constructor(text) {
        this.lastCodePoint = code_point_1.NULL;
        this.start = {
            offset: -1,
            line: 1,
            column: -1,
        };
        this.end = {
            offset: 0,
            line: 1,
            column: 0,
        };
        this.text = text;
    }
    next() {
        var _a;
        if (this.lastCodePoint === code_point_1.EOF) {
            return code_point_1.EOF;
        }
        this.start.offset = this.end.offset;
        this.start.line = this.end.line;
        this.start.column = this.end.column;
        const cp = (_a = this.text.codePointAt(this.start.offset)) !== null && _a !== void 0 ? _a : code_point_1.EOF;
        if (cp === code_point_1.EOF) {
            this.end = this.start;
            return (this.lastCodePoint = cp);
        }
        const shift = cp >= 0x10000 ? 2 : 1;
        this.end.offset = this.start.offset + shift;
        if (cp === code_point_1.LINE_FEED) {
            this.end.line = this.start.line + 1;
            this.end.column = 0;
        }
        else if (cp === code_point_1.CARRIAGE_RETURN) {
            if (this.text.codePointAt(this.end.offset) === code_point_1.LINE_FEED) {
                this.end.offset++;
                this.end.line = this.start.line + 1;
                this.end.column = 0;
            }
            return (this.lastCodePoint = code_point_1.LINE_FEED);
        }
        else {
            this.end.column = this.start.column + shift;
        }
        return (this.lastCodePoint = cp);
    }
    *iterateSubCodePoints() {
        var _a, _b;
        let index = this.end.offset;
        while (true) {
            let cp = (_a = this.text.codePointAt(index)) !== null && _a !== void 0 ? _a : code_point_1.EOF;
            if (cp === code_point_1.CARRIAGE_RETURN) {
                if (this.text.codePointAt(index) === code_point_1.LINE_FEED) {
                    cp = (_b = this.text.codePointAt(++index)) !== null && _b !== void 0 ? _b : code_point_1.EOF;
                }
                else {
                    cp = code_point_1.LINE_FEED;
                }
            }
            if (cp === code_point_1.EOF) {
                return;
            }
            yield cp;
            index += cp >= 0x10000 ? 2 : 1;
        }
    }
    subCodePoints() {
        const sub = this.iterateSubCodePoints();
        let end = false;
        let count = 0;
        return {
            next() {
                if (end) {
                    return code_point_1.EOF;
                }
                const r = sub.next();
                if (r.done) {
                    end = true;
                    return code_point_1.EOF;
                }
                count++;
                return r.value;
            },
            get count() {
                return count;
            },
        };
    }
}
exports.CodePointIterator = CodePointIterator;

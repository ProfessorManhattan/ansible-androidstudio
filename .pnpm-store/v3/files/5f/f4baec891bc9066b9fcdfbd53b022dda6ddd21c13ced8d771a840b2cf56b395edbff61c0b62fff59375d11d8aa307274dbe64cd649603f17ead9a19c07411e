"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.LexicalStructurePrettierVisitor = void 0;
var format_comments_1 = require("./comments/format-comments");
var base_cst_printer_1 = require("../base-cst-printer");
var LexicalStructurePrettierVisitor = /** @class */ (function (_super) {
    __extends(LexicalStructurePrettierVisitor, _super);
    function LexicalStructurePrettierVisitor() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    LexicalStructurePrettierVisitor.prototype.literal = function (ctx) {
        if (ctx.CharLiteral || ctx.TextBlock || ctx.StringLiteral || ctx.Null) {
            return format_comments_1.printTokenWithComments(this.getSingle(ctx));
        }
        return this.visitSingle(ctx);
    };
    LexicalStructurePrettierVisitor.prototype.integerLiteral = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    LexicalStructurePrettierVisitor.prototype.floatingPointLiteral = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    LexicalStructurePrettierVisitor.prototype.booleanLiteral = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    return LexicalStructurePrettierVisitor;
}(base_cst_printer_1.BaseCstPrettierPrinter));
exports.LexicalStructurePrettierVisitor = LexicalStructurePrettierVisitor;

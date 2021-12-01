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
var __spreadArray = (this && this.__spreadArray) || function (to, from) {
    for (var i = 0, il = from.length, j = to.length; i < il; i++, j++)
        to[j] = from[i];
    return to;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypesValuesAndVariablesPrettierVisitor = void 0;
var forEach_1 = __importDefault(require("lodash/forEach"));
var prettier_builder_1 = require("./prettier-builder");
var format_comments_1 = require("./comments/format-comments");
var printer_utils_1 = require("./printer-utils");
var base_cst_printer_1 = require("../base-cst-printer");
var utils_1 = require("../types/utils");
var TypesValuesAndVariablesPrettierVisitor = /** @class */ (function (_super) {
    __extends(TypesValuesAndVariablesPrettierVisitor, _super);
    function TypesValuesAndVariablesPrettierVisitor() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    TypesValuesAndVariablesPrettierVisitor.prototype.primitiveType = function (ctx) {
        var annotations = this.mapVisit(ctx.annotation);
        var type = ctx.numericType
            ? this.visit(ctx.numericType)
            : this.getSingle(ctx);
        return printer_utils_1.rejectAndJoin(" ", [prettier_builder_1.join(" ", annotations), type]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.numericType = function (ctx) {
        return this.visitSingle(ctx);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.integralType = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.floatingPointType = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.referenceType = function (ctx) {
        var annotations = this.mapVisit(ctx.annotation);
        var type = ctx.primitiveType
            ? this.visit(ctx.primitiveType)
            : this.visit(ctx.classOrInterfaceType);
        var dims = this.visit(ctx.dims);
        return printer_utils_1.rejectAndJoin(" ", [prettier_builder_1.join(" ", annotations), prettier_builder_1.concat([type, dims])]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.classOrInterfaceType = function (ctx) {
        return this.visitSingle(ctx);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.classType = function (ctx) {
        var _this = this;
        var tokens = printer_utils_1.sortClassTypeChildren(ctx.annotation, ctx.typeArguments, ctx.Identifier);
        var segments = [];
        var currentSegment = [];
        forEach_1.default(tokens, function (token, i) {
            if (utils_1.isTypeArgumentsCstNode(token)) {
                currentSegment.push(_this.visit([token]));
                segments.push(printer_utils_1.rejectAndConcat(currentSegment));
                currentSegment = [];
            }
            else if (utils_1.isAnnotationCstNode(token)) {
                currentSegment.push(_this.visit([token]));
            }
            else {
                currentSegment.push(token);
                if ((i + 1 < tokens.length && !utils_1.isTypeArgumentsCstNode(tokens[i + 1])) ||
                    i + 1 === tokens.length) {
                    segments.push(printer_utils_1.rejectAndConcat(currentSegment));
                    currentSegment = [];
                }
            }
        });
        return printer_utils_1.rejectAndJoinSeps(ctx.Dot, segments);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.interfaceType = function (ctx) {
        return this.visitSingle(ctx);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeVariable = function (ctx) {
        var annotations = this.mapVisit(ctx.annotation);
        var identifier = this.getSingle(ctx);
        return printer_utils_1.rejectAndJoin(" ", [prettier_builder_1.join(" ", annotations), identifier]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.dims = function (ctx) {
        var _this = this;
        var tokens = __spreadArray([], ctx.LSquare);
        if (ctx.annotation) {
            tokens = __spreadArray(__spreadArray([], tokens), ctx.annotation);
        }
        tokens = tokens.sort(function (a, b) {
            var startOffset1 = utils_1.isCstNode(a)
                ? a.children.At[0].startOffset
                : a.startOffset;
            var startOffset2 = utils_1.isCstNode(b)
                ? b.children.At[0].startOffset
                : b.startOffset;
            return startOffset1 - startOffset2;
        });
        var segments = [];
        var currentSegment = [];
        forEach_1.default(tokens, function (token) {
            if (utils_1.isCstNode(token)) {
                currentSegment.push(_this.visit([token]));
            }
            else {
                segments.push(printer_utils_1.rejectAndConcat([
                    printer_utils_1.rejectAndJoin(" ", currentSegment),
                    prettier_builder_1.concat([ctx.LSquare[0], ctx.RSquare[0]])
                ]));
                currentSegment = [];
            }
        });
        return printer_utils_1.rejectAndConcat(segments);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeParameter = function (ctx) {
        var typeParameterModifiers = this.mapVisit(ctx.typeParameterModifier);
        var typeIdentifier = this.visit(ctx.typeIdentifier);
        var typeBound = this.visit(ctx.typeBound);
        return printer_utils_1.rejectAndJoin(" ", [
            prettier_builder_1.join(" ", typeParameterModifiers),
            typeIdentifier,
            typeBound
        ]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeParameterModifier = function (ctx) {
        return this.visitSingle(ctx);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeBound = function (ctx) {
        var classOrInterfaceType = this.visit(ctx.classOrInterfaceType);
        var additionalBound = this.mapVisit(ctx.additionalBound);
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.Extends[0],
            classOrInterfaceType,
            prettier_builder_1.join(" ", additionalBound)
        ]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.additionalBound = function (ctx) {
        var interfaceType = this.visit(ctx.interfaceType);
        return prettier_builder_1.join(" ", [ctx.And[0], interfaceType]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeArguments = function (ctx) {
        var typeArgumentList = this.visit(ctx.typeArgumentList);
        return printer_utils_1.rejectAndConcat([ctx.Less[0], typeArgumentList, ctx.Greater[0]]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeArgumentList = function (ctx) {
        var typeArguments = this.mapVisit(ctx.typeArgument);
        var commas = ctx.Comma ? ctx.Comma.map(function (elt) { return prettier_builder_1.concat([elt, " "]); }) : [];
        return printer_utils_1.rejectAndJoinSeps(commas, typeArguments);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.typeArgument = function (ctx) {
        return this.visitSingle(ctx);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.wildcard = function (ctx) {
        var annotations = this.mapVisit(ctx.annotation);
        var wildcardBounds = this.visit(ctx.wildcardBounds);
        return printer_utils_1.rejectAndJoin(" ", [
            prettier_builder_1.join(" ", annotations),
            ctx.QuestionMark[0],
            wildcardBounds
        ]);
    };
    TypesValuesAndVariablesPrettierVisitor.prototype.wildcardBounds = function (ctx) {
        var keyWord = ctx.Extends ? ctx.Extends[0] : ctx.Super[0];
        var referenceType = this.visit(ctx.referenceType);
        return prettier_builder_1.join(" ", [keyWord, referenceType]);
    };
    return TypesValuesAndVariablesPrettierVisitor;
}(base_cst_printer_1.BaseCstPrettierPrinter));
exports.TypesValuesAndVariablesPrettierVisitor = TypesValuesAndVariablesPrettierVisitor;

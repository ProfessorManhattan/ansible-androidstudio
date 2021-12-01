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
exports.PackagesAndModulesPrettierVisitor = void 0;
var prettier_builder_1 = require("./prettier-builder");
var format_comments_1 = require("./comments/format-comments");
var printer_utils_1 = require("./printer-utils");
var doc_1 = require("prettier/doc");
var base_cst_printer_1 = require("../base-cst-printer");
var utils_1 = require("../types/utils");
var line = doc_1.builders.line, hardline = doc_1.builders.hardline, indent = doc_1.builders.indent, group = doc_1.builders.group;
var PackagesAndModulesPrettierVisitor = /** @class */ (function (_super) {
    __extends(PackagesAndModulesPrettierVisitor, _super);
    function PackagesAndModulesPrettierVisitor() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    PackagesAndModulesPrettierVisitor.prototype.compilationUnit = function (ctx) {
        var compilationUnit = utils_1.isOrdinaryCompilationUnitCtx(ctx)
            ? ctx.ordinaryCompilationUnit
            : ctx.modularCompilationUnit;
        return prettier_builder_1.concat([this.visit(compilationUnit[0]), line]);
    };
    PackagesAndModulesPrettierVisitor.prototype.ordinaryCompilationUnit = function (ctx) {
        var packageDecl = this.visit(ctx.packageDeclaration);
        var sortedImportsDecl = printer_utils_1.sortImports(ctx.importDeclaration);
        var nonStaticImports = this.mapVisit(sortedImportsDecl.nonStaticImports);
        var staticImports = this.mapVisit(sortedImportsDecl.staticImports);
        var typesDecl = this.mapVisit(ctx.typeDeclaration);
        // TODO: utility to add item+line (or multiple lines) but only if an item exists
        return printer_utils_1.rejectAndConcat([
            printer_utils_1.rejectAndJoin(prettier_builder_1.concat([hardline, hardline]), [
                packageDecl,
                printer_utils_1.rejectAndJoin(hardline, staticImports),
                printer_utils_1.rejectAndJoin(hardline, nonStaticImports),
                printer_utils_1.rejectAndJoin(prettier_builder_1.concat([hardline, hardline]), typesDecl)
            ])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.modularCompilationUnit = function (ctx) {
        var sortedImportsDecl = printer_utils_1.sortImports(ctx.importDeclaration);
        var nonStaticImports = this.mapVisit(sortedImportsDecl.nonStaticImports);
        var staticImports = this.mapVisit(sortedImportsDecl.staticImports);
        var moduleDeclaration = this.visit(ctx.moduleDeclaration);
        return printer_utils_1.rejectAndConcat([
            printer_utils_1.rejectAndJoin(prettier_builder_1.concat([hardline, hardline]), [
                printer_utils_1.rejectAndJoin(hardline, staticImports),
                printer_utils_1.rejectAndJoin(hardline, nonStaticImports),
                moduleDeclaration
            ])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.packageDeclaration = function (ctx) {
        var modifiers = this.mapVisit(ctx.packageModifier);
        var name = printer_utils_1.buildFqn(ctx.Identifier, ctx.Dot);
        return printer_utils_1.rejectAndJoin(hardline, [
            printer_utils_1.rejectAndJoin(hardline, modifiers),
            prettier_builder_1.concat([ctx.Package[0], " ", name, ctx.Semicolon[0]])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.packageModifier = function (ctx) {
        return this.visitSingle(ctx);
    };
    PackagesAndModulesPrettierVisitor.prototype.importDeclaration = function (ctx) {
        if (ctx.emptyStatement !== undefined) {
            return this.visit(ctx.emptyStatement);
        }
        var optionalStatic = ctx.Static ? ctx.Static[0] : "";
        var packageOrTypeName = this.visit(ctx.packageOrTypeName);
        var optionalDotStar = ctx.Dot ? prettier_builder_1.concat([ctx.Dot[0], ctx.Star[0]]) : "";
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.Import[0],
            optionalStatic,
            printer_utils_1.rejectAndConcat([packageOrTypeName, optionalDotStar, ctx.Semicolon[0]])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.typeDeclaration = function (ctx) {
        if (ctx.Semicolon) {
            return printer_utils_1.displaySemicolon(ctx.Semicolon[0]);
        }
        return this.visitSingle(ctx);
    };
    PackagesAndModulesPrettierVisitor.prototype.moduleDeclaration = function (ctx) {
        var annotations = this.mapVisit(ctx.annotation);
        var optionalOpen = ctx.Open ? ctx.Open[0] : "";
        var name = printer_utils_1.buildFqn(ctx.Identifier, ctx.Dot);
        var moduleDirectives = this.mapVisit(ctx.moduleDirective);
        var content = printer_utils_1.rejectAndJoinSeps(printer_utils_1.getBlankLinesSeparator(ctx.moduleDirective), moduleDirectives);
        return printer_utils_1.rejectAndJoin(" ", [
            prettier_builder_1.join(" ", annotations),
            optionalOpen,
            ctx.Module[0],
            name,
            printer_utils_1.putIntoBraces(content, hardline, ctx.LCurly[0], ctx.RCurly[0])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.moduleDirective = function (ctx) {
        return this.visitSingle(ctx);
    };
    PackagesAndModulesPrettierVisitor.prototype.requiresModuleDirective = function (ctx) {
        var modifiers = this.mapVisit(ctx.requiresModifier);
        var moduleName = this.visit(ctx.moduleName);
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.Requires[0],
            prettier_builder_1.join(" ", modifiers),
            prettier_builder_1.concat([moduleName, ctx.Semicolon[0]])
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.exportsModuleDirective = function (ctx) {
        var packageName = this.visit(ctx.packageName);
        var to = ctx.To ? ctx.To[0] : "";
        var moduleNames = this.mapVisit(ctx.moduleName);
        var commas = ctx.Comma ? ctx.Comma.map(function (elt) { return prettier_builder_1.concat([elt, line]); }) : [];
        return group(printer_utils_1.rejectAndConcat([
            indent(printer_utils_1.rejectAndJoin(line, [
                printer_utils_1.rejectAndJoin(" ", [ctx.Exports[0], packageName]),
                group(indent(printer_utils_1.rejectAndJoin(line, [
                    to,
                    printer_utils_1.rejectAndJoinSeps(commas, moduleNames)
                ])))
            ])),
            ctx.Semicolon[0]
        ]));
    };
    PackagesAndModulesPrettierVisitor.prototype.opensModuleDirective = function (ctx) {
        var packageName = this.visit(ctx.packageName);
        var to = ctx.To ? ctx.To[0] : "";
        var moduleNames = this.mapVisit(ctx.moduleName);
        var commas = ctx.Comma ? ctx.Comma.map(function (elt) { return prettier_builder_1.concat([elt, line]); }) : [];
        return group(printer_utils_1.rejectAndConcat([
            indent(printer_utils_1.rejectAndJoin(line, [
                printer_utils_1.rejectAndJoin(" ", [ctx.Opens[0], packageName]),
                group(indent(printer_utils_1.rejectAndJoin(line, [
                    to,
                    printer_utils_1.rejectAndJoinSeps(commas, moduleNames)
                ])))
            ])),
            ctx.Semicolon[0]
        ]));
    };
    PackagesAndModulesPrettierVisitor.prototype.usesModuleDirective = function (ctx) {
        var typeName = this.visit(ctx.typeName);
        return printer_utils_1.rejectAndConcat([
            prettier_builder_1.concat([ctx.Uses[0], " "]),
            typeName,
            ctx.Semicolon[0]
        ]);
    };
    PackagesAndModulesPrettierVisitor.prototype.providesModuleDirective = function (ctx) {
        var firstTypeName = this.visit(ctx.typeName[0]);
        var otherTypeNames = this.mapVisit(ctx.typeName.slice(1));
        var commas = ctx.Comma ? ctx.Comma.map(function (elt) { return prettier_builder_1.concat([elt, line]); }) : [];
        return group(printer_utils_1.rejectAndConcat([
            indent(printer_utils_1.rejectAndJoin(line, [
                printer_utils_1.rejectAndJoin(" ", [ctx.Provides[0], firstTypeName]),
                group(indent(printer_utils_1.rejectAndJoin(line, [
                    ctx.With[0],
                    printer_utils_1.rejectAndJoinSeps(commas, otherTypeNames)
                ])))
            ])),
            ctx.Semicolon[0]
        ]));
    };
    PackagesAndModulesPrettierVisitor.prototype.requiresModifier = function (ctx) {
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    PackagesAndModulesPrettierVisitor.prototype.isModuleCompilationUnit = function () {
        return "isModuleCompilationUnit";
    };
    return PackagesAndModulesPrettierVisitor;
}(base_cst_printer_1.BaseCstPrettierPrinter));
exports.PackagesAndModulesPrettierVisitor = PackagesAndModulesPrettierVisitor;

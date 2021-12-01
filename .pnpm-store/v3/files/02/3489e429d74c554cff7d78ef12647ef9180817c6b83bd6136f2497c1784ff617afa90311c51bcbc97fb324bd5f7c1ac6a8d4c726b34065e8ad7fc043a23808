"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var doc_1 = require("prettier/doc");
var expressions_utils_1 = require("./expressions-utils");
var format_comments_1 = require("../printers/comments/format-comments");
var prettier_builder_1 = require("../printers/prettier-builder");
var printer_utils_1 = require("../printers/printer-utils");
var softline = doc_1.builders.softline, ifBreak = doc_1.builders.ifBreak;
function printSingleLambdaInvocation(argumentListCtx, rBrace, lBrace) {
    var lambdaParametersGroupId = Symbol("lambdaParameters");
    var argumentList = this.visit(argumentListCtx, {
        lambdaParametersGroupId: lambdaParametersGroupId,
        isInsideMethodInvocationSuffix: true
    });
    var formattedRBrace = expressions_utils_1.isSingleArgumentLambdaExpressionWithBlock(argumentListCtx)
        ? ifBreak(prettier_builder_1.indent(prettier_builder_1.concat([softline, rBrace])), format_comments_1.printTokenWithComments(rBrace), { groupId: lambdaParametersGroupId })
        : prettier_builder_1.indent(prettier_builder_1.concat([softline, rBrace]));
    return prettier_builder_1.dedent(printer_utils_1.putIntoBraces(argumentList, "", lBrace, formattedRBrace));
}
exports.default = printSingleLambdaInvocation;

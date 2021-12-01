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
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __spreadArray = (this && this.__spreadArray) || function (to, from) {
    for (var i = 0, il = from.length, j = to.length; i < il; i++, j++)
        to[j] = from[i];
    return to;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BlocksAndStatementPrettierVisitor = void 0;
var doc_1 = require("prettier/doc");
var prettier_builder_1 = require("./prettier-builder");
var format_comments_1 = require("./comments/format-comments");
var comments_utils_1 = require("./comments/comments-utils");
var printer_utils_1 = require("./printer-utils");
var base_cst_printer_1 = require("../base-cst-printer");
var line = doc_1.builders.line, softline = doc_1.builders.softline, hardline = doc_1.builders.hardline;
var BlocksAndStatementPrettierVisitor = /** @class */ (function (_super) {
    __extends(BlocksAndStatementPrettierVisitor, _super);
    function BlocksAndStatementPrettierVisitor() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    BlocksAndStatementPrettierVisitor.prototype.block = function (ctx) {
        var blockStatements = this.visit(ctx.blockStatements);
        return printer_utils_1.putIntoBraces(blockStatements, hardline, ctx.LCurly[0], ctx.RCurly[0]);
    };
    BlocksAndStatementPrettierVisitor.prototype.blockStatements = function (ctx) {
        var blockStatement = this.mapVisit(ctx.blockStatement);
        var separators = printer_utils_1.rejectSeparators(printer_utils_1.getBlankLinesSeparator(ctx.blockStatement), blockStatement);
        return printer_utils_1.rejectAndJoinSeps(separators, blockStatement);
    };
    BlocksAndStatementPrettierVisitor.prototype.blockStatement = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.localVariableDeclarationStatement = function (ctx) {
        var localVariableDeclaration = this.visit(ctx.localVariableDeclaration);
        return printer_utils_1.rejectAndConcat([localVariableDeclaration, ctx.Semicolon[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.localVariableDeclaration = function (ctx) {
        var modifiers = printer_utils_1.sortModifiers(ctx.variableModifier);
        var firstAnnotations = this.mapVisit(modifiers[0]);
        var finalModifiers = this.mapVisit(modifiers[1]);
        var localVariableType = this.visit(ctx.localVariableType);
        var variableDeclaratorList = this.visit(ctx.variableDeclaratorList);
        return printer_utils_1.rejectAndJoin(hardline, [
            printer_utils_1.rejectAndJoin(hardline, firstAnnotations),
            printer_utils_1.rejectAndJoin(" ", [
                printer_utils_1.rejectAndJoin(" ", finalModifiers),
                localVariableType,
                variableDeclaratorList
            ])
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.localVariableType = function (ctx) {
        if (ctx.unannType) {
            return this.visitSingle(ctx);
        }
        return format_comments_1.printTokenWithComments(this.getSingle(ctx));
    };
    BlocksAndStatementPrettierVisitor.prototype.statement = function (ctx, params) {
        // handling Labeled statements comments
        if (ctx.labeledStatement !== undefined) {
            var newLabelStatement = __assign({}, ctx.labeledStatement[0]);
            var newColon = __assign({}, ctx.labeledStatement[0].children.Colon[0]);
            var newStatement = __assign({}, ctx.labeledStatement[0].children.statement[0]);
            var labeledStatementLeadingComments = [];
            if (newColon.trailingComments !== undefined) {
                labeledStatementLeadingComments.push.apply(labeledStatementLeadingComments, newColon.trailingComments);
                delete newColon.trailingComments;
            }
            if (newStatement.leadingComments !== undefined) {
                labeledStatementLeadingComments.push.apply(labeledStatementLeadingComments, newStatement.leadingComments);
                delete newStatement.leadingComments;
            }
            if (labeledStatementLeadingComments.length !== 0) {
                newLabelStatement.leadingComments = labeledStatementLeadingComments;
            }
            newLabelStatement.children.Colon[0] = newColon;
            newLabelStatement.children.statement[0] = newStatement;
            return this.visit([newLabelStatement]);
        }
        return this.visitSingle(ctx, params);
    };
    BlocksAndStatementPrettierVisitor.prototype.statementWithoutTrailingSubstatement = function (ctx, params) {
        return this.visitSingle(ctx, params);
    };
    BlocksAndStatementPrettierVisitor.prototype.emptyStatement = function (ctx, params) {
        return printer_utils_1.displaySemicolon(ctx.Semicolon[0], params);
    };
    BlocksAndStatementPrettierVisitor.prototype.labeledStatement = function (ctx) {
        var identifier = ctx.Identifier[0];
        var statement = this.visit(ctx.statement);
        return printer_utils_1.rejectAndJoin(ctx.Colon[0], [identifier, statement]);
    };
    BlocksAndStatementPrettierVisitor.prototype.expressionStatement = function (ctx) {
        var statementExpression = this.visit(ctx.statementExpression);
        return printer_utils_1.rejectAndConcat([statementExpression, ctx.Semicolon[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.statementExpression = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.ifStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        var ifStatement = this.visit(ctx.statement[0], {
            allowEmptyStatement: true
        });
        var ifSeparator = printer_utils_1.isStatementEmptyStatement(ifStatement) ? "" : " ";
        var elsePart = "";
        if (ctx.Else !== undefined) {
            var elseStatement = this.visit(ctx.statement[1], {
                allowEmptyStatement: true
            });
            var elseSeparator = printer_utils_1.isStatementEmptyStatement(elseStatement) ? "" : " ";
            var elseOnSameLine = comments_utils_1.hasTrailingLineComments(ctx.statement[0]) ||
                comments_utils_1.hasLeadingLineComments(ctx.Else[0])
                ? hardline
                : " ";
            elsePart = printer_utils_1.rejectAndJoin(elseSeparator, [
                prettier_builder_1.concat([elseOnSameLine, ctx.Else[0]]),
                elseStatement
            ]);
        }
        return printer_utils_1.rejectAndConcat([
            printer_utils_1.rejectAndJoin(" ", [
                ctx.If[0],
                prettier_builder_1.concat([
                    printer_utils_1.putIntoBraces(expression, softline, ctx.LBrace[0], ctx.RBrace[0]),
                    ifSeparator
                ])
            ]),
            ifStatement,
            elsePart
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.assertStatement = function (ctx) {
        var expressions = this.mapVisit(ctx.expression);
        var colon = ctx.Colon ? ctx.Colon[0] : ":";
        return printer_utils_1.rejectAndConcat([
            prettier_builder_1.concat([ctx.Assert[0], " "]),
            printer_utils_1.rejectAndJoin(prettier_builder_1.concat([" ", colon, " "]), expressions),
            ctx.Semicolon[0]
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.switchStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        var switchBlock = this.visit(ctx.switchBlock);
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.Switch[0],
            printer_utils_1.putIntoBraces(expression, softline, ctx.LBrace[0], ctx.RBrace[0]),
            switchBlock
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.switchBlock = function (ctx) {
        var switchCases = ctx.switchBlockStatementGroup !== undefined
            ? this.mapVisit(ctx.switchBlockStatementGroup)
            : this.mapVisit(ctx.switchRule);
        return printer_utils_1.putIntoBraces(printer_utils_1.rejectAndJoin(hardline, switchCases), hardline, ctx.LCurly[0], ctx.RCurly[0]);
    };
    BlocksAndStatementPrettierVisitor.prototype.switchBlockStatementGroup = function (ctx) {
        var switchLabel = this.visit(ctx.switchLabel);
        var blockStatements = this.visit(ctx.blockStatements);
        return prettier_builder_1.concat([
            switchLabel,
            ctx.Colon[0],
            blockStatements && prettier_builder_1.indent([hardline, blockStatements])
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.switchLabel = function (ctx) {
        var caseOrDefaultLabels = this.mapVisit(ctx.caseOrDefaultLabel);
        var colons = ctx.Colon
            ? ctx.Colon.map(function (elt) {
                return prettier_builder_1.concat([elt, hardline]);
            })
            : [];
        return prettier_builder_1.group(printer_utils_1.rejectAndJoinSeps(colons, caseOrDefaultLabels));
    };
    BlocksAndStatementPrettierVisitor.prototype.caseOrDefaultLabel = function (ctx) {
        if (ctx.Case) {
            var caseLabelElements = this.mapVisit(ctx.caseLabelElement);
            var commas = ctx.Comma
                ? ctx.Comma.map(function (elt) {
                    return prettier_builder_1.concat([elt, line]);
                })
                : [];
            return prettier_builder_1.group(prettier_builder_1.indent(printer_utils_1.rejectAndConcat([
                prettier_builder_1.concat([ctx.Case[0], " "]),
                printer_utils_1.rejectAndJoinSeps(commas, caseLabelElements)
            ])));
        }
        return prettier_builder_1.concat([ctx.Default[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.caseLabelElement = function (ctx) {
        if (ctx.Default || ctx.Null) {
            return this.getSingle(ctx);
        }
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.switchRule = function (ctx) {
        var switchLabel = this.visit(ctx.switchLabel);
        var caseInstruction;
        if (ctx.throwStatement !== undefined) {
            caseInstruction = this.visit(ctx.throwStatement);
        }
        else if (ctx.block !== undefined) {
            caseInstruction = this.visit(ctx.block);
        }
        else {
            caseInstruction = prettier_builder_1.concat([this.visit(ctx.expression), ctx.Semicolon[0]]);
        }
        return prettier_builder_1.join(" ", [switchLabel, ctx.Arrow[0], caseInstruction]);
    };
    BlocksAndStatementPrettierVisitor.prototype.caseConstant = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.whileStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        var statement = this.visit(ctx.statement[0], {
            allowEmptyStatement: true
        });
        var statementSeparator = printer_utils_1.isStatementEmptyStatement(statement) ? "" : " ";
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.While[0],
            printer_utils_1.rejectAndJoin(statementSeparator, [
                printer_utils_1.putIntoBraces(expression, softline, ctx.LBrace[0], ctx.RBrace[0]),
                statement
            ])
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.doStatement = function (ctx) {
        var statement = this.visit(ctx.statement[0], {
            allowEmptyStatement: true
        });
        var statementSeparator = printer_utils_1.isStatementEmptyStatement(statement) ? "" : " ";
        var expression = this.visit(ctx.expression);
        return printer_utils_1.rejectAndJoin(" ", [
            printer_utils_1.rejectAndJoin(statementSeparator, [ctx.Do[0], statement]),
            ctx.While[0],
            printer_utils_1.rejectAndConcat([
                printer_utils_1.putIntoBraces(expression, softline, ctx.LBrace[0], ctx.RBrace[0]),
                ctx.Semicolon[0]
            ])
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.forStatement = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.basicForStatement = function (ctx) {
        var forInit = this.visit(ctx.forInit);
        var expression = this.visit(ctx.expression);
        var forUpdate = this.visit(ctx.forUpdate);
        var statement = this.visit(ctx.statement[0], {
            allowEmptyStatement: true
        });
        var statementSeparator = printer_utils_1.isStatementEmptyStatement(statement) ? "" : " ";
        return printer_utils_1.rejectAndConcat([
            printer_utils_1.rejectAndJoin(" ", [
                ctx.For[0],
                printer_utils_1.putIntoBraces(printer_utils_1.rejectAndConcat([
                    forInit,
                    printer_utils_1.rejectAndJoin(line, [ctx.Semicolon[0], expression]),
                    printer_utils_1.rejectAndJoin(line, [ctx.Semicolon[1], forUpdate])
                ]), softline, ctx.LBrace[0], ctx.RBrace[0])
            ]),
            statementSeparator,
            statement
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.forInit = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.forUpdate = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.statementExpressionList = function (ctx) {
        var statementExpressions = this.mapVisit(ctx.statementExpression);
        var commas = ctx.Comma
            ? ctx.Comma.map(function (elt) {
                return prettier_builder_1.concat([format_comments_1.printTokenWithComments(elt), " "]);
            })
            : [];
        return printer_utils_1.rejectAndJoinSeps(commas, statementExpressions);
    };
    BlocksAndStatementPrettierVisitor.prototype.enhancedForStatement = function (ctx) {
        var variableModifiers = this.mapVisit(ctx.variableModifier);
        var localVariableType = this.visit(ctx.localVariableType);
        var variableDeclaratorId = this.visit(ctx.variableDeclaratorId);
        var expression = this.visit(ctx.expression);
        var statement = this.visit(ctx.statement[0], {
            allowEmptyStatement: true
        });
        var statementSeparator = printer_utils_1.isStatementEmptyStatement(statement) ? "" : " ";
        return printer_utils_1.rejectAndConcat([
            printer_utils_1.rejectAndJoin(" ", [ctx.For[0], ctx.LBrace[0]]),
            printer_utils_1.rejectAndJoin(" ", [
                printer_utils_1.rejectAndJoin(" ", variableModifiers),
                localVariableType,
                variableDeclaratorId
            ]),
            prettier_builder_1.concat([" ", ctx.Colon[0], " "]),
            expression,
            prettier_builder_1.concat([ctx.RBrace[0], statementSeparator]),
            statement
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.breakStatement = function (ctx) {
        if (ctx.Identifier) {
            var identifier = ctx.Identifier[0];
            return printer_utils_1.rejectAndConcat([
                prettier_builder_1.concat([ctx.Break[0], " "]),
                identifier,
                ctx.Semicolon[0]
            ]);
        }
        return prettier_builder_1.concat([ctx.Break[0], ctx.Semicolon[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.continueStatement = function (ctx) {
        if (ctx.Identifier) {
            var identifier = ctx.Identifier[0];
            return printer_utils_1.rejectAndConcat([
                prettier_builder_1.concat([ctx.Continue[0], " "]),
                identifier,
                ctx.Semicolon[0]
            ]);
        }
        return printer_utils_1.rejectAndConcat([ctx.Continue[0], ctx.Semicolon[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.returnStatement = function (ctx) {
        if (ctx.expression) {
            var expression = this.visit(ctx.expression, {
                addParenthesisToWrapStatement: true
            });
            return printer_utils_1.rejectAndConcat([
                prettier_builder_1.concat([ctx.Return[0], " "]),
                expression,
                ctx.Semicolon[0]
            ]);
        }
        return printer_utils_1.rejectAndConcat([ctx.Return[0], ctx.Semicolon[0]]);
    };
    BlocksAndStatementPrettierVisitor.prototype.throwStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        return printer_utils_1.rejectAndConcat([
            prettier_builder_1.concat([ctx.Throw[0], " "]),
            expression,
            ctx.Semicolon[0]
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.synchronizedStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        var block = this.visit(ctx.block);
        return printer_utils_1.rejectAndConcat([
            prettier_builder_1.join(" ", [
                ctx.Synchronized[0],
                prettier_builder_1.concat([
                    printer_utils_1.putIntoBraces(expression, softline, ctx.LBrace[0], ctx.RBrace[0]),
                    " "
                ])
            ]),
            block
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.tryStatement = function (ctx) {
        if (ctx.tryWithResourcesStatement) {
            return this.visit(ctx.tryWithResourcesStatement);
        }
        var block = this.visit(ctx.block);
        var catches = this.visit(ctx.catches);
        var finallyBlock = this.visit(ctx.finally);
        return printer_utils_1.rejectAndJoin(" ", [ctx.Try[0], block, catches, finallyBlock]);
    };
    BlocksAndStatementPrettierVisitor.prototype.catches = function (ctx) {
        var catchClauses = this.mapVisit(ctx.catchClause);
        return printer_utils_1.rejectAndJoin(" ", catchClauses);
    };
    BlocksAndStatementPrettierVisitor.prototype.catchClause = function (ctx) {
        var catchFormalParameter = this.visit(ctx.catchFormalParameter);
        var block = this.visit(ctx.block);
        return printer_utils_1.rejectAndConcat([
            prettier_builder_1.group(printer_utils_1.rejectAndConcat([
                printer_utils_1.rejectAndJoin(" ", [ctx.Catch[0], ctx.LBrace[0]]),
                prettier_builder_1.indent(printer_utils_1.rejectAndConcat([softline, catchFormalParameter])),
                softline,
                prettier_builder_1.concat([ctx.RBrace[0], " "])
            ])),
            block
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.catchFormalParameter = function (ctx) {
        var variableModifiers = this.mapVisit(ctx.variableModifier);
        var catchType = this.visit(ctx.catchType);
        var variableDeclaratorId = this.visit(ctx.variableDeclaratorId);
        return printer_utils_1.rejectAndJoin(" ", [
            printer_utils_1.rejectAndJoin(" ", variableModifiers),
            catchType,
            variableDeclaratorId
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.catchType = function (ctx) {
        var unannClassType = this.visit(ctx.unannClassType);
        var classTypes = this.mapVisit(ctx.classType);
        var ors = ctx.Or ? ctx.Or.map(function (elt) { return prettier_builder_1.concat([line, elt, " "]); }) : [];
        return prettier_builder_1.group(printer_utils_1.rejectAndJoinSeps(ors, __spreadArray([unannClassType], classTypes)));
    };
    BlocksAndStatementPrettierVisitor.prototype.finally = function (ctx) {
        var block = this.visit(ctx.block);
        return printer_utils_1.rejectAndJoin(" ", [ctx.Finally[0], block]);
    };
    BlocksAndStatementPrettierVisitor.prototype.tryWithResourcesStatement = function (ctx) {
        var resourceSpecification = this.visit(ctx.resourceSpecification);
        var block = this.visit(ctx.block);
        var catches = this.visit(ctx.catches);
        var finallyBlock = this.visit(ctx.finally);
        return printer_utils_1.rejectAndJoin(" ", [
            ctx.Try[0],
            resourceSpecification,
            block,
            catches,
            finallyBlock
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.resourceSpecification = function (ctx) {
        var resourceList = this.visit(ctx.resourceList);
        var optionalSemicolon = ctx.Semicolon ? ctx.Semicolon[0] : "";
        return printer_utils_1.putIntoBraces(printer_utils_1.rejectAndConcat([resourceList, optionalSemicolon]), softline, ctx.LBrace[0], ctx.RBrace[0]);
    };
    BlocksAndStatementPrettierVisitor.prototype.resourceList = function (ctx) {
        var resources = this.mapVisit(ctx.resource);
        var semicolons = ctx.Semicolon
            ? ctx.Semicolon.map(function (elt) {
                return prettier_builder_1.concat([elt, line]);
            })
            : [""];
        return printer_utils_1.rejectAndJoinSeps(semicolons, resources);
    };
    BlocksAndStatementPrettierVisitor.prototype.resource = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.resourceInit = function (ctx) {
        var variableModifiers = this.mapVisit(ctx.variableModifier);
        var localVariableType = this.visit(ctx.localVariableType);
        var identifier = ctx.Identifier[0];
        var expression = this.visit(ctx.expression);
        return printer_utils_1.rejectAndJoin(" ", [
            printer_utils_1.rejectAndJoin(" ", variableModifiers),
            localVariableType,
            identifier,
            ctx.Equals[0],
            expression
        ]);
    };
    BlocksAndStatementPrettierVisitor.prototype.yieldStatement = function (ctx) {
        var expression = this.visit(ctx.expression);
        return prettier_builder_1.join(" ", [ctx.Yield[0], prettier_builder_1.concat([expression, ctx.Semicolon[0]])]);
    };
    BlocksAndStatementPrettierVisitor.prototype.variableAccess = function (ctx) {
        return this.visitSingle(ctx);
    };
    BlocksAndStatementPrettierVisitor.prototype.isBasicForStatement = function () {
        return "isBasicForStatement";
    };
    BlocksAndStatementPrettierVisitor.prototype.isLocalVariableDeclaration = function () {
        return "isLocalVariableDeclaration";
    };
    BlocksAndStatementPrettierVisitor.prototype.isClassicSwitchLabel = function () {
        return "isClassicSwitchLabel";
    };
    return BlocksAndStatementPrettierVisitor;
}(base_cst_printer_1.BaseCstPrettierPrinter));
exports.BlocksAndStatementPrettierVisitor = BlocksAndStatementPrettierVisitor;

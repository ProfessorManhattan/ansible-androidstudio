"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.handleCommentsBinaryExpression = void 0;
var comments_utils_1 = require("./comments-utils");
function handleCommentsBinaryExpression(ctx) {
    var unaryExpressionIndex = 1;
    if (ctx.BinaryOperator !== undefined) {
        ctx.BinaryOperator.forEach(function (binaryOperator) {
            var _a;
            if (comments_utils_1.hasLeadingComments(binaryOperator)) {
                while (ctx.unaryExpression[unaryExpressionIndex].location.startOffset <
                    binaryOperator.endOffset) {
                    unaryExpressionIndex++;
                }
                // Adapt the position of the operator and its leading comments
                var shiftUp = binaryOperator.leadingComments[0].startLine -
                    1 -
                    binaryOperator.startLine;
                if (binaryOperator.startLine !==
                    ctx.unaryExpression[unaryExpressionIndex].location.startLine) {
                    binaryOperator.leadingComments.forEach(function (comment) {
                        comment.startLine += 1;
                        comment.endLine += 1;
                    });
                }
                binaryOperator.startLine += shiftUp;
                binaryOperator.endLine += shiftUp;
                // Assign the leading comments & trailing comments of the binaryOperator
                // to the following unaryExpression as leading comments
                ctx.unaryExpression[unaryExpressionIndex].leadingComments =
                    ctx.unaryExpression[unaryExpressionIndex].leadingComments || [];
                (_a = ctx.unaryExpression[unaryExpressionIndex].leadingComments).unshift.apply(_a, binaryOperator.leadingComments);
                delete binaryOperator.leadingComments;
            }
        });
    }
}
exports.handleCommentsBinaryExpression = handleCommentsBinaryExpression;

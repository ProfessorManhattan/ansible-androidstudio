"use strict";
const nodes_1 = require("../utils/nodes");
const docs_url_1 = require("../utils/docs-url");
const rule = {
    meta: {
        type: 'suggestion',
        docs: {
            description: 'Return of boolean expressions should not be wrapped into an "if-then-else" statement',
            category: 'Best Practices',
            recommended: 'error',
            url: docs_url_1.default(__filename),
        },
    },
    create(context) {
        return {
            IfStatement(node) {
                const ifStmt = node;
                if (
                // ignore `else if`
                !nodes_1.isIfStatement(ifStmt.parent) &&
                    // `ifStmt.alternate` can be `null`, replace it with `undefined` in this case
                    returnsBoolean(ifStmt.alternate || undefined) &&
                    returnsBoolean(ifStmt.consequent)) {
                    context.report({
                        message: 'Replace this if-then-else statement by a single return statement.',
                        node: ifStmt,
                    });
                }
            },
        };
        function returnsBoolean(statement) {
            return (statement !== undefined &&
                (isBlockReturningBooleanLiteral(statement) || isSimpleReturnBooleanLiteral(statement)));
        }
        function isBlockReturningBooleanLiteral(statement) {
            return (nodes_1.isBlockStatement(statement) &&
                statement.body.length === 1 &&
                isSimpleReturnBooleanLiteral(statement.body[0]));
        }
        function isSimpleReturnBooleanLiteral(statement) {
            // `statement.argument` can be `null`, replace it with `undefined` in this case
            return nodes_1.isReturnStatement(statement) && nodes_1.isBooleanLiteral(statement.argument || undefined);
        }
    },
};
module.exports = rule;
//# sourceMappingURL=prefer-single-boolean-return.js.map
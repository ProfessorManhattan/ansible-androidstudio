"use strict";
/*
 * eslint-plugin-sonarjs
 * Copyright (C) 2018-2021 SonarSource SA
 * mailto:info AT sonarsource DOT com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
// https://sonarsource.github.io/rspec/#/rspec/S1125
const nodes_1 = require("../utils/nodes");
const docs_url_1 = require("../utils/docs-url");
const MESSAGE = 'Remove the unnecessary boolean literal.';
const rule = {
    meta: {
        type: 'suggestion',
        docs: {
            description: 'Boolean literals should not be redundant',
            category: 'Best Practices',
            recommended: 'error',
            url: docs_url_1.default(__filename),
        },
    },
    create(context) {
        return {
            BinaryExpression(node) {
                const expression = node;
                if (expression.operator === '==' || expression.operator === '!=') {
                    checkBooleanLiteral(expression.left);
                    checkBooleanLiteral(expression.right);
                }
            },
            LogicalExpression(node) {
                const expression = node;
                checkBooleanLiteral(expression.left);
                if (expression.operator === '&&') {
                    checkBooleanLiteral(expression.right);
                }
                // ignore `x || true` and `x || false` expressions outside of conditional expressions and `if` statements
                const { parent } = node;
                if (expression.operator === '||' &&
                    ((nodes_1.isConditionalExpression(parent) && parent.test === expression) || nodes_1.isIfStatement(parent))) {
                    checkBooleanLiteral(expression.right);
                }
            },
            UnaryExpression(node) {
                const unaryExpression = node;
                if (unaryExpression.operator === '!') {
                    checkBooleanLiteral(unaryExpression.argument);
                }
            },
        };
        function checkBooleanLiteral(expression) {
            if (nodes_1.isBooleanLiteral(expression)) {
                context.report({ message: MESSAGE, node: expression });
            }
        }
    },
};
module.exports = rule;
//# sourceMappingURL=no-redundant-boolean.js.map
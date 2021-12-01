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
// https://sonarsource.github.io/rspec/#/rspec/S1066
const nodes_1 = require("../utils/nodes");
const locations_1 = require("../utils/locations");
const docs_url_1 = require("../utils/docs-url");
const rule = {
    meta: {
        type: 'suggestion',
        docs: {
            description: 'Collapsible "if" statements should be merged',
            category: 'Best Practices',
            recommended: 'error',
            url: docs_url_1.default(__filename),
        },
        schema: [
            {
                // internal parameter
                enum: ['sonar-runtime'],
            },
        ],
    },
    create(context) {
        return {
            IfStatement(node) {
                let { consequent } = node;
                if (nodes_1.isBlockStatement(consequent) && consequent.body.length === 1) {
                    consequent = consequent.body[0];
                }
                if (isIfStatementWithoutElse(node) && isIfStatementWithoutElse(consequent)) {
                    const ifKeyword = context.getSourceCode().getFirstToken(consequent);
                    const enclosingIfKeyword = context.getSourceCode().getFirstToken(node);
                    if (ifKeyword && enclosingIfKeyword) {
                        locations_1.report(context, {
                            message: `Merge this if statement with the nested one.`,
                            loc: enclosingIfKeyword.loc,
                        }, [locations_1.issueLocation(ifKeyword.loc, ifKeyword.loc, `Nested "if" statement.`)]);
                    }
                }
            },
        };
        function isIfStatementWithoutElse(node) {
            return nodes_1.isIfStatement(node) && !node.alternate;
        }
    },
};
module.exports = rule;
//# sourceMappingURL=no-collapsible-if.js.map
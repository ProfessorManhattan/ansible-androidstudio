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
// https://sonarsource.github.io/rspec/#/rspec/S1871
const nodes_1 = require("../utils/nodes");
const equivalence_1 = require("../utils/equivalence");
const conditions_1 = require("../utils/conditions");
const locations_1 = require("../utils/locations");
const docs_url_1 = require("../utils/docs-url");
const MESSAGE = "This {{type}}'s code block is the same as the block for the {{type}} on line {{line}}.";
const rule = {
    meta: {
        type: 'problem',
        docs: {
            description: 'Two branches in a conditional structure should not have exactly the same implementation',
            category: 'Possible Errors',
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
                visitIfStatement(node);
            },
            SwitchStatement(node) {
                visitSwitchStatement(node);
            },
        };
        function visitIfStatement(ifStmt) {
            if (nodes_1.isIfStatement(ifStmt.parent)) {
                return;
            }
            const { branches, endsWithElse } = conditions_1.collectIfBranches(ifStmt);
            if (allEquivalentWithoutDefault(branches, endsWithElse)) {
                branches.slice(1).forEach((branch, i) => reportIssue(branch, branches[i], 'branch'));
                return;
            }
            for (let i = 1; i < branches.length; i++) {
                if (hasRequiredSize([branches[i]])) {
                    for (let j = 0; j < i; j++) {
                        if (compareIfBranches(branches[i], branches[j])) {
                            break;
                        }
                    }
                }
            }
        }
        function visitSwitchStatement(switchStmt) {
            const { cases } = switchStmt;
            const { endsWithDefault } = conditions_1.collectSwitchBranches(switchStmt);
            const nonEmptyCases = cases.filter(c => conditions_1.takeWithoutBreak(expandSingleBlockStatement(c.consequent)).length > 0);
            const casesWithoutBreak = nonEmptyCases.map(c => conditions_1.takeWithoutBreak(expandSingleBlockStatement(c.consequent)));
            if (allEquivalentWithoutDefault(casesWithoutBreak, endsWithDefault)) {
                nonEmptyCases
                    .slice(1)
                    .forEach((caseStmt, i) => reportIssue(caseStmt, nonEmptyCases[i], 'case'));
                return;
            }
            for (let i = 1; i < cases.length; i++) {
                const firstClauseWithoutBreak = conditions_1.takeWithoutBreak(expandSingleBlockStatement(cases[i].consequent));
                if (hasRequiredSize(firstClauseWithoutBreak)) {
                    for (let j = 0; j < i; j++) {
                        const secondClauseWithoutBreak = conditions_1.takeWithoutBreak(expandSingleBlockStatement(cases[j].consequent));
                        if (equivalence_1.areEquivalent(firstClauseWithoutBreak, secondClauseWithoutBreak, context.getSourceCode())) {
                            reportIssue(cases[i], cases[j], 'case');
                            break;
                        }
                    }
                }
            }
        }
        function hasRequiredSize(nodes) {
            if (nodes.length > 0) {
                const tokens = [
                    ...context.getSourceCode().getTokens(nodes[0]),
                    ...context.getSourceCode().getTokens(nodes[nodes.length - 1]),
                ].filter(token => token.value !== '{' && token.value !== '}');
                return (tokens.length > 0 && tokens[tokens.length - 1].loc.end.line > tokens[0].loc.start.line);
            }
            return false;
        }
        function compareIfBranches(a, b) {
            const equivalent = equivalence_1.areEquivalent(a, b, context.getSourceCode());
            if (equivalent && b.loc) {
                reportIssue(a, b, 'branch');
            }
            return equivalent;
        }
        function expandSingleBlockStatement(nodes) {
            if (nodes.length === 1) {
                const node = nodes[0];
                if (nodes_1.isBlockStatement(node)) {
                    return node.body;
                }
            }
            return nodes;
        }
        function allEquivalentWithoutDefault(branches, endsWithDefault) {
            return (!endsWithDefault &&
                branches.length > 1 &&
                branches
                    .slice(1)
                    .every((branch, index) => equivalence_1.areEquivalent(branch, branches[index], context.getSourceCode())));
        }
        function reportIssue(node, equivalentNode, type) {
            const equivalentNodeLoc = equivalentNode.loc;
            locations_1.report(context, { message: MESSAGE, data: { type, line: String(equivalentNode.loc.start.line) }, node }, [locations_1.issueLocation(equivalentNodeLoc, equivalentNodeLoc, 'Original')]);
        }
    },
};
module.exports = rule;
//# sourceMappingURL=no-duplicated-branches.js.map
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.getFirstToken = exports.getFirstTokenAfter = exports.toSecondaryLocation = exports.toEncodedMessage = exports.issueLocation = exports.report = exports.getMainFunctionTokenLocation = void 0;
/**
 * Returns a location of the "main" function token:
 * - function name for a function declaration, method or accessor
 * - "function" keyword for a function expression
 * - "=>" for an arrow function
 */
function getMainFunctionTokenLocation(fn, parent, context) {
    let location;
    if (fn.type === 'FunctionDeclaration') {
        // `fn.id` can be null when it is `export default function` (despite of the @types/TSESTree definition)
        if (fn.id) {
            location = fn.id.loc;
        }
        else {
            const token = getTokenByValue(fn, 'function', context);
            location = token && token.loc;
        }
    }
    else if (fn.type === 'FunctionExpression') {
        if (parent && (parent.type === 'MethodDefinition' || parent.type === 'Property')) {
            location = parent.key.loc;
        }
        else {
            const token = getTokenByValue(fn, 'function', context);
            location = token && token.loc;
        }
    }
    else if (fn.type === 'ArrowFunctionExpression') {
        const token = context
            .getSourceCode()
            .getTokensBefore(fn.body)
            .reverse()
            .find(token => token.value === '=>');
        location = token && token.loc;
    }
    return location;
}
exports.getMainFunctionTokenLocation = getMainFunctionTokenLocation;
/**
 * Wrapper for `context.report`, supporting secondary locations and cost.
 * Encode those extra information in the issue message when rule is executed
 * in Sonar* environment.
 */
function report(context, reportDescriptor, secondaryLocations = [], cost) {
    const { message } = reportDescriptor;
    if (context.options[context.options.length - 1] === 'sonar-runtime') {
        const encodedMessage = { secondaryLocations, message: message, cost };
        reportDescriptor.message = JSON.stringify(encodedMessage);
    }
    context.report(reportDescriptor);
}
exports.report = report;
/**
 * Converts `SourceLocation` range into `IssueLocation`
 */
function issueLocation(startLoc, endLoc = startLoc, message = '') {
    return {
        line: startLoc.start.line,
        column: startLoc.start.column,
        endLine: endLoc.end.line,
        endColumn: endLoc.end.column,
        message,
    };
}
exports.issueLocation = issueLocation;
function toEncodedMessage(message, secondaryLocationsHolder, secondaryMessages, cost) {
    const encodedMessage = {
        message,
        cost,
        secondaryLocations: secondaryLocationsHolder.map((locationHolder, index) => toSecondaryLocation(locationHolder, secondaryMessages ? secondaryMessages[index] : undefined)),
    };
    return JSON.stringify(encodedMessage);
}
exports.toEncodedMessage = toEncodedMessage;
function toSecondaryLocation(locationHolder, message) {
    const { loc } = locationHolder;
    return {
        message,
        column: loc.start.column,
        line: loc.start.line,
        endColumn: loc.end.column,
        endLine: loc.end.line,
    };
}
exports.toSecondaryLocation = toSecondaryLocation;
function getTokenByValue(node, value, context) {
    return context
        .getSourceCode()
        .getTokens(node)
        .find(token => token.value === value);
}
function getFirstTokenAfter(node, context) {
    return context.getSourceCode().getTokenAfter(node);
}
exports.getFirstTokenAfter = getFirstTokenAfter;
function getFirstToken(node, context) {
    return context.getSourceCode().getTokens(node)[0];
}
exports.getFirstToken = getFirstToken;
//# sourceMappingURL=locations.js.map
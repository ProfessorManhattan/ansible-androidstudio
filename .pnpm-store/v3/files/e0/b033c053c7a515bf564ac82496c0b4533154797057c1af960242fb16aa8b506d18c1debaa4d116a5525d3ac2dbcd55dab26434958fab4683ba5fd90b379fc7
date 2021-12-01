import type { TSESTree, TSESLint } from '@typescript-eslint/experimental-utils';
import { Rule } from './types';
export interface IssueLocation {
    column: number;
    line: number;
    endColumn: number;
    endLine: number;
    message?: string;
}
export interface EncodedMessage {
    message: string;
    cost?: number;
    secondaryLocations: IssueLocation[];
}
/**
 * Returns a location of the "main" function token:
 * - function name for a function declaration, method or accessor
 * - "function" keyword for a function expression
 * - "=>" for an arrow function
 */
export declare function getMainFunctionTokenLocation(fn: TSESTree.FunctionLike, parent: TSESTree.Node | undefined, context: Rule.RuleContext): TSESTree.SourceLocation;
/**
 * Wrapper for `context.report`, supporting secondary locations and cost.
 * Encode those extra information in the issue message when rule is executed
 * in Sonar* environment.
 */
export declare function report(context: Rule.RuleContext, reportDescriptor: Rule.ReportDescriptor, secondaryLocations?: IssueLocation[], cost?: number): void;
/**
 * Converts `SourceLocation` range into `IssueLocation`
 */
export declare function issueLocation(startLoc: TSESTree.SourceLocation, endLoc?: TSESTree.SourceLocation, message?: string): IssueLocation;
export declare function toEncodedMessage(message: string, secondaryLocationsHolder: Array<TSESLint.AST.Token | TSESTree.Node>, secondaryMessages?: string[], cost?: number): string;
export declare function toSecondaryLocation(locationHolder: TSESLint.AST.Token | TSESTree.Node, message?: string): IssueLocation;
export declare function getFirstTokenAfter(node: TSESTree.Node, context: Rule.RuleContext): TSESLint.AST.Token | null;
export declare function getFirstToken(node: TSESTree.Node, context: Rule.RuleContext): TSESLint.AST.Token;

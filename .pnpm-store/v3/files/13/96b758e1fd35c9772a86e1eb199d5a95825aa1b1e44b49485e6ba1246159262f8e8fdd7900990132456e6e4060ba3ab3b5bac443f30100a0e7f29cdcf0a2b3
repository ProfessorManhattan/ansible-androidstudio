import type { TSESLint, TSESTree } from '@typescript-eslint/experimental-utils';
declare type Optional<T, K extends keyof T> = Pick<Partial<T>, K> & Omit<T, K>;
export declare namespace Rule {
    export type ReportDescriptor<TMessageIds extends string = string> = Partial<TSESLint.ReportDescriptor<TMessageIds>> & {
        message?: string;
    };
    export type RuleContext<TMessageIds extends string = string, TOptions extends readonly unknown[] = unknown[]> = Omit<TSESLint.RuleContext<TMessageIds, TOptions>, 'report'> & {
        report(descriptor: ReportDescriptor<TMessageIds>): void;
    };
    export interface RuleModule<TMessageIds extends string = never, TOptions extends readonly unknown[] = unknown[]> {
        meta: Optional<TSESLint.RuleMetaData<TMessageIds>, 'messages' | 'schema'>;
        create(context: Readonly<RuleContext<TMessageIds, TOptions>>): RuleListener;
    }
    interface RuleListener {
        onCodePathStart?(codePath: CodePath, node: TSESTree.Node): void;
        onCodePathEnd?(codePath: CodePath, node: TSESTree.Node): void;
        onCodePathSegmentStart?(segment: CodePathSegment, node: TSESTree.Node): void;
        onCodePathSegmentEnd?(segment: CodePathSegment, node: TSESTree.Node): void;
        onCodePathSegmentLoop?(fromSegment: CodePathSegment, toSegment: CodePathSegment, node: TSESTree.Node): void;
        [key: string]: ((codePath: CodePath, node: TSESTree.Node) => void) | ((segment: CodePathSegment, node: TSESTree.Node) => void) | ((fromSegment: CodePathSegment, toSegment: CodePathSegment, node: TSESTree.Node) => void) | ((node: TSESTree.Node) => void) | undefined;
    }
    export interface CodePath {
        id: string;
        initialSegment: CodePathSegment;
        finalSegments: CodePathSegment[];
        returnedSegments: CodePathSegment[];
        thrownSegments: CodePathSegment[];
        currentSegments: CodePathSegment[];
        upper: CodePath | null;
        childCodePaths: CodePath[];
    }
    export interface CodePathSegment {
        id: string;
        nextSegments: CodePathSegment[];
        prevSegments: CodePathSegment[];
        reachable: boolean;
    }
    export {};
}
export declare type Identifier = TSESTree.Identifier | TSESTree.JSXIdentifier;
export {};

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_1 = require("../utils/regexp-ast");
const refa_1 = require("refa");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const regexpp_1 = require("regexpp");
const get_usage_of_pattern_1 = require("../utils/get-usage-of-pattern");
const reorder_alternatives_1 = require("../utils/reorder-alternatives");
const mention_1 = require("../utils/mention");
function isStared(node) {
    let max = (0, regexp_ast_analysis_1.getEffectiveMaximumRepetition)(node);
    if (node.type === "Quantifier") {
        max *= node.max;
    }
    return max > 10;
}
function hasNothingAfterNode(node) {
    const md = (0, regexp_ast_analysis_1.getMatchingDirection)(node);
    for (let p = node;; p = p.parent) {
        if (p.type === "Assertion" || p.type === "Pattern") {
            return true;
        }
        if (p.type !== "Alternative") {
            const parent = p.parent;
            if (parent.type === "Quantifier") {
                if (parent.max > 1) {
                    return false;
                }
            }
            else {
                const lastIndex = md === "ltr" ? parent.elements.length - 1 : 0;
                if (parent.elements[lastIndex] !== p) {
                    return false;
                }
            }
        }
    }
}
function containsAssertions(expression) {
    try {
        (0, refa_1.visitAst)(expression, {
            onAssertionEnter() {
                throw new Error();
            },
        });
        return false;
    }
    catch (error) {
        return true;
    }
}
function containsAssertionsOrUnknowns(expression) {
    try {
        (0, refa_1.visitAst)(expression, {
            onAssertionEnter() {
                throw new Error();
            },
            onUnknownEnter() {
                throw new Error();
            },
        });
        return false;
    }
    catch (error) {
        return true;
    }
}
const creationOption = {
    ignoreAmbiguity: true,
    ignoreOrder: true,
};
const assertionTransformer = (0, refa_1.combineTransformers)([
    refa_1.Transformers.applyAssertions(creationOption),
    refa_1.Transformers.removeUnnecessaryAssertions(creationOption),
    refa_1.Transformers.inline(creationOption),
    refa_1.Transformers.removeDeadBranches(creationOption),
]);
function toNFA(parser, element) {
    try {
        const { expression, maxCharacter } = parser.parseElement(element, {
            backreferences: "unknown",
            assertions: "parse",
        });
        let e;
        if (containsAssertions(expression)) {
            e = (0, refa_1.transform)(assertionTransformer, expression);
        }
        else {
            e = expression;
        }
        return {
            nfa: refa_1.NFA.fromRegex(e, { maxCharacter }, { assertions: "disable", unknowns: "disable" }),
            partial: containsAssertionsOrUnknowns(e),
        };
    }
    catch (error) {
        return {
            nfa: refa_1.NFA.empty({
                maxCharacter: parser.ast.flags.unicode ? 0x10ffff : 0xffff,
            }),
            partial: true,
        };
    }
}
function unionAll(nfas) {
    if (nfas.length === 0) {
        throw new Error("Cannot union 0 NFAs.");
    }
    else if (nfas.length === 1) {
        return nfas[0];
    }
    const total = nfas[0].copy();
    for (let i = 1; i < nfas.length; i++) {
        total.union(nfas[i]);
    }
    return total;
}
const DFA_OPTIONS = { maxNodes: 100000 };
function isSubsetOf(superset, subset) {
    try {
        const a = refa_1.DFA.fromIntersection(superset, subset, DFA_OPTIONS);
        const b = refa_1.DFA.fromFA(subset, DFA_OPTIONS);
        a.minimize();
        b.minimize();
        return a.structurallyEqual(b);
    }
    catch (error) {
        return null;
    }
}
function getSubsetRelation(left, right) {
    try {
        const inter = refa_1.DFA.fromIntersection(left, right, DFA_OPTIONS);
        inter.minimize();
        const l = refa_1.DFA.fromFA(left, DFA_OPTIONS);
        l.minimize();
        const r = refa_1.DFA.fromFA(right, DFA_OPTIONS);
        r.minimize();
        const subset = l.structurallyEqual(inter);
        const superset = r.structurallyEqual(inter);
        if (subset && superset) {
            return 1;
        }
        else if (subset) {
            return 2;
        }
        else if (superset) {
            return 3;
        }
        return 0;
    }
    catch (error) {
        return 4;
    }
}
function getPartialSubsetRelation(left, leftIsPartial, right, rightIsPartial) {
    const relation = getSubsetRelation(left, right);
    if (!leftIsPartial && !rightIsPartial) {
        return relation;
    }
    if (relation === 0 ||
        relation === 4) {
        return relation;
    }
    if (leftIsPartial && !rightIsPartial) {
        switch (relation) {
            case 1:
                return 3;
            case 2:
                return 0;
            case 3:
                return 3;
            default:
                throw new Error(relation);
        }
    }
    if (rightIsPartial && !leftIsPartial) {
        switch (relation) {
            case 1:
                return 2;
            case 2:
                return 2;
            case 3:
                return 0;
            default:
                throw new Error(relation);
        }
    }
    return 0;
}
function faToSource(fa, flags) {
    try {
        return refa_1.JS.toLiteral(fa.toRegex(), { flags }).source;
    }
    catch (error) {
        return "<ERROR>";
    }
}
function* findDuplicationAstFast(alternatives, flags) {
    const shortCircuit = (a) => {
        return a.type === "CapturingGroup" ? false : null;
    };
    for (let i = 0; i < alternatives.length; i++) {
        const alternative = alternatives[i];
        for (let j = 0; j < i; j++) {
            const other = alternatives[j];
            if ((0, regexp_ast_1.isEqualNodes)(other, alternative, flags, shortCircuit)) {
                yield { type: "Duplicate", alternative, others: [other] };
            }
        }
    }
}
function* findDuplicationAst(alternatives, flags, hasNothingAfter) {
    const isCoveredOptions = {
        flags,
        canOmitRight: hasNothingAfter,
    };
    const isCoveredOptionsNoPrefix = {
        flags,
        canOmitRight: false,
    };
    for (let i = 0; i < alternatives.length; i++) {
        const alternative = alternatives[i];
        for (let j = 0; j < i; j++) {
            const other = alternatives[j];
            if ((0, regexp_ast_1.isCoveredNode)(other, alternative, isCoveredOptions)) {
                if ((0, regexp_ast_1.isEqualNodes)(other, alternative, flags)) {
                    yield {
                        type: "Duplicate",
                        alternative,
                        others: [other],
                    };
                }
                else if (hasNothingAfter &&
                    !(0, regexp_ast_1.isCoveredNode)(other, alternative, isCoveredOptionsNoPrefix)) {
                    yield {
                        type: "PrefixSubset",
                        alternative,
                        others: [other],
                    };
                }
                else {
                    yield { type: "Subset", alternative, others: [other] };
                }
            }
        }
    }
}
function* findPrefixDuplicationNfa(alternatives) {
    if (alternatives.length === 0) {
        return;
    }
    const all = refa_1.NFA.all({ maxCharacter: alternatives[0][0].maxCharacter });
    for (let i = 0; i < alternatives.length; i++) {
        const [nfa, partial, alternative] = alternatives[i];
        if (!partial) {
            const overlapping = alternatives
                .slice(0, i)
                .filter(([otherNfa]) => !nfa.isDisjointWith(otherNfa));
            if (overlapping.length >= 1) {
                const othersNfa = unionAll(overlapping.map(([n]) => n));
                const others = overlapping.map(([, , a]) => a);
                if (isSubsetOf(othersNfa, nfa)) {
                    yield { type: "PrefixSubset", alternative, others };
                }
            }
        }
        nfa.append(all);
    }
}
function* findDuplicationNfa(alternatives, flags, { hasNothingAfter, parser, ignoreOverlap }) {
    const previous = [];
    for (let i = 0; i < alternatives.length; i++) {
        const alternative = alternatives[i];
        const { nfa, partial } = toNFA(parser, alternative);
        const overlapping = previous.filter(([otherNfa]) => !nfa.isDisjointWith(otherNfa));
        if (overlapping.length >= 1) {
            const othersNfa = unionAll(overlapping.map(([n]) => n));
            const othersPartial = overlapping.some(([, p]) => p);
            const others = overlapping.map(([, , a]) => a);
            const relation = getPartialSubsetRelation(nfa, partial, othersNfa, othersPartial);
            switch (relation) {
                case 1:
                    if (others.length === 1) {
                        yield {
                            type: "Duplicate",
                            alternative,
                            others: [others[0]],
                        };
                    }
                    else {
                        yield { type: "Subset", alternative, others };
                    }
                    break;
                case 2:
                    yield { type: "Subset", alternative, others };
                    break;
                case 3: {
                    const reorder = (0, reorder_alternatives_1.canReorder)([alternative, ...others], flags);
                    if (reorder) {
                        for (const other of others) {
                            yield {
                                type: "Subset",
                                alternative: other,
                                others: [alternative],
                            };
                        }
                    }
                    else {
                        yield { type: "Superset", alternative, others };
                    }
                    break;
                }
                case 0:
                case 4:
                    if (!ignoreOverlap) {
                        yield {
                            type: "Overlap",
                            alternative,
                            others,
                            overlap: refa_1.NFA.fromIntersection(nfa, othersNfa),
                        };
                    }
                    break;
                default:
                    throw new Error(relation);
            }
        }
        previous.push([nfa, partial, alternative]);
    }
    if (hasNothingAfter) {
        yield* findPrefixDuplicationNfa(previous);
    }
}
function* findDuplication(alternatives, flags, options) {
    if (options.fastAst) {
        yield* findDuplicationAstFast(alternatives, flags);
    }
    else {
        yield* findDuplicationAst(alternatives, flags, options.hasNothingAfter);
    }
    if (!options.noNfa) {
        yield* findDuplicationNfa(alternatives, flags, options);
    }
}
const RESULT_TYPE_ORDER = [
    "Duplicate",
    "Subset",
    "PrefixSubset",
    "Superset",
    "Overlap",
];
function deduplicateResults(unsorted, { reportExp }) {
    const results = [...unsorted].sort((a, b) => RESULT_TYPE_ORDER.indexOf(a.type) -
        RESULT_TYPE_ORDER.indexOf(b.type));
    const seen = new Map();
    return results.filter(({ alternative, type }) => {
        const firstSeen = seen.get(alternative);
        if (firstSeen === undefined) {
            seen.set(alternative, type);
            return true;
        }
        if (reportExp &&
            firstSeen === "PrefixSubset" &&
            type !== "PrefixSubset") {
            seen.set(alternative, type);
            return true;
        }
        return false;
    });
}
function assertNever(value) {
    throw new Error(`Invalid value: ${value}`);
}
exports.default = (0, utils_1.createRule)("no-dupe-disjunctions", {
    meta: {
        docs: {
            description: "disallow duplicate disjunctions",
            category: "Possible Errors",
            recommended: true,
        },
        schema: [
            {
                type: "object",
                properties: {
                    report: {
                        type: "string",
                        enum: ["all", "trivial", "interesting"],
                    },
                    reportExponentialBacktracking: {
                        enum: ["none", "certain", "potential"],
                    },
                    reportUnreachable: {
                        enum: ["certain", "potential"],
                    },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            duplicate: "Unexpected duplicate alternative. This alternative can be removed.{{cap}}{{exp}}",
            subset: "Unexpected useless alternative. This alternative is a strict subset of {{others}} and can be removed.{{cap}}{{exp}}",
            prefixSubset: "Unexpected useless alternative. This alternative is already covered by {{others}} and can be removed.{{cap}}",
            superset: "Unexpected superset. This alternative is a superset of {{others}}. It might be possible to remove the other alternative(s).{{cap}}{{exp}}",
            overlap: "Unexpected overlap. This alternative overlaps with {{others}}. The overlap is {{expr}}.{{cap}}{{exp}}",
        },
        type: "suggestion",
    },
    create(context) {
        var _a, _b, _c, _d, _e, _f;
        const reportExponentialBacktracking = (_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.reportExponentialBacktracking) !== null && _b !== void 0 ? _b : "potential";
        const reportUnreachable = (_d = (_c = context.options[0]) === null || _c === void 0 ? void 0 : _c.reportUnreachable) !== null && _d !== void 0 ? _d : "certain";
        const report = (_f = (_e = context.options[0]) === null || _e === void 0 ? void 0 : _e.report) !== null && _f !== void 0 ? _f : "trivial";
        function createVisitor(regexpContext) {
            const { patternAst, flagsString, flags, node, getRegexpLocation, getUsageOfPattern, } = regexpContext;
            const parser = refa_1.JS.Parser.fromAst({
                pattern: patternAst,
                flags: new regexpp_1.RegExpParser().parseFlags([
                    ...new Set((flagsString || "").replace(/[^gimsuy]/gu, "")),
                ].join("")),
            });
            function getFilterInfo(parentNode) {
                const usage = getUsageOfPattern();
                let stared;
                if (isStared(parentNode)) {
                    stared = 1;
                }
                else if (usage === get_usage_of_pattern_1.UsageOfPattern.partial ||
                    usage === get_usage_of_pattern_1.UsageOfPattern.mixed) {
                    stared = 2;
                }
                else {
                    stared = 0;
                }
                let nothingAfter;
                if (!hasNothingAfterNode(parentNode)) {
                    nothingAfter = 0;
                }
                else if (usage === get_usage_of_pattern_1.UsageOfPattern.partial ||
                    usage === get_usage_of_pattern_1.UsageOfPattern.mixed) {
                    nothingAfter = 2;
                }
                else {
                    nothingAfter = 1;
                }
                let reportExp;
                switch (reportExponentialBacktracking) {
                    case "none":
                        reportExp = false;
                        break;
                    case "certain":
                        reportExp = stared === 1;
                        break;
                    case "potential":
                        reportExp = stared !== 0;
                        break;
                    default:
                        assertNever(reportExponentialBacktracking);
                }
                let reportPrefix;
                switch (reportUnreachable) {
                    case "certain":
                        reportPrefix = nothingAfter === 1;
                        break;
                    case "potential":
                        reportPrefix = nothingAfter !== 0;
                        break;
                    default:
                        assertNever(reportUnreachable);
                }
                return { stared, nothingAfter, reportExp, reportPrefix };
            }
            function verify(parentNode) {
                const info = getFilterInfo(parentNode);
                const rawResults = findDuplication(parentNode.alternatives, flags, {
                    fastAst: false,
                    noNfa: false,
                    ignoreOverlap: !info.reportExp && report !== "all",
                    hasNothingAfter: info.reportPrefix,
                    parser,
                });
                let results = filterResults([...rawResults], info);
                results = deduplicateResults(results, info);
                results.forEach((result) => reportResult(result, info));
            }
            function filterResults(results, { nothingAfter, reportExp, reportPrefix }) {
                switch (report) {
                    case "all": {
                        return results;
                    }
                    case "trivial": {
                        return results.filter(({ type }) => {
                            switch (type) {
                                case "Duplicate":
                                case "Subset":
                                    return true;
                                case "Overlap":
                                case "Superset":
                                    return reportExp;
                                case "PrefixSubset":
                                    return reportPrefix;
                                default:
                                    throw assertNever(type);
                            }
                        });
                    }
                    case "interesting": {
                        return results.filter(({ type }) => {
                            switch (type) {
                                case "Duplicate":
                                case "Subset":
                                    return true;
                                case "Overlap":
                                    return reportExp;
                                case "Superset":
                                    return (reportExp ||
                                        nothingAfter === 0);
                                case "PrefixSubset":
                                    return reportPrefix;
                                default:
                                    throw assertNever(type);
                            }
                        });
                    }
                    default:
                        throw assertNever(report);
                }
            }
            function reportResult(result, { stared }) {
                let exp;
                if (stared === 1) {
                    exp =
                        " This ambiguity is likely to cause exponential backtracking.";
                }
                else if (stared === 2) {
                    exp =
                        " This ambiguity might cause exponential backtracking.";
                }
                else {
                    exp = "";
                }
                const cap = (0, regexp_ast_analysis_1.hasSomeDescendant)(result.alternative, (d) => d.type === "CapturingGroup")
                    ? " Careful! This alternative contains capturing groups which might be difficult to remove."
                    : "";
                const others = (0, mention_1.mention)(result.others.map((a) => a.raw).join("|"));
                switch (result.type) {
                    case "Duplicate":
                        context.report({
                            node,
                            loc: getRegexpLocation(result.alternative),
                            messageId: "duplicate",
                            data: { exp, cap, others },
                        });
                        break;
                    case "Subset":
                        context.report({
                            node,
                            loc: getRegexpLocation(result.alternative),
                            messageId: "subset",
                            data: { exp, cap, others },
                        });
                        break;
                    case "PrefixSubset":
                        context.report({
                            node,
                            loc: getRegexpLocation(result.alternative),
                            messageId: "prefixSubset",
                            data: { exp, cap, others },
                        });
                        break;
                    case "Superset":
                        context.report({
                            node,
                            loc: getRegexpLocation(result.alternative),
                            messageId: "superset",
                            data: { exp, cap, others },
                        });
                        break;
                    case "Overlap":
                        context.report({
                            node,
                            loc: getRegexpLocation(result.alternative),
                            messageId: "overlap",
                            data: {
                                exp,
                                cap,
                                others,
                                expr: (0, mention_1.mention)(faToSource(result.overlap, flags)),
                            },
                        });
                        break;
                    default:
                        throw new Error(result);
                }
            }
            return {
                onPatternEnter: verify,
                onGroupEnter: verify,
                onCapturingGroupEnter: verify,
                onAssertionEnter(aNode) {
                    if (aNode.kind === "lookahead" ||
                        aNode.kind === "lookbehind") {
                        verify(aNode);
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

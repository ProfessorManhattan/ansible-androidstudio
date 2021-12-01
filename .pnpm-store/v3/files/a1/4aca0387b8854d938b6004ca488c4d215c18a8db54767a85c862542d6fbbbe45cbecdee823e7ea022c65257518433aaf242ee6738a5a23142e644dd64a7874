"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const get_usage_of_pattern_1 = require("../utils/get-usage-of-pattern");
const scslre_1 = require("scslre");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const refa_1 = require("refa");
function getParsedLiteral(context, ignoreSticky) {
    var _a, _b, _c, _d, _e, _f, _g;
    const { flags, flagsString, patternAst } = context;
    return {
        pattern: patternAst,
        flags: {
            type: "Flags",
            raw: flagsString !== null && flagsString !== void 0 ? flagsString : "",
            parent: null,
            start: NaN,
            end: NaN,
            dotAll: (_a = flags.dotAll) !== null && _a !== void 0 ? _a : false,
            global: (_b = flags.global) !== null && _b !== void 0 ? _b : false,
            hasIndices: (_c = flags.hasIndices) !== null && _c !== void 0 ? _c : false,
            ignoreCase: (_d = flags.ignoreCase) !== null && _d !== void 0 ? _d : false,
            multiline: (_e = flags.multiline) !== null && _e !== void 0 ? _e : false,
            sticky: !ignoreSticky && ((_f = flags.sticky) !== null && _f !== void 0 ? _f : false),
            unicode: (_g = flags.unicode) !== null && _g !== void 0 ? _g : false,
        },
    };
}
function dedupeReports(reports) {
    const seen = new Set();
    const result = [];
    for (const r of reports) {
        if (!seen.has(r.quant)) {
            result.push(r);
            seen.add(r.quant);
        }
    }
    return result;
}
function* findReachableQuantifiers(node) {
    switch (node.type) {
        case "CapturingGroup":
        case "Group":
        case "Pattern": {
            for (const a of node.alternatives) {
                yield* findReachableQuantifiers(a);
            }
            break;
        }
        case "Assertion": {
            if (node.kind === "lookahead" || node.kind === "lookbehind") {
                for (const a of node.alternatives) {
                    yield* findReachableQuantifiers(a);
                }
            }
            break;
        }
        case "Quantifier": {
            yield node;
            break;
        }
        case "Alternative": {
            const dir = (0, regexp_ast_analysis_1.getMatchingDirection)(node);
            for (let i = 0; i < node.elements.length; i++) {
                const elementIndex = dir === "ltr" ? i : node.elements.length - 1 - i;
                const element = node.elements[elementIndex];
                yield* findReachableQuantifiers(element);
                if (!(0, regexp_ast_analysis_1.isPotentiallyEmpty)(element)) {
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
}
const TRANFORMER_OPTIONS = {
    ignoreAmbiguity: true,
    ignoreOrder: true,
};
const PASS_1 = (0, refa_1.combineTransformers)([
    refa_1.Transformers.inline(TRANFORMER_OPTIONS),
    refa_1.Transformers.removeDeadBranches(TRANFORMER_OPTIONS),
    refa_1.Transformers.unionCharacters(TRANFORMER_OPTIONS),
    refa_1.Transformers.moveUpEmpty(TRANFORMER_OPTIONS),
    refa_1.Transformers.nestedQuantifiers(TRANFORMER_OPTIONS),
    refa_1.Transformers.removeUnnecessaryAssertions(TRANFORMER_OPTIONS),
    refa_1.Transformers.applyAssertions(TRANFORMER_OPTIONS),
]);
const PASS_2 = (0, refa_1.combineTransformers)([
    refa_1.Transformers.inline(TRANFORMER_OPTIONS),
    refa_1.Transformers.removeDeadBranches(TRANFORMER_OPTIONS),
    refa_1.Transformers.replaceAssertions(Object.assign(Object.assign({}, TRANFORMER_OPTIONS), { replacement: "empty-set" })),
]);
exports.default = (0, utils_1.createRule)("no-super-linear-move", {
    meta: {
        docs: {
            description: "disallow quantifiers that cause quadratic moves",
            category: "Possible Errors",
            recommended: false,
        },
        schema: [
            {
                type: "object",
                properties: {
                    report: {
                        enum: ["certain", "potential"],
                    },
                    ignoreSticky: {
                        type: "boolean",
                    },
                    ignorePartial: {
                        type: "boolean",
                    },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            unexpected: "Any attack string {{attack}} plus some rejecting suffix will cause quadratic runtime because of this quantifier.",
        },
        type: "problem",
    },
    create(context) {
        var _a, _b, _c, _d, _e, _f;
        const reportUncertain = ((_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.report) !== null && _b !== void 0 ? _b : "certain") === "potential";
        const ignoreSticky = (_d = (_c = context.options[0]) === null || _c === void 0 ? void 0 : _c.ignoreSticky) !== null && _d !== void 0 ? _d : false;
        const ignorePartial = (_f = (_e = context.options[0]) === null || _e === void 0 ? void 0 : _e.ignorePartial) !== null && _f !== void 0 ? _f : true;
        function getScslreReports(regexpContext, assumeRejectingSuffix) {
            const { flags } = regexpContext;
            const result = (0, scslre_1.analyse)(getParsedLiteral(regexpContext, true), {
                reportTypes: { Move: true, Self: false, Trade: false },
                assumeRejectingSuffix,
            });
            return result.reports.map((r) => {
                if (r.type !== "Move") {
                    throw new Error("Unexpected report type");
                }
                return {
                    quant: r.quant,
                    attack: `/${r.character.literal.source}+/${flags.ignoreCase ? "i" : ""}`,
                };
            });
        }
        function* getSimpleReports(regexpContext, assumeRejectingSuffix) {
            const { patternAst, flags } = regexpContext;
            const parser = refa_1.JS.Parser.fromAst(getParsedLiteral(regexpContext, true));
            for (const q of findReachableQuantifiers(patternAst)) {
                if (q.max !== Infinity) {
                    continue;
                }
                if (q.element.type === "Assertion" ||
                    q.element.type === "Backreference") {
                    continue;
                }
                let e = parser.parseElement(q.element, {
                    assertions: "parse",
                    backreferences: "disable",
                }).expression;
                e = (0, refa_1.transform)(PASS_1, e);
                e = (0, refa_1.transform)(PASS_2, e);
                if (e.alternatives.length === 0) {
                    continue;
                }
                let hasCharacters = false;
                (0, refa_1.visitAst)(e, {
                    onCharacterClassEnter() {
                        hasCharacters = true;
                    },
                });
                if (!hasCharacters) {
                    continue;
                }
                if (!assumeRejectingSuffix) {
                    const after = (0, regexp_ast_analysis_1.getFirstConsumedCharAfter)(q, (0, regexp_ast_analysis_1.getMatchingDirection)(q), flags);
                    if (after.empty && after.look.char.isAll) {
                        continue;
                    }
                }
                const attack = `/${refa_1.JS.toLiteral({
                    type: "Quantifier",
                    alternatives: e.alternatives,
                    min: 1,
                    max: Infinity,
                    lazy: false,
                }).source}/${flags.ignoreCase ? "i" : ""}`;
                yield { quant: q, attack };
            }
        }
        function createVisitor(regexpContext) {
            const { node, flags, getRegexpLocation, getUsageOfPattern } = regexpContext;
            if (ignoreSticky && flags.sticky) {
                return {};
            }
            const usage = getUsageOfPattern();
            if (ignorePartial && usage === get_usage_of_pattern_1.UsageOfPattern.partial) {
                return {};
            }
            const assumeRejectingSuffix = reportUncertain && usage !== get_usage_of_pattern_1.UsageOfPattern.whole;
            for (const report of dedupeReports([
                ...getSimpleReports(regexpContext, assumeRejectingSuffix),
                ...getScslreReports(regexpContext, assumeRejectingSuffix),
            ])) {
                context.report({
                    node,
                    loc: getRegexpLocation(report.quant),
                    messageId: "unexpected",
                    data: { attack: report.attack },
                });
            }
            return {};
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

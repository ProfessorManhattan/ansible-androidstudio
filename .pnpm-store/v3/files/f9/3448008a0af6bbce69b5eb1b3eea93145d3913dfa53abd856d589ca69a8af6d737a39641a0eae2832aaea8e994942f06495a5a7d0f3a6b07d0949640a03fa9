"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const get_usage_of_pattern_1 = require("../utils/get-usage-of-pattern");
const scslre_1 = require("scslre");
const mention_1 = require("../utils/mention");
function unionLocations(a, b) {
    function less(x, y) {
        if (x.line < y.line) {
            return true;
        }
        else if (x.line > y.line) {
            return false;
        }
        return x.column < y.column;
    }
    return {
        start: Object.assign({}, (less(a.start, b.start) ? a.start : b.start)),
        end: Object.assign({}, (less(a.end, b.end) ? b.end : a.end)),
    };
}
function getParsedLiteral(context) {
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
            sticky: (_f = flags.sticky) !== null && _f !== void 0 ? _f : false,
            unicode: (_g = flags.unicode) !== null && _g !== void 0 ? _g : false,
        },
    };
}
exports.default = (0, utils_1.createRule)("no-super-linear-backtracking", {
    meta: {
        docs: {
            description: "disallow exponential and polynomial backtracking",
            category: "Possible Errors",
            recommended: true,
        },
        fixable: "code",
        schema: [
            {
                type: "object",
                properties: {
                    report: {
                        enum: ["certain", "potential"],
                    },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            self: "This quantifier can reach itself via the loop {{parent}}." +
                " Using any string accepted by {{attack}}, this can be exploited to cause at least polynomial backtracking." +
                "{{exp}}",
            trade: "The quantifier {{start}} can exchange characters with {{end}}." +
                " Using any string accepted by {{attack}}, this can be exploited to cause at least polynomial backtracking." +
                "{{exp}}",
        },
        type: "problem",
    },
    create(context) {
        var _a, _b;
        const reportUncertain = ((_b = (_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.report) !== null && _b !== void 0 ? _b : "certain") === "potential";
        function createVisitor(regexpContext) {
            const { node, patternAst, flags, getRegexpLocation, fixReplaceNode, getUsageOfPattern, } = regexpContext;
            const result = (0, scslre_1.analyse)(getParsedLiteral(regexpContext), {
                reportTypes: { Move: false },
                assumeRejectingSuffix: reportUncertain &&
                    getUsageOfPattern() !== get_usage_of_pattern_1.UsageOfPattern.whole,
            });
            for (const report of result.reports) {
                const exp = report.exponential
                    ? " This is going to cause exponential backtracking resulting in exponential worst-case runtime behavior."
                    : getUsageOfPattern() !== get_usage_of_pattern_1.UsageOfPattern.whole
                        ? " This might cause exponential backtracking."
                        : "";
                const attack = `/${report.character.literal.source}+/${flags.ignoreCase ? "i" : ""}`;
                const fix = fixReplaceNode(patternAst, () => { var _a, _b; return (_b = (_a = report.fix()) === null || _a === void 0 ? void 0 : _a.source) !== null && _b !== void 0 ? _b : null; });
                if (report.type === "Self") {
                    context.report({
                        node,
                        loc: getRegexpLocation(report.quant),
                        messageId: "self",
                        data: {
                            exp,
                            attack,
                            parent: (0, mention_1.mention)(report.parentQuant),
                        },
                        fix,
                    });
                }
                else if (report.type === "Trade") {
                    context.report({
                        node,
                        loc: unionLocations(getRegexpLocation(report.startQuant), getRegexpLocation(report.endQuant)),
                        messageId: "trade",
                        data: {
                            exp,
                            attack,
                            start: (0, mention_1.mention)(report.startQuant),
                            end: (0, mention_1.mention)(report.endQuant),
                        },
                        fix,
                    });
                }
            }
            return {};
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

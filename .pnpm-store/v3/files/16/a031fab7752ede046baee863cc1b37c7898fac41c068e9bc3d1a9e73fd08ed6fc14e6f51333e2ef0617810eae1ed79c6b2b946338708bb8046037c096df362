"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const type_tracker_1 = require("../utils/type-tracker");
const ast_utils_1 = require("../utils/ast-utils");
const mention_1 = require("../utils/mention");
const regexp_ast_1 = require("../utils/regexp-ast");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
class ReplaceReferencesList {
    constructor(list) {
        var _a, _b;
        this.list = list;
        this.startRefName = (_a = list[0].startRef) === null || _a === void 0 ? void 0 : _a.ref;
        this.endRefName = (_b = list[0].endRef) === null || _b === void 0 ? void 0 : _b.ref;
        const otherThanStartRefNames = new Set();
        const otherThanEndRefNames = new Set();
        for (const { startRef, endRef, allRefs } of this.list) {
            for (const ref of allRefs) {
                if (ref !== startRef) {
                    otherThanStartRefNames.add(ref.ref);
                }
                if (ref !== endRef) {
                    otherThanEndRefNames.add(ref.ref);
                }
            }
        }
        this.otherThanStartRefNames = otherThanStartRefNames;
        this.otherThanEndRefNames = otherThanEndRefNames;
    }
    *[Symbol.iterator]() {
        yield* this.list;
    }
}
function getSideEffectsWhenReplacingCapturingGroup(elements, start, end, { flags }) {
    const result = new Set();
    if (start) {
        const { char } = (0, regexp_ast_1.getPossiblyConsumedChar)(start, flags);
        if (!hasDisjoint(char, elements.slice(1))) {
            result.add(0);
        }
        else {
            const last = elements[elements.length - 1];
            const lastChar = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, regexp_ast_1.getFirstConsumedCharPlusAfter)(last, "rtl", flags));
            if (!lastChar.char.isDisjointWith(char)) {
                result.add(0);
            }
        }
    }
    if (end && flags.global) {
        const first = elements[0];
        if (first) {
            const { char } = (0, regexp_ast_1.getPossiblyConsumedChar)(end, flags);
            const firstChar = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, regexp_ast_1.getFirstConsumedCharPlusAfter)(first, "ltr", flags));
            if (!firstChar.char.isDisjointWith(char)) {
                result.add(1);
            }
        }
    }
    return result;
    function hasDisjoint(target, targetElements) {
        for (const element of targetElements) {
            if (isConstantLength(element)) {
                const elementChars = (0, regexp_ast_1.getPossiblyConsumedChar)(element, flags);
                if (elementChars.char.isEmpty) {
                    continue;
                }
                if (elementChars.char.isDisjointWith(target)) {
                    return true;
                }
            }
            else {
                const elementLook = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, regexp_ast_1.getFirstConsumedCharPlusAfter)(element, "ltr", flags));
                return elementLook.char.isDisjointWith(target);
            }
        }
        return false;
    }
    function isConstantLength(target) {
        const range = (0, regexp_ast_analysis_1.getLengthRange)(target);
        return Boolean(range && range.min === range.max);
    }
}
function parseOption(userOption) {
    let strictTypes = true;
    if (userOption) {
        if (userOption.strictTypes != null) {
            strictTypes = userOption.strictTypes;
        }
    }
    return {
        strictTypes,
    };
}
exports.default = (0, utils_1.createRule)("prefer-lookaround", {
    meta: {
        docs: {
            description: "prefer lookarounds over capturing group that do not replace",
            category: "Stylistic Issues",
            recommended: false,
        },
        fixable: "code",
        schema: [
            {
                type: "object",
                properties: {
                    strictTypes: { type: "boolean" },
                },
                additionalProperties: false,
            },
        ],
        messages: {
            preferLookarounds: "These capturing groups can be replaced with lookaround assertions ({{expr1}} and {{expr2}}).",
            prefer: "This capturing group can be replaced with a {{kind}} ({{expr}}).",
        },
        type: "suggestion",
    },
    create(context) {
        const { strictTypes } = parseOption(context.options[0]);
        const typeTracer = (0, type_tracker_1.createTypeTracker)(context);
        function createVisitor(regexpContext) {
            const { regexpNode, patternAst } = regexpContext;
            if (patternAst.alternatives.length > 1 ||
                patternAst.alternatives[0].elements.length < 2) {
                return {};
            }
            const replaceReferenceList = [];
            for (const ref of (0, ast_utils_1.extractExpressionReferences)(regexpNode, context)) {
                if (ref.type === "argument") {
                    if (!(0, ast_utils_1.isKnownMethodCall)(ref.callExpression, {
                        replace: 2,
                        replaceAll: 2,
                    })) {
                        return {};
                    }
                    const replaceReference = getReplaceReferenceFromCallExpression(ref.callExpression);
                    if (!replaceReference) {
                        return {};
                    }
                    replaceReferenceList.push(replaceReference);
                }
                else if (ref.type === "member") {
                    const parent = (0, ast_utils_1.getParent)(ref.memberExpression);
                    if ((parent === null || parent === void 0 ? void 0 : parent.type) === "CallExpression" &&
                        (0, ast_utils_1.isKnownMethodCall)(parent, {
                            test: 1,
                        }) &&
                        !regexpContext.flags.global) {
                        continue;
                    }
                    return {};
                }
                else {
                    return {};
                }
            }
            if (!replaceReferenceList.length) {
                return {};
            }
            const replaceReference = replaceReferenceList[0];
            if (replaceReferenceList.some((target) => {
                var _a, _b, _c, _d;
                return ((_a = target.startRef) === null || _a === void 0 ? void 0 : _a.ref) !==
                    ((_b = replaceReference.startRef) === null || _b === void 0 ? void 0 : _b.ref) ||
                    ((_c = target.endRef) === null || _c === void 0 ? void 0 : _c.ref) !== ((_d = replaceReference.endRef) === null || _d === void 0 ? void 0 : _d.ref);
            })) {
                return {};
            }
            return createVerifyVisitor(regexpContext, new ReplaceReferencesList(replaceReferenceList));
        }
        function getReplaceReferenceFromCallExpression(node) {
            if (strictTypes
                ? !typeTracer.isString(node.callee.object)
                : !typeTracer.maybeString(node.callee.object)) {
                return null;
            }
            const replacementNode = node.arguments[1];
            if (replacementNode.type === "Literal") {
                return getReplaceReferenceFromLiteralReplacementArgument(replacementNode);
            }
            return getReplaceReferenceFromNonLiteralReplacementArgument(replacementNode);
        }
        function getReplaceReferenceFromLiteralReplacementArgument(node) {
            if (typeof node.value !== "string") {
                return null;
            }
            const replacements = (0, ast_utils_1.parseReplacements)(context, node);
            let startRef = null;
            let endRef = null;
            const start = replacements[0];
            if ((start === null || start === void 0 ? void 0 : start.type) === "ReferenceElement") {
                startRef = start;
            }
            const end = replacements[replacements.length - 1];
            if ((end === null || end === void 0 ? void 0 : end.type) === "ReferenceElement") {
                endRef = end;
            }
            if (!startRef && !endRef) {
                return null;
            }
            return {
                startRef,
                endRef,
                allRefs: replacements.filter((e) => e.type === "ReferenceElement"),
            };
        }
        function getReplaceReferenceFromNonLiteralReplacementArgument(node) {
            const evaluated = (0, ast_utils_1.getStaticValue)(context, node);
            if (!evaluated || typeof evaluated.value !== "string") {
                return null;
            }
            const refRegex = /\$(?<ref>[1-9]\d*|<(?<named>[^>]+)>)/gu;
            const allRefs = [];
            let startRef = null;
            let endRef = null;
            let re;
            while ((re = refRegex.exec(evaluated.value))) {
                const ref = {
                    ref: re.groups.named
                        ? re.groups.named
                        : Number(re.groups.ref),
                };
                if (re.index === 0) {
                    startRef = ref;
                }
                if (refRegex.lastIndex === evaluated.value.length) {
                    endRef = ref;
                }
                allRefs.push(ref);
            }
            if (!startRef && !endRef) {
                return null;
            }
            return {
                startRef,
                endRef,
                allRefs,
            };
        }
        function createVerifyVisitor(regexpContext, replaceReferenceList) {
            const startRefState = {
                capturingGroups: [],
                capturingNum: -1,
            };
            const endRefState = {
                capturingGroups: [],
                capturingNum: -1,
            };
            let refNum = 0;
            return {
                onCapturingGroupEnter(cgNode) {
                    refNum++;
                    processForState(replaceReferenceList.startRefName, replaceReferenceList.otherThanStartRefNames, startRefState);
                    processForState(replaceReferenceList.endRefName, replaceReferenceList.otherThanEndRefNames, endRefState);
                    function processForState(refName, otherThanRefNames, state) {
                        if (refName === refNum || refName === cgNode.name) {
                            state.capturingGroups.push(cgNode);
                            state.capturingNum = refNum;
                            state.isUseOther || (state.isUseOther = Boolean(otherThanRefNames.has(refNum) ||
                                (cgNode.name &&
                                    otherThanRefNames.has(cgNode.name))));
                        }
                    }
                },
                onPatternLeave(pNode) {
                    const alt = pNode.alternatives[0];
                    let reportStart = null;
                    if (!startRefState.isUseOther &&
                        startRefState.capturingGroups.length === 1 &&
                        startRefState.capturingGroups[0] === alt.elements[0] &&
                        !(0, regexp_ast_analysis_1.isZeroLength)(startRefState.capturingGroups[0])) {
                        const capturingGroup = startRefState.capturingGroups[0];
                        reportStart = {
                            capturingGroup,
                            expr: `(?<=${capturingGroup.alternatives
                                .map((a) => a.raw)
                                .join("|")})`,
                        };
                    }
                    let reportEnd = null;
                    if (!endRefState.isUseOther &&
                        endRefState.capturingGroups.length === 1 &&
                        endRefState.capturingGroups[0] ===
                            alt.elements[alt.elements.length - 1] &&
                        !(0, regexp_ast_analysis_1.isZeroLength)(endRefState.capturingGroups[0])) {
                        const capturingGroup = endRefState.capturingGroups[0];
                        reportEnd = {
                            capturingGroup,
                            expr: `(?=${capturingGroup.alternatives
                                .map((a) => a.raw)
                                .join("|")})`,
                        };
                    }
                    const sideEffects = getSideEffectsWhenReplacingCapturingGroup(alt.elements, reportStart === null || reportStart === void 0 ? void 0 : reportStart.capturingGroup, reportEnd === null || reportEnd === void 0 ? void 0 : reportEnd.capturingGroup, regexpContext);
                    if (sideEffects.has(0)) {
                        reportStart = null;
                    }
                    if (sideEffects.has(1)) {
                        reportEnd = null;
                    }
                    if (reportStart && reportEnd) {
                        const fix = buildFixer(regexpContext, [reportStart, reportEnd], replaceReferenceList, (target) => {
                            var _a, _b;
                            if (target.allRefs.some((ref) => ref !== target.startRef &&
                                ref !== target.endRef)) {
                                return null;
                            }
                            return [
                                (_a = target.startRef) === null || _a === void 0 ? void 0 : _a.range,
                                (_b = target.endRef) === null || _b === void 0 ? void 0 : _b.range,
                            ];
                        });
                        for (const report of [reportStart, reportEnd]) {
                            context.report({
                                loc: regexpContext.getRegexpLocation(report.capturingGroup),
                                messageId: "preferLookarounds",
                                data: {
                                    expr1: (0, mention_1.mention)(reportStart.expr),
                                    expr2: (0, mention_1.mention)(reportEnd.expr),
                                },
                                fix,
                            });
                        }
                    }
                    else if (reportStart) {
                        const fix = buildFixer(regexpContext, [reportStart], replaceReferenceList, (target) => {
                            var _a;
                            if (target.allRefs.some((ref) => ref !== target.startRef)) {
                                return null;
                            }
                            return [(_a = target.startRef) === null || _a === void 0 ? void 0 : _a.range];
                        });
                        context.report({
                            loc: regexpContext.getRegexpLocation(reportStart.capturingGroup),
                            messageId: "prefer",
                            data: {
                                kind: "lookbehind assertion",
                                expr: (0, mention_1.mention)(reportStart.expr),
                            },
                            fix,
                        });
                    }
                    else if (reportEnd) {
                        const fix = buildFixer(regexpContext, [reportEnd], replaceReferenceList, (target) => {
                            var _a;
                            if (target.allRefs.some((ref) => {
                                if (ref === target.endRef ||
                                    typeof ref.ref !== "number") {
                                    return false;
                                }
                                return (endRefState.capturingNum <= ref.ref);
                            })) {
                                return null;
                            }
                            return [(_a = target.endRef) === null || _a === void 0 ? void 0 : _a.range];
                        });
                        context.report({
                            loc: regexpContext.getRegexpLocation(reportEnd.capturingGroup),
                            messageId: "prefer",
                            data: {
                                kind: "lookahead assertion",
                                expr: (0, mention_1.mention)(reportEnd.expr),
                            },
                            fix,
                        });
                    }
                },
            };
        }
        function buildFixer(regexpContext, replaceCapturingGroups, replaceReferenceList, getRemoveRanges) {
            const removeRanges = [];
            for (const replaceReference of replaceReferenceList) {
                const targetRemoveRanges = getRemoveRanges(replaceReference);
                if (!targetRemoveRanges) {
                    return null;
                }
                for (const range of targetRemoveRanges) {
                    if (!range) {
                        return null;
                    }
                    removeRanges.push(range);
                }
            }
            const replaces = [];
            for (const { capturingGroup, expr } of replaceCapturingGroups) {
                const replaceRange = regexpContext.patternSource.getReplaceRange(capturingGroup);
                if (!replaceRange) {
                    return null;
                }
                replaces.push({
                    replaceRange,
                    expr,
                });
            }
            return (fixer) => {
                const list = [];
                for (const removeRange of removeRanges) {
                    list.push({
                        offset: removeRange[0],
                        fix: () => fixer.removeRange(removeRange),
                    });
                }
                for (const { replaceRange, expr } of replaces) {
                    list.push({
                        offset: replaceRange.range[0],
                        fix: () => replaceRange.replace(fixer, expr),
                    });
                }
                return list
                    .sort((a, b) => a.offset - b.offset)
                    .map((item) => item.fix());
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

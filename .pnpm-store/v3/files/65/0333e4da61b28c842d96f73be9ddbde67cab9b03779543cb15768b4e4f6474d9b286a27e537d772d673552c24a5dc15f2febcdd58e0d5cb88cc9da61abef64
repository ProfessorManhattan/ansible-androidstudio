"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const mention_1 = require("../utils/mention");
const messages = {
    alwaysRejectByChar: "{{assertion}} will always reject because it is {{followedOrPreceded}} by a character.",
    alwaysRejectByNonLineTerminator: "{{assertion}} will always reject because it is {{followedOrPreceded}} by a non-line-terminator character.",
    alwaysAcceptByLineTerminator: "{{assertion}} will always accept because it is {{followedOrPreceded}} by a line-terminator character.",
    alwaysAcceptOrRejectFollowedByWord: "{{assertion}} will always {{acceptOrReject}} because it is preceded by a non-word character and followed by a word character.",
    alwaysAcceptOrRejectFollowedByNonWord: "{{assertion}} will always {{acceptOrReject}} because it is preceded by a non-word character and followed by a non-word character.",
    alwaysAcceptOrRejectPrecededByWordFollowedByNonWord: "{{assertion}} will always {{acceptOrReject}} because it is preceded by a word character and followed by a non-word character.",
    alwaysAcceptOrRejectPrecededByWordFollowedByWord: "{{assertion}} will always {{acceptOrReject}} because it is preceded by a word character and followed by a word character.",
    alwaysForLookaround: "The {{kind}} {{assertion}} will always {{acceptOrReject}}.",
    alwaysForNegativeLookaround: "The negative {{kind}} {{assertion}} will always {{acceptOrReject}}.",
};
exports.default = (0, utils_1.createRule)("no-useless-assertions", {
    meta: {
        docs: {
            description: "disallow assertions that are known to always accept (or reject)",
            category: "Possible Errors",
            recommended: true,
        },
        schema: [],
        messages,
        type: "problem",
    },
    create(context) {
        function createVisitor({ node, flags, getRegexpLocation, }) {
            function report(assertion, messageId, data) {
                context.report({
                    node,
                    loc: getRegexpLocation(assertion),
                    messageId,
                    data: Object.assign({ assertion: (0, mention_1.mention)(assertion) }, data),
                });
            }
            function verifyStartOrEnd(assertion) {
                const direction = (0, regexp_ast_analysis_1.getMatchingDirectionFromAssertionKind)(assertion.kind);
                const next = (0, regexp_ast_analysis_1.getFirstCharAfter)(assertion, direction, flags);
                const followedOrPreceded = assertion.kind === "end" ? "followed" : "preceded";
                if (!next.edge) {
                    if (!flags.multiline) {
                        report(assertion, "alwaysRejectByChar", {
                            followedOrPreceded,
                        });
                    }
                    else {
                        const lineTerminator = regexp_ast_analysis_1.Chars.lineTerminator(flags);
                        if (next.char.isDisjointWith(lineTerminator)) {
                            report(assertion, "alwaysRejectByNonLineTerminator", { followedOrPreceded });
                        }
                        else if (next.char.isSubsetOf(lineTerminator)) {
                            report(assertion, "alwaysAcceptByLineTerminator", {
                                followedOrPreceded,
                            });
                        }
                    }
                }
            }
            function verifyWordBoundary(assertion) {
                const word = regexp_ast_analysis_1.Chars.word(flags);
                const next = (0, regexp_ast_analysis_1.getFirstCharAfter)(assertion, "ltr", flags);
                const prev = (0, regexp_ast_analysis_1.getFirstCharAfter)(assertion, "rtl", flags);
                if (prev.edge || next.edge) {
                    return;
                }
                const nextIsWord = next.char.isSubsetOf(word);
                const prevIsWord = prev.char.isSubsetOf(word);
                const nextIsNonWord = next.char.isDisjointWith(word);
                const prevIsNonWord = prev.char.isDisjointWith(word);
                const accept = assertion.negate ? "reject" : "accept";
                const reject = assertion.negate ? "accept" : "reject";
                if (prevIsNonWord) {
                    if (nextIsWord) {
                        report(assertion, "alwaysAcceptOrRejectFollowedByWord", {
                            acceptOrReject: accept,
                        });
                    }
                    if (nextIsNonWord) {
                        report(assertion, "alwaysAcceptOrRejectFollowedByNonWord", {
                            acceptOrReject: reject,
                        });
                    }
                }
                if (prevIsWord) {
                    if (nextIsNonWord) {
                        report(assertion, "alwaysAcceptOrRejectPrecededByWordFollowedByNonWord", {
                            acceptOrReject: accept,
                        });
                    }
                    if (nextIsWord) {
                        report(assertion, "alwaysAcceptOrRejectPrecededByWordFollowedByWord", {
                            acceptOrReject: reject,
                        });
                    }
                }
            }
            function verifyLookaround(assertion) {
                if ((0, regexp_ast_analysis_1.isPotentiallyEmpty)(assertion.alternatives)) {
                    return;
                }
                const direction = (0, regexp_ast_analysis_1.getMatchingDirectionFromAssertionKind)(assertion.kind);
                const after = (0, regexp_ast_analysis_1.getFirstCharAfter)(assertion, direction, flags);
                if (after.edge) {
                    return;
                }
                const firstOf = regexp_ast_analysis_1.FirstConsumedChars.toLook((0, regexp_ast_analysis_1.getFirstConsumedChar)(assertion.alternatives, direction, flags));
                const accept = assertion.negate ? "reject" : "accept";
                const reject = assertion.negate ? "accept" : "reject";
                if (after.char.isDisjointWith(firstOf.char)) {
                    report(assertion, assertion.negate
                        ? "alwaysForNegativeLookaround"
                        : "alwaysForLookaround", {
                        kind: assertion.kind,
                        acceptOrReject: reject,
                    });
                }
                if (!(0, regexp_ast_analysis_1.hasSomeDescendant)(assertion, (d) => d !== assertion && d.type === "Assertion")) {
                    const range = (0, regexp_ast_analysis_1.getLengthRange)(assertion.alternatives);
                    if (range && range.max === 1) {
                        if (firstOf.exact &&
                            after.char.isSubsetOf(firstOf.char)) {
                            report(assertion, assertion.negate
                                ? "alwaysForNegativeLookaround"
                                : "alwaysForLookaround", {
                                kind: assertion.kind,
                                acceptOrReject: accept,
                            });
                        }
                    }
                }
            }
            return {
                onAssertionEnter(assertion) {
                    switch (assertion.kind) {
                        case "start":
                        case "end":
                            verifyStartOrEnd(assertion);
                            break;
                        case "word":
                            verifyWordBoundary(assertion);
                            break;
                        case "lookahead":
                        case "lookbehind":
                            verifyLookaround(assertion);
                            break;
                        default:
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

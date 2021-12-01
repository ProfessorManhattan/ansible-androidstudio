"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const mention_1 = require("../utils/mention");
function hasNegatedLookaroundInBetween(from, to) {
    for (let p = from.parent; p && p !== to; p = p.parent) {
        if (p.type === "Assertion" &&
            (p.kind === "lookahead" || p.kind === "lookbehind") &&
            p.negate) {
            return true;
        }
    }
    return false;
}
function getUselessMessageId(backRef) {
    const group = backRef.resolved;
    const closestAncestor = (0, regexp_ast_analysis_1.getClosestAncestor)(backRef, group);
    if (closestAncestor === group) {
        return "nested";
    }
    else if (closestAncestor.type !== "Alternative") {
        return "disjunctive";
    }
    if (hasNegatedLookaroundInBetween(group, closestAncestor)) {
        return "intoNegativeLookaround";
    }
    const matchingDir = (0, regexp_ast_analysis_1.getMatchingDirection)(closestAncestor);
    if (matchingDir === "ltr" && backRef.end <= group.start) {
        return "forward";
    }
    else if (matchingDir === "rtl" && group.end <= backRef.start) {
        return "backward";
    }
    if ((0, regexp_ast_analysis_1.isZeroLength)(group)) {
        return "empty";
    }
    return null;
}
exports.default = (0, utils_1.createRule)("no-useless-backreference", {
    meta: {
        docs: {
            description: "disallow useless backreferences in regular expressions",
            category: "Possible Errors",
            recommended: true,
        },
        schema: [],
        messages: {
            nested: "Backreference {{ bref }} will be ignored. It references group {{ group }} from within that group.",
            forward: "Backreference {{ bref }} will be ignored. It references group {{ group }} which appears later in the pattern.",
            backward: "Backreference {{ bref }} will be ignored. It references group {{ group }} which appears before in the same lookbehind.",
            disjunctive: "Backreference {{ bref }} will be ignored. It references group {{ group }} which is in another alternative.",
            intoNegativeLookaround: "Backreference {{ bref }} will be ignored. It references group {{ group }} which is in a negative lookaround.",
            empty: "Backreference {{ bref }} will be ignored. It references group {{ group }} which always captures zero characters.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, }) {
            return {
                onBackreferenceEnter(backRef) {
                    const messageId = getUselessMessageId(backRef);
                    if (messageId) {
                        context.report({
                            node,
                            loc: getRegexpLocation(backRef),
                            messageId,
                            data: {
                                bref: (0, mention_1.mention)(backRef),
                                group: (0, mention_1.mention)(backRef.resolved),
                            },
                        });
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const utils_1 = require("../utils");
exports.default = (0, utils_1.createRule)("negation", {
    meta: {
        docs: {
            description: "enforce use of escapes on negation",
            category: "Best Practices",
            recommended: true,
        },
        fixable: "code",
        schema: [],
        messages: {
            unexpected: "Unexpected negated character class. Use '{{negatedCharSet}}' instead.",
        },
        type: "suggestion",
    },
    create(context) {
        function createVisitor({ node, getRegexpLocation, fixReplaceNode, flags, }) {
            return {
                onCharacterClassEnter(ccNode) {
                    if (!ccNode.negate || ccNode.elements.length !== 1) {
                        return;
                    }
                    const element = ccNode.elements[0];
                    if (element.type !== "CharacterSet") {
                        return;
                    }
                    if (flags.ignoreCase && element.kind === "property") {
                        const ccSet = (0, regexp_ast_analysis_1.toCharSet)(ccNode, flags);
                        const negatedElementSet = (0, regexp_ast_analysis_1.toCharSet)(Object.assign(Object.assign({}, element), { negate: !element.negate }), flags);
                        if (!ccSet.equals(negatedElementSet)) {
                            return;
                        }
                    }
                    const negatedCharSet = getNegationText(element);
                    context.report({
                        node,
                        loc: getRegexpLocation(ccNode),
                        messageId: "unexpected",
                        data: { negatedCharSet },
                        fix: fixReplaceNode(ccNode, negatedCharSet),
                    });
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});
function getNegationText(node) {
    let kind = node.raw[1];
    if (kind.toLowerCase() === kind) {
        kind = kind.toUpperCase();
    }
    else {
        kind = kind.toLowerCase();
    }
    return `\\${kind}${node.raw.slice(2)}`;
}

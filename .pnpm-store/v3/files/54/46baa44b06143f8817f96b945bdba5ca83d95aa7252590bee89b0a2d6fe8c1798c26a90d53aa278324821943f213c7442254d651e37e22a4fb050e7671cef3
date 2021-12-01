/**
 * @fileoverview Rule to check empty newline between object properties
 * @author Jiang Fengming<jiangfengming87@gmail.com>
 * modified from https://github.com/eslint/eslint/blob/master/lib/rules/lines-between-object-properties.js
 */
"use strict";

/**
 * Determines whether two adjacent tokens are on the same line.
 * @param {Object} left The left token object.
 * @param {Object} right The right token object.
 * @returns {boolean} Whether or not the tokens are on the same line.
 * @public
 */
function isTokenOnSameLine(left, right) {
  return left.loc.end.line === right.loc.start.line;
}

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

module.exports = {
    meta: {
        type: "layout",

        docs: {
            description: "require or disallow an empty line between object properties",
            category: "Stylistic Issues",
            recommended: false,
            url: "https://github.com/jiangfengming/eslint-plugin-ext#lines-between-object-properties"
        },

        fixable: "whitespace",

        schema: [
            {
                enum: ["always", "never"]
            },
            {
                type: "object",
                properties: {
                    exceptAfterSingleLine: {
                        type: "boolean",
                        default: false
                    },
                    exceptBetweenSingleLines: {
                        type: "boolean",
                        default: false
                    }
                },
                additionalProperties: false
            }
        ],
        messages: {
            never: "Unexpected blank line between object properties.",
            always: "Expected blank line between object properties."
        }
    },

    create(context) {

        const options = [];

        options[0] = context.options[0] || "always";
        options[1] = context.options[1] || { exceptAfterSingleLine: false, exceptBetweenSingleLines: false };

        const sourceCode = context.getSourceCode();

        /**
         * Return the last token among the consecutive tokens that have no exceed max line difference in between, before the first token in the next member.
         * @param {Token} prevLastToken The last token in the previous member node.
         * @param {Token} nextFirstToken The first token in the next member node.
         * @param {number} maxLine The maximum number of allowed line difference between consecutive tokens.
         * @returns {Token} The last token among the consecutive tokens.
         */
        function findLastConsecutiveTokenAfter(prevLastToken, nextFirstToken, maxLine) {
            const after = sourceCode.getTokenAfter(prevLastToken, { includeComments: true });

            if (after !== nextFirstToken && after.loc.start.line - prevLastToken.loc.end.line <= maxLine) {
                return findLastConsecutiveTokenAfter(after, nextFirstToken, maxLine);
            }
            return prevLastToken;
        }

        /**
         * Return the first token among the consecutive tokens that have no exceed max line difference in between, after the last token in the previous member.
         * @param {Token} nextFirstToken The first token in the next member node.
         * @param {Token} prevLastToken The last token in the previous member node.
         * @param {number} maxLine The maximum number of allowed line difference between consecutive tokens.
         * @returns {Token} The first token among the consecutive tokens.
         */
        function findFirstConsecutiveTokenBefore(nextFirstToken, prevLastToken, maxLine) {
            const before = sourceCode.getTokenBefore(nextFirstToken, { includeComments: true });

            if (before !== prevLastToken && nextFirstToken.loc.start.line - before.loc.end.line <= maxLine) {
                return findFirstConsecutiveTokenBefore(before, prevLastToken, maxLine);
            }
            return nextFirstToken;
        }

        /**
         * Checks if there is a token or comment between two tokens.
         * @param {Token} before The token before.
         * @param {Token} after The token after.
         * @returns {boolean} True if there is a token or comment between two tokens.
         */
        function hasTokenOrCommentBetween(before, after) {
            return sourceCode.getTokensBetween(before, after, { includeComments: true }).length !== 0;
        }

        return {
            ObjectExpression(node) {
                const properties = node.properties;

                for (let i = 0; i < properties.length - 1; i++) {
                    const curFirst = sourceCode.getFirstToken(properties[i]);
                    const curLast = sourceCode.getLastToken(properties[i]);
                    const nextFirst = sourceCode.getFirstToken(properties[i + 1]);
                    const nextLast = sourceCode.getLastToken(properties[i + 1]);
                    const isMulti = !isTokenOnSameLine(curFirst, curLast);
                    const isNextMulti = !isTokenOnSameLine(nextFirst, nextLast);
                    const skip = !isMulti &&
                        (options[1].exceptAfterSingleLine || (!isNextMulti && options[1].exceptBetweenSingleLines));
                    const beforePadding = findLastConsecutiveTokenAfter(curLast, nextFirst, 1);
                    const afterPadding = findFirstConsecutiveTokenBefore(nextFirst, curLast, 1);
                    const isPadded = afterPadding.loc.start.line - beforePadding.loc.end.line > 1;
                    const hasTokenInPadding = hasTokenOrCommentBetween(beforePadding, afterPadding);
                    const curLineLastToken = findLastConsecutiveTokenAfter(curLast, nextFirst, 0);

                    if ((options[0] === "always" && !skip && !isPadded) ||
                        (options[0] === "never" && isPadded)) {
                        context.report({
                            node: properties[i + 1],
                            messageId: isPadded ? "never" : "always",
                            fix(fixer) {
                                if (hasTokenInPadding) {
                                    return null;
                                }
                                return isPadded
                                    ? fixer.replaceTextRange([beforePadding.range[1], afterPadding.range[0]], "\n")
                                    : fixer.insertTextAfter(curLineLastToken, "\n");
                            }
                        });
                    }
                }
            }
        };
    }
};
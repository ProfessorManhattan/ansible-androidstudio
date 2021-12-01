"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const char_ranges_1 = require("../utils/char-ranges");
const utils_1 = require("../utils");
const mention_1 = require("../utils/mention");
exports.default = (0, utils_1.createRule)("no-obscure-range", {
    meta: {
        docs: {
            description: "disallow obscure character ranges",
            category: "Best Practices",
            recommended: true,
        },
        schema: [
            {
                type: "object",
                properties: {
                    allowed: (0, char_ranges_1.getAllowedCharValueSchema)(),
                },
                additionalProperties: false,
            },
        ],
        messages: {
            unexpected: "Unexpected obscure character range. The characters of {{range}} are not obvious.",
        },
        type: "suggestion",
    },
    create(context) {
        var _a;
        const allowedRanges = (0, char_ranges_1.getAllowedCharRanges)((_a = context.options[0]) === null || _a === void 0 ? void 0 : _a.allowed, context);
        function createVisitor({ node, getRegexpLocation, }) {
            return {
                onCharacterClassRangeEnter(rNode) {
                    const { min, max } = rNode;
                    if (min.value === max.value) {
                        return;
                    }
                    if ((0, utils_1.isControlEscape)(min.raw) && (0, utils_1.isControlEscape)(max.raw)) {
                        return;
                    }
                    if ((0, utils_1.isOctalEscape)(min.raw) && (0, utils_1.isOctalEscape)(max.raw)) {
                        return;
                    }
                    if (((0, utils_1.isUseHexEscape)(min.raw) || min.value === 0) &&
                        (0, utils_1.isUseHexEscape)(max.raw)) {
                        return;
                    }
                    if (!(0, utils_1.isEscapeSequence)(min.raw) &&
                        !(0, utils_1.isEscapeSequence)(max.raw) &&
                        (0, char_ranges_1.inRange)(allowedRanges, min.value, max.value)) {
                        return;
                    }
                    context.report({
                        node,
                        loc: getRegexpLocation(rNode),
                        messageId: "unexpected",
                        data: {
                            range: (0, mention_1.mentionChar)(rNode),
                        },
                    });
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

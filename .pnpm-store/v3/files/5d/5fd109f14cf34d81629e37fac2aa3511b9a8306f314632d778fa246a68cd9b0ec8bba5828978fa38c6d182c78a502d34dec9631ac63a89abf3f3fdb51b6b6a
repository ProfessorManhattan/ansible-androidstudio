"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const refa_1 = require("refa");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const mention_1 = require("../utils/mention");
function groupElements(elements, flags) {
    const duplicates = [];
    const characters = new Map();
    const characterRanges = new Map();
    const characterSets = new Map();
    function addToGroup(group, key, element) {
        const current = group.get(key);
        if (current !== undefined) {
            duplicates.push({ element: current, duplicate: element });
        }
        else {
            group.set(key, element);
        }
    }
    for (const e of elements) {
        const charSet = (0, regexp_ast_analysis_1.toCharSet)(e, flags);
        if (e.type === "Character") {
            const key = charSet.ranges[0].min;
            addToGroup(characters, key, e);
        }
        else if (e.type === "CharacterClassRange") {
            const key = buildRangeKey(charSet);
            addToGroup(characterRanges, key, e);
        }
        else if (e.type === "CharacterSet") {
            const key = e.raw;
            addToGroup(characterSets, key, e);
        }
    }
    return {
        duplicates,
        characters: [...characters.values()],
        characterRanges: [...characterRanges.values()],
        characterSets: [...characterSets.values()],
    };
    function buildRangeKey(rangeCharSet) {
        return rangeCharSet.ranges
            .map((r) => String.fromCodePoint(r.min, r.max))
            .join(",");
    }
}
function inRange({ min, max }, char) {
    return min <= char && char <= max;
}
function fixRemove(context, element) {
    const parent = element.parent;
    if (parent.type !== "CharacterClass") {
        throw new Error("Only call this function for character class elements.");
    }
    return context.fixReplaceNode(element, () => {
        const textBefore = parent.raw.slice(0, element.start - parent.start);
        const textAfter = parent.raw.slice(element.end - parent.start);
        if ((0, utils_1.mightCreateNewElement)(textBefore, textAfter)) {
            return null;
        }
        const elementBefore = parent.elements[parent.elements.indexOf(element) - 1];
        const elementAfter = parent.elements[parent.elements.indexOf(element) + 1];
        if (elementBefore &&
            elementAfter &&
            elementBefore.type === "Character" &&
            elementBefore.raw === "-" &&
            elementAfter.type === "Character") {
            return null;
        }
        if ((textAfter.startsWith("-") &&
            elementBefore &&
            elementBefore.type === "Character") ||
            (textAfter.startsWith("^") && !parent.negate && !elementBefore)) {
            return "\\";
        }
        return "";
    });
}
exports.default = (0, utils_1.createRule)("no-dupe-characters-character-class", {
    meta: {
        type: "suggestion",
        docs: {
            description: "disallow duplicate characters in the RegExp character class",
            category: "Best Practices",
            recommended: true,
        },
        fixable: "code",
        schema: [],
        messages: {
            duplicate: "Unexpected duplicate {{duplicate}}.",
            duplicateNonObvious: "Unexpected duplicate. {{duplicate}} is a duplicate of {{element}}.",
            subset: "{{subsetElement}} is already included in {{element}}.",
            subsetOfMany: "{{subsetElement}} is already included by the elements {{elements}}.",
            overlap: "Unexpected overlap of {{elementA}} and {{elementB}} was found '{{overlap}}'.",
        },
    },
    create(context) {
        function reportDuplicate(regexpContext, duplicate, element) {
            const { node, getRegexpLocation } = regexpContext;
            if (duplicate.raw === element.raw) {
                context.report({
                    node,
                    loc: getRegexpLocation(duplicate),
                    messageId: "duplicate",
                    data: {
                        duplicate: (0, mention_1.mentionChar)(duplicate),
                    },
                    fix: fixRemove(regexpContext, duplicate),
                });
            }
            else {
                context.report({
                    node,
                    loc: getRegexpLocation(duplicate),
                    messageId: "duplicateNonObvious",
                    data: {
                        duplicate: (0, mention_1.mentionChar)(duplicate),
                        element: (0, mention_1.mentionChar)(element),
                    },
                    fix: fixRemove(regexpContext, duplicate),
                });
            }
        }
        function reportOverlap({ node, getRegexpLocation }, element, intersectElement, overlap) {
            context.report({
                node,
                loc: getRegexpLocation(element),
                messageId: "overlap",
                data: {
                    elementA: (0, mention_1.mentionChar)(element),
                    elementB: (0, mention_1.mentionChar)(intersectElement),
                    overlap,
                },
            });
        }
        function reportSubset(regexpContext, subsetElement, element) {
            const { node, getRegexpLocation } = regexpContext;
            context.report({
                node,
                loc: getRegexpLocation(subsetElement),
                messageId: "subset",
                data: {
                    subsetElement: (0, mention_1.mentionChar)(subsetElement),
                    element: (0, mention_1.mentionChar)(element),
                },
                fix: fixRemove(regexpContext, subsetElement),
            });
        }
        function reportSubsetOfMany(regexpContext, subsetElement, elements) {
            const { node, getRegexpLocation } = regexpContext;
            context.report({
                node,
                loc: getRegexpLocation(subsetElement),
                messageId: "subsetOfMany",
                data: {
                    subsetElement: (0, mention_1.mentionChar)(subsetElement),
                    elements: `'${elements
                        .map((e) => e.raw)
                        .join("")}' (${elements.map(mention_1.mentionChar).join(", ")})`,
                },
                fix: fixRemove(regexpContext, subsetElement),
            });
        }
        function createVisitor(regexpContext) {
            const { flags } = regexpContext;
            return {
                onCharacterClassEnter(ccNode) {
                    const { duplicates, characters, characterRanges, characterSets, } = groupElements(ccNode.elements, flags);
                    const rangesAndSets = [...characterRanges, ...characterSets];
                    const subsets = new Set();
                    for (const { element, duplicate } of duplicates) {
                        reportDuplicate(regexpContext, duplicate, element);
                        subsets.add(duplicate);
                    }
                    for (const char of characters) {
                        for (const other of rangesAndSets) {
                            if ((0, regexp_ast_analysis_1.toCharSet)(other, flags).has(char.value)) {
                                reportSubset(regexpContext, char, other);
                                subsets.add(char);
                                break;
                            }
                        }
                    }
                    for (const element of rangesAndSets) {
                        for (const other of rangesAndSets) {
                            if (element === other || subsets.has(other)) {
                                continue;
                            }
                            if ((0, regexp_ast_analysis_1.toCharSet)(element, flags).isSubsetOf((0, regexp_ast_analysis_1.toCharSet)(other, flags))) {
                                reportSubset(regexpContext, element, other);
                                subsets.add(element);
                                break;
                            }
                        }
                    }
                    const characterTotal = (0, regexp_ast_analysis_1.toCharSet)(characters.filter((c) => !subsets.has(c)), flags);
                    for (const element of rangesAndSets) {
                        if (subsets.has(element)) {
                            continue;
                        }
                        const totalOthers = characterTotal.union(...rangesAndSets
                            .filter((e) => !subsets.has(e) && e !== element)
                            .map((e) => (0, regexp_ast_analysis_1.toCharSet)(e, flags)));
                        const elementCharSet = (0, regexp_ast_analysis_1.toCharSet)(element, flags);
                        if (elementCharSet.isSubsetOf(totalOthers)) {
                            const superSetElements = ccNode.elements
                                .filter((e) => !subsets.has(e) && e !== element)
                                .filter((e) => !(0, regexp_ast_analysis_1.toCharSet)(e, flags).isDisjointWith(elementCharSet));
                            reportSubsetOfMany(regexpContext, element, superSetElements);
                            subsets.add(element);
                        }
                    }
                    for (let i = 0; i < characterRanges.length; i++) {
                        const range = characterRanges[i];
                        if (subsets.has(range)) {
                            continue;
                        }
                        for (let j = i + 1; j < rangesAndSets.length; j++) {
                            const other = rangesAndSets[j];
                            if (range === other || subsets.has(other)) {
                                continue;
                            }
                            const intersection = (0, regexp_ast_analysis_1.toCharSet)(range, flags).intersect((0, regexp_ast_analysis_1.toCharSet)(other, flags));
                            if (intersection.isEmpty) {
                                continue;
                            }
                            const interestingRanges = intersection.ranges.filter((r) => inRange(r, range.min.value) ||
                                inRange(r, range.max.value));
                            const interest = refa_1.JS.createCharSet(interestingRanges, flags);
                            if (!interest.isEmpty) {
                                reportOverlap(regexpContext, range, other, (0, utils_1.toCharSetSource)(interest, flags));
                                break;
                            }
                        }
                    }
                },
            };
        }
        return (0, utils_1.defineRegexpVisitor)(context, {
            createVisitor,
        });
    },
});

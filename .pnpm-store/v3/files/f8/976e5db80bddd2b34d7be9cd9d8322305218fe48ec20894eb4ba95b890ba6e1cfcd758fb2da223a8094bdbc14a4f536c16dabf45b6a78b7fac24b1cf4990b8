"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDeterminismEqClasses = exports.canReorder = void 0;
const refa_1 = require("refa");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
const alternative_prefix_1 = require("./regexp-ast/alternative-prefix");
function canReorder(alternatives, flags, options = {}) {
    const { ignoreCapturingGroups = false, matchingDirection } = options;
    const target = asSet(alternatives);
    if (target.size < 2) {
        return true;
    }
    const slice = getAlternativesSlice(target);
    const dir = matchingDirection !== null && matchingDirection !== void 0 ? matchingDirection : (0, regexp_ast_analysis_1.getMatchingDirection)(slice[0]);
    const eqClasses = dir === "unknown"
        ? getDirectionIndependedDeterminismEqClasses(slice, flags)
        : getDeterminismEqClasses(slice, dir, flags);
    if (!ignoreCapturingGroups &&
        !canReorderCapturingGroups(target, slice, eqClasses)) {
        return false;
    }
    return eqClasses.every((eq) => {
        if (eq.length < 2) {
            return true;
        }
        if (eq.every((a) => !target.has(a))) {
            return true;
        }
        return (canReorderBasedOnLength(eq) ||
            canReorderBasedOnConsumedChars(eq, flags));
    });
}
exports.canReorder = canReorder;
function canReorderCapturingGroups(target, slice, eqClasses) {
    const containsCG = cachedFn(containsCapturingGroup);
    let targetCG = 0;
    let nonTargetCG = 0;
    for (const a of slice) {
        if (containsCG(a)) {
            if (target.has(a)) {
                targetCG++;
            }
            else {
                nonTargetCG++;
            }
        }
    }
    if (targetCG > 1 || (targetCG === 1 && nonTargetCG !== 0)) {
        return false;
    }
    if (nonTargetCG !== 0) {
        return eqClasses.every((eq) => {
            return (!eq.some(containsCapturingGroup) ||
                eq.every((a) => !target.has(a)));
        });
    }
    else if (targetCG !== 0) {
        return eqClasses.every((eq) => {
            return eq.length < 2 || !eq.some(containsCapturingGroup);
        });
    }
    return true;
}
function getDeterminismEqClasses(alternatives, dir, flags) {
    if (dir === "unknown") {
        return getDirectionIndependedDeterminismEqClasses(alternatives, flags);
    }
    return getDirectionalDeterminismEqClasses(alternatives, dir, flags);
}
exports.getDeterminismEqClasses = getDeterminismEqClasses;
function getDirectionIndependedDeterminismEqClasses(alternatives, flags) {
    const ltr = getDirectionalDeterminismEqClasses(alternatives, "ltr", flags);
    const rtl = getDirectionalDeterminismEqClasses(alternatives, "rtl", flags);
    const disjoint = mergeOverlappingSets([...ltr, ...rtl], (s) => s);
    const result = [];
    for (const sets of disjoint) {
        const eq = new Set();
        for (const s of sets) {
            s.forEach((a) => eq.add(a));
        }
        result.push([...eq]);
    }
    return result;
}
function getDirectionalDeterminismEqClasses(alternatives, dir, flags) {
    const getPrefixCharSets = cachedFn((a) => {
        let prefix = (0, alternative_prefix_1.getLongestPrefix)(a, dir, flags);
        let all = 0;
        for (let i = prefix.length - 1; i >= 0; i--) {
            if (prefix[i].isAll) {
                all++;
            }
            else {
                break;
            }
        }
        if (all > 0) {
            prefix = prefix.slice(0, prefix.length - all);
        }
        return prefix;
    });
    const allCharSets = new Set();
    for (const a of alternatives) {
        getPrefixCharSets(a).forEach((cs) => allCharSets.add(cs));
    }
    const base = new refa_1.CharBase(allCharSets);
    const prefixes = [];
    for (const a of alternatives) {
        prefixes.push({
            characters: getPrefixCharSets(a).map((cs) => base.split(cs)),
            alternative: a,
        });
    }
    function subdivide(eqClass, index) {
        if (eqClass.length < 2) {
            return [eqClass];
        }
        for (const prefix of eqClass) {
            if (index >= prefix.characters.length) {
                return [eqClass];
            }
        }
        const disjointSets = mergeOverlappingSets(eqClass, (p) => p.characters[index]);
        const result = [];
        for (const set of disjointSets) {
            result.push(...subdivide(set, index + 1));
        }
        return result;
    }
    return subdivide(prefixes, 0).map((eq) => eq.map((p) => p.alternative));
}
class SetEquivalence {
    constructor(count) {
        this.count = count;
        this.indexes = [];
        for (let i = 0; i < count; i++) {
            this.indexes.push(i);
        }
    }
    makeEqual(a, b) {
        let aValue = this.indexes[a];
        let bValue = this.indexes[b];
        while (aValue !== bValue) {
            if (aValue < bValue) {
                this.indexes[b] = aValue;
                b = bValue;
                bValue = this.indexes[b];
            }
            else {
                this.indexes[a] = bValue;
                a = aValue;
                aValue = this.indexes[a];
            }
        }
    }
    getEquivalenceSets() {
        let counter = 0;
        for (let i = 0; i < this.count; i++) {
            if (i === this.indexes[i]) {
                this.indexes[i] = counter++;
            }
            else {
                this.indexes[i] = this.indexes[this.indexes[i]];
            }
        }
        return {
            count: counter,
            indexes: this.indexes,
        };
    }
}
function mergeOverlappingSets(sets, getElements) {
    if (sets.length < 2) {
        return [sets];
    }
    const eq = new SetEquivalence(sets.length);
    const elementMap = new Map();
    for (let i = 0; i < sets.length; i++) {
        const s = sets[i];
        for (const e of getElements(s)) {
            const elementSet = elementMap.get(e);
            if (elementSet === undefined) {
                elementMap.set(e, i);
            }
            else {
                eq.makeEqual(i, elementSet);
            }
        }
    }
    const eqSets = eq.getEquivalenceSets();
    const result = [];
    for (let i = 0; i < eqSets.count; i++) {
        result.push([]);
    }
    for (let i = 0; i < sets.length; i++) {
        result[eqSets.indexes[i]].push(sets[i]);
    }
    return result;
}
function canReorderBasedOnLength(slice) {
    const lengthRange = (0, regexp_ast_analysis_1.getLengthRange)(slice);
    return Boolean(lengthRange && lengthRange.min === lengthRange.max);
}
function canReorderBasedOnConsumedChars(slice, flags) {
    if (slice.some(regexp_ast_analysis_1.isPotentiallyZeroLength)) {
        return false;
    }
    const parent = slice[0].parent;
    if (parent.type === "Pattern" || parent.type === "Assertion") {
        return false;
    }
    const consumedChars = regexp_ast_analysis_1.Chars.empty(flags).union(...slice.map((a) => getConsumedChars(a, flags)));
    return ((0, regexp_ast_analysis_1.getFirstCharAfter)(parent, "rtl", flags).char.isDisjointWith(consumedChars) &&
        (0, regexp_ast_analysis_1.getFirstCharAfter)(parent, "ltr", flags).char.isDisjointWith(consumedChars));
}
function getAlternativesSlice(set) {
    if (set.size <= 1) {
        return [...set];
    }
    let first;
    for (const item of set) {
        first = item;
        break;
    }
    if (!first) {
        throw new Error();
    }
    const parentAlternatives = first.parent.alternatives;
    let min = set.size;
    let max = 0;
    for (let i = 0; i < parentAlternatives.length; i++) {
        const a = parentAlternatives[i];
        if (set.has(a)) {
            min = Math.min(min, i);
            max = Math.max(max, i);
        }
    }
    return parentAlternatives.slice(min, max + 1);
}
function asSet(iter) {
    if (iter instanceof Set) {
        return iter;
    }
    return new Set(iter);
}
function getConsumedChars(element, flags) {
    const sets = [];
    (0, regexp_ast_analysis_1.hasSomeDescendant)(element, (d) => {
        if (d.type === "Character" ||
            d.type === "CharacterClass" ||
            d.type === "CharacterSet") {
            sets.push((0, regexp_ast_analysis_1.toCharSet)(d, flags));
        }
        else if (d.type === "Backreference" && !(0, regexp_ast_analysis_1.isEmptyBackreference)(d)) {
            sets.push(getConsumedChars(d.resolved, flags));
        }
        return false;
    }, (d) => d.type !== "Assertion" && d.type !== "CharacterClass");
    return regexp_ast_analysis_1.Chars.empty(flags).union(...sets);
}
function containsCapturingGroup(node) {
    return (0, regexp_ast_analysis_1.hasSomeDescendant)(node, (d) => d.type === "CapturingGroup");
}
function cachedFn(fn) {
    function wrapper(value) {
        let cached = wrapper.cache.get(value);
        if (cached === undefined) {
            cached = fn(value);
            wrapper.cache.set(value, cached);
        }
        return cached;
    }
    wrapper.cache = new Map();
    return wrapper;
}

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isCoveredNode = void 0;
const is_equals_1 = require("./is-equals");
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
class NormalizedOther {
    constructor(node) {
        this.type = "NormalizedOther";
        this.node = node;
    }
    static fromNode(node) {
        return new NormalizedOther(node);
    }
}
class NormalizedCharacter {
    constructor(charSet) {
        this.type = "NormalizedCharacter";
        this.charSet = charSet;
    }
    static fromElement(element, options) {
        return new NormalizedCharacter((0, regexp_ast_analysis_1.toCharSet)(element, options.flags));
    }
}
class NormalizedAlternative {
    constructor(elements, node) {
        this.type = "NormalizedAlternative";
        this.raw = node.raw;
        this.elements = elements;
    }
    static fromAlternative(node, options) {
        const normalizeElements = [
            ...NormalizedAlternative.normalizedElements(function* () {
                for (const element of node.elements) {
                    const normal = normalizeNode(element, options);
                    if (normal.type === "NormalizedAlternative") {
                        yield* normal.elements;
                    }
                    else {
                        yield normal;
                    }
                }
            }),
        ];
        if (normalizeElements.length === 1) {
            return normalizeElements[0];
        }
        return new NormalizedAlternative(normalizeElements, node);
    }
    static fromQuantifier(node, options) {
        const normalizeElements = [
            ...NormalizedAlternative.normalizedElements(function* () {
                const normalizeElement = normalizeNode(node.element, options);
                for (let index = 0; index < node.min; index++) {
                    yield normalizeElement;
                }
            }),
        ];
        if (normalizeElements.length === 1) {
            return normalizeElements[0];
        }
        return new NormalizedAlternative(normalizeElements, node);
    }
    static fromElements(elements, node) {
        const normalizeElements = [
            ...NormalizedAlternative.normalizedElements(function* () {
                yield* elements;
            }),
        ];
        return new NormalizedAlternative(normalizeElements, node);
    }
    static *normalizedElements(generate) {
        for (const node of generate()) {
            if (node.type === "NormalizedAlternative") {
                yield* node.elements;
            }
            else {
                yield node;
            }
        }
    }
}
class NormalizedDisjunctions {
    constructor(node, options) {
        this.type = "NormalizedDisjunctions";
        this.raw = node.raw;
        this.node = node;
        this.options = options;
    }
    static fromNode(node, options) {
        if (node.alternatives.length === 1) {
            return NormalizedAlternative.fromAlternative(node.alternatives[0], options);
        }
        return new NormalizedDisjunctions(node, options);
    }
    get alternatives() {
        if (this.normalizedAlternatives) {
            return this.normalizedAlternatives;
        }
        this.normalizedAlternatives = [];
        for (const alt of this.node.alternatives) {
            const node = normalizeNode(alt, this.options);
            if (node.type === "NormalizedAlternative") {
                this.normalizedAlternatives.push(node);
            }
            else {
                this.normalizedAlternatives.push(NormalizedAlternative.fromElements([node], alt));
            }
        }
        return this.normalizedAlternatives;
    }
}
class NormalizedLookaroundAssertion {
    constructor(node, options) {
        this.type = "NormalizedLookaroundAssertion";
        this.raw = node.raw;
        this.node = node;
        this.options = options;
    }
    static fromNode(node, options) {
        return new NormalizedLookaroundAssertion(node, options);
    }
    get alternatives() {
        if (this.normalizedAlternatives) {
            return this.normalizedAlternatives;
        }
        this.normalizedAlternatives = [];
        for (const alt of this.node.alternatives) {
            const node = normalizeNode(alt, this.options);
            if (node.type === "NormalizedAlternative") {
                this.normalizedAlternatives.push(node);
            }
            else {
                this.normalizedAlternatives.push(NormalizedAlternative.fromElements([node], alt));
            }
        }
        return this.normalizedAlternatives;
    }
    get kind() {
        return this.node.kind;
    }
    get negate() {
        return this.node.negate;
    }
}
class NormalizedOptional {
    constructor(node, options, max) {
        this.type = "NormalizedOptional";
        this.raw = node.raw;
        this.max = max;
        this.node = node;
        this.options = options;
    }
    static fromQuantifier(node, options) {
        let alt = null;
        if (node.min > 0) {
            alt = NormalizedAlternative.fromQuantifier(node, options);
        }
        const max = node.max - node.min;
        if (max > 0) {
            const optional = new NormalizedOptional(node, options, max);
            if (alt) {
                if (alt.type === "NormalizedAlternative") {
                    return NormalizedAlternative.fromElements([...alt.elements, optional], node);
                }
                return NormalizedAlternative.fromElements([alt, optional], node);
            }
            return optional;
        }
        if (alt) {
            return alt;
        }
        return NormalizedOther.fromNode(node);
    }
    get element() {
        var _a;
        return ((_a = this.normalizedElement) !== null && _a !== void 0 ? _a : (this.normalizedElement = normalizeNode(this.node.element, this.options)));
    }
    decrementMax(dec = 1) {
        if (this.max <= dec) {
            return null;
        }
        if (this.max === Infinity) {
            return this;
        }
        const opt = new NormalizedOptional(this.node, this.options, this.max - dec);
        opt.normalizedElement = this.normalizedElement;
        return opt;
    }
}
function isCoveredNode(left, right, options) {
    const leftNode = normalizeNode(left, options);
    const rightNode = normalizeNode(right, options);
    return isCoveredForNormalizedNode(leftNode, rightNode, options);
}
exports.isCoveredNode = isCoveredNode;
function isCoveredForNormalizedNode(left, right, options) {
    if (right.type === "NormalizedDisjunctions") {
        return right.alternatives.every((r) => isCoveredForNormalizedNode(left, r, options));
    }
    if (left.type === "NormalizedDisjunctions") {
        return isCoveredAnyNode(left.alternatives, right, options);
    }
    if (left.type === "NormalizedAlternative") {
        if (right.type === "NormalizedAlternative") {
            return isCoveredAltNodes(left.elements, right.elements, options);
        }
        return isCoveredAltNodes(left.elements, [right], options);
    }
    else if (right.type === "NormalizedAlternative") {
        return isCoveredAltNodes([left], right.elements, options);
    }
    if (left.type === "NormalizedOptional" ||
        right.type === "NormalizedOptional") {
        return isCoveredAltNodes([left], [right], options);
    }
    if (left.type === "NormalizedOther" || right.type === "NormalizedOther") {
        if (left.type === "NormalizedOther" &&
            right.type === "NormalizedOther") {
            return (0, is_equals_1.isEqualNodes)(left.node, right.node, options.flags);
        }
        return false;
    }
    if (left.type === "NormalizedLookaroundAssertion" ||
        right.type === "NormalizedLookaroundAssertion") {
        if (left.type === "NormalizedLookaroundAssertion" &&
            right.type === "NormalizedLookaroundAssertion") {
            if (left.kind === right.kind && !left.negate && !right.negate) {
                return right.alternatives.every((r) => isCoveredAnyNode(left.alternatives, r, options));
            }
            return (0, is_equals_1.isEqualNodes)(left.node, right.node, options.flags);
        }
        return false;
    }
    if (right.type === "NormalizedCharacter") {
        return right.charSet.isSubsetOf(left.charSet);
    }
    return false;
}
const cacheNormalizeNode = new WeakMap();
function normalizeNode(node, options) {
    let n = cacheNormalizeNode.get(node);
    if (n) {
        return n;
    }
    n = normalizeNodeWithoutCache(node, options);
    cacheNormalizeNode.set(node, n);
    return n;
}
function normalizeNodeWithoutCache(node, options) {
    if (node.type === "CharacterSet" ||
        node.type === "CharacterClass" ||
        node.type === "Character" ||
        node.type === "CharacterClassRange") {
        return NormalizedCharacter.fromElement(node, options);
    }
    if (node.type === "Alternative") {
        return NormalizedAlternative.fromAlternative(node, options);
    }
    if (node.type === "Quantifier") {
        return NormalizedOptional.fromQuantifier(node, options);
    }
    if (node.type === "CapturingGroup" ||
        node.type === "Group" ||
        node.type === "Pattern") {
        return NormalizedDisjunctions.fromNode(node, options);
    }
    if (node.type === "RegExpLiteral") {
        return normalizeNode(node.pattern, options);
    }
    if (node.type === "Assertion") {
        if (node.kind === "lookahead" || node.kind === "lookbehind") {
            return NormalizedLookaroundAssertion.fromNode(node, options);
        }
        return NormalizedOther.fromNode(node);
    }
    return NormalizedOther.fromNode(node);
}
function isCoveredAnyNode(left, right, options) {
    for (const e of left) {
        if (isCoveredForNormalizedNode(e, right, options)) {
            return true;
        }
    }
    return false;
}
function isCoveredAltNodes(leftNodes, rightNodes, options) {
    const left = options.canOmitRight ? omitEnds(leftNodes) : [...leftNodes];
    const right = options.canOmitRight ? omitEnds(rightNodes) : [...rightNodes];
    while (left.length && right.length) {
        const le = left.shift();
        const re = right.shift();
        if (re.type === "NormalizedOptional") {
            if (le.type === "NormalizedOptional") {
                if (!isCoveredForNormalizedNode(le.element, re.element, options)) {
                    return false;
                }
                const decrementLe = le.decrementMax(re.max);
                if (decrementLe) {
                    return isCoveredAltNodes([decrementLe, ...left], right, options);
                }
                const decrementRe = re.decrementMax(le.max);
                if (decrementRe) {
                    return isCoveredAltNodes(left, [decrementRe, ...right], options);
                }
            }
            else {
                if (!isCoveredForNormalizedNode(le, re.element, options)) {
                    return false;
                }
                if (!isCoveredAltNodes([le, ...left], right, options)) {
                    return false;
                }
                const decrementRe = re.decrementMax();
                if (decrementRe) {
                    return isCoveredAltNodes(left, [decrementRe, ...right], options);
                }
            }
        }
        else if (le.type === "NormalizedOptional") {
            if (isCoveredAltNodes(left, [re, ...right], options)) {
                return true;
            }
            if (!isCoveredForNormalizedNode(le.element, re, options)) {
                return false;
            }
            const decrementLe = le.decrementMax();
            if (decrementLe) {
                if (isCoveredAltNodes([decrementLe, ...left], right, options)) {
                    return true;
                }
            }
        }
        else if (!isCoveredForNormalizedNode(le, re, options)) {
            return false;
        }
    }
    if (!options.canOmitRight) {
        if (right.length) {
            return false;
        }
    }
    return !left.length;
}
function omitEnds(nodes) {
    for (let index = nodes.length - 1; index >= 0; index--) {
        const node = nodes[index];
        if (node.type !== "NormalizedOptional") {
            return nodes.slice(0, index + 1);
        }
    }
    return [];
}

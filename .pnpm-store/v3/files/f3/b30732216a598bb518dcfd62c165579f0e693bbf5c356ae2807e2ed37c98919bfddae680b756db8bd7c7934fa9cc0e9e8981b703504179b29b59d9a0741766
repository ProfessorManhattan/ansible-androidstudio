"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isEqualNodes = void 0;
const regexp_ast_analysis_1 = require("regexp-ast-analysis");
function isEqualChar(a, b, flags) {
    if (a.type === "Character") {
        if (b.type === "Character") {
            if (a.value === b.value) {
                return true;
            }
        }
        else if (b.type === "CharacterSet") {
            return false;
        }
    }
    else if (a.type === "CharacterSet") {
        if (b.type === "Character") {
            return false;
        }
        else if (b.type === "CharacterSet") {
            return a.raw === b.raw;
        }
    }
    else if (a.type === "CharacterClassRange") {
        if (b.type === "CharacterClassRange") {
            return a.min.value === b.min.value && a.max.value === b.max.value;
        }
    }
    if (a.raw === b.raw) {
        return true;
    }
    return (0, regexp_ast_analysis_1.toCharSet)(a, flags).equals((0, regexp_ast_analysis_1.toCharSet)(b, flags));
}
const EQUALS_CHECKER = {
    Alternative(a, b, flags, shortCircuit) {
        return isEqualElements(a.elements, b.elements, flags, shortCircuit);
    },
    Assertion(a, b, flags, shortCircuit) {
        if (a.kind === "start" || a.kind === "end") {
            return a.kind === b.kind;
        }
        if (a.kind === "word") {
            return b.kind === "word" && a.negate === b.negate;
        }
        if (a.kind === "lookahead" || a.kind === "lookbehind") {
            if (b.kind === a.kind && a.negate === b.negate) {
                return isEqualAlternatives(a.alternatives, b.alternatives, flags, shortCircuit);
            }
            return false;
        }
        return false;
    },
    Backreference(a, b) {
        return a.ref === b.ref;
    },
    CapturingGroup(a, b, flags, shortCircuit) {
        return (a.name === b.name &&
            isEqualAlternatives(a.alternatives, b.alternatives, flags, shortCircuit));
    },
    Character(a, b, flags) {
        return isEqualChar(a, b, flags);
    },
    CharacterClass(a, b, flags) {
        return isEqualChar(a, b, flags);
    },
    CharacterClassRange(a, b, flags) {
        return isEqualChar(a, b, flags);
    },
    CharacterSet(a, b, flags) {
        return isEqualChar(a, b, flags);
    },
    Flags(a, b) {
        return (a.dotAll === b.dotAll &&
            a.global === b.global &&
            a.ignoreCase === b.ignoreCase &&
            a.multiline === b.multiline &&
            a.sticky === b.sticky &&
            a.unicode === b.unicode);
    },
    Group(a, b, flags, shortCircuit) {
        return isEqualAlternatives(a.alternatives, b.alternatives, flags, shortCircuit);
    },
    Pattern(a, b, flags, shortCircuit) {
        return isEqualAlternatives(a.alternatives, b.alternatives, flags, shortCircuit);
    },
    Quantifier(a, b, flags, shortCircuit) {
        return (a.min === b.min &&
            a.max === b.max &&
            a.greedy === b.greedy &&
            isEqualNodes(a.element, b.element, flags, shortCircuit));
    },
    RegExpLiteral(a, b, flags, shortCircuit) {
        return (isEqualNodes(a.pattern, b.pattern, flags, shortCircuit) &&
            isEqualNodes(a.flags, b.flags, flags, shortCircuit));
    },
};
function isToCharSetElement(node) {
    return (node.type === "Character" ||
        node.type === "CharacterClass" ||
        node.type === "CharacterClassRange" ||
        node.type === "CharacterSet");
}
function isEqualNodes(a, b, flags, shortCircuit) {
    if (isToCharSetElement(a) && isToCharSetElement(b)) {
        return isEqualChar(a, b, flags);
    }
    if (a.type !== b.type) {
        return false;
    }
    if (shortCircuit) {
        const kind = shortCircuit(a, b);
        if (kind != null) {
            return kind;
        }
    }
    if (/[(*+?[\\{|]/u.test(a.raw) || /[(*+?[\\{|]/u.test(b.raw)) {
        return EQUALS_CHECKER[a.type](a, b, flags, shortCircuit);
    }
    return a.raw === b.raw;
}
exports.isEqualNodes = isEqualNodes;
function isEqualElements(a, b, flags, shortCircuit) {
    if (a.length !== b.length) {
        return false;
    }
    for (let index = 0; index < a.length; index++) {
        const ae = a[index];
        const be = b[index];
        if (!isEqualNodes(ae, be, flags, shortCircuit)) {
            return false;
        }
    }
    return true;
}
function isEqualAlternatives(a, b, flags, shortCircuit) {
    if (a.length !== b.length) {
        return false;
    }
    const beList = [...b];
    for (const ae of a) {
        const bIndex = beList.findIndex((be) => isEqualNodes(ae, be, flags, shortCircuit));
        if (bIndex >= 0) {
            beList.splice(bIndex, 1);
        }
        else {
            return false;
        }
    }
    return true;
}

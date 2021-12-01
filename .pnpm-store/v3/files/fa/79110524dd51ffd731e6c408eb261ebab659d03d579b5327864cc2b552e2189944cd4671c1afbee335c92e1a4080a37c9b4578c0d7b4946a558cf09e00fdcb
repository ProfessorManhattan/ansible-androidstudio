"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.extractCapturingGroupReferences = void 0;
const ast_utils_1 = require("./ast-utils");
const extract_property_references_1 = require("./ast-utils/extract-property-references");
const replacements_utils_1 = require("./replacements-utils");
function* extractCapturingGroupReferences(node, flags, typeTracer, countOfCapturingGroup, context, options) {
    const ctx = {
        flags,
        countOfCapturingGroup,
        context,
        isString: options.strictTypes
            ? (n) => typeTracer.isString(n)
            : (n) => typeTracer.maybeString(n),
    };
    for (const ref of (0, ast_utils_1.extractExpressionReferences)(node, context)) {
        if (ref.type === "argument") {
            yield* iterateForArgument(ref.callExpression, ref.node, ctx);
        }
        else if (ref.type === "member") {
            yield* iterateForMember(ref.memberExpression, ref.node, ctx);
        }
        else {
            yield {
                type: "UnknownUsage",
                node: ref.node,
            };
        }
    }
}
exports.extractCapturingGroupReferences = extractCapturingGroupReferences;
function* iterateForArgument(callExpression, argument, ctx) {
    if (!(0, ast_utils_1.isKnownMethodCall)(callExpression, {
        match: 1,
        search: 1,
        replace: 2,
        replaceAll: 2,
        matchAll: 1,
        split: 1,
    })) {
        return;
    }
    if (callExpression.arguments[0] !== argument) {
        return;
    }
    if (!ctx.isString(callExpression.callee.object)) {
        yield {
            type: "UnknownUsage",
            node: argument,
        };
        return;
    }
    if (callExpression.callee.property.name === "match") {
        yield* iterateForStringMatch(callExpression, argument, ctx);
    }
    else if (callExpression.callee.property.name === "search") {
        yield {
            type: "WithoutRef",
            node: argument,
            on: "search",
        };
    }
    else if (callExpression.callee.property.name === "replace" ||
        callExpression.callee.property.name === "replaceAll") {
        yield* iterateForStringReplace(callExpression, argument, ctx, callExpression.callee.property.name);
    }
    else if (callExpression.callee.property.name === "matchAll") {
        yield* iterateForStringMatchAll(callExpression, argument, ctx);
    }
    else if (callExpression.callee.property.name === "split") {
        yield {
            type: "Split",
            node: callExpression,
        };
    }
}
function* iterateForMember(memberExpression, object, ctx) {
    const parent = (0, ast_utils_1.getParent)(memberExpression);
    if (!parent ||
        parent.type !== "CallExpression" ||
        parent.callee !== memberExpression ||
        !(0, ast_utils_1.isKnownMethodCall)(parent, {
            test: 1,
            exec: 1,
        })) {
        return;
    }
    if (parent.callee.property.name === "test") {
        yield {
            type: "WithoutRef",
            node: object,
            on: "test",
        };
    }
    else if (parent.callee.property.name === "exec") {
        yield* iterateForRegExpExec(parent, object, ctx);
    }
}
function* iterateForStringMatch(node, argument, ctx) {
    if (ctx.flags.global) {
        yield {
            type: "WithoutRef",
            node: argument,
            on: "match",
        };
    }
    else {
        let useRet = false;
        for (const ref of iterateForExecResult(node, ctx)) {
            useRet = true;
            yield ref;
        }
        if (!useRet) {
            yield {
                type: "WithoutRef",
                node: argument,
                on: "match",
            };
        }
    }
}
function* iterateForStringReplace(node, argument, ctx, on) {
    const replacementNode = node.arguments[1];
    if (replacementNode.type === "FunctionExpression" ||
        replacementNode.type === "ArrowFunctionExpression") {
        yield* iterateForReplacerFunction(replacementNode, argument, on, ctx);
    }
    else {
        const replacement = node.arguments[1];
        if (!replacement) {
            yield {
                type: "UnknownUsage",
                node: argument,
                on,
            };
            return;
        }
        if (replacement.type === "Literal") {
            yield* verifyForReplaceReplacementLiteral(replacement, argument, on, ctx);
        }
        else {
            const evaluated = (0, ast_utils_1.getStaticValue)(ctx.context, replacement);
            if (!evaluated || typeof evaluated.value !== "string") {
                yield {
                    type: "UnknownUsage",
                    node: argument,
                    on,
                };
                return;
            }
            yield* verifyForReplaceReplacement(evaluated.value, argument, on);
        }
    }
}
function* iterateForStringMatchAll(node, argument, ctx) {
    let useRet = false;
    for (const iterationRef of (0, ast_utils_1.extractPropertyReferences)(node, ctx.context)) {
        if (!iterationRef.extractPropertyReferences) {
            useRet = true;
            yield {
                type: "UnknownUsage",
                node: argument,
                on: "matchAll",
            };
            return;
        }
        if (hasNameRef(iterationRef)) {
            if (Number.isNaN(Number(iterationRef.name))) {
                continue;
            }
        }
        for (const ref of iterationRef.extractPropertyReferences()) {
            if (hasNameRef(ref)) {
                if (ref.name === "groups") {
                    for (const namedRef of ref.extractPropertyReferences()) {
                        useRet = true;
                        yield getNamedArrayRef(namedRef);
                    }
                }
                else {
                    if (ref.name === "input" ||
                        ref.name === "index" ||
                        ref.name === "indices") {
                        continue;
                    }
                    useRet = true;
                    yield getIndexArrayRef(ref);
                }
            }
            else {
                useRet = true;
                yield {
                    type: "UnknownRef",
                    kind: "array",
                    prop: ref,
                };
                return;
            }
        }
    }
    if (!useRet) {
        yield {
            type: "WithoutRef",
            node: argument,
            on: "matchAll",
        };
    }
}
function* iterateForRegExpExec(node, object, ctx) {
    let useRet = false;
    for (const ref of iterateForExecResult(node, ctx)) {
        useRet = true;
        yield ref;
    }
    if (!useRet) {
        yield {
            type: "WithoutRef",
            node: object,
            on: "exec",
        };
    }
}
function* iterateForExecResult(node, ctx) {
    for (const ref of (0, ast_utils_1.extractPropertyReferences)(node, ctx.context)) {
        if (hasNameRef(ref)) {
            if (ref.name === "groups") {
                for (const namedRef of ref.extractPropertyReferences()) {
                    yield getNamedArrayRef(namedRef);
                }
            }
            else {
                if (ref.name === "input" ||
                    ref.name === "index" ||
                    ref.name === "indices") {
                    continue;
                }
                yield getIndexArrayRef(ref);
            }
        }
        else {
            yield {
                type: "UnknownRef",
                kind: "array",
                prop: ref,
            };
            return;
        }
    }
}
function* verifyForReplaceReplacementLiteral(substr, argument, on, ctx) {
    let useReplacement = false;
    for (const replacement of (0, ast_utils_1.parseReplacements)(ctx.context, substr)) {
        if (replacement.type === "ReferenceElement") {
            useReplacement = true;
            if (typeof replacement.ref === "number") {
                yield {
                    type: "ReplacementRef",
                    kind: "index",
                    ref: replacement.ref,
                    range: replacement.range,
                };
            }
            else {
                yield {
                    type: "ReplacementRef",
                    kind: "name",
                    ref: replacement.ref,
                    range: replacement.range,
                };
            }
        }
    }
    if (!useReplacement) {
        yield {
            type: "WithoutRef",
            node: argument,
            on,
        };
    }
}
function* verifyForReplaceReplacement(substr, argument, on) {
    let useReplacement = false;
    for (const replacement of (0, replacements_utils_1.parseReplacementsForString)(substr)) {
        if (replacement.type === "ReferenceElement") {
            useReplacement = true;
            if (typeof replacement.ref === "number") {
                yield {
                    type: "ReplacementRef",
                    kind: "index",
                    ref: replacement.ref,
                };
            }
            else {
                yield {
                    type: "ReplacementRef",
                    kind: "name",
                    ref: replacement.ref,
                };
            }
        }
    }
    if (!useReplacement) {
        yield {
            type: "WithoutRef",
            node: argument,
            on,
        };
    }
}
function* iterateForReplacerFunction(replacementNode, argument, on, ctx) {
    if (replacementNode.params.length < 2 &&
        !replacementNode.params.some((arg) => arg.type === "RestElement")) {
        yield {
            type: "WithoutRef",
            node: argument,
            on,
        };
        return;
    }
    for (let index = 0; index < replacementNode.params.length; index++) {
        const arg = replacementNode.params[index];
        if (arg.type === "RestElement") {
            yield {
                type: "UnknownRef",
                kind: "replacerFunction",
                arg,
            };
            return;
        }
        if (index === 0) {
            continue;
        }
        else if (index <= ctx.countOfCapturingGroup) {
            yield {
                type: "ReplacerFunctionRef",
                kind: "index",
                ref: index,
                arg,
            };
        }
        else if (ctx.countOfCapturingGroup + 3 === index) {
            if (arg.type === "Identifier" || arg.type === "ObjectPattern") {
                for (const ref of (0, extract_property_references_1.extractPropertyReferencesForPattern)(arg, ctx.context)) {
                    if (hasNameRef(ref)) {
                        yield {
                            type: "ReplacerFunctionRef",
                            kind: "name",
                            ref: ref.name,
                            prop: ref,
                        };
                    }
                    else {
                        yield {
                            type: "ReplacerFunctionRef",
                            kind: "name",
                            ref: null,
                            prop: ref,
                            arg: null,
                        };
                    }
                }
            }
            else {
                yield {
                    type: "ReplacerFunctionRef",
                    kind: "name",
                    ref: null,
                    arg,
                    prop: null,
                };
            }
        }
    }
}
function hasNameRef(ref) {
    return ref.type === "destructuring" || ref.type === "member";
}
function getIndexArrayRef(ref) {
    const numRef = Number(ref.name);
    if (Number.isFinite(numRef)) {
        return {
            type: "ArrayRef",
            kind: "index",
            ref: numRef,
            prop: ref,
        };
    }
    return {
        type: "ArrayRef",
        kind: "index",
        ref: null,
        prop: ref,
    };
}
function getNamedArrayRef(namedRef) {
    if (hasNameRef(namedRef)) {
        return {
            type: "ArrayRef",
            kind: "name",
            ref: namedRef.name,
            prop: namedRef,
        };
    }
    return {
        type: "ArrayRef",
        kind: "name",
        ref: null,
        prop: namedRef,
    };
}

"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __spreadArray = (this && this.__spreadArray) || function (to, from) {
    for (var i = 0, il = from.length, j = to.length; i < il; i++, j++)
        to[j] = from[i];
    return to;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.printArrayList = exports.isUniqueMethodInvocation = exports.sortImports = exports.isStatementEmptyStatement = exports.isShiftOperator = exports.separateTokensIntoGroups = exports.putIntoBraces = exports.getInterfaceBodyDeclarationsSeparator = exports.getClassBodyDeclarationsSeparator = exports.getBlankLinesSeparator = exports.isExplicitLambdaParameter = exports.displaySemicolon = exports.findDeepElementInPartsArray = exports.sortModifiers = exports.sortClassTypeChildren = exports.matchCategory = exports.sortNodes = exports.sortAnnotationIdentifier = exports.rejectAndConcat = exports.rejectAndJoin = exports.rejectSeparators = exports.reject = exports.rejectAndJoinSeps = exports.buildFqn = void 0;
var forEach_1 = __importDefault(require("lodash/forEach"));
var forEachRight_1 = __importDefault(require("lodash/forEachRight"));
var findLastIndex_1 = __importDefault(require("lodash/findLastIndex"));
var findIndex_1 = __importDefault(require("lodash/findIndex"));
var includes_1 = __importDefault(require("lodash/includes"));
var prettier_builder_1 = require("./prettier-builder");
var format_comments_1 = require("./comments/format-comments");
var comments_utils_1 = require("./comments/comments-utils");
var doc_1 = require("prettier/doc");
var utils_1 = require("../types/utils");
var indent = doc_1.builders.indent, hardline = doc_1.builders.hardline, line = doc_1.builders.line;
var isConcat = doc_1.utils.isConcat;
var orderedModifiers = [
    "Public",
    "Protected",
    "Private",
    "Abstract",
    "Default",
    "Static",
    "Final",
    "Transient",
    "Volatile",
    "Synchronized",
    "Native",
    "Sealed",
    "NonSealed",
    "Strictfp"
];
function buildFqn(tokens, dots) {
    return rejectAndJoinSeps(dots ? dots : [], tokens);
}
exports.buildFqn = buildFqn;
function rejectAndJoinSeps(sepTokens, elems, sep) {
    if (!Array.isArray(sepTokens)) {
        return rejectAndJoin(sepTokens, elems);
    }
    var actualElements = reject(elems);
    var res = [];
    for (var i = 0; i < sepTokens.length; i++) {
        res.push(actualElements[i], sepTokens[i]);
        if (sep) {
            res.push(sep);
        }
    }
    res.push.apply(res, actualElements.slice(sepTokens.length));
    return prettier_builder_1.concat(res);
}
exports.rejectAndJoinSeps = rejectAndJoinSeps;
function reject(elems) {
    return elems.filter(function (item) {
        if (typeof item === "string") {
            return item !== "";
        }
        // eslint-ignore next - We want the conversion to boolean!
        // @ts-ignore
        return item != false && item !== undefined;
    });
}
exports.reject = reject;
function rejectSeparators(separators, elems) {
    var realElements = reject(elems);
    var realSeparators = [];
    for (var i = 0; i < realElements.length - 1; i++) {
        if (realElements[i] !== "") {
            realSeparators.push(separators[i]);
        }
    }
    return realSeparators;
}
exports.rejectSeparators = rejectSeparators;
function rejectAndJoin(sep, elems) {
    var actualElements = reject(elems);
    return prettier_builder_1.join(sep, actualElements);
}
exports.rejectAndJoin = rejectAndJoin;
function rejectAndConcat(elems) {
    var actualElements = reject(elems);
    return prettier_builder_1.concat(actualElements);
}
exports.rejectAndConcat = rejectAndConcat;
function sortAnnotationIdentifier(annotations, identifiers) {
    var tokens = __spreadArray([], identifiers);
    if (annotations && annotations.length > 0) {
        tokens = __spreadArray(__spreadArray([], tokens), annotations);
    }
    return tokens.sort(function (a, b) {
        var startOffset1 = utils_1.isCstNode(a)
            ? a.children.At[0].startOffset
            : a.startOffset;
        var startOffset2 = utils_1.isCstNode(b)
            ? b.children.At[0].startOffset
            : b.startOffset;
        return startOffset1 - startOffset2;
    });
}
exports.sortAnnotationIdentifier = sortAnnotationIdentifier;
function sortTokens(values) {
    var tokens = [];
    forEach_1.default(values, function (argument) {
        if (argument) {
            tokens = tokens.concat(argument);
        }
    });
    return tokens.sort(function (a, b) {
        return a.startOffset - b.startOffset;
    });
}
function sortNodes(values) {
    var nodes = [];
    forEach_1.default(values, function (argument) {
        if (argument) {
            nodes = nodes.concat(argument);
        }
    });
    return nodes.sort(function (a, b) {
        var aOffset = a.location.startOffset;
        var bOffset = b.location.startOffset;
        return aOffset - bOffset;
    });
}
exports.sortNodes = sortNodes;
function matchCategory(token, categoryName) {
    var labels = (token.tokenType.CATEGORIES || []).map(function (category) {
        return category.LABEL;
    });
    return labels.indexOf(categoryName) !== -1;
}
exports.matchCategory = matchCategory;
function sortClassTypeChildren(annotations, typeArguments, identifiers, dots) {
    var tokens = __spreadArray([], identifiers);
    if (annotations && annotations.length > 0) {
        tokens = __spreadArray(__spreadArray([], tokens), annotations);
    }
    if (typeArguments && typeArguments.length > 0) {
        tokens = __spreadArray(__spreadArray([], tokens), typeArguments);
    }
    if (dots && dots.length > 0) {
        tokens = __spreadArray(__spreadArray([], tokens), dots);
    }
    return tokens.sort(function (a, b) {
        var startOffsetA = utils_1.isCstNode(a)
            ? a.children.At
                ? a.children.At[0].startOffset
                : a.children.Less[0].startOffset
            : a.startOffset;
        var startOffsetB = utils_1.isCstNode(b)
            ? b.children.At
                ? b.children.At[0].startOffset
                : b.children.Less[0].startOffset
            : b.startOffset;
        return startOffsetA - startOffsetB;
    });
}
exports.sortClassTypeChildren = sortClassTypeChildren;
function sortModifiers(modifiers) {
    var firstAnnotations = [];
    var otherModifiers = [];
    var lastAnnotations = [];
    var hasOtherModifier = false;
    /**
     * iterate in reverse order because we special-case
     * method annotations which come after all other
     * modifiers
     */
    forEachRight_1.default(modifiers, function (modifier) {
        var isAnnotation = modifier.children.annotation !== undefined;
        var isMethodAnnotation = isAnnotation &&
            (modifier.name === "methodModifier" ||
                modifier.name === "interfaceMethodModifier");
        if (isAnnotation) {
            if (isMethodAnnotation && !hasOtherModifier) {
                lastAnnotations.unshift(modifier);
            }
            else {
                firstAnnotations.unshift(modifier);
            }
        }
        else {
            otherModifiers.unshift(modifier);
            hasOtherModifier = true;
        }
    });
    /**
     * if there are only annotations, move everything from
     * lastAnnotations to firstAnnotations
     */
    if (!hasOtherModifier) {
        firstAnnotations = firstAnnotations.concat(lastAnnotations);
        lastAnnotations = [];
    }
    otherModifiers.sort(function (a, b) {
        var modifierIndexA = orderedModifiers.indexOf(Object.keys(a.children)[0]);
        var modifierIndexB = orderedModifiers.indexOf(Object.keys(b.children)[0]);
        return modifierIndexA - modifierIndexB;
    });
    return [firstAnnotations, otherModifiers.concat(lastAnnotations)];
}
exports.sortModifiers = sortModifiers;
function findDeepElementInPartsArray(item, elt) {
    if (Array.isArray(item)) {
        if (includes_1.default(item, elt)) {
            return true;
        }
        for (var i = 0; i < item.length; i++) {
            if (findDeepElementInPartsArray(item[i], elt)) {
                return true;
            }
        }
    }
    else {
        for (var key in item) {
            if (typeof item[key] === "object" &&
                findDeepElementInPartsArray(item[key], elt)) {
                return true;
            }
        }
    }
    return false;
}
exports.findDeepElementInPartsArray = findDeepElementInPartsArray;
function displaySemicolon(token, params) {
    if (params !== undefined && params.allowEmptyStatement) {
        return format_comments_1.printTokenWithComments(token);
    }
    if (!comments_utils_1.hasComments(token)) {
        return "";
    }
    token.image = "";
    return format_comments_1.printTokenWithComments(token);
}
exports.displaySemicolon = displaySemicolon;
function isExplicitLambdaParameter(ctx) {
    return (ctx &&
        ctx.lambdaParameterList &&
        ctx.lambdaParameterList[0] &&
        ctx.lambdaParameterList[0].children &&
        ctx.lambdaParameterList[0].children.explicitLambdaParameterList);
}
exports.isExplicitLambdaParameter = isExplicitLambdaParameter;
function getBlankLinesSeparator(ctx, separator) {
    if (separator === void 0) { separator = hardline; }
    if (ctx === undefined) {
        return undefined;
    }
    var separators = [];
    for (var i = 0; i < ctx.length - 1; i++) {
        var node = ctx[i];
        var previousRuleEndLineWithComment = comments_utils_1.hasTrailingComments(node)
            ? node.trailingComments[node.trailingComments.length - 1].endLine
            : node.location.endLine;
        var nextNode = ctx[i + 1];
        var nextRuleStartLineWithComment = comments_utils_1.hasLeadingComments(nextNode)
            ? nextNode.leadingComments[0].startLine
            : nextNode.location.startLine;
        if (nextRuleStartLineWithComment - previousRuleEndLineWithComment > 1) {
            separators.push(prettier_builder_1.concat([hardline, hardline]));
        }
        else {
            separators.push(separator);
        }
    }
    return separators;
}
exports.getBlankLinesSeparator = getBlankLinesSeparator;
function getDeclarationsSeparator(declarations, needLineDeclaration, isSemicolon) {
    var declarationsWithoutEmptyStatements = declarations.filter(function (declaration) { return !isSemicolon(declaration); });
    var userBlankLinesSeparators = getBlankLinesSeparator(declarationsWithoutEmptyStatements);
    var additionalBlankLines = declarationsWithoutEmptyStatements.map(needLineDeclaration);
    var separators = [];
    var indexNextNotEmptyDeclaration = 0;
    for (var i = 0; i < declarations.length - 1; i++) {
        // if the empty statement has comments
        // we want to print them on their own line
        if (isSemicolon(declarations[i])) {
            if (comments_utils_1.hasComments(declarations[i])) {
                separators.push(hardline);
            }
        }
        else if (indexNextNotEmptyDeclaration <
            declarationsWithoutEmptyStatements.length - 1) {
            var isTwoHardLines = 
            // @ts-ignore
            userBlankLinesSeparators[indexNextNotEmptyDeclaration].parts[0].type ===
                "concat";
            var additionalSep = !isTwoHardLines &&
                (additionalBlankLines[indexNextNotEmptyDeclaration + 1] ||
                    additionalBlankLines[indexNextNotEmptyDeclaration])
                ? hardline
                : "";
            separators.push(prettier_builder_1.concat([
                userBlankLinesSeparators[indexNextNotEmptyDeclaration],
                additionalSep
            ]));
            indexNextNotEmptyDeclaration += 1;
        }
    }
    return separators;
}
function needLineClassBodyDeclaration(declaration) {
    if (declaration.children.classMemberDeclaration === undefined) {
        return true;
    }
    var classMemberDeclaration = declaration.children.classMemberDeclaration[0];
    if (classMemberDeclaration.children.fieldDeclaration !== undefined) {
        var fieldDeclaration = classMemberDeclaration.children.fieldDeclaration[0];
        if (fieldDeclaration.children.fieldModifier !== undefined &&
            hasAnnotation(fieldDeclaration.children.fieldModifier)) {
            return true;
        }
        return false;
    }
    else if (classMemberDeclaration.children.Semicolon !== undefined) {
        return false;
    }
    return true;
}
function needLineInterfaceMemberDeclaration(declaration) {
    if (declaration.children.constantDeclaration !== undefined) {
        var constantDeclaration = declaration.children.constantDeclaration[0];
        if (constantDeclaration.children.constantModifier !== undefined &&
            hasAnnotation(constantDeclaration.children.constantModifier)) {
            return true;
        }
        return false;
    }
    else if (declaration.children.interfaceMethodDeclaration !== undefined) {
        var interfaceMethodDeclaration = declaration.children.interfaceMethodDeclaration[0];
        if (interfaceMethodDeclaration.children.interfaceMethodModifier !==
            undefined &&
            hasNonTrailingAnnotation(interfaceMethodDeclaration.children.interfaceMethodModifier)) {
            return true;
        }
        return false;
    }
    return true;
}
function isClassBodyDeclarationASemicolon(classBodyDeclaration) {
    if (classBodyDeclaration.children.classMemberDeclaration) {
        if (classBodyDeclaration.children.classMemberDeclaration[0].children
            .Semicolon !== undefined) {
            return true;
        }
    }
    return false;
}
function isInterfaceMemberASemicolon(interfaceMemberDeclaration) {
    return interfaceMemberDeclaration.children.Semicolon !== undefined;
}
function hasAnnotation(modifiers) {
    return modifiers.some(function (modifier) { return modifier.children.annotation !== undefined; });
}
/**
 * Return true if there is a method modifier that does not come after all other modifiers
 * It is useful to know if sortModifiers will add an annotation before other modifiers
 *
 * @param methodModifiers
 * @returns {boolean}
 */
function hasNonTrailingAnnotation(methodModifiers) {
    var firstAnnotationIndex = findIndex_1.default(methodModifiers, function (modifier) { return modifier.children.annotation !== undefined; });
    var lastNonAnnotationIndex = findLastIndex_1.default(methodModifiers, function (modifier) { return modifier.children.annotation === undefined; });
    return (firstAnnotationIndex < lastNonAnnotationIndex ||
        lastNonAnnotationIndex === -1);
}
function getClassBodyDeclarationsSeparator(classBodyDeclarationContext) {
    return getDeclarationsSeparator(classBodyDeclarationContext, needLineClassBodyDeclaration, isClassBodyDeclarationASemicolon);
}
exports.getClassBodyDeclarationsSeparator = getClassBodyDeclarationsSeparator;
function getInterfaceBodyDeclarationsSeparator(interfaceMemberDeclarationContext) {
    return getDeclarationsSeparator(interfaceMemberDeclarationContext, needLineInterfaceMemberDeclaration, isInterfaceMemberASemicolon);
}
exports.getInterfaceBodyDeclarationsSeparator = getInterfaceBodyDeclarationsSeparator;
function putIntoBraces(argument, separator, LBrace, RBrace) {
    var rightBraceLeadingComments = format_comments_1.getTokenLeadingComments(RBrace);
    var lastBreakLine = 
    // check if last element of the array is a line
    rightBraceLeadingComments.length !== 0 &&
        rightBraceLeadingComments[rightBraceLeadingComments.length - 1] === hardline
        ? rightBraceLeadingComments.pop()
        : separator;
    delete RBrace.leadingComments;
    var contentInsideBraces;
    if (argument === undefined || argument === "") {
        if (rightBraceLeadingComments.length === 0) {
            return prettier_builder_1.concat([LBrace, RBrace]);
        }
        contentInsideBraces = __spreadArray([separator], rightBraceLeadingComments);
    }
    else if (rightBraceLeadingComments.length !== 0) {
        contentInsideBraces = __spreadArray([
            separator,
            argument,
            separator
        ], rightBraceLeadingComments);
    }
    else {
        contentInsideBraces = [separator, argument];
    }
    return prettier_builder_1.group(rejectAndConcat([
        LBrace,
        indent(prettier_builder_1.concat(contentInsideBraces)),
        lastBreakLine,
        RBrace
    ]));
}
exports.putIntoBraces = putIntoBraces;
var andOrBinaryOperators = ["&&", "||", "&", "|", "^"];
function separateTokensIntoGroups(ctx) {
    /**
     * separate tokens into groups by andOrBinaryOperators ("&&", "||", "&", "|", "^")
     * in order to break those operators in priority.
     */
    var tokens = sortTokens([
        ctx.Instanceof,
        ctx.AssignmentOperator,
        ctx.Less,
        ctx.Greater,
        ctx.BinaryOperator
    ]);
    var groupsOfOperator = [];
    var sortedBinaryOperators = [];
    var tmpGroup = [];
    tokens.forEach(function (token) {
        if (matchCategory(token, "'BinaryOperator'") &&
            includes_1.default(andOrBinaryOperators, token.image)) {
            sortedBinaryOperators.push(token);
            groupsOfOperator.push(tmpGroup);
            tmpGroup = [];
        }
        else {
            tmpGroup.push(token);
        }
    });
    groupsOfOperator.push(tmpGroup);
    return {
        groupsOfOperator: groupsOfOperator,
        sortedBinaryOperators: sortedBinaryOperators
    };
}
exports.separateTokensIntoGroups = separateTokensIntoGroups;
function isShiftOperator(tokens, index) {
    if (tokens.length <= index + 1) {
        return "none";
    }
    if (tokens[index].image === "<" &&
        tokens[index + 1].image === "<" &&
        tokens[index].startOffset === tokens[index + 1].startOffset - 1) {
        return "leftShift";
    }
    if (tokens[index].image === ">" &&
        tokens[index + 1].image === ">" &&
        tokens[index].startOffset === tokens[index + 1].startOffset - 1) {
        if (tokens.length > index + 2 &&
            tokens[index + 2].image === ">" &&
            tokens[index + 1].startOffset === tokens[index + 2].startOffset - 1) {
            return "doubleRightShift";
        }
        return "rightShift";
    }
    return "none";
}
exports.isShiftOperator = isShiftOperator;
function isStatementEmptyStatement(statement) {
    return (statement === ";" ||
        // @ts-ignore
        (isConcat(statement) && statement.parts[0] === ";"));
}
exports.isStatementEmptyStatement = isStatementEmptyStatement;
function sortImports(imports) {
    var staticImports = [];
    var nonStaticImports = [];
    if (imports !== undefined) {
        for (var i = 0; i < imports.length; i++) {
            if (imports[i].children.Static !== undefined) {
                staticImports.push(imports[i]);
            }
            else if (imports[i].children.emptyStatement === undefined) {
                nonStaticImports.push(imports[i]);
            }
        }
        // TODO: Could be optimized as we could expect that the array is already almost sorted
        var comparator = function (first, second) {
            return compareFqn(first.children.packageOrTypeName[0], second.children.packageOrTypeName[0]);
        };
        staticImports.sort(comparator);
        nonStaticImports.sort(comparator);
    }
    return {
        staticImports: staticImports,
        nonStaticImports: nonStaticImports
    };
}
exports.sortImports = sortImports;
function compareFqn(packageOrTypeNameFirst, packageOrTypeNameSecond) {
    var identifiersFirst = packageOrTypeNameFirst.children.Identifier;
    var identifiersSecond = packageOrTypeNameSecond.children.Identifier;
    var minParts = Math.min(identifiersFirst.length, identifiersSecond.length);
    for (var i = 0; i < minParts; i++) {
        if (identifiersFirst[i].image < identifiersSecond[i].image) {
            return -1;
        }
        else if (identifiersFirst[i].image > identifiersSecond[i].image) {
            return 1;
        }
    }
    if (identifiersFirst.length < identifiersSecond.length) {
        return -1;
    }
    else if (identifiersFirst.length > identifiersSecond.length) {
        return 1;
    }
    return 0;
}
function isUniqueMethodInvocation(primarySuffixes) {
    if (primarySuffixes === undefined) {
        return 0;
    }
    var count = 0;
    primarySuffixes.forEach(function (primarySuffix) {
        if (primarySuffix.children.methodInvocationSuffix !== undefined) {
            count++;
            if (count > 1) {
                return 2;
            }
        }
    });
    return count;
}
exports.isUniqueMethodInvocation = isUniqueMethodInvocation;
function printArrayList(_a) {
    var list = _a.list, extraComma = _a.extraComma, LCurly = _a.LCurly, RCurly = _a.RCurly, trailingComma = _a.trailingComma;
    var optionalComma;
    if (trailingComma !== "none" && list !== "") {
        optionalComma = extraComma
            ? prettier_builder_1.ifBreak(extraComma[0], __assign(__assign({}, extraComma[0]), { image: "" }))
            : prettier_builder_1.ifBreak(",", "");
    }
    else {
        optionalComma = extraComma ? __assign(__assign({}, extraComma[0]), { image: "" }) : "";
    }
    return putIntoBraces(rejectAndConcat([list, optionalComma]), line, LCurly, RCurly);
}
exports.printArrayList = printArrayList;

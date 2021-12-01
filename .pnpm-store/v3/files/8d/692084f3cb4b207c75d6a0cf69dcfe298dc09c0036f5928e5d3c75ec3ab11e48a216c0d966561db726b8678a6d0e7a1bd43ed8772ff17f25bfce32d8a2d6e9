"use strict";
var prettier = require("prettier").doc.builders;
var processComments = require("./comments/format-comments").processComments;
/*
 * ------------------------------------------------------------------
 * Wraps the Prettier builder functions to print tokens with comments
 * ------------------------------------------------------------------
 */
function concat(docs) {
    var concatenation = prettier.concat(processComments(docs));
    return concatenation.parts.length === 0 ? "" : concatenation;
}
function join(sep, docs) {
    var concatenation = prettier.join(processComments(sep), processComments(docs));
    return concatenation.parts.length === 0 ? "" : concatenation;
}
function group(doc, opts) {
    var group = prettier.group(processComments(doc), opts);
    return group.contents === undefined ? "" : group;
}
function fill(docs) {
    var fill = prettier.fill(processComments(docs));
    return fill.parts.length === 0 ? "" : fill;
}
function indent(doc) {
    var indentedDoc = prettier.indent(processComments(doc));
    return indentedDoc.contents.length === 0 ? "" : indentedDoc;
}
function dedent(doc) {
    var indentedDoc = prettier.dedent(processComments(doc));
    return indentedDoc.contents.length === 0 ? "" : indentedDoc;
}
function ifBreak(breakContents, flatContents) {
    return prettier.ifBreak(processComments(breakContents), processComments(flatContents));
}
module.exports = {
    concat: concat,
    join: join,
    group: group,
    fill: fill,
    indent: indent,
    dedent: dedent,
    ifBreak: ifBreak
};

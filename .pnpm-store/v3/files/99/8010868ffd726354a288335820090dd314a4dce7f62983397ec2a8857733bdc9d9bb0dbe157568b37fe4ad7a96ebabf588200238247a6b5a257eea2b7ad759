"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ruleCreator = exports.escapeRegExp = exports.createRegExpForWords = void 0;
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
function createRegExpForWords(config) {
    if (!config || !config.length) {
        return undefined;
    }
    const flags = "i";
    if (typeof config === "string") {
        return new RegExp(config, flags);
    }
    const words = config;
    const joined = words.map((word) => String.raw `(\b|_)${word}(\b|_)`).join("|");
    return new RegExp(`(${joined})`, flags);
}
exports.createRegExpForWords = createRegExpForWords;
function escapeRegExp(text) {
    return text.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
}
exports.escapeRegExp = escapeRegExp;
exports.ruleCreator = experimental_utils_1.ESLintUtils.RuleCreator((name) => `https://github.com/cartant/eslint-plugin-rxjs/tree/main/docs/rules/${name}.md`);

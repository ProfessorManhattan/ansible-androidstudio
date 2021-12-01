"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const rules_1 = require("./utils/rules");
const recommended_1 = __importDefault(require("./configs/recommended"));
const all_1 = __importDefault(require("./configs/all"));
const configs = {
    recommended: recommended_1.default,
    all: all_1.default,
};
const rules = rules_1.rules.reduce((obj, r) => {
    obj[r.meta.docs.ruleName] = r;
    return obj;
}, {});
module.exports = {
    configs,
    rules,
};

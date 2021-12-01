"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const no_useless_lazy_1 = __importDefault(require("./no-useless-lazy"));
exports.default = (0, utils_1.createRule)("no-useless-non-greedy", {
    meta: Object.assign(Object.assign({}, no_useless_lazy_1.default.meta), { docs: Object.assign(Object.assign({}, no_useless_lazy_1.default.meta.docs), { recommended: false, replacedBy: ["no-useless-lazy"] }), deprecated: true }),
    create(context) {
        return no_useless_lazy_1.default.create(context);
    },
});

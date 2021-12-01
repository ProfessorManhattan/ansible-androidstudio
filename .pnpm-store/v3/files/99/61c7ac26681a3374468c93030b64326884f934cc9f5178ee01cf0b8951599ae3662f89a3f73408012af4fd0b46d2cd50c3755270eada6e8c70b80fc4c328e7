"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const no_empty_capturing_group_1 = __importDefault(require("./no-empty-capturing-group"));
exports.default = (0, utils_1.createRule)("no-assertion-capturing-group", {
    meta: Object.assign(Object.assign({}, no_empty_capturing_group_1.default.meta), { docs: Object.assign(Object.assign({}, no_empty_capturing_group_1.default.meta.docs), { recommended: false, replacedBy: ["no-empty-capturing-group"] }), deprecated: true }),
    create(context) {
        return no_empty_capturing_group_1.default.create(context);
    },
});

"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const sort_character_class_elements_1 = __importDefault(require("./sort-character-class-elements"));
exports.default = (0, utils_1.createRule)("order-in-character-class", {
    meta: Object.assign(Object.assign({}, sort_character_class_elements_1.default.meta), { docs: Object.assign(Object.assign({}, sort_character_class_elements_1.default.meta.docs), { recommended: false, replacedBy: ["sort-character-class-elements"] }), deprecated: true }),
    create(context) {
        return sort_character_class_elements_1.default.create(context);
    },
});

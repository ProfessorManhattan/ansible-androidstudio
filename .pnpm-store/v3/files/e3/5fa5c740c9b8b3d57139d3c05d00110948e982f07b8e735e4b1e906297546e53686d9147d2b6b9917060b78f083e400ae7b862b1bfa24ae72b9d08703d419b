"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isAngularInterpolation = exports.isAngularDirective = exports.isAngularAction = exports.isAngularBinding = void 0;
const common_1 = require("./common");
function isAngularBinding(name) {
    return name.length >= 3 && name[0] === '[' && name[name.length - 1] === ']';
}
exports.isAngularBinding = isAngularBinding;
function isAngularAction(name) {
    return name.length >= 3 && name[0] === '(' && name[name.length - 1] === ')';
}
exports.isAngularAction = isAngularAction;
function isAngularDirective(name) {
    return name.length >= 2 && name[0] === '*';
}
exports.isAngularDirective = isAngularDirective;
function isAngularInterpolation(val) {
    return val.length >= 5 && (0, common_1.isQuoted)(val) && (0, common_1.isWrappedWith)(val, '{{', '}}', 1) && !val.includes('{{', 3);
}
exports.isAngularInterpolation = isAngularInterpolation;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYW5ndWxhci5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uL3NyYy91dGlscy9hbmd1bGFyLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLHFDQUFtRDtBQW1CbkQsU0FBZ0IsZ0JBQWdCLENBQUMsSUFBWTtJQUM1QyxPQUFPLElBQUksQ0FBQyxNQUFNLElBQUksQ0FBQyxJQUFJLElBQUksQ0FBQyxDQUFDLENBQUMsS0FBSyxHQUFHLElBQUksSUFBSSxDQUFDLElBQUksQ0FBQyxNQUFNLEdBQUcsQ0FBQyxDQUFDLEtBQUssR0FBRyxDQUFDO0FBQzdFLENBQUM7QUFGRCw0Q0FFQztBQW1CRCxTQUFnQixlQUFlLENBQUMsSUFBWTtJQUMzQyxPQUFPLElBQUksQ0FBQyxNQUFNLElBQUksQ0FBQyxJQUFJLElBQUksQ0FBQyxDQUFDLENBQUMsS0FBSyxHQUFHLElBQUksSUFBSSxDQUFDLElBQUksQ0FBQyxNQUFNLEdBQUcsQ0FBQyxDQUFDLEtBQUssR0FBRyxDQUFDO0FBQzdFLENBQUM7QUFGRCwwQ0FFQztBQW1CRCxTQUFnQixrQkFBa0IsQ0FBQyxJQUFZO0lBQzlDLE9BQU8sSUFBSSxDQUFDLE1BQU0sSUFBSSxDQUFDLElBQUksSUFBSSxDQUFDLENBQUMsQ0FBQyxLQUFLLEdBQUcsQ0FBQztBQUM1QyxDQUFDO0FBRkQsZ0RBRUM7QUFtQkQsU0FBZ0Isc0JBQXNCLENBQUMsR0FBVztJQUNqRCxPQUFPLEdBQUcsQ0FBQyxNQUFNLElBQUksQ0FBQyxJQUFJLElBQUEsaUJBQVEsRUFBQyxHQUFHLENBQUMsSUFBSSxJQUFBLHNCQUFhLEVBQUMsR0FBRyxFQUFFLElBQUksRUFBRSxJQUFJLEVBQUUsQ0FBQyxDQUFDLElBQUksQ0FBQyxHQUFHLENBQUMsUUFBUSxDQUFDLElBQUksRUFBRSxDQUFDLENBQUMsQ0FBQztBQUN4RyxDQUFDO0FBRkQsd0RBRUMifQ==
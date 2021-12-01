"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isVueVOnExpression = exports.isVueVBindExpression = exports.isVueVForWithOf = exports.isVueExpression = exports.isVueEventBinding = void 0;
function isVueEventBinding(name) {
    return /^(v-on:|@).*/.test(name);
}
exports.isVueEventBinding = isVueEventBinding;
function isVueExpression(name) {
    return /^((v-(bind|slot))?:|v-(model|slot|if|for|else-if|text|html|t)|#).*/.test(name);
}
exports.isVueExpression = isVueExpression;
function isVueVForWithOf(name, val) {
    return 'v-for' === name && val.includes('of');
}
exports.isVueVForWithOf = isVueVForWithOf;
function isVueVBindExpression(name) {
    return 'v-bind' === name;
}
exports.isVueVBindExpression = isVueVBindExpression;
function isVueVOnExpression(name) {
    return 'v-on' === name;
}
exports.isVueVOnExpression = isVueVOnExpression;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidnVlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vc3JjL3V0aWxzL3Z1ZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUF1QkEsU0FBZ0IsaUJBQWlCLENBQUMsSUFBWTtJQUM3QyxPQUFPLGNBQWMsQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLENBQUM7QUFDbEMsQ0FBQztBQUZELDhDQUVDO0FBMEJELFNBQWdCLGVBQWUsQ0FBQyxJQUFZO0lBQzNDLE9BQU8sb0VBQW9FLENBQUMsSUFBSSxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ3hGLENBQUM7QUFGRCwwQ0FFQztBQXdCRCxTQUFnQixlQUFlLENBQUMsSUFBWSxFQUFFLEdBQVc7SUFDeEQsT0FBTyxPQUFPLEtBQUssSUFBSSxJQUFJLEdBQUcsQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUM7QUFDL0MsQ0FBQztBQUZELDBDQUVDO0FBdUJELFNBQWdCLG9CQUFvQixDQUFDLElBQVk7SUFDaEQsT0FBTyxRQUFRLEtBQUssSUFBSSxDQUFDO0FBQzFCLENBQUM7QUFGRCxvREFFQztBQXVCRCxTQUFnQixrQkFBa0IsQ0FBQyxJQUFZO0lBQzlDLE9BQU8sTUFBTSxLQUFLLElBQUksQ0FBQztBQUN4QixDQUFDO0FBRkQsZ0RBRUMifQ==
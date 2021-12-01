"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getScriptParserName = void 0;
const jsonSuffixRe = /\+(json|yaml)$/i;
const wrappingQuotesRe = /(^("|'|`))|(("|'|`)$)/g;
const scriptTypeToParserMap = new Map([
    ['application/ecmascript', 'babel'],
    ['application/javascript', 'babel'],
    ['application/json', 'json'],
    ['text/ecmascript', 'babel'],
    ['text/javascript', 'babel'],
    ['text/markdown', 'markdown'],
    ['text/typescript', 'typescript'],
    ['module', 'babel']
]);
function getScriptParserName(typeAttrToken) {
    if (!typeAttrToken) {
        return 'babel';
    }
    const typeRaw = typeAttrToken.val;
    if (typeof typeRaw !== 'string') {
        return;
    }
    const type = typeRaw.replace(wrappingQuotesRe, '');
    if (!type) {
        return 'babel';
    }
    const suffixExec = jsonSuffixRe.exec(type);
    if (suffixExec) {
        return suffixExec[1];
    }
    return scriptTypeToParserMap.get(type);
}
exports.getScriptParserName = getScriptParserName;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2NyaXB0LW1pbWUtdHlwZXMuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi9zcmMvdXRpbHMvc2NyaXB0LW1pbWUtdHlwZXMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBS0EsTUFBTSxZQUFZLEdBQVcsaUJBQWlCLENBQUM7QUFDL0MsTUFBTSxnQkFBZ0IsR0FBVyx3QkFBd0IsQ0FBQztBQU8xRCxNQUFNLHFCQUFxQixHQUFtQyxJQUFJLEdBQUcsQ0FBQztJQUNyRSxDQUFDLHdCQUF3QixFQUFFLE9BQU8sQ0FBQztJQUNuQyxDQUFDLHdCQUF3QixFQUFFLE9BQU8sQ0FBQztJQUNuQyxDQUFDLGtCQUFrQixFQUFFLE1BQU0sQ0FBQztJQUM1QixDQUFDLGlCQUFpQixFQUFFLE9BQU8sQ0FBQztJQUM1QixDQUFDLGlCQUFpQixFQUFFLE9BQU8sQ0FBQztJQUM1QixDQUFDLGVBQWUsRUFBRSxVQUFVLENBQUM7SUFDN0IsQ0FBQyxpQkFBaUIsRUFBRSxZQUFZLENBQUM7SUFDakMsQ0FBQyxRQUFRLEVBQUUsT0FBTyxDQUFDO0NBQ25CLENBQUMsQ0FBQztBQVFILFNBQWdCLG1CQUFtQixDQUFDLGFBQThCO0lBRWpFLElBQUksQ0FBQyxhQUFhLEVBQUU7UUFDbkIsT0FBTyxPQUFPLENBQUM7S0FDZjtJQUVELE1BQU0sT0FBTyxHQUFxQixhQUFhLENBQUMsR0FBRyxDQUFDO0lBRXBELElBQUksT0FBTyxPQUFPLEtBQUssUUFBUSxFQUFFO1FBQ2hDLE9BQU87S0FDUDtJQUVELE1BQU0sSUFBSSxHQUFXLE9BQU8sQ0FBQyxPQUFPLENBQUMsZ0JBQWdCLEVBQUUsRUFBRSxDQUFDLENBQUM7SUFHM0QsSUFBSSxDQUFDLElBQUksRUFBRTtRQUNWLE9BQU8sT0FBTyxDQUFDO0tBQ2Y7SUFFRCxNQUFNLFVBQVUsR0FBMkIsWUFBWSxDQUFDLElBQUksQ0FBQyxJQUFJLENBQUMsQ0FBQztJQUNuRSxJQUFJLFVBQVUsRUFBRTtRQUNmLE9BQU8sVUFBVSxDQUFDLENBQUMsQ0FBK0IsQ0FBQztLQUNuRDtJQUVELE9BQU8scUJBQXFCLENBQUMsR0FBRyxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ3hDLENBQUM7QUF6QkQsa0RBeUJDIn0=
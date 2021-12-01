"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isUnformattable = exports.isRoot = exports.isMultiBlock = exports.isBlock = exports.isInline = exports.parseGoTemplate = void 0;
const create_id_generator_1 = require("./create-id-generator");
exports.parseGoTemplate = (text, parsers, options) => {
    var _a, _b, _c, _d, _e, _f, _g;
    const regex = /{{(?<startdelimiter>-|<|%|\/\*)?\s*(?<statement>(?<keyword>if|range|block|with|define|end|else|prettier-ignore-start|prettier-ignore-end)?[\s\S]*?)\s*(?<endDelimiter>-|>|%|\*\/)?}}|(?<unformattable>\s*<(script|style)[\s\S]*{{[\s\S]*(script|style)>)/g;
    const blocks = [];
    const root = {
        type: "root",
        content: text,
        aliasedContent: "",
        children: {},
        index: 0,
        contentStart: 0,
        length: text.length,
    };
    const nodeStack = [root];
    const getId = create_id_generator_1.createIdGenerator();
    for (let match of text.matchAll(regex)) {
        const current = last(nodeStack);
        const keyword = (_a = match.groups) === null || _a === void 0 ? void 0 : _a.keyword;
        const statement = (_b = match.groups) === null || _b === void 0 ? void 0 : _b.statement;
        const unformattable = (_c = match.groups) === null || _c === void 0 ? void 0 : _c.unformattable;
        const startDelimiter = ((_e = (_d = match.groups) === null || _d === void 0 ? void 0 : _d.startdelimiter) !== null && _e !== void 0 ? _e : "");
        const endDelimiter = ((_g = (_f = match.groups) === null || _f === void 0 ? void 0 : _f.endDelimiter) !== null && _g !== void 0 ? _g : "");
        if (current === undefined) {
            throw Error("Node stack empty.");
        }
        if (match.index === undefined) {
            throw Error("Regex match index undefined.");
        }
        const id = getId();
        if (unformattable) {
            current.children[id] = {
                id,
                type: "unformattable",
                index: match.index,
                length: match[0].length,
                content: unformattable,
                parent: current,
            };
            continue;
        }
        if (statement === undefined) {
            throw Error("Formattable match without statement.");
        }
        const inline = {
            index: match.index,
            length: match[0].length,
            startDelimiter,
            endDelimiter,
            parent: current,
            type: "inline",
            statement,
            id,
        };
        if (keyword === "end" || keyword === "prettier-ignore-end") {
            if (current.type !== "block") {
                throw Error("Encountered unexpted end keyword.");
            }
            current.length = match[0].length + match.index - current.index;
            current.content = text.substring(current.contentStart, match.index);
            current.aliasedContent = aliasNodeContent(current);
            current.end = inline;
            if (current.parent.type === "double-block") {
                const firstChild = current.parent.blocks[0];
                const lastChild = current.parent.blocks[current.parent.blocks.length - 1];
                current.parent.length =
                    lastChild.index + lastChild.length - firstChild.index;
            }
            nodeStack.pop();
        }
        else if (isBlock(current) && keyword === "else") {
            const nextChild = {
                type: "block",
                start: inline,
                end: null,
                children: {},
                keyword: keyword,
                index: match.index,
                parent: current.parent,
                contentStart: match.index + match[0].length,
                content: "",
                aliasedContent: "",
                length: -1,
                id: getId(),
                startDelimiter,
                endDelimiter,
            };
            if (isMultiBlock(current.parent)) {
                current.parent.blocks.push(nextChild);
            }
            else {
                const multiBlock = {
                    type: "double-block",
                    parent: current.parent,
                    index: current.index,
                    length: -1,
                    keyword,
                    id: current.id,
                    blocks: [current, nextChild],
                };
                nextChild.parent = multiBlock;
                current.parent = multiBlock;
                if ("children" in multiBlock.parent) {
                    multiBlock.parent.children[multiBlock.id] = multiBlock;
                }
                else {
                    throw Error("Could not find child in parent.");
                }
            }
            current.id = getId();
            current.length = match[0].length + match.index - current.index;
            current.content = text.substring(current.contentStart, match.index);
            current.aliasedContent = aliasNodeContent(current);
            nodeStack.pop();
            nodeStack.push(nextChild);
        }
        else if (keyword) {
            const block = {
                type: "block",
                start: inline,
                end: null,
                children: {},
                keyword: keyword,
                index: match.index,
                parent: current,
                contentStart: match.index + match[0].length,
                content: "",
                aliasedContent: "",
                length: -1,
                id: getId(),
                startDelimiter,
                endDelimiter,
            };
            current.children[block.id] = block;
            nodeStack.push(block);
        }
        else {
            current.children[inline.id] = inline;
        }
    }
    if (!isRoot(nodeStack.pop())) {
        throw Error("Missing end block.");
    }
    root.aliasedContent = aliasNodeContent(root);
    return root;
};
function aliasNodeContent(current) {
    let result = current.content;
    Object.entries(current.children)
        .sort(([_, node1], [__, node2]) => node2.index - node1.index)
        .forEach(([id, node]) => (result =
        result.substring(0, node.index - current.contentStart) +
            id +
            result.substring(node.index + node.length - current.contentStart)));
    return result;
}
function last(array) {
    return array[array.length - 1];
}
function isInline(node) {
    return node.type === "inline";
}
exports.isInline = isInline;
function isBlock(node) {
    return node.type === "block";
}
exports.isBlock = isBlock;
function isMultiBlock(node) {
    return node.type === "double-block";
}
exports.isMultiBlock = isMultiBlock;
function isRoot(node) {
    return node.type === "root";
}
exports.isRoot = isRoot;
function isUnformattable(node) {
    return node.type === "unformattable";
}
exports.isUnformattable = isUnformattable;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicGFyc2UuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvcGFyc2UudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQ0EsK0RBQTBEO0FBRTdDLFFBQUEsZUFBZSxHQUE0QixDQUN0RCxJQUFJLEVBQ0osT0FBTyxFQUNQLE9BQU8sRUFDUCxFQUFFOztJQUNGLE1BQU0sS0FBSyxHQUNULDJQQUEyUCxDQUFDO0lBQzlQLE1BQU0sTUFBTSxHQUdOLEVBQUUsQ0FBQztJQUVULE1BQU0sSUFBSSxHQUFXO1FBQ25CLElBQUksRUFBRSxNQUFNO1FBQ1osT0FBTyxFQUFFLElBQUk7UUFDYixjQUFjLEVBQUUsRUFBRTtRQUNsQixRQUFRLEVBQUUsRUFBRTtRQUNaLEtBQUssRUFBRSxDQUFDO1FBQ1IsWUFBWSxFQUFFLENBQUM7UUFDZixNQUFNLEVBQUUsSUFBSSxDQUFDLE1BQU07S0FDcEIsQ0FBQztJQUNGLE1BQU0sU0FBUyxHQUF5QixDQUFDLElBQUksQ0FBQyxDQUFDO0lBQy9DLE1BQU0sS0FBSyxHQUFHLHVDQUFpQixFQUFFLENBQUM7SUFFbEMsS0FBSyxJQUFJLEtBQUssSUFBSSxJQUFJLENBQUMsUUFBUSxDQUFDLEtBQUssQ0FBQyxFQUFFO1FBQ3RDLE1BQU0sT0FBTyxHQUFHLElBQUksQ0FBQyxTQUFTLENBQUMsQ0FBQztRQUNoQyxNQUFNLE9BQU8sR0FBRyxNQUFBLEtBQUssQ0FBQyxNQUFNLDBDQUFFLE9BQXFDLENBQUM7UUFDcEUsTUFBTSxTQUFTLFNBQUcsS0FBSyxDQUFDLE1BQU0sMENBQUUsU0FBUyxDQUFDO1FBQzFDLE1BQU0sYUFBYSxTQUFHLEtBQUssQ0FBQyxNQUFNLDBDQUFFLGFBQWEsQ0FBQztRQUNsRCxNQUFNLGNBQWMsR0FBRyxhQUFDLEtBQUssQ0FBQyxNQUFNLDBDQUFFLGNBQWMsbUNBQ2xELEVBQUUsQ0FBMkIsQ0FBQztRQUNoQyxNQUFNLFlBQVksR0FBRyxhQUFDLEtBQUssQ0FBQyxNQUFNLDBDQUFFLFlBQVks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QUFDLElBQVk7SUFDdkMsT0FBTyxJQUFJLENBQUMsSUFBSSxLQUFLLGNBQWMsQ0FBQztBQUN0QyxDQUFDO0FBRkQsb0NBRUM7QUFFRCxTQUFnQixNQUFNLENBQUMsSUFBWTtJQUNqQyxPQUFPLElBQUksQ0FBQyxJQUFJLEtBQUssTUFBTSxDQUFDO0FBQzlCLENBQUM7QUFGRCx3QkFFQztBQUVELFNBQWdCLGVBQWUsQ0FBQyxJQUFZO0lBQzFDLE9BQU8sSUFBSSxDQUFDLElBQUksS0FBSyxlQUFlLENBQUM7QUFDdkMsQ0FBQztBQUZELDBDQUVDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgUGFyc2VyIH0gZnJvbSBcInByZXR0aWVyXCI7XG5pbXBvcnQgeyBjcmVhdGVJZEdlbmVyYXRvciB9IGZyb20gXCIuL2NyZWF0ZS1pZC1nZW5lcmF0b3JcIjtcblxuZXhwb3J0IGNvbnN0IHBhcnNlR29UZW1wbGF0ZTogUGFyc2VyPEdvTm9kZT5bXCJwYXJzZVwiXSA9IChcbiAgdGV4dCxcbiAgcGFyc2VycyxcbiAgb3B0aW9uc1xuKSA9PiB7XG4gIGNvbnN0IHJlZ2V4ID1cbiAgICAve3soPzxzdGFydGRlbGltaXRlcj4tfDx8JXxcXC9cXCopP1xccyooPzxzdGF0ZW1lbnQ+KD88a2V5d29yZD5pZnxyYW5nZXxibG9ja3x3aXRofGRlZmluZXxlbmR8ZWxzZXxwcmV0dGllci1pZ25vcmUtc3RhcnR8cHJldHRpZXItaWdub3JlLWVuZCk/W1xcc1xcU10qPylcXHMqKD88ZW5kRGVsaW1pdGVyPi18PnwlfFxcKlxcLyk/fX18KD88dW5mb3JtYXR0YWJsZT5cXHMqPChzY3JpcHR8c3R5bGUpW1xcc1xcU10qe3tbXFxzXFxTXSooc2NyaXB0fHN0eWxlKT4pL2c7XG4gIGNvbnN0IGJsb2Nrczoge1xuICAgIHN0YXJ0OiBSZWdFeHBNYXRjaEFycmF5O1xuICAgIGVuZDogUmVnRXhwTWF0Y2hBcnJheTtcbiAgfVtdID0gW107XG5cbiAgY29uc3Qgcm9vdDogR29Sb290ID0ge1xuICAgIHR5cGU6IFwicm9vdFwiLFxuICAgIGNvbnRlbnQ6IHRleHQsXG4gICAgYWxpYXNlZENvbnRlbnQ6IFwiXCIsXG4gICAgY2hpbGRyZW46IHt9LFxuICAgIGluZGV4OiAwLFxuICAgIGNvbnRlbnRTdGFydDogMCxcbiAgICBsZW5ndGg6IHRleHQubGVuZ3RoLFxuICB9O1xuICBjb25zdCBub2RlU3RhY2s6IChHb0Jsb2NrIHwgR29Sb290KVtdID0gW3Jvb3RdO1xuICBjb25zdCBnZXRJZCA9IGNyZWF0ZUlkR2VuZXJhdG9yKCk7XG5cbiAgZm9yIChsZXQgbWF0Y2ggb2YgdGV4dC5tYXRjaEFsbChyZWdleCkpIHtcbiAgICBjb25zdCBjdXJyZW50ID0gbGFzdChub2RlU3RhY2spO1xuICAgIGNvbnN0IGtleXdvcmQgPSBtYXRjaC5ncm91cHM/LmtleXdvcmQgYXMgR29CbG9ja0tleXdvcmQgfCB1bmRlZmluZWQ7XG4gICAgY29uc3Qgc3RhdGVtZW50ID0gbWF0Y2guZ3JvdXBzPy5zdGF0ZW1lbnQ7XG4gICAgY29uc3QgdW5mb3JtYXR0YWJsZSA9IG1hdGNoLmdyb3Vwcz8udW5mb3JtYXR0YWJsZTtcbiAgICBjb25zdCBzdGFydERlbGltaXRlciA9IChtYXRjaC5ncm91cHM/LnN0YXJ0ZGVsaW1pdGVyID8/XG4gICAgICBcIlwiKSBhcyBHb0lubGluZVN0YXJ0RGVsaW1pdGVyO1xuICAgIGNvbnN0IGVuZERlbGltaXRlciA9IChtYXRjaC5ncm91cHM/LmVuZERlbGltaXRlciA/P1xuICAgICAgXCJcIikgYXMgR29JbmxpbmVFbmREZWxpbWl0ZXI7XG5cbiAgICBpZiAoY3VycmVudCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBFcnJvcihcIk5vZGUgc3RhY2sgZW1wdHkuXCIpO1xuICAgIH1cblxuICAgIGlmIChtYXRjaC5pbmRleCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBFcnJvcihcIlJlZ2V4IG1hdGNoIGluZGV4IHVuZGVmaW5lZC5cIik7XG4gICAgfVxuICAgIGNvbnN0IGlkID0gZ2V0SWQoKTtcbiAgICBpZiAodW5mb3JtYXR0YWJsZSkge1xuICAgICAgY3VycmVudC5jaGlsZHJlbltpZF0gPSB7XG4gICAgICAgIGlkLFxuICAgICAgICB0eXBlOiBcInVuZm9ybWF0dGFibGVcIixcbiAgICAgICAgaW5kZXg6IG1hdGNoLmluZGV4LFxuICAgICAgICBsZW5ndGg6IG1hdGNoWzBdLmxlbmd0aCxcbiAgICAgICAgY29udGVudDogdW5mb3JtYXR0YWJsZSxcbiAgICAgICAgcGFyZW50OiBjdXJyZW50LFxuICAgICAgfTtcbiAgICAgIGNvbnRpbnVlO1xuICAgIH1cblxuICAgIGlmIChzdGF0ZW1lbnQgPT09IHVuZGVmaW5lZCkge1xuICAgICAgdGhyb3cgRXJyb3IoXCJGb3JtYXR0YWJsZSBtYXRjaCB3aXRob3V0IHN0YXRlbWVudC5cIik7XG4gICAgfVxuXG4gICAgY29uc3QgaW5saW5lOiBHb0lubGluZSA9IHtcbiAgICAgIGluZGV4OiBtYXRjaC5pbmRleCxcbiAgICAgIGxlbmd0aDogbWF0Y2hbMF0ubGVuZ3RoLFxuICAgICAgc3RhcnREZWxpbWl0ZXIsXG4gICAgICBlbmREZWxpbWl0ZXIsXG4gICAgICBwYXJlbnQ6IGN1cnJlbnQhLFxuICAgICAgdHlwZTogXCJpbmxpbmVcIixcbiAgICAgIHN0YXRlbWVudCxcbiAgICAgIGlkLFxuICAgIH07XG5cbiAgICBpZiAoa2V5d29yZCA9PT0gXCJlbmRcIiB8fCBrZXl3b3JkID09PSBcInByZXR0aWVyLWlnbm9yZS1lbmRcIikge1xuICAgICAgaWYgKGN1cnJlbnQudHlwZSAhPT0gXCJibG9ja1wiKSB7XG4gICAgICAgIHRocm93IEVycm9yKFwiRW5jb3VudGVyZWQgdW5leHB0ZWQgZW5kIGtleXdvcmQuXCIpO1xuICAgICAgfVxuXG4gICAgICBjdXJyZW50Lmxlbmd0aCA9IG1hdGNoWzBdLmxlbmd0aCArIG1hdGNoLmluZGV4IC0gY3VycmVudC5pbmRleDtcbiAgICAgIGN1cnJlbnQuY29udGVudCA9IHRleHQuc3Vic3RyaW5nKGN1cnJlbnQuY29udGVudFN0YXJ0LCBtYXRjaC5pbmRleCk7XG4gICAgICBjdXJyZW50LmFsaWFzZWRDb250ZW50ID0gYWxpYXNOb2RlQ29udGVudChjdXJyZW50KTtcbiAgICAgIGN1cnJlbnQuZW5kID0gaW5saW5lO1xuXG4gICAgICBpZiAoY3VycmVudC5wYXJlbnQudHlwZSA9PT0gXCJkb3VibGUtYmxvY2tcIikge1xuICAgICAgICBjb25zdCBmaXJzdENoaWxkID0gY3VycmVudC5wYXJlbnQuYmxvY2tzWzBdO1xuICAgICAgICBjb25zdCBsYXN0Q2hpbGQgPVxuICAgICAgICAgIGN1cnJlbnQucGFyZW50LmJsb2Nrc1tjdXJyZW50LnBhcmVudC5ibG9ja3MubGVuZ3RoIC0gMV07XG5cbiAgICAgICAgY3VycmVudC5wYXJlbnQubGVuZ3RoID1cbiAgICAgICAgICBsYXN0Q2hpbGQuaW5kZXggKyBsYXN0Q2hpbGQubGVuZ3RoIC0gZmlyc3RDaGlsZC5pbmRleDtcbiAgICAgIH1cblxuICAgICAgbm9kZVN0YWNrLnBvcCgpO1xuICAgIH0gZWxzZSBpZiAoaXNCbG9jayhjdXJyZW50KSAmJiBrZXl3b3JkID09PSBcImVsc2VcIikge1xuICAgICAgY29uc3QgbmV4dENoaWxkOiBHb0Jsb2NrID0ge1xuICAgICAgICB0eXBlOiBcImJsb2NrXCIsXG4gICAgICAgIHN0YXJ0OiBpbmxpbmUsXG4gICAgICAgIGVuZDogbnVsbCxcbiAgICAgICAgY2hpbGRyZW46IHt9LFxuICAgICAgICBrZXl3b3JkOiBrZXl3b3JkLFxuICAgICAgICBpbmRleDogbWF0Y2guaW5kZXgsXG4gICAgICAgIHBhcmVudDogY3VycmVudC5wYXJlbnQsXG4gICAgICAgIGNvbnRlbnRTdGFydDogbWF0Y2guaW5kZXggKyBtYXRjaFswXS5sZW5ndGgsXG4gICAgICAgIGNvbnRlbnQ6IFwiXCIsXG4gICAgICAgIGFsaWFzZWRDb250ZW50OiBcIlwiLFxuICAgICAgICBsZW5ndGg6IC0xLFxuICAgICAgICBpZDogZ2V0SWQoKSxcbiAgICAgICAgc3RhcnREZWxpbWl0ZXIsXG4gICAgICAgIGVuZERlbGltaXRlcixcbiAgICAgIH07XG5cbiAgICAgIGlmIChpc011bHRpQmxvY2soY3VycmVudC5wYXJlbnQpKSB7XG4gICAgICAgIGN1cnJlbnQucGFyZW50LmJsb2Nrcy5wdXNoKG5leHRDaGlsZCk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBjb25zdCBtdWx0aUJsb2NrOiBHb011bHRpQmxvY2sgPSB7XG4gICAgICAgICAgdHlwZTogXCJkb3VibGUtYmxvY2tcIixcbiAgICAgICAgICBwYXJlbnQ6IGN1cnJlbnQucGFyZW50LFxuICAgICAgICAgIGluZGV4OiBjdXJyZW50LmluZGV4LFxuICAgICAgICAgIGxlbmd0aDogLTEsXG4gICAgICAgICAga2V5d29yZCxcbiAgICAgICAgICBpZDogY3VycmVudC5pZCxcbiAgICAgICAgICBibG9ja3M6IFtjdXJyZW50LCBuZXh0Q2hpbGRdLFxuICAgICAgICB9O1xuICAgICAgICBuZXh0Q2hpbGQucGFyZW50ID0gbXVsdGlCbG9jaztcbiAgICAgICAgY3VycmVudC5wYXJlbnQgPSBtdWx0aUJsb2NrO1xuXG4gICAgICAgIGlmIChcImNoaWxkcmVuXCIgaW4gbXVsdGlCbG9jay5wYXJlbnQpIHtcbiAgICAgICAgICBtdWx0aUJsb2NrLnBhcmVudC5jaGlsZHJlblttdWx0aUJsb2NrLmlkXSA9IG11bHRpQmxvY2s7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgdGhyb3cgRXJyb3IoXCJDb3VsZCBub3QgZmluZCBjaGlsZCBpbiBwYXJlbnQuXCIpO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGN1cnJlbnQuaWQgPSBnZXRJZCgpO1xuICAgICAgY3VycmVudC5sZW5ndGggPSBtYXRjaFswXS5sZW5ndGggKyBtYXRjaC5pbmRleCAtIGN1cnJlbnQuaW5kZXg7XG4gICAgICBjdXJyZW50LmNvbnRlbnQgPSB0ZXh0LnN1YnN0cmluZyhjdXJyZW50LmNvbnRlbnRTdGFydCwgbWF0Y2guaW5kZXgpO1xuICAgICAgY3VycmVudC5hbGlhc2VkQ29udGVudCA9IGFsaWFzTm9kZUNvbnRlbnQoY3VycmVudCk7XG5cbiAgICAgIG5vZGVTdGFjay5wb3AoKTtcbiAgICAgIG5vZGVTdGFjay5wdXNoKG5leHRDaGlsZCk7XG4gICAgfSBlbHNlIGlmIChrZXl3b3JkKSB7XG4gICAgICBjb25zdCBibG9jazogR29CbG9jayA9IHtcbiAgICAgICAgdHlwZTogXCJibG9ja1wiLFxuICAgICAgICBzdGFydDogaW5saW5lLFxuICAgICAgICBlbmQ6IG51bGwsXG4gICAgICAgIGNoaWxkcmVuOiB7fSxcbiAgICAgICAga2V5d29yZDoga2V5d29yZCBhcyBHb0Jsb2NrS2V5d29yZCxcbiAgICAgICAgaW5kZXg6IG1hdGNoLmluZGV4LFxuICAgICAgICBwYXJlbnQ6IGN1cnJlbnQsXG4gICAgICAgIGNvbnRlbnRTdGFydDogbWF0Y2guaW5kZXggKyBtYXRjaFswXS5sZW5ndGgsXG4gICAgICAgIGNvbnRlbnQ6IFwiXCIsXG4gICAgICAgIGFsaWFzZWRDb250ZW50OiBcIlwiLFxuICAgICAgICBsZW5ndGg6IC0xLFxuICAgICAgICBpZDogZ2V0SWQoKSxcbiAgICAgICAgc3RhcnREZWxpbWl0ZXIsXG4gICAgICAgIGVuZERlbGltaXRlcixcbiAgICAgIH07XG5cbiAgICAgIGN1cnJlbnQuY2hpbGRyZW5bYmxvY2suaWRdID0gYmxvY2s7XG4gICAgICBub2RlU3RhY2sucHVzaChibG9jayk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGN1cnJlbnQuY2hpbGRyZW5baW5saW5lLmlkXSA9IGlubGluZTtcbiAgICB9XG4gIH1cblxuICBpZiAoIWlzUm9vdChub2RlU3RhY2sucG9wKCkhKSkge1xuICAgIHRocm93IEVycm9yKFwiTWlzc2luZyBlbmQgYmxvY2suXCIpO1xuICB9XG5cbiAgcm9vdC5hbGlhc2VkQ29udGVudCA9IGFsaWFzTm9kZUNvbnRlbnQocm9vdCk7XG5cbiAgcmV0dXJuIHJvb3Q7XG59O1xuXG5mdW5jdGlvbiBhbGlhc05vZGVDb250ZW50KGN1cnJlbnQ6IEdvQmxvY2sgfCBHb1Jvb3QpOiBzdHJpbmcge1xuICBsZXQgcmVzdWx0ID0gY3VycmVudC5jb250ZW50O1xuXG4gIE9iamVjdC5lbnRyaWVzKGN1cnJlbnQuY2hpbGRyZW4pXG4gICAgLnNvcnQoKFtfLCBub2RlMV0sIFtfXywgbm9kZTJdKSA9PiBub2RlMi5pbmRleCAtIG5vZGUxLmluZGV4KVxuICAgIC5mb3JFYWNoKFxuICAgICAgKFtpZCwgbm9kZV0pID0+XG4gICAgICAgIChyZXN1bHQgPVxuICAgICAgICAgIHJlc3VsdC5zdWJzdHJpbmcoMCwgbm9kZS5pbmRleCAtIGN1cnJlbnQuY29udGVudFN0YXJ0KSArXG4gICAgICAgICAgaWQgK1xuICAgICAgICAgIHJlc3VsdC5zdWJzdHJpbmcobm9kZS5pbmRleCArIG5vZGUubGVuZ3RoIC0gY3VycmVudC5jb250ZW50U3RhcnQpKVxuICAgICk7XG5cbiAgcmV0dXJuIHJlc3VsdDtcbn1cblxuZnVuY3Rpb24gbGFzdDxUPihhcnJheTogVFtdKTogVCB8IHVuZGVmaW5lZCB7XG4gIHJldHVybiBhcnJheVthcnJheS5sZW5ndGggLSAxXTtcbn1cblxuZXhwb3J0IHR5cGUgR29Ob2RlID1cbiAgfCBHb1Jvb3RcbiAgfCBHb0Jsb2NrXG4gIHwgR29JbmxpbmVcbiAgfCBHb011bHRpQmxvY2tcbiAgfCBHb1VuZm9ybWF0dGFibGU7XG5cbmV4cG9ydCB0eXBlIEdvQmxvY2tLZXl3b3JkID1cbiAgfCBcImlmXCJcbiAgfCBcInJhbmdlXCJcbiAgfCBcImJsb2NrXCJcbiAgfCBcIndpdGhcIlxuICB8IFwiZGVmaW5lXCJcbiAgfCBcImVsc2VcIlxuICB8IFwicHJldHRpZXItaWdub3JlLXN0YXJ0XCJcbiAgfCBcInByZXR0aWVyLWlnbm9yZS1lbmRcIlxuICB8IFwiZW5kXCI7XG5cbmV4cG9ydCB0eXBlIEdvUm9vdCA9IHsgdHlwZTogXCJyb290XCIgfSAmIE9taXQ8XG4gIEdvQmxvY2ssXG4gIHwgXCJ0eXBlXCJcbiAgfCBcImtleXdvcmRcIlxuICB8IFwicGFyZW50XCJcbiAgfCBcInN0YXRlbWVudFwiXG4gIHwgXCJpZFwiXG4gIHwgXCJzdGFydERlbGltaXRlclwiXG4gIHwgXCJlbmREZWxpbWl0ZXJcIlxuICB8IFwic3RhcnRcIlxuICB8IFwiZW5kXCJcbj47XG5cbmV4cG9ydCBpbnRlcmZhY2UgR29CYXNlTm9kZTxUeXBlIGV4dGVuZHMgc3RyaW5nPiB7XG4gIGlkOiBzdHJpbmc7XG4gIHR5cGU6IFR5cGU7XG4gIGluZGV4OiBudW1iZXI7XG4gIGxlbmd0aDogbnVtYmVyO1xuICBwYXJlbnQ6IEdvQmxvY2sgfCBHb1Jvb3QgfCBHb011bHRpQmxvY2s7XG59XG5cbmV4cG9ydCBpbnRlcmZhY2UgR29CbG9jayBleHRlbmRzIEdvQmFzZU5vZGU8XCJibG9ja1wiPiwgV2l0aERlbGltaXRlciB7XG4gIGtleXdvcmQ6IEdvQmxvY2tLZXl3b3JkO1xuICBjaGlsZHJlbjoge1xuICAgIFtpZDogc3RyaW5nXTogR29Ob2RlO1xuICB9O1xuICBzdGFydDogR29JbmxpbmU7XG4gIGVuZDogR29JbmxpbmUgfCBudWxsO1xuICBjb250ZW50OiBzdHJpbmc7XG4gIGFsaWFzZWRDb250ZW50OiBzdHJpbmc7XG4gIGNvbnRlbnRTdGFydDogbnVtYmVyO1xufVxuXG5leHBvcnQgaW50ZXJmYWNlIEdvTXVsdGlCbG9jayBleHRlbmRzIEdvQmFzZU5vZGU8XCJkb3VibGUtYmxvY2tcIj4ge1xuICBibG9ja3M6IChHb0Jsb2NrIHwgR29NdWx0aUJsb2NrKVtdO1xuICBrZXl3b3JkOiBHb0Jsb2NrS2V5d29yZDtcbn1cblxuZXhwb3J0IHR5cGUgR29TaGFyZWREZWxpbWl0ZXIgPSBcIiVcIiB8IFwiLVwiIHwgXCJcIjtcbmV4cG9ydCB0eXBlIEdvSW5saW5lU3RhcnREZWxpbWl0ZXIgPSBcIjxcIiB8IFwiLypcIiB8IEdvU2hhcmVkRGVsaW1pdGVyO1xuZXhwb3J0IHR5cGUgR29JbmxpbmVFbmREZWxpbWl0ZXIgPSBcIj5cIiB8IFwiKi9cIiB8IEdvU2hhcmVkRGVsaW1pdGVyO1xuXG5leHBvcnQgaW50ZXJmYWNlIEdvVW5mb3JtYXR0YWJsZSBleHRlbmRzIEdvQmFzZU5vZGU8XCJ1bmZvcm1hdHRhYmxlXCI+IHtcbiAgY29udGVudDogc3RyaW5nO1xufVxuXG5leHBvcnQgaW50ZXJmYWNlIFdpdGhEZWxpbWl0ZXIge1xuICBzdGFydERlbGltaXRlcjogR29JbmxpbmVTdGFydERlbGltaXRlcjtcbiAgZW5kRGVsaW1pdGVyOiBHb0lubGluZUVuZERlbGltaXRlcjtcbn1cblxuZXhwb3J0IGludGVyZmFjZSBHb0lubGluZSBleHRlbmRzIEdvQmFzZU5vZGU8XCJpbmxpbmVcIj4sIFdpdGhEZWxpbWl0ZXIge1xuICBzdGF0ZW1lbnQ6IHN0cmluZztcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGlzSW5saW5lKG5vZGU6IEdvTm9kZSk6IG5vZGUgaXMgR29JbmxpbmUge1xuICByZXR1cm4gbm9kZS50eXBlID09PSBcImlubGluZVwiO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gaXNCbG9jayhub2RlOiBHb05vZGUpOiBub2RlIGlzIEdvQmxvY2sge1xuICByZXR1cm4gbm9kZS50eXBlID09PSBcImJsb2NrXCI7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBpc011bHRpQmxvY2sobm9kZTogR29Ob2RlKTogbm9kZSBpcyBHb011bHRpQmxvY2sge1xuICByZXR1cm4gbm9kZS50eXBlID09PSBcImRvdWJsZS1ibG9ja1wiO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gaXNSb290KG5vZGU6IEdvTm9kZSk6IG5vZGUgaXMgR29Sb290IHtcbiAgcmV0dXJuIG5vZGUudHlwZSA9PT0gXCJyb290XCI7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBpc1VuZm9ybWF0dGFibGUobm9kZTogR29Ob2RlKTogbm9kZSBpcyBHb1Jvb3Qge1xuICByZXR1cm4gbm9kZS50eXBlID09PSBcInVuZm9ybWF0dGFibGVcIjtcbn1cbiJdfQ==
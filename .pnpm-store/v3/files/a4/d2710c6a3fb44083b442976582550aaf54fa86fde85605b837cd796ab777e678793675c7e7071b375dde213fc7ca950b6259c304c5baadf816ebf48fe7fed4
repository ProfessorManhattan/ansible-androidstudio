"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatPugCommentPreserveSpaces = exports.PUG_COMMENT_PRESERVE_SPACES_OPTION = void 0;
const _1 = require(".");
exports.PUG_COMMENT_PRESERVE_SPACES_OPTION = {
    since: '1.6.0',
    category: _1.CATEGORY_PUG,
    type: 'choice',
    default: 'keep-all',
    description: 'Change behavior of spaces within comments.',
    choices: [
        {
            value: 'keep-all',
            description: 'Keep all spaces within comments. Example: `//    this  is   a   comment`'
        },
        {
            value: 'keep-leading',
            description: 'Keep leading spaces within comments. Example: `//    this is a comment`'
        },
        {
            value: 'trim-all',
            description: 'Trim all spaces within comments. Example: `// this is a comment`'
        }
    ]
};
function formatPugCommentPreserveSpaces(input, pugCommentPreserveSpaces, pipeless = false) {
    switch (pugCommentPreserveSpaces) {
        case 'keep-leading': {
            let result = '';
            let firstNonSpace = 0;
            for (firstNonSpace; firstNonSpace < input.length && input[firstNonSpace] === ' '; firstNonSpace++) {
                result += ' ';
            }
            result += input.slice(firstNonSpace).trim().replace(/\s\s+/g, ' ');
            return result;
        }
        case 'trim-all': {
            let result = input.trim();
            result = result.replace(/\s\s+/g, ' ');
            if (!pipeless && input[0] === ' ') {
                result = ` ${result}`;
            }
            return result;
        }
        case 'keep-all':
        default:
            return input;
    }
}
exports.formatPugCommentPreserveSpaces = formatPugCommentPreserveSpaces;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicHVnLWNvbW1lbnQtcHJlc2VydmUtc3BhY2VzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vc3JjL29wdGlvbnMvcHVnLWNvbW1lbnQtcHJlc2VydmUtc3BhY2VzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLHdCQUFpQztBQUdwQixRQUFBLGtDQUFrQyxHQUFrRDtJQUNoRyxLQUFLLEVBQUUsT0FBTztJQUNkLFFBQVEsRUFBRSxlQUFZO0lBQ3RCLElBQUksRUFBRSxRQUFRO0lBQ2QsT0FBTyxFQUFFLFVBQVU7SUFDbkIsV0FBVyxFQUFFLDRDQUE0QztJQUN6RCxPQUFPLEVBQUU7UUFDUjtZQUNDLEtBQUssRUFBRSxVQUFVO1lBQ2pCLFdBQVcsRUFBRSwwRUFBMEU7U0FDdkY7UUFDRDtZQUNDLEtBQUssRUFBRSxjQUFjO1lBQ3JCLFdBQVcsRUFBRSx5RUFBeUU7U0FDdEY7UUFDRDtZQUNDLEtBQUssRUFBRSxVQUFVO1lBQ2pCLFdBQVcsRUFBRSxrRUFBa0U7U0FDL0U7S0FDRDtDQUNELENBQUM7QUFhRixTQUFnQiw4QkFBOEIsQ0FDN0MsS0FBYSxFQUNiLHdCQUFrRCxFQUNsRCxXQUFvQixLQUFLO0lBRXpCLFFBQVEsd0JBQXdCLEVBQUU7UUFDakMsS0FBSyxjQUFjLENBQUMsQ0FBQztZQUNwQixJQUFJLE1BQU0sR0FBVyxFQUFFLENBQUM7WUFDeEIsSUFBSSxhQUFhLEdBQVcsQ0FBQyxDQUFDO1lBQzlCLEtBQUssYUFBYSxFQUFFLGFBQWEsR0FBRyxLQUFLLENBQUMsTUFBTSxJQUFJLEtBQUssQ0FBQyxhQUFhLENBQUMsS0FBSyxHQUFHLEVBQUUsYUFBYSxFQUFFLEVBQUU7Z0JBQ2xHLE1BQU0sSUFBSSxHQUFHLENBQUM7YUFDZDtZQUNELE1BQU0sSUFBSSxLQUFLLENBQUMsS0FBSyxDQUFDLGFBQWEsQ0FBQyxDQUFDLElBQUksRUFBRSxDQUFDLE9BQU8sQ0FBQyxRQUFRLEVBQUUsR0FBRyxDQUFDLENBQUM7WUFDbkUsT0FBTyxNQUFNLENBQUM7U0FDZDtRQUNELEtBQUssVUFBVSxDQUFDLENBQUM7WUFDaEIsSUFBSSxNQUFNLEdBQVcsS0FBSyxDQUFDLElBQUksRUFBRSxDQUFDO1lBQ2xDLE1BQU0sR0FBRyxNQUFNLENBQUMsT0FBTyxDQUFDLFFBQVEsRUFBRSxHQUFHLENBQUMsQ0FBQztZQUN2QyxJQUFJLENBQUMsUUFBUSxJQUFJLEtBQUssQ0FBQyxDQUFDLENBQUMsS0FBSyxHQUFHLEVBQUU7Z0JBQ2xDLE1BQU0sR0FBRyxJQUFJLE1BQU0sRUFBRSxDQUFDO2FBQ3RCO1lBQ0QsT0FBTyxNQUFNLENBQUM7U0FDZDtRQUNELEtBQUssVUFBVSxDQUFDO1FBQ2hCO1lBRUMsT0FBTyxLQUFLLENBQUM7S0FDZDtBQUNGLENBQUM7QUE1QkQsd0VBNEJDIn0=
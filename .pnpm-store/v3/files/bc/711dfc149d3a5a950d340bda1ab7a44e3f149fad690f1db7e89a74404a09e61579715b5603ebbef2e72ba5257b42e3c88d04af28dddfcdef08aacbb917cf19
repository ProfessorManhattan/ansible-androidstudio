"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.resolvePugAttributeSeparatorOption = exports.PUG_ATTRIBUTE_SEPARATOR_OPTION = void 0;
const _1 = require(".");
exports.PUG_ATTRIBUTE_SEPARATOR_OPTION = {
    since: '1.6.0',
    category: _1.CATEGORY_PUG,
    type: 'choice',
    default: 'always',
    description: 'Change when attributes are separated by commas in tags.',
    choices: [
        {
            value: 'always',
            description: 'Always separate attributes with commas. Example: `button(type="submit", (click)="play()", disabled)`'
        },
        {
            value: 'as-needed',
            description: 'Only add commas between attributes where required. Example: `button(type="submit", (click)="play()" disabled)`'
        },
        {
            value: 'none',
            description: 'Never add commas between attributes. Example: `button(type="submit" @click="play()" :style="style" disabled)`'
        }
    ]
};
function resolvePugAttributeSeparatorOption(pugAttributeSeparator) {
    switch (pugAttributeSeparator) {
        case 'always':
        case 'as-needed':
        case 'none':
            return pugAttributeSeparator;
    }
    throw new Error(`Invalid option for pugAttributeSeparator. Found '${pugAttributeSeparator}'. Possible options: 'always', 'as-needed' or 'none'`);
}
exports.resolvePugAttributeSeparatorOption = resolvePugAttributeSeparatorOption;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicHVnLWF0dHJpYnV0ZS1zZXBhcmF0b3IuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi9zcmMvb3B0aW9ucy9wdWctYXR0cmlidXRlLXNlcGFyYXRvci50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFDQSx3QkFBaUM7QUFHcEIsUUFBQSw4QkFBOEIsR0FBK0M7SUFDekYsS0FBSyxFQUFFLE9BQU87SUFDZCxRQUFRLEVBQUUsZUFBWTtJQUN0QixJQUFJLEVBQUUsUUFBUTtJQUNkLE9BQU8sRUFBRSxRQUFRO0lBQ2pCLFdBQVcsRUFBRSx5REFBeUQ7SUFDdEUsT0FBTyxFQUFFO1FBQ1I7WUFDQyxLQUFLLEVBQUUsUUFBUTtZQUNmLFdBQVcsRUFDVixzR0FBc0c7U0FDdkc7UUFDRDtZQUNDLEtBQUssRUFBRSxXQUFXO1lBQ2xCLFdBQVcsRUFDVixnSEFBZ0g7U0FDakg7UUFDRDtZQUNDLEtBQUssRUFBRSxNQUFNO1lBQ2IsV0FBVyxFQUNWLCtHQUErRztTQUNoSDtLQUNEO0NBQ0QsQ0FBQztBQVlGLFNBQWdCLGtDQUFrQyxDQUNqRCxxQkFBNEM7SUFFNUMsUUFBUSxxQkFBcUIsRUFBRTtRQUM5QixLQUFLLFFBQVEsQ0FBQztRQUNkLEtBQUssV0FBVyxDQUFDO1FBQ2pCLEtBQUssTUFBTTtZQUNWLE9BQU8scUJBQXFCLENBQUM7S0FDOUI7SUFDRCxNQUFNLElBQUksS0FBSyxDQUNkLG9EQUFvRCxxQkFBcUIsc0RBQXNELENBQy9ILENBQUM7QUFDSCxDQUFDO0FBWkQsZ0ZBWUMifQ==
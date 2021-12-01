"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const experimental_utils_1 = require("@typescript-eslint/experimental-utils");
const memoize_1 = __importDefault(require("lodash/memoize"));
const tslint_1 = require("tslint");
const custom_linter_1 = require("../custom-linter");
// note - cannot migrate this to an import statement because it will make TSC copy the package.json to the dist folder
// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
const version = require('../../package.json');
const createRule = experimental_utils_1.ESLintUtils.RuleCreator(() => `https://github.com/typescript-eslint/typescript-eslint/blob/v${version}/packages/eslint-plugin-tslint/README.md`);
/**
 * Construct a configFile for TSLint
 */
const tslintConfig = (0, memoize_1.default)((lintFile, tslintRules, tslintRulesDirectory) => {
    if (lintFile != null) {
        return tslint_1.Configuration.loadConfigurationFromPath(lintFile);
    }
    return tslint_1.Configuration.parseConfigFile({
        rules: tslintRules !== null && tslintRules !== void 0 ? tslintRules : {},
        rulesDirectory: tslintRulesDirectory !== null && tslintRulesDirectory !== void 0 ? tslintRulesDirectory : [],
    });
}, (lintFile, tslintRules = {}, tslintRulesDirectory = []) => `${lintFile}_${JSON.stringify(tslintRules)}_${tslintRulesDirectory.join()}`);
exports.default = createRule({
    name: 'config',
    meta: {
        docs: {
            description: 'Wraps a TSLint configuration and lints the whole source using TSLint',
            recommended: false,
        },
        fixable: 'code',
        type: 'problem',
        messages: {
            failure: '{{message}} (tslint:{{ruleName}})',
        },
        schema: [
            {
                type: 'object',
                properties: {
                    rules: {
                        type: 'object',
                        /**
                         * No fixed schema properties for rules, as this would be a permanently moving target
                         */
                        additionalProperties: true,
                    },
                    rulesDirectory: {
                        type: 'array',
                        items: {
                            type: 'string',
                        },
                    },
                    lintFile: {
                        type: 'string',
                    },
                },
                additionalProperties: false,
            },
        ],
    },
    defaultOptions: [{}],
    create(context) {
        var _a;
        const fileName = context.getFilename();
        const sourceCode = context.getSourceCode().text;
        const parserServices = experimental_utils_1.ESLintUtils.getParserServices(context);
        /**
         * The TSLint rules configuration passed in by the user
         */
        const [{ rules: tslintRules, rulesDirectory: tslintRulesDirectory, lintFile },] = context.options;
        const program = parserServices.program;
        /**
         * Create an instance of TSLint
         * Lint the source code using the configured TSLint instance, and the rules which have been
         * passed via the ESLint rule options for this rule (using "tslint/config")
         */
        const tslintOptions = {
            formatter: 'json',
            fix: false,
        };
        const tslint = new custom_linter_1.CustomLinter(tslintOptions, program);
        const configuration = tslintConfig(lintFile, tslintRules, tslintRulesDirectory);
        tslint.lint(fileName, sourceCode, configuration);
        const result = tslint.getResult();
        /**
         * Format the TSLint results for ESLint
         */
        if ((_a = result.failures) === null || _a === void 0 ? void 0 : _a.length) {
            result.failures.forEach(failure => {
                const start = failure.getStartPosition().getLineAndCharacter();
                const end = failure.getEndPosition().getLineAndCharacter();
                context.report({
                    messageId: 'failure',
                    data: {
                        message: failure.getFailure(),
                        ruleName: failure.getRuleName(),
                    },
                    loc: {
                        start: {
                            line: start.line + 1,
                            column: start.character,
                        },
                        end: {
                            line: end.line + 1,
                            column: end.character,
                        },
                    },
                    fix: fixer => {
                        const replacements = failure.getFix();
                        return Array.isArray(replacements)
                            ? replacements.map(replacement => fixer.replaceTextRange([replacement.start, replacement.end], replacement.text))
                            : replacements !== undefined
                                ? fixer.replaceTextRange([replacements.start, replacements.end], replacements.text)
                                : [];
                    },
                });
            });
        }
        /**
         * Return an empty object for the ESLint rule
         */
        return {};
    },
});
//# sourceMappingURL=config.js.map
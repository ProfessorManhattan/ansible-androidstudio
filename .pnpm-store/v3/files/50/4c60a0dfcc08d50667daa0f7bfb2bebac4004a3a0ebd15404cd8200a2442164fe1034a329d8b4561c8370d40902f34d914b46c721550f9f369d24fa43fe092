"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.defaultOptions = exports.options = exports.printers = exports.parsers = exports.languages = exports.plugin = void 0;
const lex = require("pug-lexer");
const logger_1 = require("./logger");
const options_1 = require("./options");
const converge_1 = require("./options/converge");
const printer_1 = require("./printer");
const logger = (0, logger_1.createLogger)(console);
if (process.env.NODE_ENV === 'test') {
    logger.setLogLevel(logger_1.LogLevel.DEBUG);
}
exports.plugin = {
    languages: [
        {
            name: 'Pug',
            parsers: ['pug'],
            tmScope: 'text.jade',
            aceMode: 'jade',
            codemirrorMode: 'pug',
            codemirrorMimeType: 'text/x-pug',
            extensions: ['.jade', '.pug'],
            linguistLanguageId: 179,
            vscodeLanguageIds: ['jade', 'pug']
        }
    ],
    parsers: {
        pug: {
            parse(text, parsers, options) {
                logger.debug('[parsers:pug:parse]:', { text });
                let trimmedAndAlignedContent = text.replace(/^\s*\n/, '');
                const contentIndentation = /^\s*/.exec(trimmedAndAlignedContent);
                if (contentIndentation === null || contentIndentation === void 0 ? void 0 : contentIndentation[0]) {
                    const contentIndentationRegex = new RegExp(`(^|\\n)${contentIndentation[0]}`, 'g');
                    trimmedAndAlignedContent = trimmedAndAlignedContent.replace(contentIndentationRegex, '$1');
                }
                const content = trimmedAndAlignedContent;
                const tokens = lex(content);
                return { content, tokens };
            },
            astFormat: 'pug-ast',
            hasPragma(text) {
                return text.startsWith('//- @prettier\n') || text.startsWith('//- @format\n');
            },
            locStart(node) {
                logger.debug('[parsers:pug:locStart]:', { node });
                return 0;
            },
            locEnd(node) {
                logger.debug('[parsers:pug:locEnd]:', { node });
                return 0;
            },
            preprocess(text, options) {
                logger.debug('[parsers:pug:preprocess]:', { text });
                return text;
            }
        }
    },
    printers: {
        'pug-ast': {
            print(path, options, print) {
                const entry = path.stack[0];
                const { content, tokens } = entry;
                const pugOptions = (0, converge_1.convergeOptions)(options);
                const printer = new printer_1.PugPrinter(content, tokens, pugOptions);
                const result = printer.build();
                logger.debug('[printers:pug-ast:print]:', result);
                return result;
            },
            embed(path, print, textToDoc, options) {
                return null;
            },
            insertPragma(text) {
                return `//- @prettier\n${text}`;
            }
        }
    },
    options: options_1.options,
    defaultOptions: {}
};
exports.languages = exports.plugin.languages;
exports.parsers = exports.plugin.parsers;
exports.printers = exports.plugin.printers;
exports.options = exports.plugin.options;
exports.defaultOptions = exports.plugin.defaultOptions;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiaW5kZXguanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvaW5kZXgudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBYUEsaUNBQWlDO0FBQ2pDLHFDQUEwRDtBQUUxRCx1Q0FBa0Q7QUFDbEQsaURBQXFEO0FBRXJELHVDQUF1QztBQUV2QyxNQUFNLE1BQU0sR0FBVyxJQUFBLHFCQUFZLEVBQUMsT0FBTyxDQUFDLENBQUM7QUFDN0MsSUFBSSxPQUFPLENBQUMsR0FBRyxDQUFDLFFBQVEsS0FBSyxNQUFNLEVBQUU7SUFDcEMsTUFBTSxDQUFDLFdBQVcsQ0FBQyxpQkFBUSxDQUFDLEtBQUssQ0FBQyxDQUFDO0NBQ25DO0FBU1ksUUFBQSxNQUFNLEdBQVc7SUFDN0IsU0FBUyxFQUFFO1FBQ1Y7WUFDQyxJQUFJLEVBQUUsS0FBSztZQUNYLE9BQU8sRUFBRSxDQUFDLEtBQUssQ0FBQztZQUNoQixPQUFPLEVBQUUsV0FBVztZQUNwQixPQUFPLEVBQUUsTUFBTTtZQUNmLGNBQWMsRUFBRSxLQUFLO1lBQ3JCLGtCQUFrQixFQUFFLFlBQVk7WUFDaEMsVUFBVSxFQUFFLENBQUMsT0FBTyxFQUFFLE1BQU0sQ0FBQztZQUM3QixrQkFBa0IsRUFBRSxHQUFHO1lBQ3ZCLGlCQUFpQixFQUFFLENBQUMsTUFBTSxFQUFFLEtBQUssQ0FBQztTQUNsQztLQUNEO0lBRUQsT0FBTyxFQUFFO1FBQ1IsR0FBRyxFQUFFO1lBQ0osS0FBSyxDQUFDLElBQVksRUFBRSxPQUF5QyxFQUFFLE9BQXNCO2dCQUNwRixNQUFNLENBQUMsS0FBSyxDQUFDLHNCQUFzQixFQUFFLEVBQUUsSUFBSSxFQUFFLENBQUMsQ0FBQztnQkFFL0MsSUFBSSx3QkFBd0IsR0FBVyxJQUFJLENBQUMsT0FBTyxDQUFDLFFBQVEsRUFBRSxFQUFFLENBQUMsQ0FBQztnQkFDbEUsTUFBTSxrQkFBa0IsR0FBMkIsTUFBTSxDQUFDLElBQUksQ0FBQyx3QkFBd0IsQ0FBQyxDQUFDO2dCQUN6RixJQUFJ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
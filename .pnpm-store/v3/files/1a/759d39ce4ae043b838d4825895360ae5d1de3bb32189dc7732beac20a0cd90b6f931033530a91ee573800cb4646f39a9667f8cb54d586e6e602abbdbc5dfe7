"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createLogger = exports.Logger = exports.LogLevel = void 0;
var LogLevel;
(function (LogLevel) {
    LogLevel[LogLevel["DEBUG"] = 0] = "DEBUG";
    LogLevel[LogLevel["LOG"] = 1] = "LOG";
    LogLevel[LogLevel["INFO"] = 2] = "INFO";
    LogLevel[LogLevel["WARN"] = 3] = "WARN";
    LogLevel[LogLevel["ERROR"] = 4] = "ERROR";
    LogLevel[LogLevel["OFF"] = 5] = "OFF";
})(LogLevel = exports.LogLevel || (exports.LogLevel = {}));
class Logger {
    constructor(logger = console, level = LogLevel.INFO) {
        this.logger = logger;
        this.level = level;
    }
    setLogLevel(level) {
        this.level = level;
    }
    isDebugEnabled() {
        return this.level <= LogLevel.DEBUG;
    }
    debug(message, ...optionalParams) {
        this.message(LogLevel.DEBUG, message, ...optionalParams);
    }
    log(message, ...optionalParams) {
        this.message(LogLevel.LOG, message, ...optionalParams);
    }
    info(message, ...optionalParams) {
        this.message(LogLevel.INFO, message, ...optionalParams);
    }
    warn(message, ...optionalParams) {
        this.message(LogLevel.WARN, message, ...optionalParams);
    }
    error(message, ...optionalParams) {
        this.message(LogLevel.ERROR, message, ...optionalParams);
    }
    message(level, message, ...optionalParams) {
        if (this.level !== LogLevel.OFF && this.level <= level) {
            const logLevel = Logger.LOG_LEVELS[level];
            if (logLevel) {
                this.logger[logLevel](message, ...optionalParams);
            }
        }
    }
}
exports.Logger = Logger;
Logger.LOG_LEVELS = [
    'debug',
    'log',
    'info',
    'warn',
    'error'
];
function createLogger(logger = console) {
    return new Logger(logger);
}
exports.createLogger = createLogger;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibG9nZ2VyLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vc3JjL2xvZ2dlci50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFDQSxJQUFZLFFBT1g7QUFQRCxXQUFZLFFBQVE7SUFDbkIseUNBQUssQ0FBQTtJQUNMLHFDQUFHLENBQUE7SUFDSCx1Q0FBSSxDQUFBO0lBQ0osdUNBQUksQ0FBQTtJQUNKLHlDQUFLLENBQUE7SUFDTCxxQ0FBRyxDQUFBO0FBQ0osQ0FBQyxFQVBXLFFBQVEsR0FBUixnQkFBUSxLQUFSLGdCQUFRLFFBT25CO0FBWUQsTUFBYSxNQUFNO0lBZWxCLFlBQW9DLFNBQWtCLE9BQU8sRUFBVSxRQUFrQixRQUFRLENBQUMsSUFBSTtRQUFsRSxXQUFNLEdBQU4sTUFBTSxDQUFtQjtRQUFVLFVBQUssR0FBTCxLQUFLLENBQTBCO0lBQUcsQ0FBQztJQU9uRyxXQUFXLENBQUMsS0FBZTtRQUNqQyxJQUFJLENBQUMsS0FBSyxHQUFHLEtBQUssQ0FBQztJQUNwQixDQUFDO0lBT00sY0FBYztRQUNwQixPQUFPLElBQUksQ0FBQyxLQUFLLElBQUksUUFBUSxDQUFDLEtBQUssQ0FBQztJQUNyQyxDQUFDO0lBUU0sS0FBSyxDQUFDLE9BQWlCLEVBQUUsR0FBRyxjQUFxQjtRQUN2RCxJQUFJLENBQUMsT0FBTyxDQUFDLFFBQVEsQ0FBQyxLQUFLLEVBQUUsT0FBTyxFQUFFLEdBQUcsY0FBYyxDQUFDLENBQUM7SUFDMUQsQ0FBQztJQVFNLEdBQUcsQ0FBQyxPQUFpQixFQUFFLEdBQUcsY0FBcUI7UUFDckQsSUFBSSxDQUFDLE9BQU8sQ0FBQyxRQUFRLENBQUMsR0FBRyxFQUFFLE9BQU8sRUFBRSxHQUFHLGNBQWMsQ0FBQyxDQUFDO0lBQ3hELENBQUM7SUFRTSxJQUFJLENBQUMsT0FBaUIsRUFBRSxHQUFHLGNBQXFCO1FBQ3RELElBQUksQ0FBQyxPQUFPLENBQUMsUUFBUSxDQUFDLElBQUksRUFBRSxPQUFPLEVBQUUsR0FBRyxjQUFjLENBQUMsQ0FBQztJQUN6RCxDQUFDO0lBUU0sSUFBSSxDQUFDLE9BQWlCLEVBQUUsR0FBRyxjQUFxQjtRQUN0RCxJQUFJLENBQUMsT0FBTyxDQUFDLFFBQVEsQ0FBQyxJQUFJLEVBQUUsT0FBTyxFQUFFLEdBQUcsY0FBYyxDQUFDLENBQUM7SUFDekQsQ0FBQztJQVFNLEtBQUssQ0FBQyxPQUFpQixFQUFFLEdBQUcsY0FBcUI7UUFDdkQsSUFBSSxDQUFDLE9BQU8sQ0FBQyxRQUFRLENBQUMsS0FBSyxFQUFFLE9BQU8sRUFBRSxHQUFHLGNBQWMsQ0FBQyxDQUFDO0lBQzFELENBQUM7SUFFTyxPQUFPLENBQUMsS0FBZSxFQUFFLE9BQWEsRUFBRSxHQUFHLGNBQXFCO1FBQ3ZFLElBQUksSUFBSSxDQUFDLEtBQUssS0FBSyxRQUFRLENBQUMsR0FBRyxJQUFJLElBQUksQ0FBQyxLQUFLLElBQUksS0FBSyxFQUFFO1lBQ3ZELE1BQU0sUUFBUSxHQUNiLE1BQU0sQ0FBQyxVQUFVLENBQUMsS0FBZSxDQUFDLENBQUM7WUFDcEMsSUFBSSxRQUFRLEVBQUU7Z0JBQ2IsSUFBSSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUMsQ0FBQyxPQUFPLEVBQUUsR0FBRyxjQUFjLENBQUMsQ0FBQzthQUNsRDtTQUNEO0lBQ0YsQ0FBQzs7QUE3RkYsd0JBOEZDO0FBN0Z3QixpQkFBVSxHQUE4QztJQUMvRSxPQUFPO0lBQ1AsS0FBSztJQUNMLE1BQU07SUFDTixNQUFNO0lBQ04sT0FBTztDQUNQLENBQUM7QUErRkgsU0FBZ0IsWUFBWSxDQUFDLFNBQWtCLE9BQU87SUFDckQsT0FBTyxJQUFJLE1BQU0sQ0FBQyxNQUFNLENBQUMsQ0FBQztBQUMzQixDQUFDO0FBRkQsb0NBRUMifQ==
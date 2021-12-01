"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.get = void 0;
function get(url, options, httpModulePath) {
    const client = httpModulePath
        ?
            require(httpModulePath)
        :
            require("./get-modules/http");
    return client.default ? client.default(url, options) : client(url, options);
}
exports.get = get;

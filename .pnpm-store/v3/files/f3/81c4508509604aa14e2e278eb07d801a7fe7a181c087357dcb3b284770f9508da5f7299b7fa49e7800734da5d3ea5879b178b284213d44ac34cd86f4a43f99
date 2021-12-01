"use strict";
module.exports = {
    plugins: ["jsonc"],
    overrides: [
        {
            files: ["*.json", "*.json5"],
            parser: require.resolve("jsonc-eslint-parser"),
            rules: {
                strict: "off",
                "no-unused-expressions": "off",
            },
        },
    ],
};

"use strict";

const RuleTester = require("eslint").RuleTester;
const rule = require("../rules/lines-between-object-properties")

const ruleTester = new RuleTester({ parserOptions: { ecmaVersion: 2015 } });

ruleTester.run("lines-between-object-properties", rule, {
    valid: [
        {
            code: "const foo = {\na: 1,\n\nb: 2}",
            options: ["always"]
        },
        {
            code: "const foo = {\na: 1,\nb: 2}",
            options: ["never"]
        },
        {
            code: "const foo = {\na: 1,\nb() {\n},\n\nc() {\n}\n}",
            options: ["always", { "exceptAfterSingleLine": true }]
        },
        {
            code: "const foo = {\na: 1,\n\nb() {\n},\n\nc() {\n}\n}",
            options: ["always", { "exceptBetweenSingleLines": true }]
        }
    ],

    invalid: [
        {
            code: "const foo = {\na: 1,\nb: 2}",
            options: ["always"],
            errors: [{ message: "Expected blank line between object properties." }]
        },
        {
            code: "const foo = {\na: 1,\n\nb: 2}",
            options: ["never"],
            errors: [{ message: "Unexpected blank line between object properties." }]
        },
        {
            code: "const foo = {\na: 1,\nb() {\n},\n\nc() {\n}\n}",
            options: ["always", { "exceptBetweenSingleLines": true }],
            errors: [{ message: "Expected blank line between object properties." }]
        }
    ]
});

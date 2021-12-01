/**
 * @fileoverview Use class arrow methods instead of binding in the constructor
 * @author Mark Battersby
 */
'use strict'

//------------------------------------------------------------------------------
// Requirements
//------------------------------------------------------------------------------

var rule = require('../../../lib/rules/no-constructor-state'),
  RuleTester = require('eslint').RuleTester

RuleTester.setDefaultConfig({ parser: require.resolve('babel-eslint') })

//------------------------------------------------------------------------------
// Tests
//------------------------------------------------------------------------------

var error = {
  type: 'AssignmentExpression',
  message: "Don't set initial state in the constructor"
}

var ruleTester = new RuleTester()
ruleTester.run('no-constructor-state', rule, {
  valid: [
    'class myClass { state = { foo: "bar" } }',
    'class myClass { constructor() { this.notState = { foo: "bar" } } }',
    'class myClass { constructor() { this.notState = { foo: "bar" } } state = { foo: "bar" } }',
    // Shouldn't flag on complex state creation in constructor
    'class myClass { constructor() { const bar = 1; this.state = { foo: bar } } }',
    'class myClass { constructor(props) { this.state = { ...props } } }',
    'class myClass { constructor(props) { this.state = [ ...props ] } }',
    'class myClass { constructor(props) { this.state = { foo: { ...props } } } }',
    'class myClass { constructor(props) { this.state = { foo: [ ...props ] } } }',
    'class myClass { constructor(props) { this.state = { foo: props.foo } } }',
    'class myClass { constructor(props) { this.state = { foo: _.defaults(props, { bar: "baz" }) } } }'
  ],

  invalid: [
    {
      // Should handle simple literals
      code:
        'class myClass { constructor() { this.state = { foo: "bar" } } }',
      output:
        'class myClass { constructor() {  } state = { foo: "bar" } }',
      errors: [error]
    },
    {
      // Should handle nested literals
      code:
        'class myClass { constructor() { this.state = { foo: { bar: "baz" } } } }',
      output:
        'class myClass { constructor() {  } state = { foo: { bar: "baz" } } }',
      errors: [error]
    },
    {
      // Should handle deeply nested literals
      code:
        'class myClass { constructor() { this.state = { foo: { bar: { baz: "buzz" } } } } }',
      output:
        'class myClass { constructor() {  } state = { foo: { bar: { baz: "buzz" } } } }',
      errors: [error]
    },
    {
      // Should handle arrays made up of literals
      code:
        'class myClass { constructor() { this.state = { foo: [0, 1, "", "foo", true, false, null, undefined, NaN, Infinity] } } }',
      output:
        'class myClass { constructor() {  } state = { foo: [0, 1, "", "foo", true, false, null, undefined, NaN, Infinity] } }',
      errors: [error]
    },
    {
      // Should handle multiple classes.
      code:
        `class firstClass { constructor() { this.state = { foo: "bar" } } }
         class secondClass { constructor() { this.state = { foo: "bar" } } }`,
      output:
        `class firstClass { constructor() {  } state = { foo: "bar" } }
         class secondClass { constructor() {  } state = { foo: "bar" } }`,
      errors: [error, error]
    },
    {
      // Infers that state should be separated by a newline.
      code:
        `class myClass {
          constructor() {
            super()
            this.state = { foo: "bar" }
          }
        }`,

      output:
        `class myClass {
          constructor() {
            super()
            ` + `
          }

          state = { foo: "bar" }
        }`,
      errors: [error]
    }
  ]
})

/**
 * @fileoverview Use class arrow methods instead of binding in the constructor
 * @author Mark Battersby
 */
'use strict'

//------------------------------------------------------------------------------
// Requirements
//------------------------------------------------------------------------------

var rule = require('../../../lib/rules/no-constructor-bind'),
  RuleTester = require('eslint').RuleTester

RuleTester.setDefaultConfig({ parser: require.resolve('babel-eslint') })

//------------------------------------------------------------------------------
// Tests
//------------------------------------------------------------------------------

var error = {
  type: 'AssignmentExpression',
  message: 'use arrow functions instead of binding in the constructor'
}

var ruleTester = new RuleTester()
ruleTester.run('no-constructor-bind', rule, {
  valid: [
    'class myClass { myFunction = () => {} }',
    'myClass = class { myFunction = () => {} }',

    'class myClass { constructor() { this.myFunction = this.myFunction.bind({ foo: "bar" }) } }',
    'myClass = class { constructor() { this.myFunction = this.myFunction.bind({ foo: "bar" }) } }',

    'class firstClass { myFunction = () => {} } class secondClass { myFunction = () => {} }',
    'firstClass = class { myFunction = () => {} }; class secondClass { myFunction = () => {} }',
    'firstClass = class { myFunction = () => {} }; secondClass = class { myFunction = () => {} }',

    'class myClass { constructor() { this.myFn = this.fns.myFn.bind(this) } fns = { myFn: function() {} } }',
    'class myClass { constructor() { this.myFunction = myFunction.bind(this) } }',

    'class myClass { myFunction() { return class { constructor() {} } } }'
  ],

  invalid: [
    {
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction() {} }',
      output:
        'class myClass { constructor() {  } myFunction = () => {} }',
      errors: [error]
    },
    {
      code:
        'myClass = class { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction() {} }',
      output:
        'myClass = class { constructor() {  } myFunction = () => {} }',
      errors: [error]
    },
    {
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction(arg1) {} }',
      output:
        'class myClass { constructor() {  } myFunction = (arg1) => {} }',
      errors: [error]
    },
    {
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } async myFunction() {} }',
      output:
        'class myClass { constructor() {  } myFunction = async () => {} }',
      errors: [error]
    },
    {
      // Method cannot be converted to arrow function because it doesn't exist. So bind should not be removed.
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } }',
      output:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } }',
      errors: [error]
    },
    {
      // Method is already an arrow function. Maybe bind should not be removed?
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction = () => {} }',
      output:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction = () => {} }',
      errors: [error]
    },
    {
      // Should handle multiple classes.
      code:
        `class firstClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction() {} }
         class secondClass { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction() {} }`,
      output:
        `class firstClass { constructor() {  } myFunction = () => {} }
         class secondClass { constructor() {  } myFunction = () => {} }`,
      errors: [error, error]
    },
    {
      // Should handle semicolons.
      code:
        'class myClass { constructor() { this.myFunction = this.myFunction.bind(this); }; myFunction() {}; };',
      output:
        'class myClass { constructor() {  }; myFunction = () => {}; };',
      errors: [error]
    },
    // Should handle multi-line params
    {
      code:
        `class myClass {
          constructor() { this.myFunction = this.myFunction.bind(this) }
          myFunction(
            arg1,
            arg2,
            arg3
          ) {}
        }`,
      output:
        `class myClass {
          constructor() {  }
          myFunction = (
            arg1,
            arg2,
            arg3
          ) => {}
        }`,
      errors: [error]
    },
    {
      // Should handle anonymous classes
      code:
        'class myClass { constructor() { return class { constructor() { this.myFunction = this.myFunction.bind(this) } myFunction() {} } } }',
      output:
        'class myClass { constructor() { return class { constructor() {  } myFunction = () => {} } } }',
      errors: [error]
    }
  ]
})

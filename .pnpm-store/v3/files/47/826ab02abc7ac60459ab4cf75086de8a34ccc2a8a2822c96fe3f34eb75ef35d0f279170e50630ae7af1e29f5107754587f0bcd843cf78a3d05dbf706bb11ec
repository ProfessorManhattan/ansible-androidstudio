/**
 * @fileoverview Tests to enforce returning store.dispatch() when asynchronously making a test
 *               assertion
 * @author Eric L. Goldstein <elg2001@columbia.edu>
 */
'use strict';

//------------------------------------------------------------------------------
// Requirements
//------------------------------------------------------------------------------

const rule = require('../../../lib/rules/expect-return');
const RuleTester = require('eslint').RuleTester;

RuleTester.setDefaultConfig({
  parserOptions: {
    ecmaVersion: 6,
  },
});


//------------------------------------------------------------------------------
// Tests
//------------------------------------------------------------------------------

const ruleTester = new RuleTester();
ruleTester.run('expect-return', rule, {
  valid: [
    `
    function test() {
      return store.dispatch(action())
        .then(() => expect(store.getActions()).toEqual(expectedActions)); }
    `,
    `
    function test() {
      return store.dispatch(action())
        .then(() => store.dispatch(action2()))
        .then(() => expect(store.getActions()).toEqual(expectedActions));
    }
    `
  ],

  invalid: [
    {
      code: `
        function test() {
          store.dispatch(action())
            .then(() => expect(store.getActions()).toEqual(expectedActions));
        }
      `,
      errors: [{
        message: 'Return async dispatch expressions',
        type: 'CallExpression',
      }],
    },
    {
      code: `
        function test() {
          store.dispatch(action())
            .then(() => store.dispatch(action2()))
            .then(() => expect(store.getActions()).toEqual(expectedActions));
        }
      `,
      errors: [{
        message: 'Return async dispatch expressions',
        type: 'CallExpression',
      }],
    },
  ],
});

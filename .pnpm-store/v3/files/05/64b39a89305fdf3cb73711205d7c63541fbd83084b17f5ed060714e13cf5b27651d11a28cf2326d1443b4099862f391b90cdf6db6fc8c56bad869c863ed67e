'use strict';

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

module.exports = {
  meta: {
    docs: {},

    schema: []
  },

  create: function noCaseCurly(context) {
    return {
      SwitchCase: function SwitchCase(node) {
        if (node.consequent.length && node.consequent[0].type === 'BlockStatement') {
          context.report(node, 'Do not use braces in a case - extract the case to a' + ' function if it requires its own variables.');
        }
      }
    };
  }
};
/**
 * @fileoverview Enforces returning store.dispatch() when asynchronously making a test assertion
 * @author Eric L. Goldstein <elg2001@columbia.edu>
 */
'use strict';

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

module.exports = {
  meta: {
    docs: {
      description: 'Enforces returning store.dispatch() when asynchronously making a test assertion',
    },
  },

  create(context) {
    return {
      CallExpression(node) {
        // Ensure we're looking at the outermost MemberExpression of the Promise chain
        const hasParentMemberExpression = node.parent.type === 'MemberExpression';
        const hasParentReturnStatement = node.parent.type === 'ReturnStatement';

        const hasMemberExpression = 'callee' in node && node.callee.type === 'MemberExpression';
        if (!hasParentMemberExpression && !hasParentReturnStatement && hasMemberExpression) {
          // Find the innermost CallExpression to find a call to dispatch() within it
          let ce = 'callee' in node && 'object' in node.callee ? node.callee.object : null;
          while (ce && 'callee' in ce && 'object' in ce.callee && ce.callee.object.type === 'CallExpression') {
            ce = ce.callee.object;
          }
          const hasDispatch =
            'callee' in ce
            && 'property' in ce.callee
            && ce.callee.property.name === 'dispatch';

          // Find any chained ".then()" call
          const memberExpression = node.callee;
          const hasThen = 'property' in memberExpression && memberExpression.property.name === 'then';

          // If both are found, we have a problem
          if (hasDispatch && hasThen) {
            context.report({
              message: 'Return async dispatch expressions',
              node,
            });
          }
        }
      },
    };
  },
};

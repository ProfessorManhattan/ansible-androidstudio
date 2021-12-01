/**
 * @fileoverview Use class arrow functions instead of binding in the constructor
 * @author Mark Battersby
 */
'use strict'

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

module.exports = {
  meta: {
    docs: {
      description:
        'Use class property instead of setting initial state in the constructor',
      category: 'ECMAScript 7',
      recommended: false
    },
    fixable: 'code',
    schema: []
  },

  create: function(context) {
    //----------------------------------------------------------------------
    // Helpers
    //----------------------------------------------------------------------

    function assigningToThis(node) {
      return (
        node.left &&
        node.left.type === 'MemberExpression' &&
        node.left.object &&
        node.left.object.type === 'ThisExpression'
      )
    }

    function assigningToState(node) {
      return (
        node.left &&
        node.left.type === 'MemberExpression' &&
        node.left.property &&
        node.left.property.name === 'state'
      )
    }

    function assigningSimpleValue(node) {
      return node.right && isSimple(node.right)
    }

    function isSimple(node) {
      return (
        isLiteral(node) ||
        isMagicIdentifier(node) ||
        isSimpleObject(node) ||
        isSimpleArray(node)
      )
    }

    function isLiteral(node) {
      return node.type === 'Literal'
    }

    function isMagicIdentifier(node) {
      return (
        node.type === 'Identifier' &&
        node.name === 'undefined' ||
        node.name === 'Infinity' ||
        node.name === 'NaN'
      )
    }

    function isSimpleObject(node) {
      return (
        node.type === 'ObjectExpression' &&
        node.properties.every(p => p.value && isSimple(p.value))
      )
    }

    function isSimpleArray(node) {
      return (
        node.type === 'ArrayExpression' &&
        node.elements.every(isSimple)
      )
    }

    function reconstructState(node) {
      const constructorNode = findConstructor(node)
      const newline =
        constructorNode.loc.start.line !== constructorNode.loc.end.line
      const indent = constructorNode.loc.start.column

      const sourceCode = context.getSourceCode()

      let leftText = ' state = '
      if (newline) {
        leftText = '\n\n' + ' '.repeat(indent) + 'state = '
      }

      const rightText = sourceCode.getText(node.right)
      return leftText + rightText
    }

    function findConstructor(node) {
      // this seems... maybe brittle
      return node.parent.parent.parent.parent
    }

    //----------------------------------------------------------------------
    // Public
    //----------------------------------------------------------------------

    function checkAssignment(node) {
      if (
        assigningToThis(node) &&
        assigningToState(node) &&
        assigningSimpleValue(node)
      ) {
        context.report({
          node: node,
          message: "Don't set initial state in the constructor",
          fix: fixer => [
            fixer.insertTextAfter(findConstructor(node), reconstructState(node)),
            fixer.remove(node)
          ]
        })
      }
    }

    const constructorDefinition = [
      'MethodDefinition[kind="constructor"]',
      'ExpressionStatement',
      'AssignmentExpression'
    ].join(' ')

    return {
      [constructorDefinition]: checkAssignment
    }
  }
}

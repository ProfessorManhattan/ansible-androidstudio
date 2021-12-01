const { parseLines, stringify } = require('dot-properties')
const linguist = require('linguist-languages')['Java Properties']
const { concat, hardline } = require('prettier').doc.builders

const language = {
  name: linguist.name,
  parsers: ['dot-properties'],
  tmScope: linguist.tmScope,
  aceMode: linguist.aceMode,
  codemirrorMode: linguist.codemirrorMode,
  codemirrorMimeType: linguist.codemirrorMimeType,
  aliases: ['properties'],
  extensions: linguist.extensions,
  linguistLanguageId: linguist.languageId,
  vscodeLanguageIds: ['properties']
}

const parser = {
  parse: text => parseLines(text, true),
  astFormat: 'dot-properties',
  hasPragma: text => /^\s*[#!][ \t\f]*@(pragma|format)\b/.test(text),
  locStart(node) {
    // istanbul ignore if
    if (Array.isArray(node)) node = node[0]
    return node.range[0]
  },
  locEnd(node) {
    // istanbul ignore if
    if (Array.isArray(node)) node = node[node.length - 1]
    return node.range[node.range.length - 1]
  }
}

const printer = {
  print(path, options, print) {
    const node = path.getValue()
    if (Array.isArray(node)) return concat(path.map(print))
    const opt = {
      indent: options.useTabs ? '\t' : ' '.repeat(options.tabWidth),
      keySep: options.keySeparator,
      latin1: options.escapeNonLatin1,
      lineWidth: options.printWidth
    }
    return concat([stringify([node], opt), hardline])
  },
  hasPrettierIgnore(path) {
    const node = path.getValue()
    if (Array.isArray(node)) return false
    const tokens = path.stack[0]
    // istanbul ignore else
    if (Array.isArray(tokens)) {
      const prev = tokens[tokens.indexOf(node) - 1]
      return (
        prev &&
        prev.type === 'COMMENT' &&
        /^\s*[#!][ \t\f]*prettier-ignore/.test(prev.comment)
      )
    } else return false
  },
  insertPragma: text => `# @format\n${text}`
}

const options = {
  escapeNonLatin1: {
    category: 'Format',
    type: 'boolean',
    description:
      'Escape with \\u all non-Latin-1 characters, to allow safely encoding as ISO-8859-1',
    default: false
  },
  keySeparator: {
    category: 'Format',
    type: 'choice',
    description: 'The separator to use between a property key and its value',
    default: ' = ',
    choices: [
      { value: ' ' },
      { value: ':' },
      { value: '=' },
      { value: ': ' },
      { value: '= ' },
      { value: ' : ' },
      { value: ' = ' }
    ]
  }
}

module.exports = {
  languages: [language],
  parsers: { 'dot-properties': parser },
  printers: { 'dot-properties': printer },
  options
}

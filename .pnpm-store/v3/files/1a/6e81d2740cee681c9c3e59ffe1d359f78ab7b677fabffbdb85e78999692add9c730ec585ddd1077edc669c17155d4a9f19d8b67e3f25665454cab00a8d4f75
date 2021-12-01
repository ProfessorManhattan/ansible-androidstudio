# String-Break

[![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Build status][azure-image]][azure-url]
[![Coverage status][coveralls-image]][coveralls-url]
[![npm download][download-image]][download-url]

![](./example/screenshot.gif)

String-Break 是命令行字符串格式化工具，可以方便的将长字符串按照宽度分段。
  
特点:

  - 支持中文，英文，中英文混排
  - 英文不会被截断
  - 标点不会出现在行首

## Install

```shell
npm install string-break --save
```

## Usage

```js
const stringBreak = require('string-break');
const str = '远处海港传来阵阵船笛 我一直飘零到被你拣起 如今望著反映窗户玻璃 有个我陌生又熟悉';

let lines = stringBreak(str, 30);
/**
 * lines: [ 
 *   '远处海港传来阵阵船笛 我一直飘',
 *   '零到被你拣起 如今望著反映窗户',
 *   '玻璃 有个我陌生又熟悉'
 * ]
 */
```

## License

MIT.

[npm-image]: https://img.shields.io/npm/v/string-break.svg?maxAge=3600
[npm-url]: https://www.npmjs.com/package/string-break
[travis-image]: https://img.shields.io/travis/keenwon/string-break.svg?maxAge=3600&logo=travis
[travis-url]: https://travis-ci.org/keenwon/string-break
[azure-image]: https://dev.azure.com/keenwon/github/_apis/build/status/string-break?branchName=master
[azure-url]: https://dev.azure.com/keenwon/github/_build/latest?definitionId=2
[coveralls-image]: https://coveralls.io/repos/github/keenwon/string-break/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/keenwon/string-break?branch=master
[download-image]: https://img.shields.io/npm/dm/string-break.svg?maxAge=3600
[download-url]: https://npmjs.org/package/string-break

'use strict';

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _lodash = require('lodash.zipobject');

var _lodash2 = _interopRequireDefault(_lodash);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const rules = _fs2.default.readdirSync(_path2.default.resolve(__dirname, 'rules')).map(f => f.replace(/\.js$/, ''));

module.exports = {
  // eslint-disable-next-line global-require
  rules: (0, _lodash2.default)(rules, rules.map(rule => require(`./rules/${ rule }`))),
  configs: {
    recommended: {
      rules: {
        'switch-case/newline-between-switch-case': 'error',
        'switch-case/no-case-curly': 'error'
      }
    }
  }
};
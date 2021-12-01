# eslint-plugin-no-constructor-bind

[![Build Status](https://travis-ci.org/markalfred/eslint-plugin-no-constructor-bind.svg?branch=master)](https://travis-ci.org/markalfred/eslint-plugin-no-constructor-bind)
[![Coverage Status](https://coveralls.io/repos/github/markalfred/eslint-plugin-no-constructor-bind/badge.svg?branch=master)](https://coveralls.io/github/markalfred/eslint-plugin-no-constructor-bind?branch=master)
[![Known Vulnerabilities](https://snyk.io/test/github/markalfred/eslint-plugin-no-constructor-bind/badge.svg?targetFile=package.json)](https://snyk.io/test/github/markalfred/eslint-plugin-no-constructor-bind?targetFile=package.json)

Prefer class properties to equivalent setup steps taken in a class' constructor method.

```js
// Bad:
class User {
  constructor() {
    this.greet = this.greet.bind(this)
  }
  greet() { return 'Hello' }
}

// Good:
class User {
  greet = () => 'hello'
}
```

Use `no-constructor-bind` to eliminate bound functions in your constructor.
Use `no-constructor-state` to eliminate initial state setting in your constructor.
Doing this, most likely you'll be able to use ESLint's builtin `no-useless-constructor` to remove many constructors in your app.

## Installation

You'll first need to install [ESLint](http://eslint.org):

```
$ npm i eslint --save-dev
```

Next, install `eslint-plugin-no-constructor-bind`:

```
$ npm install eslint-plugin-no-constructor-bind --save-dev
```

**Note:** If you installed ESLint globally (using the `-g` flag) then you must also install `eslint-plugin-no-constructor-bind` globally.

## Usage

Add `no-constructor-bind` to the plugins section of your `.eslintrc` configuration file. You can omit the `eslint-plugin-` prefix:

```json
{
  "plugins": ["no-constructor-bind"]
}
```

Then configure the rules you want to use under the rules section.

```json
{
  "rules": {
    "no-constructor-bind/no-constructor-bind": "error",
    "no-constructor-bind/no-constructor-state": "error"
  }
}
```

## Supported Rules

* no-constructor-bind (:wrench:) — Use class arrow functions instead of binding in the constructor
* no-constructor-state (:wrench:) — Use class property instead of setting initial state in the constructor

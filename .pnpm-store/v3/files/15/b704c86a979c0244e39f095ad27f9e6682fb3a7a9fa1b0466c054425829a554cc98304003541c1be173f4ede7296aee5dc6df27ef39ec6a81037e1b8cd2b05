# eslint-plugin-ext
eslint extended rules

## Install
```sh
npm i eslint-plugin-ext -D
```

Edit `.eslintrc.json`:

```json
{
  "plugins": [
    "ext"
  ],

  "rules": {
    "ext/lines-between-object-properties": ["error", "always", { "exceptBetweenSingleLines": true }]
  }
}
```

## Rules

### lines-between-object-properties
require or disallow an empty line between object properties.

Modified from [lines-between-class-members](https://eslint.org/docs/rules/lines-between-class-members).

It has same options as `lines-between-class-members`, and one extra option `exceptBetweenSingleLines`.

```js
/* eslint ext/lines-between-object-properties: ["error", "always", { "exceptBetweenSingleLines": true }] */

// bad
const foo = {
  a: 1,
  b: 2,
  c() {
  },
  d() {
  }
}

// good
const foo = {
  a: 1,
  b: 2,

  c() {
  },

  d() {
  }
}
```

## License
[MIT](LICENSE)

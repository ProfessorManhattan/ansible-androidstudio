# Prettier Config Documentation

> Documentation for the `@megabytelabs/prettier-config` module.

## Usage

**Yarn:**

```sh
yarn add --dev @megabytelabs/prettier-config
```

**NPM**

```
npm install --save-dev @megabytelabs/prettier-config
```

And reference it in your _.prettierrc.js_ file:

```js
module.exports = require('@megabytelabs/prettier-config');
```

Or you can, of course, choose your preferred way of using configs:

<details>
<summary><i>package.json</i></summary>

```json
{
  // ...
  "prettier": "@megabytelabs/prettier-config"
}
```

</details>
<details>
<summary><i>.prettierrc</i> or <i>.prettierrc.json</i></summary>

```json
{
  "extends": ["@megabytelabs/prettier-config"]
}
```

</details>

_Note: If you are using `prettier` < v1.17 check [this note](#Prettier-version)._

## Extending

To extend the current options you will need to create a _.prettierrc.js_ and add the following:

```js
module.exports = {
  ...require('@megabytelabs/prettier-config'),

  // Add custom options bellow:
  useTabs: true
};
```

## Prettier version

Versions of `prettier` prior to v1.17 did not feature the possibility to use a shared config via `package.json`. The way to do it is similar to when [extending](#Extending), except that you can just export the config directly:

```js
// .prettierrc.js

module.exports = require('@megabytelabs/prettier-config');
```

## More

- [Prettier Documentation](https://prettier.io/docs/en/index.html)
- [README.md Source](https://github.com/strvcom/code-quality-tools/blob/master/packages/prettier-config/readme.md)

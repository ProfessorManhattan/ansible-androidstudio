# Use class property instead of setting initial state in the constructor (no-constructor-state)

We can use class properties to define a component's initial state, rather than doing it in the constructor.

## Rule Details

Examples of **incorrect** code for this rule:

```js
class myClass {
  constructor() {
    super()
    this.state = { myValue: null }
  }
}
```

Examples of **correct** code for this rule:

```js
class myClass {
  state = { myValue: null }
}
```

## When Not To Use It

If you dislike class properties or if you don't use ES7 proposed syntax.

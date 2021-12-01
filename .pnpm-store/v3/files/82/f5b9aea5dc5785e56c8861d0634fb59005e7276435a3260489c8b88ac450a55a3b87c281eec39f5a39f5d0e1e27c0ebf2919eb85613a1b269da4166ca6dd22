# Use class arrow functions instead of binding in the constructor (no-constructor-bind)

Binding functions to `this` in the constructor is annoying and verbose. Let's use arrow functions instead.

## Rule Details

Examples of **incorrect** code for this rule:

```js
class myClass {
  constructor() {
    super()
    this.myFunction = this.myFunction.bind(this)
  }

  myFunction() {
    doSomething()
  }
}
```

Examples of **correct** code for this rule:

```js
class myClass {
  myFunction = () => {
    doSomething()
  }
}
```

## When Not To Use It

If you dislike arrow functions or if you don't use ES7 proposed syntax.

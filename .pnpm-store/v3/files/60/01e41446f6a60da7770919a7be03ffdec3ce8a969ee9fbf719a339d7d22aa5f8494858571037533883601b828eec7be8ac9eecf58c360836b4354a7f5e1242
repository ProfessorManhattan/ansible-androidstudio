# Expect store.dispatch assertion Promise chain to be returned (expect-return)

Jest will pass most tests whose `store.dispatch()` Promise chain is not returned. However, leaving
out the `return` keyword is easy to do, so this rule prevents that from happening.


## Rule Details

This rule aims to prevent a missing `return` keyword when testing an asynchronous action by
detecting a non-returned `store.dispatch()` call chained to a `.then()`.

Examples of **incorrect** code for this rule:

```js

function test() {
	store.dispatch(action())
		.then(() => expect(store.getActions()).toEqual(expectedActions));
}

```

Examples of **correct** code for this rule:

```js

function test() {
	return store.dispatch(action())
		.then(() => expect(store.getActions()).toEqual(expectedActions));
}

```

## When Not To Use It

If no asynchronous actions are being tested, this rule can be safely disabled.

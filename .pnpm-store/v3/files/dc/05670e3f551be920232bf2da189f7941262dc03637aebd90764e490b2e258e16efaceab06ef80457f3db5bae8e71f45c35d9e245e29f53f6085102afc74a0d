import { AST, RegExpParser } from "regexpp";
export interface SourceLocation {
	start: number;
	end: number;
}
interface NodeBase {
	type: Node["type"];
	parent: Node["parent"];
	source?: SourceLocation;
}
export type Element = CharacterClass | Alternation | Quantifier | Assertion | Unknown;
export type Parent = Expression | Alternation | Quantifier | Assertion;
export type Node = Expression | CharacterClass | Alternation | Quantifier | Assertion | Concatenation | Unknown;
export interface Alternation extends NodeBase {
	type: "Alternation";
	parent: Concatenation;
	alternatives: Concatenation[];
}
export interface Assertion extends NodeBase {
	type: "Assertion";
	parent: Concatenation;
	alternatives: Concatenation[];
	kind: "ahead" | "behind";
	negate: boolean;
}
export interface Quantifier extends NodeBase {
	type: "Quantifier";
	parent: Concatenation;
	alternatives: Concatenation[];
	lazy: boolean;
	min: number;
	max: number;
}
export interface CharacterClass extends NodeBase {
	type: "CharacterClass";
	parent: Concatenation;
	characters: CharSet;
}
export interface Unknown extends NodeBase {
	type: "Unknown";
	parent: Concatenation;
	id: string;
}
export interface Expression extends NodeBase {
	type: "Expression";
	parent: null;
	alternatives: Concatenation[];
}
export interface Concatenation extends NodeBase {
	type: "Concatenation";
	parent: Parent;
	elements: Element[];
}
type NodeIdent = {
	type: Node["type"];
};
type NoParentArray<T> = {
	[K in keyof T]: NoParent<T[K]>;
};
type NoParentNode<T extends NodeIdent> = {
	[K in keyof NoParentNodePick<T>]: NoParent<NoParentNodePick<T>[K]>;
};
type NoParentNodePick<T extends NodeIdent> = Pick<T, Exclude<keyof T, "parent">>;
/**
 * A view of an AST node that hides the `parent` property.
 */
export type NoParent<T> = T extends NodeIdent ? NoParentNode<T> : T extends unknown[] ? NoParentArray<T> : T;
/**
 * Sets the `parent` properties of the given node and all of its child nodes.
 *
 * @param node
 * @param parent The parent of `node`.
 */
export function setParent<T extends Node>(node: T | NoParent<T>, parent: T["parent"]): asserts node is T;
/**
 * Sets the `source` property of the given node and all of its child nodes.
 *
 * If `source` is not a function, then the source object will be copied for all `source` properties to be set. The
 * object will be copied using the `start` and `end` properties alone, other properties will not be copied.
 *
 * @param node
 * @param source
 * @param overwrite
 */
export function setSource(
	node: NoParent<Node>,
	source: SourceLocation | (() => SourceLocation),
	overwrite?: boolean
): void;
export interface VisitAstHandler {
	onAlternationEnter?(node: Alternation): void;
	onAlternationLeave?(node: Alternation): void;
	onAssertionEnter?(node: Assertion): void;
	onAssertionLeave?(node: Assertion): void;
	onCharacterClassEnter?(node: CharacterClass): void;
	onCharacterClassLeave?(node: CharacterClass): void;
	onConcatenationEnter?(node: Concatenation): void;
	onConcatenationLeave?(node: Concatenation): void;
	onExpressionEnter?(node: Expression): void;
	onExpressionLeave?(node: Expression): void;
	onQuantifierEnter?(node: Quantifier): void;
	onQuantifierLeave?(node: Quantifier): void;
	onUnknownEnter?(node: Unknown): void;
	onUnknownLeave?(node: Unknown): void;
}
export interface VisitNoParentAstHandler {
	onAlternationEnter?(node: NoParent<Alternation>): void;
	onAlternationLeave?(node: NoParent<Alternation>): void;
	onAssertionEnter?(node: NoParent<Assertion>): void;
	onAssertionLeave?(node: NoParent<Assertion>): void;
	onCharacterClassEnter?(node: NoParent<CharacterClass>): void;
	onCharacterClassLeave?(node: NoParent<CharacterClass>): void;
	onConcatenationEnter?(node: NoParent<Concatenation>): void;
	onConcatenationLeave?(node: NoParent<Concatenation>): void;
	onExpressionEnter?(node: NoParent<Expression>): void;
	onExpressionLeave?(node: NoParent<Expression>): void;
	onQuantifierEnter?(node: NoParent<Quantifier>): void;
	onQuantifierLeave?(node: NoParent<Quantifier>): void;
	onUnknownEnter?(node: NoParent<Unknown>): void;
	onUnknownLeave?(node: NoParent<Unknown>): void;
}
/**
 * Calls the given visitor on the given node and all of its children.
 *
 * If the given visitor throws an error, the traversal will stop and the error will be re-thrown.
 *
 * @param node
 * @param visitor
 */
export function visitAst(node: Node, visitor: VisitAstHandler): void;
export function visitAst(node: NoParent<Node>, visitor: VisitNoParentAstHandler): void;
/**
 * A transform is some algorithm that takes a AST subtree and makes any number of modifications to the given subtree.
 * They cannot see or modify anything outside the given subtree. Transformers are assumed to behave like a set of pure
 * functions.
 *
 * Transformers are always applied bottom-up.
 *
 * The most simple transformer is an empty object (`{}`). This is equivalent to a no-op transformer that does not change
 * the given AST.
 */
export interface Transformer {
	onAlternation?(node: NoParent<Alternation>, context: TransformContext): void;
	onAssertion?(node: NoParent<Assertion>, context: TransformContext): void;
	onCharacterClass?(node: NoParent<CharacterClass>, context: TransformContext): void;
	onConcatenation?(node: NoParent<Concatenation>, context: TransformContext): void;
	onExpression?(node: NoParent<Expression>, context: TransformContext): void;
	onQuantifier?(node: NoParent<Quantifier>, context: TransformContext): void;
	onUnknown?(node: NoParent<Unknown>, context: TransformContext): void;
}
export interface TransformContext {
	/**
	 * The maximum character of all character sets in the AST.
	 *
	 * If the expression to transform does not contain any characters at the start of the transformation, then this
	 * value will be `0`.
	 */
	readonly maxCharacter: Char;
	/**
	 * Signals that the transformer changed the AST.
	 */
	readonly signalMutation: () => void;
}
/**
 * Creates a new transformer that performs all given transformers in sequentially order.
 *
 * If only one transformer is given, the returned transformer will be functionally equivalent. If no transformers are
 * given, the returned transformer will be equivalent to a noop transformer.
 *
 * The given iterable can be changed and reused after this function returns.
 *
 * @param transformers
 */
export function combineTransformers(transformers: Iterable<Transformer>): Transformer;
export interface TransformOptions {
	/**
	 * The maximum number of times the transformer will be applied to the AST.
	 *
	 * This is only a maximum. The transformer will be stopped before this number is reach if the AST isn't modified
	 * anymore.
	 *
	 * @default 10
	 */
	maxPasses?: number;
}
/**
 * Transforms the given expression according to the given transformer.
 *
 * __Do not__ use the given `ast` object again after calling this function, the object will be in an undefined state.
 *
 * @param transformer
 * @param ast
 * @param options
 */
export function transform(
	transformer: Transformer,
	ast: NoParent<Expression>,
	options?: Readonly<TransformOptions>
): NoParent<Expression>;
/**
 * A character base is constructed from a collection of character sets. It holds a list of disjoint, non-empty
 * character sets - the base sets - that can be used to construct every character set in the collection it was
 * constructed from.
 *
 * ## Guarantees
 *
 * - The base sets are guaranteed to be mutually disjoint and non-empty.
 *
 * - Every character set in the collection can be constructed by combining (union) a unique set of base sets.
 *
 * - The list of base sets is guaranteed to be as small as possible. There are at most `min(n^2, o)` base sets where `n`
 *   is the number of unique, non-empty character sets in the collection, and `o` is the number of characters in the
 *   union of all character sets in the collection.
 *
 * ## Use case
 *
 * The primary purpose of base sets is to remap alphabets. Some FA operations scale with the number of characters in the
 * alphabet of the FA (e.g. DFA minimization).
 *
 * Base sets can be used to determine which characters in an FA's alphabet *Σ* cannot be distinguished by the FA *A*.
 * Two characters *a,b* in *Σ* are indistinguishable if for all inputs *w* the following hold true:
 *
 * 1. *w* is accepted by *A* iff *w* with all occurrences of *a* replaced with *b* is accepted by *A*.
 * 2. *w* is accepted by *A* iff *w* with all occurrences of *b* replaced with *a* is accepted by *A*.
 *
 * Two indistinguishable characters are guaranteed to be in the same base set.
 *
 * By treating each base set as a character, it is possible to create a new (smaller) alphabet *Γ* (*|Γ| <= |Σ|*) such
 * that the FA *A* still behaves the same.
 *
 * Since *Γ* is typically (several orders of magnitude) smaller, operations that scale with the size of the alphabet
 * can be done more quickly.
 */
export class CharBase {
	/**
	 * A list of disjoint, non-empty character sets.
	 *
	 * See {@link CharBase} to learn more.
	 */
	readonly sets: readonly CharSet[];
	/**
	 * Create the base sets of the given collection of character sets.
	 *
	 * See {@link CharBase} to learn more.
	 *
	 * @param charSets
	 * @throws `RangeError` if the collection contains two character sets with different maximums.
	 */
	constructor(charSets: Iterable<CharSet>);
	/**
	 * Splits the given character set into its base sets.
	 *
	 * The returned array will be a list of indexes of base sets necessary to construct the given character sets. The
	 * indexes will be sorted and occur at most once.
	 *
	 * **Note**: This assumes that `charSet` is either empty or can be constructed from the base sets. If the
	 * assumption is not met, the output of this function will be undefined.
	 *
	 * @param charSet
	 */
	split(charSet: CharSet): number[];
}
export interface ReadonlyCharMap<T> extends Iterable<[CharRange, T]> {
	readonly isEmpty: boolean;
	/**
	 * Returns whether the given character is a key in the map.
	 *
	 * @param char
	 */
	has(char: Char): boolean;
	/**
	 * Returns whether every character in the given range is a key in the map.
	 *
	 * This is equivalent to: `[...chars].every(char => this.has(char))`.
	 *
	 * @param chars
	 */
	hasEvery(chars: CharRange): boolean;
	/**
	 * Returns whether some character in the given range is a key in the map.
	 *
	 * This is equivalent to: `[...chars].some(char => this.has(char))`.
	 *
	 * @param chars
	 */
	hasSome(chars: CharRange): boolean;
	/**
	 * Returns the value associated with the given character of `undefined` if the character is not key in the map.
	 *
	 * @param char
	 */
	get(char: Char): T | undefined;
	/**
	 * Invokes the given callback for every item of the character map.
	 *
	 * This method is implemented more efficiently than other iterator based methods, so chose `forEach` where every
	 * possible.
	 *
	 * @param callback
	 */
	forEach(callback: (value: T, chars: CharRange, map: ReadonlyCharMap<T>) => void): void;
	keys(): Iterable<CharRange>;
	values(): Iterable<T>;
	entries(range?: CharRange): Iterable<[CharRange, T]>;
	/**
	 * Returns a mapping from the values of this map to its keys.
	 */
	invert(maxCharacter: Char): Map<T, CharSet>;
}
/**
 * A map from characters to generic values.
 *
 * The map guarantees that there are no adjacent character ranges that map to the equal values, will always be iterated
 * as one character range. The equality of values is given by JavaScript's strict equality operator (`===`).
 */
export class CharMap<T> implements ReadonlyCharMap<T> {
	constructor();
	get isEmpty(): boolean;
	has(char: Char): boolean;
	hasEvery(chars: CharRange): boolean;
	hasSome(chars: CharRange): boolean;
	get(char: Char): T | undefined;
	set(char: Char, value: T): void;
	/**
	 * Sets the value for all characters in the given range.
	 *
	 * This is equivalent to `[...chars].forEach(char => this.set(char, value))`.
	 *
	 * @param chars
	 * @param value
	 */
	setRange(chars: CharRange, value: T): void;
	/**
	 * Sets the value for all characters in the given character set.
	 *
	 * This is equivalent to `[...charSet.characters()].forEach(char => this.set(char, value))`.
	 *
	 * @param charSet
	 * @param value
	 */
	setCharSet(charSet: CharSet, value: T): void;
	delete(char: Char): boolean;
	/**
	 * Deletes all characters in the given range.
	 *
	 * This is equivalent to `[...range].forEach(char => this.delete(char))`.
	 *
	 * @param range
	 */
	deleteRange(range: CharRange): void;
	/**
	 * Deletes all entries in the map.
	 */
	clear(): void;
	map(mapFn: (value: T, chars: CharRange, map: ReadonlyCharMap<T>) => T): void;
	mapRange(
		range: CharRange,
		mapFn: (value: T | undefined, chars: CharRange, map: ReadonlyCharMap<T>) => T | undefined
	): void;
	filter(conditionFn: (value: T, chars: CharRange, map: ReadonlyCharMap<T>) => boolean): void;
	invert(maxCharacter: Char): Map<T, CharSet>;
	forEach(callback: (value: T, chars: CharRange, map: ReadonlyCharMap<T>) => void): void;
	keys(): IterableIterator<CharRange>;
	values(): IterableIterator<T>;
	entries(range?: CharRange): IterableIterator<[CharRange, T]>;
	[Symbol.iterator](): IterableIterator<[CharRange, T]>;
}
/**
 * An immutable interval of {@link Char}s with inclusive ends.
 *
 * Each interval contains all characters `x` with `min <= x <= max`.
 */
export interface CharRange {
	/**
	 * The inclusive minimum of the interval.
	 *
	 * This value has to be less or equal to {@link max}.
	 */
	readonly min: Char;
	/**
	 * The inclusive maximum of the interval.
	 *
	 * This value has to be greater or equal to {@link min}.
	 */
	readonly max: Char;
}
/**
 * An immutable set of {@link Char}s represented as a sorted set of disjoint non-adjacent intervals ({@link CharRange}).
 *
 * All characters in the set have to be between 0 (inclusive) and the maximum of the set (inclusive).
 */
export class CharSet {
	/**
	 * The greatest character which can be element of the set.
	 */
	readonly maximum: Char;
	/**
	 * An array of ranges representing this character set.
	 *
	 * The array must be guaranteed to have the following properties at all times:
	 *
	 * 1. Any two ranges are disjoint.
	 * 2. Any two ranges are non-adjacent.
	 * 3. 0 <= `min` <= `max` <= `this.maximum` for all ranges.
	 * 4. All ranges are sorted by ascending `min`.
	 */
	readonly ranges: readonly CharRange[];
	/**
	 * Returns `true` if this set doesn't contain any characters.
	 */
	get isEmpty(): boolean;
	/**
	 * Returns `true` if all characters in the range from 0 to `this.maximum`, including 0 and `this.maximum`, are in
	 * the set.
	 */
	get isAll(): boolean;
	/**
	 * Returns the number of unique characters in the set.
	 *
	 * The returned number will be at least `0` and at most `this.maximum + 1`.
	 */
	get size(): number;
	/**
	 * Returns an iterable of all characters in this set.
	 *
	 * Characters are sorted by ascending order and each character is yielded exactly once.
	 *
	 * Note: The iterable is stable. It can be iterated multiple times.
	 */
	characters(): Iterable<Char>;
	/**
	 * Returns a string representation of the character set.
	 */
	toString(): string;
	/**
	 * Returns a string representation of the ranges of this character set.
	 *
	 * The string representation has the following rules:
	 *
	 * 1. Each character is represented as a hexadecimal number.
	 * 2. Each range where `min == max` will be represented by the `min` character.
	 * 3. Each range where `min != max` will be represented by `min` followed by `".."` followed by `max`.
	 * 4. The sequence of ranges will be joined together using `", "`.
	 *
	 * The returned string representation will have the following format:
	 *
	 * ```
	 * string = [ ranges ]
	 * ranges = range *( ", " range )
	 * range  = +hex [ ".." +hex ]
	 * hex    = "a" | "b" | "c" | "d" | "e" | "f" | digit
	 * digit  = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
	 * ```
	 */
	toRangesString(): string;
	/**
	 * Returns an empty character set with the given maximum.
	 *
	 * @param maximum The greatest character which can be element of the set.
	 */
	static empty(maximum: Char): CharSet;
	/**
	 * Returns a complete character set with the given maximum.
	 *
	 * @param maximum The greatest character which will be element of the set.
	 */
	static all(maximum: Char): CharSet;
	/**
	 * Returns a character set which contains the given characters.
	 *
	 * @param maximum The greatest character which will be element of the set.
	 * @param characters A sorted collection of characters.
	 * @throws `RangeError` if the given collection is not sorted or contains characters greater than `maximum`.
	 */
	static fromCharacters(maximum: Char, characters: Iterable<Char>): CharSet;
	/**
	 * Returns whether this and the given character set are equivalent.
	 *
	 * Two `CharSet`s are equal if and only if:
	 *
	 * 1.  They have the same maximum.
	 * 2.  They have the same number of char ranges.
	 * 3.  For every `CharRange` in this set, there exists one `CharRange` in the other set with the same minimum and
	 *     maximum.
	 *
	 * @param other
	 */
	equals(other: CharSet): boolean;
	/**
	 * Compares this set with given set and returns an integer value describing their relation. Two equivalent set are
	 * always guaranteed to return 0.
	 *
	 * The order defined by this function is guaranteed to be a
	 * [total order](https://en.wikipedia.org/wiki/Total_order). Apart from this, no other guarantees are given.
	 *
	 * @param other
	 */
	compare(other: CharSet): number;
	/**
	 * Returns [the complement](https://en.wikipedia.org/wiki/Complement_(set_theory)) of this set.
	 *
	 * The returned set will have the same maximum as this set.
	 */
	negate(): CharSet;
	/**
	 * Returns [the union](https://en.wikipedia.org/wiki/Union_(set_theory)) of this set and all given sets and
	 * character ranges.
	 *
	 * The returned set will have the same maximum as this set.
	 *
	 * @param data
	 * @throws `RangeError` If the maximum of one of the given sets differs from the maximum of this set or if the
	 * maximum of one of the given ranges is greater than the maximum of this set.
	 */
	union(...data: (Iterable<CharRange> | CharSet)[]): CharSet;
	/**
	 * Returns [the intersection](https://en.wikipedia.org/wiki/Intersection_(set_theory)) of this set and the given set
	 * and character ranges.
	 *
	 * The returned set will have the same maximum as this set.
	 *
	 * @param set
	 * @throws `RangeError` If the maximum of the given set differs from the maximum of this set or if the maximum of
	 * one of the given ranges is greater than the maximum of this set.
	 */
	intersect(set: CharSet): CharSet;
	intersect(ranges: Iterable<CharRange>): CharSet;
	/**
	 * Returns a set that contains all characters of this set that are not in the given set.
	 *
	 * The returned set will have the same maximum as this set.
	 *
	 * @param set
	 * @throws `RangeError` If the maximum of the given set differs from the maximum of this set or if the maximum of
	 * one of the given ranges is greater than the maximum of this set.
	 */
	without(set: CharSet): CharSet;
	without(ranges: Iterable<CharRange>): CharSet;
	/**
	 * Returns whether this set contains the given character.
	 *
	 * @param character
	 */
	has(character: Char): boolean;
	isSupersetOf(other: CharSet | CharRange): boolean;
	isSubsetOf(other: CharSet | CharRange): boolean;
	/**
	 * Returns whether this set and the given set (or range) are disjoint.
	 *
	 * @param other
	 */
	isDisjointWith(other: CharSet | CharRange): boolean;
	/**
	 * Returns any one of the common characters of this set and the given set or range.
	 *
	 * If this character set is disjoint with the given character set/range, then `undefined` will be returned.
	 *
	 * @param other
	 */
	commonCharacter(other: CharSet | CharRange): Char | undefined;
}
/**
 * A character is a non-negative integer.
 *
 * This is one of the core concepts of refa. Instead of operating on JavaScript strings, UTF16 character codes, or
 * Unicode code points, this library uses plain numbers instead. This makes refa agnostic to text encodings and even
 * text in general since the integers used as character may represent arbitrary concepts.
 *
 * There are only 2 restrictions on the numbers that can be characters:
 *
 * 1.  They have to be non-negative integers.
 * 2.  They can be at most `Number.MAX_SAFE_INTEGER`.
 *
 * ---
 *
 * This type serves as a way to document characters. It is a clear way to signal that a value is not just any number.
 */
export type Char = number & {
	__char?: never;
};
/**
 * A word is finite sequence of {@link Char}s.
 *
 * This one of the core concepts of refa. Instead of operating on JavaScript strings, all functions operate on
 * {@link Char}s and char arrays (= words). This means that refa is agnostic to text encodings, the string
 * representation of JavaScript, and even text itself.
 *
 * This type serves as a way to document words. It should _not_ be used interchangeably with `Char[]` or `number[]`.
 */
export type Word = Char[];
/**
 * An immutable finite sequence of {@link Char}s.
 *
 * This is an immutable view on a {@link Word}.
 */
export type ReadonlyWord = readonly Char[];
export interface FiniteAutomaton {
	/**
	 * Returns whether this FA accepts the empty language meaning that it doesn't accept any words.
	 */
	readonly isEmpty: boolean;
	/**
	 * Returns whether the formal language accepted by this FA contains finitely many words.
	 *
	 * __Note__: Finite does not mean that all words can be iterated in practice. E.g. the set of all Unicode words with
	 * 10 or less characters contains 2.6e54 many words and can be accepted by a DFA with only 11 states.
	 */
	readonly isFinite: boolean;
	/**
	 * The maximum character that is part of the alphabet of the words that this FA can accept.
	 */
	readonly maxCharacter: Char;
	/**
	 * Returns whether this FA accepts the given word.
	 *
	 * @param word The characters of the word to test.
	 */
	test(word: ReadonlyWord): boolean;
	/**
	 * Returns an iterable that will yield all words accepted by this FA. Words are yielded by ascending length.
	 *
	 * If this FA accepts infinitely many words, the iterable will never end.
	 */
	words(): Iterable<Word>;
	/**
	 * Returns an iterable that will yield all word sets accepted by this FA. Word sets are yielded by ascending length.
	 *
	 * If you analyse the words of this FA, consider using this method instead of `words` because this method will yield
	 * at most `O(n^3)` word sets while `words` will yield at most `O(n^3 * m)` words (n = number of states, m = number
	 * of possible characters).
	 *
	 * If this FA accepts infinitely many words, the iterable will never end.
	 */
	wordSets(): Iterable<WordSet>;
	/**
	 * Returns a string representation of this FA.
	 */
	toString(): string;
	/**
	 * Returns the AST of a regular expression that accepts the same language as this FA.
	 *
	 * @param options
	 */
	toRegex(options?: Readonly<ToRegexOptions>): NoParent<Expression>;
	/**
	 * Returns the string representation of this FA in the
	 * [DOT format](https://en.wikipedia.org/wiki/DOT_(graph_description_language)).
	 *
	 * The output of this function can passed to any graph visualization program. This can be a
	 * [local installation](https://graphviz.org/download/) or an [online editor](https://edotor.net/).
	 *
	 * By default, a hexadecimal range form will be used to represent {@link CharSet}s. It's possible to provide a
	 * custom stringify function using the `charSetToString` parameter.
	 *
	 * @param charSetToString
	 */
	toDot(charSetToString?: (charSet: CharSet) => string): string;
}
/**
 * A graph iterator for all states of an FA with final states.
 *
 * @template S The type of a state in the FA to iterate.
 * @template O The type of the value each state maps to.
 */
export interface FAIterator<S, O = Iterable<S>> {
	/**
	 * The initial state of the FA.
	 */
	readonly initial: S;
	/**
	 * Returns the value a state maps to.
	 *
	 * @see {@link stableOut}
	 */
	readonly getOut: (state: S) => O;
	/**
	 * Whether the {@link getOut} function is stableOut during the lifetime of the iterator.
	 *
	 * Stable means that if `getOut` gets called for the same state more than once, it will always return the same
	 * value.
	 *
	 * The sameness of states is defined by
	 * [the key equality of the Map class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map#key_equality).
	 *
	 * The sameness of returned values is not defined by this interface and depends of the iterator.
	 *
	 * I.e. a stable `getOut` function may return new collections/iterators on subsequent invocations as long as the
	 * collections/iterators are considered equal (e.g. equal could be defined as "same elements") by the consumer of
	 * the iterator.
	 *
	 * @default false
	 */
	readonly stableOut?: boolean;
	/**
	 * Returns whether the given state is a final state.
	 *
	 * This function is guaranteed to be deterministic during the time the iterator is used. It is also guaranteed to be
	 * sufficiently fast, usually `O(1)` can be assumed.
	 */
	readonly isFinal: (state: S) => boolean;
}
/**
 * An FA builder has the responsibility of constructing a finite automata.
 *
 * The constructed FA is always owned by the builder.
 *
 * @template S The type of a state.
 * @template T The transition type of the values linking states.
 */
export interface FABuilder<S, T> {
	/**
	 * The initial state of the FA.
	 */
	readonly initial: S;
	/**
	 * Makes the given state behave like a final state of this FA.
	 *
	 * This does not necessarily mean that the given state will be a final state. I.e. calling `makeFinal(s)` does not
	 * necessitate that `isFinal(s)` is true.
	 *
	 * The implementation has to guarantee that calling this method for the same state more than once is allowed.
	 */
	readonly makeFinal: (state: S) => void;
	/**
	 * Returns whether the given state is a final state.
	 *
	 * This operation is assumed to be semantically equivalent to {@link FAIterator.isFinal}.
	 */
	readonly isFinal: (state: S) => boolean;
	/**
	 * Creates a new state owned by the builder.
	 *
	 * @throws {@link TooManyNodesError}
	 * May be thrown if the number of created nodes exceeds some limit.
	 */
	readonly createNode: () => S;
	/**
	 * Links to the two given states using the given transition.
	 *
	 * Calling this operations more than once for the given `from` and `to` states is not guaranteed to succeed.
	 */
	readonly linkNodes: (from: S, to: S, transition: T) => void;
}
export interface FACreationOptions {
	/**
	 * The maximum number of nodes the operation is allowed to create before throwing a `TooManyNodesError`.
	 *
	 * If the maximum number of nodes is unset or set to `Infinity`, the operation may create as many nodes as
	 * necessary. This might cause the machine to run out of memory.
	 *
	 * @default 10000
	 */
	maxNodes?: number;
}
/**
 * An {@link FAIterator} where transitions are map of states to character sets.
 *
 * This is a commonly used interface when dealing with FA. It's the common core all currently implemented FA support.
 */
export type TransitionIterator<T> = FAIterator<T, ReadonlyMap<T, CharSet>>;
/**
 * A graph or FA that can create a {@link TransitionIterator}.
 */
export interface TransitionIterable<T> {
	readonly maxCharacter: Char;
	readonly transitionIterator: () => TransitionIterator<T>;
}
export interface ToRegexOptions {
	/**
	 * The maximum number of RE AST nodes the implementation is allowed to create.
	 *
	 * If the implementation has to create more nodes to create the RE, a `TooManyNodesError` will be thrown. This
	 * maximum will be check before any optimization passes.
	 *
	 * @default 10000
	 */
	maxNodes?: number;
	/**
	 * The maximum number of optimization passes that will be done after the initial RE AST was created.
	 *
	 * The initial AST is usually a lot more complex than necessary. Optimizations are then applied in order to minimize
	 * the AST until this limit is reached or the AST can be optimized no further.
	 *
	 * The default number of passes is implementation defined.
	 */
	maxOptimizationPasses?: number;
}
/**
 * A readonly {@link DFA}.
 */
export interface ReadonlyDFA extends FiniteAutomaton, TransitionIterable<DFA.ReadonlyNode> {
	readonly nodes: DFA.ReadonlyNodeList;
	readonly options: Readonly<DFA.Options>;
	stateIterator(): FAIterator<DFA.ReadonlyNode>;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	/**
	 * Creates a new DFA equivalent to this one.
	 */
	copy(): DFA;
	/**
	 * Returns whether this and the given DFA are structurally equal meaning that all nodes and all transitions are
	 * equal.
	 *
	 * @param other
	 */
	structurallyEqual(other: ReadonlyDFA): boolean;
}
/**
 * A [deterministic finite automaton](https://en.wikipedia.org/wiki/Deterministic_finite_automaton).
 *
 * This class implements DFAs with the following properties:
 *
 * - There is exactly one initial state.
 *
 * - There may be any number of final states.
 *
 *   This is implemented using a `Set` of states.
 *
 * - No epsilon transitions.
 *
 * - A transitions always consumes a character.
 *
 *   (All character sets are guaranteed to be non-empty.)
 *
 * - Transitions are unordered.
 *
 *   As a consequence, `/aa|bb/` and `/bb|aa/` have the same state machine.
 *
 * - Between any two states, there can at most be one transition.
 */
export class DFA implements ReadonlyDFA {
	readonly nodes: DFA.NodeList;
	readonly maxCharacter: Char;
	get options(): Readonly<DFA.Options>;
	get isEmpty(): boolean;
	get isFinite(): boolean;
	stateIterator(): FAIterator<DFA.ReadonlyNode>;
	transitionIterator(): TransitionIterator<DFA.ReadonlyNode>;
	test(word: ReadonlyWord): boolean;
	wordSets(): Iterable<WordSet>;
	words(): Iterable<Word>;
	toString(): string;
	toRegex(options?: Readonly<ToRegexOptions>): NoParent<Expression>;
	toDot(charSetToString?: (charSet: CharSet) => string): string;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	copy(): DFA;
	structurallyEqual(other: ReadonlyDFA): boolean;
	/**
	 * [Minimizes](https://en.wikipedia.org/wiki/DFA_minimization) this DFA.
	 */
	minimize(): void;
	/**
	 * Complements this DFA.
	 *
	 * This DFA after calling this function will accept all words that are not accepted by this DFA before calling this
	 * function.
	 */
	complement(): void;
	/**
	 * Modifies this DFA such that all prefixes of all accepted words are also accepted.
	 *
	 * If the language of this DFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	prefixes(): void;
	/**
	 * Creates a new DFA which matches no words. The language of the returned DFA is empty.
	 *
	 * @param options
	 */
	static empty(options: Readonly<DFA.Options>): DFA;
	/**
	 * Creates a new DFA which matches all words.
	 *
	 * @param options
	 */
	static all(options: Readonly<DFA.Options>): DFA;
	/**
	 * Returns a new DFA which is equivalent to the intersection of the two given FA.
	 *
	 * @param left
	 * @param right
	 * @param options
	 */
	static fromIntersection<L, R>(
		left: TransitionIterable<L>,
		right: TransitionIterable<R>,
		options?: Readonly<DFA.CreationOptions>
	): DFA;
	static fromWords(
		words: Iterable<ReadonlyWord>,
		options: Readonly<DFA.Options>,
		creationOptions?: Readonly<DFA.CreationOptions>
	): DFA;
	static fromFA<InputNode>(fa: TransitionIterable<InputNode>, creationOptions?: Readonly<DFA.CreationOptions>): DFA;
	static fromTransitionIterator<InputNode>(
		iter: TransitionIterator<InputNode>,
		options: Readonly<DFA.Options>,
		creationOptions?: Readonly<DFA.CreationOptions>
	): DFA;
}
/**
 * A namespace for DFA-specific classes and interfaces.
 *
 * @see {@link DFA} (class)
 */
export namespace DFA {
	interface ReadonlyNode {
		readonly list: ReadonlyNodeList;
		readonly out: ReadonlyCharMap<ReadonlyNode>;
	}
	interface Node extends ReadonlyNode {
		readonly list: NodeList;
		readonly out: CharMap<Node>;
	}
	interface ReadonlyNodeList extends Iterable<ReadonlyNode> {
		readonly initial: ReadonlyNode;
		readonly finals: ReadonlySet<ReadonlyNode>;
		/**
		 * Returns the number of nodes reachable from the initial state including the initial state.
		 *
		 * This may include trap states. This will not include unreachable final states.
		 *
		 * This operation has to traverse the whole graph and runs in _O(E + V)_.
		 */
		count(): number;
	}
	class NodeList implements ReadonlyNodeList, Iterable<Node>, FABuilder<Node, CharSet> {
		readonly initial: Node;
		readonly finals: Set<Node>;
		constructor();
		/**
		 * Creates and returns a new node list that is only allowed to create a certain number of nodes during the
		 * execution of the given consumer function.
		 *
		 * After this function returns, the limit no longer applies.
		 *
		 * @param maxNodes
		 * @param consumerFn
		 */
		static withLimit(maxNodes: number, consumerFn: (nodeList: NodeList) => void): NodeList;
		createNode(): Node;
		linkNodes(from: Node, to: Node, characters: CharSet | CharRange | Char): void;
		/** @internal */
		_uncheckedLinkNodesWithCharacter(from: Node, to: Node, character: Char): void;
		/** @internal */
		_uncheckedLinkNodesWithCharRange(from: Node, to: Node, characters: CharRange): void;
		/** @internal */
		_uncheckedLinkNodesWithCharSet(from: Node, to: Node, characters: CharSet): void;
		unlinkNodes(from: Node, to: Node): void;
		makeFinal(state: Node): void;
		isFinal(state: Node): boolean;
		removeUnreachable(): void;
		count(): number;
		[Symbol.iterator](): IterableIterator<Node>;
	}
	/**
	 * Options for the constraints on how a DFA will be created.
	 */
	interface CreationOptions extends FACreationOptions {
		/**
		 * The maximum number of nodes the DFA creation operation is allowed to create before throwing a
		 * `TooManyNodesError`.
		 *
		 * If the maximum number of nodes is set to `Infinity`, the DFA creation operation may create as many nodes as
		 * necessary to construct the DFA. This might cause the machine to run out of memory. I.e. the conversion from
		 * NFA to DFA may create `O(2^n)` many nodes and an intersection may created `O(n * m)` many.
		 *
		 * Note: This limit describes the maximum number of __created__ nodes. If nodes are created and subsequently
		 * discard, they will still count toward the limit.
		 *
		 * @default 10000
		 */
		maxNodes?: number;
	}
	interface Options {
		/**
		 * The maximum numerical value any character can have.
		 *
		 * This will be the maximum of all underlying {@link CharSet}s.
		 */
		maxCharacter: Char;
	}
}
/**
 * A readonly {@link ENFA}.
 */
export interface ReadonlyENFA extends FiniteAutomaton, TransitionIterable<ENFA.ReadonlyNode> {
	readonly nodes: ENFA.ReadonlyNodeList;
	readonly options: Readonly<ENFA.Options>;
	stateIterator(resolveEpsilon: boolean): FAIterator<ENFA.ReadonlyNode>;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	/**
	 * Create a mutable copy of this ENFA.
	 */
	copy(): ENFA;
}
/**
 * A [nondeterministic finite automaton](https://en.wikipedia.org/wiki/Nondeterministic_finite_automaton) with epsilon
 * transitions.
 *
 * This class implements NFAs with the following properties:
 *
 * - There is exactly one initial state.
 *
 * - There is exactly one final state.
 *
 * - There are epsilon transitions.
 *
 * - A transitions either an epsilon transition or consumes a character.
 *
 *   Epsilon transition are represented using `null` and characters are represented using non-empty `CharSet`s.
 *
 * - Transitions are ordered.
 *
 *   As a consequence, `/aa|bb/` and `/bb|aa/` have different state machines in this NFA implementation.
 *
 *   Order is only guaranteed as long as no transitions are removed. Order is defined by the key order of the JavaScript
 *   `Map` class.
 *
 * - Between any two states, there can at most be one transition.
 *
 *   Unlike the {@link NFA} class, transition cannot be merged. As a consequence, `/a|a/` and `/a/` have different
 *   state machines in this NFA implementation.
 */
export class ENFA implements ReadonlyENFA {
	readonly nodes: ENFA.NodeList;
	readonly maxCharacter: Char;
	get options(): Readonly<ENFA.Options>;
	get isEmpty(): boolean;
	get isFinite(): boolean;
	stateIterator(resolveEpsilon: boolean): FAIterator<ENFA.ReadonlyNode>;
	transitionIterator(): TransitionIterator<ENFA.ReadonlyNode>;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	copy(): ENFA;
	test(word: ReadonlyWord): boolean;
	wordSets(): Iterable<WordSet>;
	words(): Iterable<Word>;
	toString(): string;
	toRegex(options?: Readonly<ToRegexOptions>): NoParent<Expression>;
	toDot(charSetToString?: (charSet: CharSet) => string): string;
	/**
	 * Modifies this ENFA to accept the concatenation of this ENFA and the given FA.
	 *
	 * @param other
	 */
	append<O>(other: TransitionIterable<O>): void;
	/**
	 * Modifies this ENFA to accept the concatenation of the given FA and this ENFA.
	 *
	 * @param other
	 */
	prepend<O>(other: TransitionIterable<O>): void;
	/**
	 * Modifies this ENFA to accept the language of this ENFA and the language of the given FA.
	 *
	 * If the union kind is `left`, then this ENFA will be modified to accept `<other>|<this>`. Otherwise, it will be
	 * modified to accept `<this>|<other>`.
	 *
	 * @param other
	 * @param kind
	 */
	union<O>(other: TransitionIterable<O>, kind?: "left" | "right"): void;
	/**
	 * Modifies this ENFA to accept at least `min` and at most `max` concatenations of itself.
	 *
	 * Both `min` and `max` both have to be non-negative integers with `min <= max`.
	 * `max` is also allowed to be `Infinity`.
	 *
	 * @param min
	 * @param max
	 * @param lazy
	 */
	quantify(min: number, max: number, lazy?: boolean): void;
	/**
	 * Modifies this ENFA such that all prefixes of all accepted words are also accepted.
	 *
	 * If the language of this ENFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	prefixes(): void;
	/**
	 * Modifies this ENFA such that all suffixes of all accepted words are also accepted.
	 *
	 * If the language of this ENFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	suffixes(): void;
	/**
	 * Creates a new ENFA which matches no words. The language of the returned ENFA is empty.
	 *
	 * @param options
	 */
	static empty(options: Readonly<ENFA.Options>): ENFA;
	/**
	 * Creates a new ENFA which matches all words.
	 *
	 * @param options
	 */
	static all(options: Readonly<ENFA.Options>): ENFA;
	static fromRegex(
		concat: NoParent<Node>,
		options: Readonly<ENFA.Options>,
		creationOptions?: Readonly<ENFA.FromRegexOptions>
	): ENFA;
	static fromRegex(
		alternatives: readonly NoParent<Concatenation>[],
		options: Readonly<ENFA.Options>,
		creationOptions?: Readonly<ENFA.FromRegexOptions>
	): ENFA;
	/**
	 * Creates a new ENFA which matches all and only all of the given words.
	 *
	 * @param words
	 * @param options
	 * @param creationOptions
	 */
	static fromWords(
		words: Iterable<ReadonlyWord>,
		options: Readonly<ENFA.Options>,
		creationOptions?: Readonly<ENFA.CreationOptions>
	): ENFA;
	static fromFA<InputNode>(fa: TransitionIterable<InputNode>, creationOptions?: Readonly<ENFA.CreationOptions>): ENFA;
	static fromTransitionIterator<InputNode>(
		iter: TransitionIterator<InputNode>,
		options: Readonly<ENFA.Options>,
		creationOptions?: Readonly<ENFA.CreationOptions>
	): ENFA;
}
/**
 * A namespace for ENFA-specific classes and interfaces.
 *
 * @see {@link ENFA} (class)
 */
export namespace ENFA {
	interface ReadonlyNode {
		readonly list: ReadonlyNodeList;
		readonly out: ReadonlyMap<ReadonlyNode, CharSet | null>;
		readonly in: ReadonlyMap<ReadonlyNode, CharSet | null>;
	}
	interface Node extends ReadonlyNode {
		readonly list: NodeList;
		readonly out: Map<Node, CharSet | null>;
		readonly in: Map<Node, CharSet | null>;
	}
	interface ReadonlyNodeList extends Iterable<ReadonlyNode> {
		/**
		 * The initial state of this list.
		 *
		 * The initial state is fixed an cannot be changed or removed.
		 *
		 * This state is not allowed to have any incoming transitions.
		 *
		 * The initial and final state are guaranteed to be two different states.
		 */
		readonly initial: ReadonlyNode;
		/**
		 * The final state of this list.
		 *
		 * The final state is fixed an cannot be changed or removed.
		 *
		 * This state is not allowed to have any outgoing transitions.
		 *
		 * The initial and final state are guaranteed to be two different states.
		 */
		readonly final: ReadonlyNode;
		/**
		 * Returns the number of nodes reachable from the initial state including the initial state.
		 *
		 * This may include trap states. This will not include unreachable final states.
		 *
		 * This operation has to traverse the whole graph and runs in _O(E + V)_.
		 */
		count(): number;
	}
	class NodeList implements ReadonlyNodeList, Iterable<Node>, FABuilder<Node, CharSet | null> {
		initial: Node;
		final: Node;
		constructor();
		/**
		 * Creates and returns a new node list that is only allowed to create a certain number of nodes during the
		 * execution of the given consumer function.
		 *
		 * After this function returns, the limit no longer applies.
		 *
		 * @param maxNodes
		 * @param consumerFn
		 */
		static withLimit(maxNodes: number, consumerFn: (nodeList: NodeList) => void): NodeList;
		/**
		 * Creates a new node associated with this node list.
		 */
		createNode(): Node;
		/**
		 * Adds a transition from `from` to `to` using the given non-empty set of characters.
		 *
		 * If two nodes are already linked, the character sets will be combined.
		 *
		 * @param from
		 * @param to
		 * @param characters
		 */
		linkNodes(from: Node, to: Node, characters: CharSet | null): void;
		/**
		 * Removes the transition from `from` to `to`.
		 *
		 * If there is no transition from `from` to `to`, an error will be thrown.
		 *
		 * @param from
		 * @param to
		 */
		unlinkNodes(from: Node, to: Node): void;
		makeFinal(state: Node): void;
		isFinal(state: Node): boolean;
		/**
		 * All states which cannot be reached from the initial state or cannot reach (or are) a final state, will be
		 * removed.
		 */
		removeUnreachable(): void;
		/**
		 * Changes the nodes, so that the initial state has no incoming transitions and that the final state has no
		 * outgoing transitions.
		 */
		normalize(): void;
		count(): number;
		[Symbol.iterator](): Iterator<Node>;
		/**
		 * Calls the given consumer function on every non-epsilon transition directly reachable from the given node.
		 *
		 * Epsilon transitions will be resolved using a DFS algorithm. This means that for the following graph:
		 *
		 * ```text
		 * (0) -> (1) : "a"
		 *     -> (2) : epsilon
		 *     -> (3) : "b"
		 *
		 * (1) -> (3) : "c"
		 *
		 * (2) -> (4) : "d"
		 *     -> (1) : "e"
		 *     -> (2) : epsilon
		 *
		 * (3) -> (1) : epsilon
		 *
		 * (4) -> empty
		 * ```
		 *
		 * The node `(0)` will return the resolved list:
		 *
		 * ```text
		 * [(1), "a"]
		 * [(4), "d"]
		 * [(1), "e"]
		 * [(3), "b"]
		 * ```
		 */
		static resolveEpsilon(
			node: ENFA.Node,
			direction: "in" | "out",
			consumerFn: (charSet: CharSet, node: ENFA.Node) => void
		): void;
		static resolveEpsilon(
			node: ENFA.ReadonlyNode,
			direction: "in" | "out",
			consumerFn: (charSet: CharSet, node: ENFA.ReadonlyNode) => void
		): void;
		/**
		 * Calls the given consumer function on every non-epsilon transition directly reachable from the given node.
		 *
		 * The order in which the consumer function will be called for the pair is implementation-defined. Only use this
		 * if the order of nodes is irrelevant.
		 */
		static unorderedResolveEpsilon(
			node: ENFA.Node,
			direction: "in" | "out",
			consumerFn: (charSet: CharSet, node: ENFA.Node) => void
		): void;
		static unorderedResolveEpsilon(
			node: ENFA.ReadonlyNode,
			direction: "in" | "out",
			consumerFn: (charSet: CharSet, node: ENFA.ReadonlyNode) => void
		): void;
		/**
		 * Returns a set of all nodes that are reachable from the given node by only following epsilon transitions in
		 * the given direction. The returned set is guaranteed to always contain the given node.
		 *
		 * The order of the nodes in the returned set in implementation-defined and cannot be relied upon.
		 *
		 * ---
		 *
		 * This method can be used to determine the set of all effectively final states.
		 *
		 * ```
		 * const effectivelyFinal = ENFA.NodeList.reachableViaEpsilon(final, "in");
		 * ```
		 */
		static reachableViaEpsilon(node: ENFA.Node, direction: "in" | "out"): Set<ENFA.Node>;
		static reachableViaEpsilon(node: ENFA.ReadonlyNode, direction: "in" | "out"): Set<ENFA.ReadonlyNode>;
	}
	/**
	 * Options for the constraints on how a ENFA will be created.
	 */
	interface CreationOptions extends FACreationOptions {
		/**
		 * The maximum number of nodes the ENFA creation operation is allowed to create before throwing a
		 * `TooManyNodesError`.
		 *
		 * If the maximum number of nodes is set to `Infinity`, the ENFA creation operation may create as many nodes as
		 * necessary to construct the ENFA. This might cause the machine to run out of memory. I.e. some REs can only be
		 * represented with a huge number of states (e.g `/a{123456789}/`).
		 *
		 * Note: This limit describes maximum number of __created__ nodes. If nodes are created and subsequently
		 * discard, they will still count toward the limit.
		 *
		 * @default 10000
		 */
		maxNodes?: number;
	}
	interface Options {
		/**
		 * The maximum numerical value any character can have.
		 *
		 * This will be the maximum of all underlying {@link CharSet}s.
		 */
		maxCharacter: Char;
	}
	interface FromRegexOptions extends CreationOptions {
		/**
		 * How to handle assertions when construction the ENFA.
		 *
		 * - `"throw"`
		 *
		 *   This method will throw an error when encountering an assertion.
		 *
		 * - `"disable"`
		 *
		 *   This method will replace any assertion with an empty character class, effectively removing it.
		 *
		 * @default "throw"
		 */
		assertions?: "disable" | "throw";
		/**
		 * How to handle unknowns when construction the ENFA.
		 *
		 * - `"throw"`
		 *
		 *   This method will throw an error when encountering an unknown.
		 *
		 * - `"disable"`
		 *
		 *   This method will replace any unknown with an empty character class, effectively removing it.
		 *
		 * @default "throw"
		 */
		unknowns?: "disable" | "throw";
		/**
		 * The number at which the maximum of a quantifier will be assumed to be infinity.
		 *
		 * Quantifiers with a large finite maximum (e.g. `a{1,10000}`) can create huge NFAs with thousands of states.
		 * Any Quantifier with a maximum greater or equal to this threshold will be assumed to be infinite.
		 *
		 * @default Infinity
		 */
		infinityThreshold?: number;
	}
}
/**
 * An error that is thrown when the max characters of two or more FA or transition iterables is not the same.
 *
 * Operations on FA and transition iterables require the max characters of all given FA and transition iterables to be
 * the same and will throw this error if they are not.
 */
export class MaxCharacterError extends Error {
	/**
	 * Asserts the two given max characters are the same.
	 *
	 * @param a
	 * @param b
	 * @param kind
	 */
	static assert(
		a:
			| Char
			| {
					maxCharacter: Char;
			  },
		b:
			| Char
			| {
					maxCharacter: Char;
			  },
		kind?: string
	): void;
}
/**
 * An error that is thrown when an operation causes too many nodes to be created.
 *
 * Many FA operation have the potential to create a huge number of nodes (thousands and millions) which may result in
 * the JavaScript runtime running out of memory and/or crashing. This error will thrown before that happens to safely
 * abort an otherwise resource-intensive operation.
 */
export class TooManyNodesError extends Error {
	/**
	 * Asserts that the current number of created nodes does not exceed the limit.
	 *
	 * @param current
	 * @param limit
	 * @param kind
	 */
	static assert(current: number, limit: number, kind: string): void;
}
/**
 * Returns a lazily-created {@link TransitionIterator} for the intersection of the two given FA.
 *
 * The iterator will create states as it is traversed.
 *
 * @param left
 * @param right
 * @param options
 */
export function getIntersectionIterator<L, R>(
	left: TransitionIterable<L>,
	right: TransitionIterable<R>,
	options?: Readonly<FACreationOptions>
): TransitionIterator<FAIterators.MapFABuilderNode>;
/**
 * Returns whether the languages of this and the other FA are disjoint.
 *
 * The runtime of this algorithm is `O(n * m)` (n = number of states of this NFA, m = number of states of the other
 * FA) but it's a lot faster in practice with the worst case being very rare.
 *
 * Since this uses the intersection operation, you can supply intersection options.
 *
 * This is equivalent to `NFA.fromIntersection(left, right).isEmpty` but implemented more efficiently.
 *
 * @param left
 * @param right
 * @param options
 */
export function isDisjointWith<L, R>(
	left: TransitionIterable<L>,
	right: TransitionIterable<R>,
	options?: Readonly<FACreationOptions>
): boolean;
/**
 * Returns a potentially infinite iterable of word sets accepted by both given transition iterables.
 *
 * This function provides the following guarantees:
 *
 * 1. Word sets are guaranteed to be yielded in the order of increasing length. (Word sets of equal lengths may be
 *    yielded in any order.)
 * 3. No character set of the yielded word sets is empty.
 *
 * This is roughly equivalent to `NFA.fromIntersection(left, right).wordSets()` but implemented more efficiently.
 *
 * @param left
 * @param right
 * @param options
 */
export function getIntersectionWordSets<L, R>(
	left: TransitionIterable<L>,
	right: TransitionIterable<R>,
	options?: Readonly<FACreationOptions>
): Iterable<WordSet>;
/**
 * Returns a potentially infinite iterable of words accepted by both given transition iterables.
 *
 * This function provides the following guarantees:
 *
 * 1. Words are guaranteed to be yielded in the order of increasing length. (Words of equal lengths may be yielded in
 *    any order.)
 *
 * This is roughly equivalent to `NFA.fromIntersection(left, right).words()` but implemented more efficiently.
 *
 * @param left
 * @param right
 * @param options
 */
export function getIntersectionWords<L, R>(
	left: TransitionIterable<L>,
	right: TransitionIterable<R>,
	options?: Readonly<FACreationOptions>
): Iterable<Word>;
/**
 * A readonly {@link NFA}.
 */
export interface ReadonlyNFA extends FiniteAutomaton, TransitionIterable<NFA.ReadonlyNode> {
	readonly nodes: NFA.ReadonlyNodeList;
	readonly options: Readonly<NFA.Options>;
	stateIterator(): FAIterator<NFA.ReadonlyNode>;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	/**
	 * Create a mutable copy of this NFA.
	 */
	copy(): NFA;
}
/**
 * A [nondeterministic finite automaton](https://en.wikipedia.org/wiki/Nondeterministic_finite_automaton).
 *
 * This class implements NFAs with the following properties:
 *
 * - There is exactly one initial state.
 *
 * - There may be any number of final states.
 *
 *   This is implemented using a `Set` of states.
 *
 * - No epsilon transitions.
 *
 * - A transitions always consumes a character.
 *
 *   (All character sets are guaranteed to be non-empty.)
 *
 * - Transitions are unordered.
 *
 *   As a consequence, `/aa|bb/` and `/bb|aa/` have the same state machine in this NFA implementation.
 *
 *   (The underlying data structure may be a JavaScript `Map` but the key order is ignored.)
 *
 * - Between any two states, there can at most be one transition.
 *
 *   This means that all transitions between two nodes will be merged into one. This is implemented as a simple
 *   {@link CharSet.union}. As a consequence, `/a|a/` and `/a/` have the same state machine in this NFA implementation.
 */
export class NFA implements ReadonlyNFA {
	readonly nodes: NFA.NodeList;
	readonly maxCharacter: Char;
	get options(): Readonly<NFA.Options>;
	get isEmpty(): boolean;
	get isFinite(): boolean;
	stateIterator(): FAIterator<NFA.ReadonlyNode>;
	transitionIterator(): TransitionIterator<NFA.ReadonlyNode>;
	copy(): NFA;
	test(word: ReadonlyWord): boolean;
	wordSets(): Iterable<WordSet>;
	words(): Iterable<Word>;
	toString(): string;
	toRegex(options?: Readonly<ToRegexOptions>): NoParent<Expression>;
	toDot(charSetToString?: (charSet: CharSet) => string): string;
	/**
	 * This is equivalent to `isDisjointWith(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	isDisjointWith<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): boolean;
	/**
	 * This is equivalent to `getIntersectionWords(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWords<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<Word>;
	/**
	 * This is equivalent to `getIntersectionWordSets(this, other, options)` (free function).
	 *
	 * @deprecated Use the equivalent free function instead.
	 *
	 * @param other
	 * @param options
	 */
	getIntersectionWordSets<O>(other: TransitionIterable<O>, options?: Readonly<FACreationOptions>): Iterable<WordSet>;
	/**
	 * Modifies this NFA to accept all words from this NFA and the given FA.
	 *
	 * @param other
	 */
	union<O>(other: TransitionIterable<O>): void;
	/**
	 * Modifies this NFA to accept the concatenation of this NFA and the given FA.
	 *
	 * @param other
	 */
	append<O>(other: TransitionIterable<O>): void;
	/**
	 * Modifies this NFA to accept the concatenation of the given NFA and this FA.
	 *
	 * @param other
	 */
	prepend<O>(other: TransitionIterable<O>): void;
	/**
	 * Modifies this NFA to accept at least `min` and at most `max` concatenations of itself.
	 *
	 * Both `min` and `max` both have to be non-negative integers with `min <= max`.
	 * `max` is also allowed to be `Infinity`.
	 *
	 * @param min
	 * @param max
	 */
	quantify(min: number, max: number): void;
	/**
	 * Removes the empty word from the accepted languages of this NFA.
	 */
	withoutEmptyWord(): void;
	/**
	 * Modifies this NFA such that all prefixes of all accepted words are also accepted.
	 *
	 * If the language of this NFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	prefixes(): void;
	/**
	 * Modifies this NFA such that all suffixes of all accepted words are also accepted.
	 *
	 * If the language of this NFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	suffixes(): void;
	/**
	 * Modifies this NFA such that it accepts the reverse of all words it currently accepts.
	 *
	 * If the language of this NFA is empty, then it will remain empty.
	 *
	 * Unreachable states will be removed by this operation.
	 */
	reverse(): void;
	/**
	 * Creates a new NFA which matches no words. The language of the returned NFA is empty.
	 *
	 * @param options
	 */
	static empty(options: Readonly<NFA.Options>): NFA;
	/**
	 * Creates a new NFA which matches all words.
	 *
	 * @param options
	 */
	static all(options: Readonly<NFA.Options>): NFA;
	/**
	 * Returns a new NFA which is equivalent to the intersection of the two given FA.
	 *
	 * @param left
	 * @param right
	 * @param options
	 */
	static fromIntersection<L, R>(
		left: TransitionIterable<L>,
		right: TransitionIterable<R>,
		options?: Readonly<NFA.CreationOptions>
	): NFA;
	static fromRegex(
		concat: NoParent<Node>,
		options: Readonly<NFA.Options>,
		creationOptions?: Readonly<NFA.FromRegexOptions>
	): NFA;
	static fromRegex(
		alternatives: readonly NoParent<Concatenation>[],
		options: Readonly<NFA.Options>,
		creationOptions?: Readonly<NFA.FromRegexOptions>
	): NFA;
	/**
	 * Creates a new NFA which matches all and only all of the given words.
	 *
	 * @param words
	 * @param options
	 * @param creationOptions
	 */
	static fromWords(
		words: Iterable<ReadonlyWord>,
		options: Readonly<NFA.Options>,
		creationOptions?: Readonly<NFA.CreationOptions>
	): NFA;
	static fromFA<InputNode>(fa: TransitionIterable<InputNode>, creationOptions?: Readonly<NFA.CreationOptions>): NFA;
	static fromTransitionIterator<InputNode>(
		iter: TransitionIterator<InputNode>,
		options: Readonly<NFA.Options>,
		creationOptions?: Readonly<NFA.CreationOptions>
	): NFA;
}
/**
 * A namespace for NFA-specific classes and interfaces.
 *
 * @see {@link NFA} (class)
 */
export namespace NFA {
	interface ReadonlyNode {
		readonly list: ReadonlyNodeList;
		readonly out: ReadonlyMap<ReadonlyNode, CharSet>;
		readonly in: ReadonlyMap<ReadonlyNode, CharSet>;
	}
	interface Node extends ReadonlyNode {
		readonly list: NodeList;
		readonly out: Map<Node, CharSet>;
		readonly in: Map<Node, CharSet>;
	}
	interface ReadonlyNodeList extends Iterable<ReadonlyNode> {
		readonly initial: ReadonlyNode;
		readonly finals: ReadonlySet<ReadonlyNode>;
		/**
		 * Returns the number of nodes reachable from the initial state including the initial state.
		 *
		 * This may include trap states. This will not include unreachable final states.
		 *
		 * This operation has to traverse the whole graph and runs in _O(E + V)_.
		 */
		count(): number;
	}
	class NodeList implements ReadonlyNodeList, Iterable<Node>, FABuilder<Node, CharSet> {
		/**
		 * The initial state of this list.
		 *
		 * The initial state is fixed an cannot be changed or removed.
		 */
		readonly initial: Node;
		/**
		 * The set of final states of this list.
		 */
		readonly finals: Set<Node>;
		constructor();
		/**
		 * Creates and returns a new node list that is only allowed to create a certain number of nodes during the
		 * execution of the given consumer function.
		 *
		 * After this function returns, the limit no longer applies.
		 *
		 * @param maxNodes
		 * @param consumerFn
		 */
		static withLimit(maxNodes: number, consumerFn: (nodeList: NodeList) => void): NodeList;
		/**
		 * Creates a new node associated with this node list.
		 */
		createNode(): Node;
		/**
		 * Adds a transition from `from` to `to` using the given non-empty set of characters.
		 *
		 * If two nodes are already linked, the character sets will be combined.
		 *
		 * @param from
		 * @param to
		 * @param characters
		 */
		linkNodes(from: Node, to: Node, characters: CharSet): void;
		/**
		 * Removes the transition from `from` to `to`.
		 *
		 * If there is no transition from `from` to `to`, an error will be thrown.
		 *
		 * @param from
		 * @param to
		 */
		unlinkNodes(from: Node, to: Node): void;
		makeFinal(state: Node): void;
		isFinal(state: Node): boolean;
		/**
		 * All states which cannot be reached from the initial state or cannot reach (or are) a final state, will be
		 * removed.
		 */
		removeUnreachable(): void;
		count(): number;
		[Symbol.iterator](): Iterator<Node>;
	}
	/**
	 * Options for the constraints on how a NFA will be created.
	 */
	interface CreationOptions extends FACreationOptions {
		/**
		 * The maximum number of nodes the NFA creation operation is allowed to create before throwing a
		 * `TooManyNodesError`.
		 *
		 * If the maximum number of nodes is set to `Infinity`, the NFA creation operation may create as many nodes as
		 * necessary to construct the NFA. This might cause the machine to run out of memory. I.e. some REs can only be
		 * represented with a huge number of states (e.g `/a{123456789}/`).
		 *
		 * Note: This limit describes maximum number of __created__ nodes. If nodes are created and subsequently
		 * discard, they will still count toward the limit.
		 *
		 * @default 10000
		 */
		maxNodes?: number;
	}
	interface Options {
		/**
		 * The maximum numerical value any character can have.
		 *
		 * This will be the maximum of all underlying {@link CharSet}s.
		 */
		maxCharacter: Char;
	}
	interface FromRegexOptions extends CreationOptions {
		/**
		 * How to handle assertions when construction the NFA.
		 *
		 * - `"throw"`
		 *
		 *   This method will throw an error when encountering an assertion.
		 *
		 * - `"disable"`
		 *
		 *   This method will replace any assertion with an empty character class, effectively removing it.
		 *
		 * @default "throw"
		 */
		assertions?: "disable" | "throw";
		/**
		 * How to handle unknowns when construction the NFA.
		 *
		 * - `"throw"`
		 *
		 *   This method will throw an error when encountering an unknown.
		 *
		 * - `"disable"`
		 *
		 *   This method will replace any unknown with an empty character class, effectively removing it.
		 *
		 * @default "throw"
		 */
		unknowns?: "disable" | "throw";
		/**
		 * The number at which the maximum of a quantifier will be assumed to be infinity.
		 *
		 * Quantifiers with a large finite maximum (e.g. `a{1,10000}`) can create huge NFAs with thousands of states.
		 * Any Quantifier with a maximum greater or equal to this threshold will be assumed to be infinite.
		 *
		 * @default Infinity
		 */
		infinityThreshold?: number;
	}
}
/**
 * A word set is finite sequence of non-empty {@link CharSet}s.
 *
 * All {@link CharSet}s are guaranteed to be non-empty and to have the same maximum.
 *
 * All FA and regex implementations are based on either {@link CharSet}s or {@link CharRange}s. This is necessary
 * because it's not practical to represent the large character sets used in every-day regexes using single characters.
 * Consequently, it is more efficient to work with {@link CharSet}s for them, so operations that yield the words of an
 * FA or regex typically yield {@link WordSet}s instead of {@link Word}s.
 *
 * This type serves as a way to document word sets. It should _not_ be used interchangeably with `CharSet[]`.
 */
export type WordSet = CharSet[];
/**
 * An immutable finite sequence of non-empty {@link CharSet}s.
 *
 * This is an immutable view on a {@link WordSet}.
 */
export type ReadonlyWordSet = readonly CharSet[];
/**
 * Contains all AST transformer implementations of refa.
 *
 * All transformer factory functions implemented here will optionally take {@link CreationOptions} or a sub-class of it.
 * This can be used to control the behavior of the created transformers.
 *
 * @module
 */
export namespace Transformers {
	interface CreationOptions {
		/**
		 * If `true`, transformers are allowed to reorder alternatives and to change/ignore the laziness of quantifiers.
		 * This may cause the behavior of the regex to change.
		 *
		 * @default false
		 */
		ignoreOrder?: boolean;
		/**
		 * If `true`, transformers are allowed to reduce or increase the ambiguity of the regular expression.
		 *
		 * @default false
		 */
		ignoreAmbiguity?: boolean;
	}
	/**
	 * This transformer will apply all trivial assertion (e.g. `/(?!0)\d/` => `/[1-9]/`) and remove all branches in
	 * assertions that are guaranteed to reject (e.g. `(?=\d+=|-)\w` => `(?=\d+=)\w`).
	 *
	 * @param _options
	 */
	function applyAssertions(_options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This will factor out common prefixes and suffixes in parent nodes.
	 *
	 * Examples:
	 *
	 * - `(?:abc|aba)` => `(?:ab(?:c|a))`
	 * - `(?<!air|after)` => `(?<!a(?:i|fte)r)`
	 *
	 * The order of alternatives and the ambiguity of the regular expression are guaranteed to be preserved. One non-obvious
	 * case where ambiguity is preserved is the case of duplicate alternatives. In this case, a group with multiple empty
	 * alternatives will be left.
	 *
	 * E.g. `(?:abc|abc|abc)` => `(?:abc(?:||))`
	 *
	 * @param options
	 */
	function factorOut(options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This transformer will simplify the AST by doing trivial inlining operations.
	 *
	 * It will:
	 *
	 * 1. Inline single-alternative alternations in concatenation (e.g. `a(?:b)c` => `abc`).
	 * 2. Inline single-alternation concatenations (e.g. `(?:(?:a|b)|c)` => `(?:a|b|c)`).
	 * 3. Inline constant-one quantifiers (e.g. `ab{1}c` => `abc`).
	 * 4. Remove constant-zero quantifiers (e.g. `ab{0}c` => `ac`).
	 * 5. Inline trivially nested assertions (e.g. `(?!(?<!a))` => `(?<=a)`).
	 * 6. Inline nested assertions at the end of the expression tree (e.g. `(?!a(?=b))` => `(?!ab)`).
	 *
	 * ---
	 *
	 * This transformer should be used in combination with {@link removeDeadBranches} to handle trivial simplifications.
	 *
	 * @param _options
	 */
	function inline(_options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This operation tries to merge as many elements as possible with existing quantifiers.
	 *
	 * Examples:
	 *
	 * - `/a*a/` => `/a+/`
	 * - `/a*(?:a+|c)/` => `/a*(?:a|c)/`
	 *
	 * @param options
	 */
	function mergeWithQuantifier(options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This tries to simplify how a given sub-expression accepts the empty string. The goal is to modify the sub-expression
	 * such that exactly one path accepts the empty string. This has the emergent result that the operator that causes the
	 * sub-expression to accept the empty string moves closer to the root of the tree.
	 *
	 * Examples:
	 *
	 * - `a(?:b*|d?)` => `a(?:b+|d)?`
	 * - `||a*|b` => `(?:a+|b)?`
	 *
	 * This operation largely ignores the order of alternatives and usually reduces the ambiguity of the expression. If
	 * order or ambiguity have to be preserved, then the effectiveness of this transformer will be greatly reduced.
	 *
	 * @param options
	 */
	function moveUpEmpty(options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This merges/optimizes nested quantifiers.
	 *
	 * Examples:
	 *
	 * - `(?:a+)*` => `a*`
	 * - `(?:a{2,4})+` => `a{2,}`
	 * - `(?:a{4}){8}` => `a{32}`
	 * - `(?:a*|b+c|f+)*` => `(?:a{1}|b+c|f{1})*`
	 *
	 * This operation largely ignores the order of alternatives and usually reduces the ambiguity of the expression. If
	 * order or ambiguity have to be preserved, then the effectiveness of this transformer will be greatly reduced.
	 *
	 * @param options
	 */
	function nestedQuantifiers(options?: Readonly<CreationOptions>): Transformer;
	interface PatternEdgeAssertionsCreationOptions extends CreationOptions {
		/**
		 * @default true
		 */
		inline?: boolean;
		/**
		 * @default false
		 */
		remove?: boolean;
	}
	/**
	 * This transformer will only touch assertion that assert characters beyond the edge of the pattern.
	 *
	 * E.g. in `/(?<!\w)(?!\d)\w+(?=\s*<)/` only `(?<!\w)` and `(?=\s*<)` are pattern edge assertions.
	 *
	 * The transformer can inline non-negated assertions (e.g. `/(?<!\w)(?!\d)\w+(?=\s*<)/` => `/(?<!\w)(?!\d)\w+\s*</`)
	 * and/or remove them (e.g. `/(?<!\w)(?!\d)\w+\s*</` => `/(?!\d)\w+\s*</`).
	 *
	 * If both inlining and removal are active, then inlining will be done first, e.g. `a(?=\w)(?!\d)` => `a(?!\d)\w`, which
	 * may prevent some removal. Some assertions will not be removed because another may be inlined later. E.g. the `(?!\d)`
	 * in `(?=\w)a?(?!\d)` will not be removed because the pattern may be transformed to `(?:a|(?=\w))(?!\d)` =>
	 * `a(?!\d)|(?=\w)(?!\d)` which can be inlined to `a(?!\d)|(?!\d)\w` and transformed to `a(?!\d)|[A-Z_a-z]`.
	 *
	 * If neither inlining nor removal are active, then this transformer won't do anything.
	 *
	 * @param options
	 */
	function patternEdgeAssertions(options?: Readonly<PatternEdgeAssertionsCreationOptions>): Transformer;
	/**
	 * This removes dead branches in the AST.
	 *
	 * Dead branches are parts of the regex that can never accept on any given input string (e.g. `[]a|b` => `b`).
	 *
	 * This operation may produce parent nodes with 0 alternatives. Quantifiers with 0 alternatives and a minimum of 0 will
	 * be replaced with the empty concatenation (e.g. `a(?:[]b)?c` => `ac`).
	 *
	 * ---
	 *
	 * This transformer should be used in combination with {@link inline} to handle trivial simplifications.
	 *
	 * @param _options
	 */
	function removeDeadBranches(_options?: Readonly<CreationOptions>): Transformer;
	/**
	 * This will remove all assertions that are known to always reject/accept no matter the input string.
	 *
	 * @param _options
	 */
	function removeUnnecessaryAssertions(_options?: Readonly<CreationOptions>): Transformer;
	interface RemoveAssertionsCreationOptions extends CreationOptions {
		/**
		 * @default "empty-set"
		 */
		replacement?: "empty-set" | "empty-word";
	}
	/**
	 * This transformer will all assertions with either the empty set or the empty word.
	 *
	 * @param options
	 */
	function replaceAssertions(options?: Readonly<RemoveAssertionsCreationOptions>): Transformer;
	/**
	 * Sorts adjacent assertions such that lookbehinds are always to the right of lookaheads.
	 *
	 * This is operation may be necessary for other transformers to pick up on certain patterns.
	 *
	 * E.g. `(?=a)(?!b)(?<!c)(?<=d)` => `(?<!c)(?<=d)(?=a)(?!b)`
	 *
	 * @param _options
	 */
	function sortAssertions(_options?: Readonly<CreationOptions>): Transformer;
	/**
	 * Combines single-character alternatives.
	 *
	 * This rule will try to combine as many character classes as possible to simplify the regular expression.
	 *
	 * E.g. `a|b|c` => `[abc]`.
	 *
	 * @param options
	 */
	function unionCharacters(options?: Readonly<CreationOptions>): Transformer;
}
/**
 * Contains algorithms consuming and producing {@link FAIterator}s.
 *
 * @module
 */
export namespace FAIterators {
	/**
	 * A lazy intersection algorithm that will use the given FA builder to construct the intersection FA as the returned
	 * iterator is used to traverse the FA.
	 *
	 * To construct the whole intersection FA, simply traverse the entire iterator.
	 *
	 * @param builder
	 * @param left
	 * @param right
	 */
	function intersection<S, L, R>(
		builder: FABuilder<S, CharSet>,
		left: TransitionIterator<L>,
		right: TransitionIterator<R>
	): FAIterator<S, S>;
	/**
	 * Maps the out type of the given iterator and returns a new iterator.
	 *
	 * @param iter
	 * @param mapFn
	 */
	function mapOut<S, O, T>(iter: FAIterator<S, O>, mapFn: (out: O) => T): FAIterator<S, T>;
	/**
	 * Maps the out type of the given iterator and returns a new iterator.
	 *
	 * @param iter
	 * @param mapFn
	 */
	function mapOutIter<S, O, T>(iter: FAIterator<S, Iterable<O>>, mapFn: (out: O) => T): FAIterator<S, Iterable<T>>;
	/**
	 * Maps the out type of the given iterator and returns a new iterator.
	 *
	 * @param iter
	 * @param conditionFn
	 */
	function filterOutIter<S, O>(
		iter: FAIterator<S, Iterable<O>>,
		conditionFn: (out: O) => boolean
	): FAIterator<S, Iterable<O>>;
	/**
	 * This will traverse the whole iterator can call the given consumer function (optional) on each reachable state
	 * exactly once.
	 *
	 * The order in which states are traversed is implementation-defined.
	 *
	 * @param iter
	 * @param consumerFn
	 */
	function forEach<S>(iter: FAIterator<S>, consumerFn?: (state: S) => void): void;
	/**
	 * Returns the number of nodes reachable from the initial state (including the initial state itself).
	 *
	 * @param iter
	 */
	function count<S>(iter: FAIterator<S>): number;
	/**
	 * The returned iterator is guaranteed to be stable.
	 *
	 * @param iter
	 */
	function ensureStableOut<S, O>(iter: FAIterator<S, O>): FAIterator<S, O>;
	/**
	 * Iterates all states reachable from the initial state of the given iterator in BFS order.
	 *
	 * The returned iterable cannot be empty and will always contain the initial state.
	 *
	 * @param iter
	 */
	function iterateStates<S>(iter: FAIterator<S>): Iterable<S>;
	/**
	 * Returns whether the initial state can reach (or is) a final state.
	 *
	 * @param iter
	 */
	function canReachFinal<S>(iter: FAIterator<S>): boolean;
	/**
	 * Returns whether the given graph contains a cycle reachable from the initial state.
	 *
	 * @param iter
	 */
	function hasCycle<S>(iter: FAIterator<S>): boolean;
	/**
	 * Returns whether the given FA only has finitely many paths that lead to a final state.
	 *
	 * @param iter
	 */
	function languageIsFinite<S>(iter: FAIterator<S>): boolean;
	/**
	 * Creates a new iterator that is equivalent to the given iterator expect that the initial state is guaranteed to be
	 * final.
	 *
	 * @param iter
	 */
	function makeInitialFinal<S, O>(iter: FAIterator<S, O>): FAIterator<S, O>;
	/**
	 * Creates a new iterator that is equivalent to the given iterator expect that the initial state is guaranteed to be
	 * non-final.
	 *
	 * @param iter
	 */
	function makeInitialNonFinal<S, O>(iter: FAIterator<S, O>): FAIterator<S, O>;
	/**
	 * Returns any one of the shortest paths accepted by the given iterator.
	 *
	 * E.g. for the regex `a|b|cd`, the returned path may be `a` or `b` but not `cd`,
	 *
	 * If the iterator does not accept any path, `undefined` will be returned.
	 *
	 * @param iter
	 * @param selectState
	 */
	function shortestAcceptingPath<S, T>(
		iter: FAIterator<S, Iterable<T>>,
		selectState: (item: T) => S
	): T[] | undefined;
	/**
	 * This will return an iterator that iteratively create a DFA using the given {@link FABuilder}.
	 *
	 * This operation may produce up to _2^O(n)_ many states. The builder should limit the number of states created.
	 *
	 * @param builder
	 * @param iter
	 */
	function makeDeterministic<B, I>(
		builder: FABuilder<B, CharSet>,
		iter: FAIterator<I, Iterable<[I, CharSet]>>
	): FAIterator<B, B>;
	/**
	 * An FA builder that uses `Map` objects as nodes. Each node is the map of its outgoing transitions.
	 */
	class MapFABuilder implements FABuilder<MapFABuilderNode, CharSet> {
		readonly initial: MapFABuilderNode;
		readonly finals: Set<MapFABuilderNode>;
		constructor(maxNodes?: number, kind?: string);
		makeFinal(state: MapFABuilderNode): void;
		isFinal(state: MapFABuilderNode): boolean;
		createNode(): MapFABuilderNode;
		linkNodes(from: MapFABuilderNode, to: MapFABuilderNode, transition: CharSet): void;
	}
	type MapFABuilderNode = Map<MapFABuilderNode, CharSet>;
	/**
	 * Removes all dead states (and trap states) from the given iterator.
	 *
	 * Note: This will iteratively create a complete copy of the given FA. This method is an expensive operation.
	 *
	 * @param iter
	 * @param select
	 */
	function removeDeadStates<S, O>(iter: FAIterator<S, Iterable<O>>, select: (item: O) => S): FAIterator<S, O[]>;
	function toDot<S, T>(iter: FAIterator<S, Iterable<[S, T]>>, options: ToDotOptions<S, T>): string;
	type ToDotAttrs = Record<string, string | number | undefined>;
	interface ToDotOptions<S, T> {
		getEdgeAttributes: (transition: T, nth: number, from: S, to: S, info: ToDotInfo<S>) => Readonly<ToDotAttrs>;
		getGraphAttributes?: () => Readonly<ToDotAttrs>;
		getNodeAttributes?: (node: S, info: ToDotInfo<S>) => Readonly<ToDotAttrs>;
	}
	interface ToDotInfo<S> {
		isInitial(node: S): boolean;
		isFinal(node: S): boolean;
		getId(node: S): number;
		getNumberOfOutgoingEdges(node: S): number;
	}
	function createSimpleToDotOptions<S, T>(toString: (transition: T) => string, ordered?: boolean): ToDotOptions<S, T>;
	/**
	 * Returns a regular expression for the given iterator.
	 *
	 * `null` transitions are assumed to be epsilon transitions.
	 *
	 * @param iter
	 * @param options
	 */
	function toRegex<S>(
		iter: FAIterator<S, Iterable<[S, CharSet | null]>>,
		options?: Readonly<ToRegexOptions>
	): NoParent<Expression>;
	/**
	 * Returns a human readable string representation of the given FA. The FA has to have exactly one initial state.
	 *
	 * All states will be labeled with numbers. The initial state will **always** has the number 0. Each state will be
	 * mapped to its outgoing states. The outgoing states may contain duplicates and are sorted alphabetically by their
	 * transition string. The number of states will be surrounded by brackets - square brackets for final states and round
	 * brackets for non-final states.
	 *
	 * A conversion function for the transitions may optionally be given. If no transition function is given, the native
	 * `String` function will be used.
	 *
	 * ---
	 *
	 * Example output for an NFA of `a*d|bb*`
	 *
	 * ```text
	 * (0) -> (1) : 'a'
	 *     -> [2] : 'b'
	 *     -> [3] : 'd'
	 *
	 * (1) -> [3] : 'd'
	 *
	 * [2] -> [2] : 'b'
	 *
	 * [3] -> none
	 * ```
	 *
	 * @param iter
	 * @param toString
	 * @param ordered
	 */
	function toString<S, T>(
		iter: FAIterator<S, Iterable<[S, T]>>,
		toString?: (value: T) => string,
		ordered?: boolean
	): string;
	/**
	 * Iterates all word sets of the given FA.
	 *
	 * Word sets are guaranteed to be iterated ordered by ascending length. Word sets might overlap.
	 *
	 * This function assumes that all character sets in the given iterator are non-empty.
	 *
	 * @param iter
	 */
	function iterateWordSets<S>(iter: FAIterator<S, Iterable<[S, CharSet]>>): Iterable<WordSet>;
	/**
	 * Returns any one of the shortest word sets accepted by the given iterator.
	 *
	 * If the iterator does not accept any words, `undefined` will be returned.
	 *
	 * This function assumes that all character sets in the given iterator are non-empty.
	 *
	 * ---
	 *
	 * This operation is roughly equivalent to `firstOf(iterateWordSets(iter))` but implemented **much more** efficiently.
	 *
	 * @param iter
	 */
	function shortestWordSet<S>(iter: FAIterator<S, Iterable<[S, CharSet]>>): WordSet | undefined;
	/**
	 * Returns a set of inputs rejected by the given iterator using the given input character set.
	 *
	 * If the iterator accepts all words, `undefined` will be returned.
	 *
	 * This algorithm implements an approximation to determine rejecting inputs in order to guarantee non-exponential
	 * worst-case execution time. Consequently, the algorithm can't find rejecting inputs for some iterators and returns
	 * `undefined` instead.
	 *
	 * @param iter
	 * @param inputCharacters The set of input characters.
	 *
	 * All character sets in the returned word set will be subsets of the set of input characters.
	 *
	 * If all characters are allowed, use `CharSet.all(maxCharacter)`.
	 * @throws if the set of input characters is empty.
	 */
	function approximateRejectingWordSet<S>(
		iter: FAIterator<S, Iterable<[S, CharSet]>>,
		inputCharacters: CharSet
	): WordSet | undefined;
}
/**
 * Classes and functions to convert JavaScript RegExp to refa AST and vise versa.
 *
 * All classes and functions in this module/namespace are specific to JavaScript regular expressions as defined by the
 * ECMAScript standard.
 *
 * @see {@link Parser}: A class to convert from JS RegExp to refa AST.
 * @see {@link toLiteral}: A function to convert from refa AST to JS RegExp.
 *
 * @module
 */
export namespace JS {
	type BoundaryAssertion = WordBoundaryAssertion | TextBoundaryAssertion;
	interface WordBoundaryAssertion {
		kind: "word";
		negate: boolean;
	}
	interface TextBoundaryAssertion {
		kind: "end" | "start";
	}
	function createAssertion(assertion: Readonly<BoundaryAssertion>, flags: Readonly<Flags>): NoParent<Element>;
	type PredefinedCharacterSet =
		| AnyCharacterSet
		| DigitCharacterSet
		| PropertyCharacterSet
		| SpaceCharacterSet
		| WordCharacterSet;
	interface AnyCharacterSet {
		kind: "any";
	}
	interface DigitCharacterSet {
		kind: "digit";
		negate: boolean;
	}
	interface PropertyCharacterSet {
		kind: "property";
		key: string;
		value: string | null;
		negate: boolean;
	}
	interface SpaceCharacterSet {
		kind: "space";
		negate: boolean;
	}
	interface WordCharacterSet {
		kind: "word";
		negate: boolean;
	}
	/**
	 * Creates a new character set with the characters equivalent to a JavaScript regular expression character set.
	 *
	 * @param chars The characters in the set.
	 * @param flags The flags of the pattern.
	 */
	function createCharSet(
		chars: Iterable<Char | CharRange | Readonly<PredefinedCharacterSet>>,
		flags: Readonly<Flags>
	): CharSet;
	interface ToLiteralOptions {
		/**
		 * An optional template for the flags of the JavaScript RegExp literal to be created.
		 *
		 * All flags that are set to `false` are guaranteed to be disabled in the created literal. Likewise, all flags that
		 * are set to `true` are guaranteed to be enabled in the created literal.
		 *
		 * Flags that are `undefined` will be enabled/disabled depending on the implementation. While no guarantees are
		 * given, the implementation will generally try to choose flags such that it can create a literal that is as
		 * small/simple as possible.
		 *
		 * If the constraints on flags defined here make it impossible to create a literal, an error will be thrown.
		 */
		flags?: Flags;
		/**
		 * This will force the function to print characters as fast as possible.
		 *
		 * Literals created with this option will usually be created about 10x faster but the result will usually be very
		 * hard to read. The is option is intended to provide performance benefits when readability is not a concern.
		 *
		 * @default false
		 */
		fastCharacters?: boolean;
	}
	/**
	 * Converts the given AST or AST subtree into a JS literal.
	 *
	 * The returned literal will be a literal representation of the given AST. However, assertions maybe converted to
	 * builtin JS RegExp assertions (e.g `\b`, `$`) instead of using the literal lookahead/lookbehind form.
	 */
	function toLiteral(node: NoParent<Node>, options?: Readonly<ToLiteralOptions>): Literal;
	function toLiteral(alternatives: readonly NoParent<Concatenation>[], options?: Readonly<ToLiteralOptions>): Literal;
	/**
	 * A partial set of RegExp flags.
	 */
	interface Flags {
		/** @default false */
		dotAll?: boolean;
		/** @default false */
		global?: boolean;
		/** @default false */
		hasIndices?: boolean;
		/** @default false */
		ignoreCase?: boolean;
		/** @default false */
		multiline?: boolean;
		/** @default false */
		sticky?: boolean;
		/** @default false */
		unicode?: boolean;
	}
	/**
	 * A light-weight representation of a
	 * [JavaScript RegExp](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp) object.
	 *
	 * This interface only requires the `source` and `flags` properties of a RegExp object.
	 */
	interface Literal {
		readonly source: string;
		readonly flags: string;
	}
	interface ParseOptions {
		/**
		 * The maximum number of words a backreference can be replaced by.
		 *
		 * Set this to 0 to disable resolving backreferences.
		 *
		 * @default 100
		 */
		maxBackreferenceWords?: number;
		/**
		 * How to the parser will handle unresolved backreferences.
		 *
		 * - `"disable"`
		 *
		 *   The parser will replace all backreferences with an empty character class. This will cause all paths containing
		 *   a backreference to be (effectively) removed.
		 *
		 *   E.g. `(a*)(\1|b)` will be parsed as `(a*)(([])|b)` which is equivalent to `a*b`.
		 *
		 * - `"throw"`
		 *
		 *   The parser will throw an error when encountering a backreference that cannot be removed.
		 *
		 *   E.g. `(a*)b\1` will throw but `(a*)[^\s\S]\1` will not because the backreference will be removed anyway because
		 *   of the empty character class.
		 *
		 * - `"unknown"`
		 *
		 *   The parser will create a `Unknown` node for each backreference that cannot be removed. The id of the node will
		 *   be raw string of the backreference.
		 *
		 * Backreferences that have been resolved are not affected by this option.
		 *
		 * @default "throw"
		 */
		backreferences?: "disable" | "throw" | "unknown";
		/**
		 * How the parser will handle assertions.
		 *
		 * - `"parse"`
		 *
		 *   The parser will translate every assertion literally to an equivalent RE AST representation. Builtin assertions
		 *   (e.g. `\b`, `$`) will be transformed into equivalent assertions.
		 *
		 * - `"disable"`
		 *
		 *   The parser will disable all assertion by replacing them with an empty character class. This will cause all
		 *   paths containing a assertion to be (effectively) removed.
		 *
		 * - `"throw"`
		 *
		 *   The parser will throw an error when encountering a assertion that cannot be removed.
		 *
		 *   E.g. `a\B` will throw but `a([]\b)(\b){0}` will not because none of the `\b`s can be reached.
		 *
		 * - `"unknown"`
		 *
		 *   The parser will create a `Unknown` node for each assertion. The id of the node will be raw string of the
		 *   assertion.
		 *
		 * @default "parse"
		 */
		assertions?: "parse" | "disable" | "throw" | "unknown";
		/**
		 * By default, the parser will try to simplify the generated RE as much as possible.
		 *
		 * If set to `false`, all trivial simplifications will be disabled. This includes:
		 *
		 * - Removing alternatives where all paths go through an empty character class, an alternation with 0 alternatives,
		 *   or a disabled backreference/assertion.
		 * - Removing constant 0 and constant 1 quantifiers.
		 * - Inlining single-alternative groups.
		 *
		 * These simplifications might prevent certain backreferences or assertions from throwing an error. It's usually
		 * good to have them enabled since parsing is usually faster and the produced RE AST is smaller.
		 *
		 * If the produced RE AST is supposed to be a literal translation, then simplifications have to be disabled.
		 *
		 * @default true
		 */
		simplify?: boolean;
		/**
		 * The maximum number of nodes the parser is allowed to create.
		 *
		 * If the regexes requires more nodes, a {@link TooManyNodesError} will be thrown.
		 *
		 * @default 10000
		 */
		maxNodes?: number;
		/**
		 * `Unknown` nodes have an `id` property that can be used to identify the element that created the unknown. This
		 * function can be used to control the `id` value.
		 *
		 * By default, the raw of the element will be used as its id.
		 */
		getUnknownId?: (element: AST.Backreference | AST.Assertion) => string;
	}
	interface RegexppAst {
		readonly pattern: AST.Pattern;
		readonly flags: AST.Flags;
	}
	type ParsableElement = AST.Element | AST.Pattern | AST.Alternative;
	interface ParseResult {
		expression: Expression;
		maxCharacter: Char;
	}
	/**
	 * Converts JS RegExp to refa's RE AST format.
	 */
	class Parser {
		/**
		 * The literal of the parser instance.
		 */
		readonly literal: Literal;
		/**
		 * The parsed AST of the literal this parser works on.
		 *
		 * While not explicitly typed that way, the parser will assume that the AST is readonly and makes optimizations
		 * based on that assumption. It is not safe to change the AST in any way.
		 */
		readonly ast: RegexppAst;
		/**
		 * The maximum character of all character sets in the parsed AST.
		 *
		 * This value will also be returned as part of the {@link ParseResult}.
		 */
		readonly maxCharacter: Char;
		/**
		 * Creates a new parser from the given literal.
		 *
		 * This function will throw a `SyntaxError` if the given literal is not a valid RegExp literal according to the
		 * given RegExp parser options.
		 *
		 * @param literal
		 * @param parserOptions
		 */
		static fromLiteral(literal: Literal, parserOptions?: RegExpParser.Options): Parser;
		/**
		 * Creates a new parser from the given [regexpp](https://github.com/mysticatea/regexpp) AST.
		 *
		 * When the JS RegExp has already been parsed using regexpp, this method can be used to avoid parsing the regex
		 * again.
		 *
		 * The given AST is not allowed to be changed during the lifetime of the returned parser.
		 *
		 * @param ast
		 */
		static fromAst(ast: RegexppAst): Parser;
		/**
		 * Parsed the entire literal.
		 *
		 * For more information on parsing, see {@link parseElement}.
		 *
		 * @param options
		 */
		parse(options?: Readonly<ParseOptions>): ParseResult;
		/**
		 * Parses a specific element of the literal.
		 *
		 * Use {@link ParseOptions} to control how the element is parsed.
		 *
		 * @param element
		 * @param options
		 */
		parseElement(element: ParsableElement, options?: Readonly<ParseOptions>): ParseResult;
	}
}
export namespace Words {
	/**
	 * Converts the given array of UTF16 character codes into a string.
	 *
	 * All numbers in the given array must be between 0 (inclusive) and 65535 = 0xFFFF (inclusive).
	 *
	 * @param word
	 */
	function fromUTF16ToString(word: ReadonlyWord): string;
	/**
	 * Converts the given array of Unicode code points into a string.
	 *
	 * All numbers in the given array must be between 0 (inclusive) and 1114111 = 0x10FFFF (inclusive).
	 *
	 * @param word
	 */
	function fromUnicodeToString(word: ReadonlyWord): string;
	/**
	 * Converts the given string into an array of UTF16 character codes.
	 *
	 * All numbers in the returned array are guaranteed to be between 0 (inclusive) and 65535 = 0xFFFF (inclusive).
	 *
	 * @param string
	 */
	function fromStringToUTF16(string: string): Word;
	/**
	 * Converts the given string into an array of Unicode code points.
	 *
	 * All numbers in the returned array are guaranteed to be between 0 (inclusive) and 1114111 = 0x10FFFF (inclusive).
	 *
	 * @param string
	 */
	function fromStringToUnicode(string: string): Word;
	/**
	 * Returns the most humanly readable character in the given character set. Which character is picked is entirely
	 * implementation-defined but, generally, word characters will be picked over non-word characters and printable
	 * characters will be picked over non-printable characters.
	 *
	 * If the given character set is empty, `undefined` will be returned.
	 *
	 * @param set
	 */
	function pickMostReadableCharacter(set: CharSet): Char | undefined;
	/**
	 * Returns a word of the given word set that is the most humanly readable.
	 *
	 * @param wordSet
	 */
	function pickMostReadableWord(wordSet: ReadonlyWordSet): Word;
	/**
	 * Returns an iterable yielding all words that can be constructed from the given word sets.
	 *
	 * @param wordSets
	 */
	function wordSetsToWords(wordSets: Iterable<ReadonlyWordSet>): Iterable<Word>;
	/**
	 * Returns an iterable yielding all words that can be constructed from the given word set.
	 *
	 * @param wordSet
	 * @deprecated Use {@link wordSetsToWords} instead.
	 */
	function wordSetToWords(wordSet: ReadonlyWordSet): Iterable<Word>;
}

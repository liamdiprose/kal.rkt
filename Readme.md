# Kal

A Racket implementation of my friend's language, Kal. We wanted to see
the performance difference between Racket and his optimised Rust interpreter.

Benchmarks to come!

---

## Usage

```bash
$ git clone https://github.com/liamdiprose/kal.rkt.git kal
$ raco pkg install kal
$ racket tests/readme.rkt
```

## Syntax Comparisons

**evens.kal.rkt**
```scheme
(fn (even_numbers)
  (let count 0)
  (loop
    (send yield with count)
    (set! count (+ count 2))))
```

**evens.kal**
```rust
fn even_numbers() {
  let mut count = 0;
  loop {
    send yield with count;
    count += 2;
  }
}
```

---

**handle.kal.rkt**
```scheme
(handle (even_numbers)
  [(yield num)
   (log num)
   (continue)])
```

**handle.kal**
```rust
handle even_numbers() {
  yield num {
    log(num);
    continue;
  }
}
```
---

**for.kal.rkt**
```scheme
(for ([x (even_numbers)])
   (log num))
```

**for.kal**
```rust
for x in even_numbers() {
    log(num);
}
```

## Implementation Status

- [x] Dynamic type system (:free:)
- [ ] Explicit mutability
- [ ] No Garbage collection
- [ ] Object/List spread operators
- [x] Implicit cast to big integers on overflow (:free:)
- [x] Symbols for private fields and langauage-defined behaviour (:free: ?)

---

- [x] Let bindings (:free:)
- [x] Functions `fn` (:free:)
- [ ] Anonymous functions
- [x] Addition, multiplication, subtraction, division (:free:)
- [x] Comparision and boolean operators (:free:)
- [x] If expressions (:free:)
- [-] Non-recursive (stack-based), (?)
  - Scheme has tail call optimisation
  - Chez has efficient implementation of continuations
- [x] Booleans (:free:)
- [x] Integers (:free:)
- [x] Floats (:free:)
- [x] Big Integers (:free:)
- [x] Lists (:free:)
- [x] Objects (:free:)
- [x] Strings (:free:)
- [x] Symbols (:free:)
- [x] Effects
  - [x] `send [with <value>]`
  - [x] `handle`
  - [x] `break [with <value>]`
  - [x] `continue [with <value>]`
- [ ] Explicit effect propagation?
- [x] Forever loops
- [x] For-each loops
- [ ] Intrinsics
- [x] Mutable let bindings (:free:)
- [ ] Mutable assignment operators
- [x] Mutable object values and list elements (:free:)
- [x] Non-string object keys (:free:)
- [x] Import / export (Racket: `require` and `provide`) (:free:)
- [x] Print (:free:)
- [ ] Patterns
  - [ ] List spread operator
  - [ ] List destructuring in `let`
  - [ ] Destructure when receiving function parameters
  - [ ] Spread lists into function calls
  - [ ] Object spread operator
    - [ ] Object destructure in `let`
  - [ ] Nested destructuring in `let` and function parameters
  - [ ] `import` pattern
  - [ ] Renaming in object destructuring
- [-] Proper type-error support (:free:)
- [-] Proper syntax-error support (:free:)
- [x] Integer division operator (:free:)
- [x] Remainder operator (:free:)
- [x] Integer modulo operator (:free:)
- [x] Exponent operator (:free:)
- [ ] Numpy-style tensors using `ndarray` (Racket: [`math/matrix`](https://docs.racket-lang.org/math/matrices.html))
- [x] Floating point numbers (:free:)
- [ ] Markdown-like comments
- [ ] Doc comments and builtin `help` function
- [ ] CLI binary
- [ ] Embeddable Rust library
- [ ] JS/WASM runtime
- [ ] Native runtime

## Wishlist: Granted

- [Typed Racket](https://docs.racket-lang.org/ts-guide/index.html) can optimise code based on type proofs, 
  especially used in Racket's [`math` libraries](https://docs.racket-lang.org/math/index.html).
- Kal.rkt is syntax agnostic via [BNF notation](lang/ast.rkt)
- Port Kal.rkt to Kal.gerbil.scm to get an optimised, standalone binary
  - Racket bundles standalone executables using the `include_str` method @maxeonyx describes
- Compiling to Javascript can be acheived via [Gerbil](https://cons.io) or it's parent, [Gambit](https://gambitscheme.org/).


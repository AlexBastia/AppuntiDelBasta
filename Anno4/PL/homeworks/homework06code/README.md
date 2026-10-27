# CS-462 Homework 6: VCgen for Separation Logic

See the associated `homework06.pdf` file for details on the assignment.

## Installation

You need OCaml, [opam](https://opam.ocaml.org), [dune](https://dune.build),
and the OCaml bindings for the [Z3](https://github.com/Z3Prover/z3) SMT solver,
which is used to check assertions. If you set these up for Homework 5, you
already have everything you need. Otherwise, follow the installation
instructions in the Homework 5 README, or in short, from this directory:

```sh
opam install . --deps-only
eval $(opam env)
```

This installs `dune` and `z3`. Installing `z3` builds Z3 from source, which can
take 10 to 30 minutes, so start early. On macOS, opam may first ask to install
some Homebrew packages (`llvm@17` and `zstd`); accept, or run the `brew install`
command it suggests and then rerun the command above. On Linux, you may need
`libgmp-dev`.

## Building and running

Build, run, and test with Dune:

```sh
dune build                          # build the executable
dune exec imp -- -run foo.imp       # run the interpreter
dune exec imp -- -verify foo.imp    # run the verifier
dune exec imp -- -debug -verify foo.imp   # also print the verification conditions
dune runtest                        # verify all programs in basic-tests/*.imp and lists/*.imp
```

Alternatively, `make` builds an executable called `imp` in this directory, so
you can run `./imp -verify foo.imp`, and `make test` runs `dune runtest`.

The programs in `lists/` will not verify until you complete them.

## The starter code

* `ast.ml` contains the ASTs for both programs and logical formulas. You will
want to be familiar with it.

* `solve.mli` / `solve.ml` has a simple solver for separation logic, using Z3
  as the underlying solver for pure first-order logic, and loosely based on
  the techniques from <https://link.springer.com/chapter/10.1007/11575467_5>.

* You will implement `vcgen.ml`, whose job is to take a program and generate a set of verification conditions, logical formulas whose validity can be checked with the solver.

* `parser.mly` and `lexer.mll` define the grammar, and `pprint.ml` pretty-prints expressions back to strings

* `eval.ml` evaluates Imp expressions with heap allocation

* Lastly, `main.ml` has the main executable entry point, which can parse a
  file, send it to `vcgen`, and check the resulting verification conditions.


## Syntax of separation logic

Our Imp programs are now annotated with separation logic assertions
(`Logic.assn`, defined in `ast.ml`).

```text
@ x |-> 1 * y |-> 2 @
t := *x;
u := *y;
@ x |-> 1 * y |-> 2 * (t = 1  and  u = 2) @
*x := u;
*y := t;
@ x |-> 2 * y |-> 1 @
```

Programs may contain C-style comments, `/* like this */`, which do not nest.

Memory commands are like those from lecture, but `new` and `free` have both
been extended to allow contiguous blocks of memory. `x := new(e1, ..., en)`
requires at least one expression, and allocates a block of `n` cells of memory,
one for each of `e1, ..., en`. `free(n, e)` frees the `n` memory cells starting
at location `e`. Memory locations are always positive. In particular, `0` is
not a valid address.

```text
x := new(6, 7, 8);
y := *(x + 2);
*x := y;
free(3, x)
```

The atomic separation logic assertions you can write are:

 * `x |-> y`, points-to
 * `x |-> _`, which means the same as `exists v. x |-> v`
 * `lseg(a, b)`, a linked-list segment from `a` to `b`
 * `list(a)`, which means the same as `lseg(a, 0)`
 * And of course, pure logic assertions: `x <= y` etc.

Because separation logic is difficult to automate, there are syntactic
restrictions on what kinds of formulas can be in program assertions, and what
kind of syntax the solver will accept. A program assertion (`Logic.assn`) is
the separating conjunction of a list of atomic assertions and a pure logic
formula. This technically limits our expressive power as the user, but
implication for full separation logic is undecidable, so we restrict to a
smaller fragment.

```
e     ::=  x  |  $a  |  n  |  e + e  |  ...         logical expressions
phi   ::=  ... pure first-order logic ...           pure assertions
a     ::=  e |-> e  |  e |-> _  |  lseg(e,e)        atomic heap assertions
assn  ::=  phi * a1 * ... * aN                      heap assertions
```

Your code will take in a program decorated with assertions (`assn`), and output
separation logic verification conditions whose validity implies the correctness
of the program. The most general kind of formula that the underlying solver can
handle is `Logic.formula`, and includes things like implication `P -* Q`.

```
form  ::=  phi  |  form /\ form  |   assn * form  |  assn -* form
       |  forall $a, form  |  exists $a, form
```

## Linked lists and list segments

A linked list node consists of two consecutive memory locations `l` and `l+1`,
the first of which stores a value and the second a `next`-pointer.

The separation logic predicate `list(p)` asserts ownership of the linked list
beginning at `p`. `p` may be `0`, in which case the list is empty. It is also
convenient to deal with list segments. The predicate `lseg(p, q)` asserts
ownership of the list segment beginning at `p` up until `q`. More formally, it
is the least predicate satisfying

```
lseg(p, q)  <=>  p = q  or  exists v, r.  (p != q) * p |-> v * p+1 |-> r * lseg(r, q)
```

and we define `list(p)` as an abbreviation for `lseg(p, 0)`. (In fact, in the
AST, there's only `lseg(p, q)`.)

Unlike lecture notes, this predicate does not track the actual contents of the
list in the logic. This is because automated reasoning with lists in the logic
is hard.


## Solver limitations

Separation logic is very powerful, and the full power of separation logic is
incredibly useful in interactive verification tools. However, it also makes it
tricky for automated verification tools. The solver in the starter code only
supports a restricted syntactic fragment of separation logic, as explained
above, but it also has some other restrictions that make it incomplete:

1. **Linear integer arithmetic.**  We restrict the first-order fragment to the
   theory of linear integer arithmetic.  This means that we can't prove things that would require nonlinear reasoning, such as:

   ```
   forall x, x * x != 2
   ```

   Verifying things like this would require reasoning about which equations
   have integer solutions, which is [famously undecidable](https://en.wikipedia.org/wiki/Hilbert%27s_tenth_problem).

2. **Existential quantifiers.**  Quantifiers in general make verification hard,
   and the more quantifiers you have the harder it'll be.  The solver only
   supports existential quantifiers in a very restricted setting:

   ```
   exists x, (e |-> x) * ...
   ```

   It expects that any formulas it is given only use existential quantifiers in
   this limited way.

3. **Case analysis.**  Some formulas require case analysis that the solver
   doesn't do. For instance, the solver cannot verify

   ```
   @ (x = z or y = z) * x |-> 1 * y |-> 1 @
   w := *z
   @ (w = 1) * x |-> 1 * y |-> 1 @
   ```

   because finding the cell that `z` points to would require splitting into
   the two cases based on whether `x=z` or `y=z`, which it doesn't (currently)
   do. It reports "Verification incomplete" instead.

   This shouldn't be an issue for typical verification problems, but it's
   possible to come up with a contrived example where it matters (try it!).

4. **Appending list segments.**  It is tempting to conclude `lseg(a, c)` from
   `lseg(a, b) * lseg(b, c)`, but this is not valid in general: `c` might be
   one of the nodes of the first segment, in which case `lseg(a, c)` stops
   early. The solver only appends segments when it can prove that `c` is `0`
   or the address of some other allocated cell, so that it cannot be inside
   the first segment. Otherwise it reports "Cannot append list segments". If
   you see this message, try strengthening your loop invariant, for example
   by keeping track of the rest of the list with `list(c)`.

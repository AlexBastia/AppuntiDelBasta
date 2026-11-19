# CS-462 Homework 10: Definitional Equality in Dependent Types

See the associated `homework10.pdf` file for details on the assignment.

In this homework, you will implement definitions of equality for a
small dependently typed language: dependent functions (Pi), dependent
pairs (Sigma), and a hierarchy of universes, as in the lectures. The
type checker is parameterized by a definition of equality, and
different definitions accept different programs.  Everything else,
including the parser and the type checker, is provided.

## Installation

You only need OCaml and [dune](https://dune.build), which you already
installed for the previous homeworks.

## Building and running

```sh
make                      # build the executable ./pi
./pi prog.pi              # type check and run the program in prog.pi
make test                 # run all the tests, for every definition of equality
make clean                # delete the build products
```

Type checking a program needs to decide when two types are equal. You
choose the definition of equality with a flag:

```sh
./pi --equal=alpha prog.pi        # syntactic: alpha-equivalence
./pi --equal=beta prog.pi          # computational: beta and delta (default)
./pi --equal=eta prog.pi          # computational, with eta
```

## Tests

`make test` runs the programs in `tests/` once for each definition of
equality, with the programs that the definition is supposed to handle:

| definition | tests it should pass             |
| ---------- | -------------------------------- |
| alpha      | `requirements`                   |
| beta       | `requirements`, `beta`           |
| eta        | `requirements`, `beta`, `eta`    |

A program whose name starts with `good` should be accepted, and a
program whose name starts with `bad` should be rejected with a type
error. The tests are also examples of how to program in the language,
so read them!

The programs in `tests/requirements` check the requirements that the
handout puts on any definition of equality, so every definition has to
pass them. Each one says in a comment which requirement it
checks. `make test-requirements` runs just those, for each definition.

## The files

You will modify one file, and write one program:

* `equality.ml`: the definitions of equality.
* `unsound.pi`: a program that you write.

The other files are provided:

* `ast.ml`: the abstract syntax of expressions, commands, and signatures.
* `util.ml`: free variables, fresh names, capture-avoiding substitution
  (`subst`), helpers for opening binders (`unbind` and `unbind2`), and lookup
  functions for signatures. **You will want to use these.**
* `check.ml`: the type checker. It calls the functions in `equality.ml`
  through `modes.ml`, which chooses the definition.
* `prelude.ml`: the built-in constants.
* `lexer.mll` and `parser.mly`: the lexer and parser.
* `pprint.ml`: the pretty printer.
* `main.ml`: the driver code.

## Syntax

There is a single syntactic category of expressions, which includes
types:

```
e ::= x                     variable or constant
    | Type i                the ith universe, for i = 0, 1, 2, ...
    | Pi (x : e1) -> e2     dependent function type
    | e1 -> e2              function type: Pi (_ : e1) -> e2
    | Sigma (x : e1) * e2   dependent pair type
    | e1 * e2               pair type: Sigma (_ : e1) * e2
    | lambda x . e          function
    | e1 e2                 application
    | (e1, e2)              pair
    | fst e | snd e         projections
    | ( e )
```

`lambda`, `Pi`, and `Sigma` extend as far to the right as possible,
`*` binds more tightly than `->`, both are right associative, and
application is left associative. As a convenience, `lambda x y . e`
abbreviates `lambda x . lambda y . e`. Identifiers may contain
letters, digits, underscores, and primes. Comments are written `(*
like this *)`.

A program is a sequence of commands:

```
axiom c : e               declare a constant c of type e
def c : e1 := e2          define a constant c of type e1 to be e2
check e                   print the type of e
eval e                    print the normal form of e
```

The built-in constants are `unit : Type 0`, with one element `tt :
unit`, and `empty : Type 0`, which has no elements.

A function `lambda x . e` does not say what the type of `x` is, and a
pair `(e1, e2)` does not say how the type of `e2` depends on `e1`. So
a function or a pair can only be used where the type checker already
knows its type: as the body of a `def`, or as an argument.

```
def id : Pi (A : Type 0) -> A -> A := lambda A x. x
def apply : (unit -> unit) -> unit := lambda f. f tt
eval apply (lambda x. x)

def p : unit * unit := (tt, tt)
eval fst p
```

There are no natural numbers or vectors, but we can define them, by
encoding numbers as functions and computing types from them. See
`tests/beta/good-church.pi`.

## Testing equality

To test whether two expressions `e1` and `e2` of type `A` are equal,
use them in a type. For example:

```
def id : unit -> unit := lambda x. x

axiom T : unit -> Type 0
axiom t : T tt
def test : T (id tt) := t
```

The definition of `test` uses `t`, which has type `T tt`, where the
type `T (id tt)` is expected. So it type checks exactly when those two
types are equal, which is to say, when `tt` is equal to `id tt`. That
is the case with `--equal=beta`, and not with `--equal=alpha`. (The
`eval` command prints the normal form that your `normalize` computes,
so it will not compute anything until you have implemented part (b).)

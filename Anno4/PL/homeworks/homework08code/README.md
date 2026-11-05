# CS-462 Homework 8: Polymorphism

See the associated `homework08.pdf` file for details on the assignment.

This homework has two parts, which you can do in either order:

1. **System F** (Lecture 14): a type checker and interpreter for System F.
2. **Type inference** (Lecture 15): unification and let-polymorphism for a
   small ML-like language.

Both parts are built into a single executable, `poly`, which decides what to
do based on the file extension: System F programs end in `.f`, and ML
programs end in `.hm`.

## Installation

You only need OCaml and [dune](https://dune.build), which you already
installed for the previous homeworks. (This homework does not use Z3.)

## Building and running

```sh
make                      # build the executable ./poly
./poly prog.f             # type check and evaluate a System F program
./poly prog.hm            # infer the type of an ML program
make test                 # run all the programs in tests/
make clean                # delete the build products
```

`make test` expects every program whose name starts with `good` to be
accepted, and every program whose name starts with `bad` to be rejected.

## The files

You will modify three files:

* `systemf/eval.ml`: evaluation for System F.
* `systemf/check.ml`: the type checker for System F.
* `inference/infer.ml`: unification and type inference for the ML language.

The other files are provided:

* `systemf/ast.ml` and `inference/ast.ml`: the abstract syntax.
* `systemf/subst.ml`: capture-avoiding substitution for System F, of an
  expression for a variable, of a type for a type variable, and of a type for
  a type variable in an expression. **You will want to use these.**
* `systemf/util.ml`: functions that compute free variables and free type
  variables, and generate fresh variable names. **You will want to use
  these.**
* `inference/types.ml`: type schemes, substitutions, and helper functions for
  type inference, such as applying and composing substitutions and generating
  fresh type variables. **You will want to use these, too.**
* `*/lexer.mll` and `*/parser.mly`: the lexers and parsers.
* `*/pprint.ml`: pretty printers.
* `*/run.ml` and `main.ml`: the driver code.

## System F syntax

```
e ::= x | lambda x : t . e | e1 e2 | Lambda X . e | e [t]
    | () | n | e1 + e2 | e1 - e2 | e1 * e2 | e1 = e2
    | true | false | if e1 then e2 else e3
t ::= Unit | Int | Bool | t1 -> t2 | X | forall X . t
```

Term variables start with a lowercase letter, and type variables start with an
uppercase letter. `lambda`, `Lambda`, `forall`, and `if` extend as far to the
right as possible, and application (including type application `e [t]`) is
left associative. For example:

```
(Lambda X . lambda f : X -> X . lambda x : X . f (f x)) [Int] (lambda n : Int . n + 1) 7
```

## ML syntax

```
e ::= x | fun x -> e | e1 e2 | let x = e1 in e2
    | () | n | e1 + e2 | e1 - e2 | e1 * e2 | e1 = e2
    | true | false | if e1 then e2 else e3 | (e : t)
t ::= unit | int | bool | t1 -> t2 | 'a
```

As in OCaml, `fun x y -> e` means `fun x -> fun y -> e`, and
`let f x y = e1 in e2` means `let f = fun x y -> e1 in e2`. A type ascription
`(e : t)` says that `e` must have type `t`; as in OCaml, the type variables in
`t` stand for types that inference may determine. You can use ascriptions to
check the types that your implementation infers. For example:

```
let twice f x = f (f x) in
(twice : ('a -> 'a) -> 'a -> 'a)
```

Both languages support comments, `(* like this *)`.

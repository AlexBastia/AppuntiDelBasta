CS-462 Homework 3
==================

See the associated writeup for details on the assignment.


The Files
---------

- `ast.ml`:
  Defines the data types for the abstract syntax trees (ASTs).

- `eval.ml`:
  The interpreter for the ASTs. Your task is to edit this (and
  only this) file to A lexer and parser for IMP programs.

- `errors.ml`:
  Some exceptions you will want to `raise` when error conditions arise during evaluation.

- `main.ml`:
  The top level code that parses in an input file, and executes it.

- `lexer.mll` and `parser.mly`:
  The lexer and parser specs for IMP programs. These are fed through [OCaml's
  lexer and parser generators][ocamlyacc] to generate source code.

- `pprint.ml`:
  A pretty printer for the ASTs.

- `test.imp`:
  A test IMP program.

[ocamlyacc]: http://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html


Compile and Execute
-------------------

You'll need to [install OCaml][] if you don't have it already. See the course website for instructions. 

If you have Make (i.e., on any Unix), you can simply type `make` at the
command line. Compilation will produce an executable file
called `imp`.

Now you can run the executable on a test program: `./imp test.imp`.

This will parse the file test.imp and evaluate the program.

Working with OCaml
------------------

OCaml modes exist for most editors:

* Vim: comes built in with recent versions, or
  http://www.ocaml.info/vim/ftplugin/ocaml.vim
* Emacs: https://github.com/ocaml/caml-mode or https://github.com/ocaml/tuareg
* Atom: https://atom.io/packages/language-ocaml
* VSCode: https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform
* Sublime Text: has a built in mode, or a better one at
  https://github.com/whitequark/sublime-better-ocaml

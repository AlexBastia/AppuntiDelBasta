CS-462 Homework 5
=================

See the associated `homework05.pdf` file for details on the assignment.


The Files
---------

- `ast.ml`:
  Defines the data types for the abstract syntax trees (ASTs).

- `eval.ml`:
  The interpreter for the ASTs.

- `main.ml`:
  The top level code that parses in an input file and generates the
  verification conditions.

- `lexer.mll` and `parser.mly`:
  The lexer and parser specs for IMP programs. 
  
- `pprint.ml`:
  A pretty printer for the ASTs.

- `vcgen.ml`:
  The verification condition generator.
  **This is the only OCaml file you need to modify.**

- `solve.ml`:
  The checker that automatically verifies the validity of assertions
  using [Z3][], an SMT (satisfiability modulo theories) solver, through
  its official OCaml bindings.

- `dune`, `dune-project`, `Makefile`:
  Build files.

- `tests/`:
  Several test IMP programs.


Installation
------------

You need three things: OCaml with its package manager [opam][], the [dune][]
build system, and the Z3 OCaml bindings. **Start early:** installing Z3 compiles
it from source, which may take as long as 30 minutes on older machines.

### 1. OCaml and opam

If you already have a working opam installation from earlier homeworks, skip
to step 2. Otherwise:

- **macOS:** install [Homebrew][] if you don't have it, and the Xcode
  command-line tools (`xcode-select --install`). Then:

      brew install opam

- **Linux (Debian/Ubuntu):**

      sudo apt install opam build-essential python3

  On other distributions, use your package manager to install opam, a C/C++
  compiler, and Python 3.

- **Windows:** use [WSL][] (Windows Subsystem for Linux) with Ubuntu, and
  follow the Linux instructions inside WSL.

Then initialize opam and load its environment into your shell:

    opam init
    eval $(opam env)

`opam init` asks whether to update your shell configuration; say yes, so that
new terminals pick up the opam environment automatically. If a command later
says it can't find `ocaml`, `dune`, or the `z3` library, run `eval $(opam env)`
again in that terminal.

### 2. dune and Z3

    opam install dune z3

opam checks for the system packages Z3 needs and offers to install any that are
missing (on macOS, Homebrew's `llvm@17` and `zstd`; on Linux, GMP). We recommend
accepting the suggestion, but it's your machine! You may also install the packages 
it lists yourself (e.g., `brew install llvm@17 zstd` or `sudo apt install libgmp-dev`) 
and re-run `opam install dune z3`. Then the Z3 C++ build runs. It is slow and prints 
little output but should complete after a while.

### 3. Check the installation

In the directory with the homework starter code, type:

    make
    ./imp -verify tests/given01.imp

If `make` succeeds, everything is installed correctly. Since you haven't
implemented `wp` yet, the second command should stop with
`Fatal error: exception Failure("Kurt")`.

On macOS, the build may print `ld: warning: search path ... not found`. You may
safely ignore this warning. The compiler also warns about unused variables in the
unfinished `vcgen.ml`; those warnings will go away once you implement `wp`.

Compile
-------

Type `make` to build the program. This runs `dune build` and copies the result
to an executable file called `imp`. Type `make clean` to delete the build
products.


Execute
-------

The tool can either run or verify IMP programs.

* To verify a program, type `./imp -verify something.imp`. This will parse the
  program, calculate the verification conditions, and check them for validity
  with Z3. It prints `Verified` if every condition is valid and `Not verified`
  otherwise.

* For testing purposes, you can run the interpreter with
  `./imp -run something.imp`. However, keep in mind that the test
  programs read variables that are never initialized, which is a runtime
  error. (For the purposes of this assignment, we only care about
  verification, not execution.)

To print some extra diagnostic information, including the verification
conditions, supply the `-debug` flag.

Typing `make test` verifies all the programs in `tests/` (and any `.imp` files
in this directory).

### About the Interface with Z3

To check that a verification condition is valid, the tool asks Z3 whether its
negation is satisfiable. If Z3 says the negation is unsatisfiable, the formula
is valid (it holds under every valuation of its free variables). If Z3 finds a
satisfying assignment for the negation, the formula is not valid. Z3 can also
give up and say `unknown`, which can happen for formulas that use nonlinear
arithmetic or quantifiers, or when a query takes longer than 10 seconds. The
tool prints `Verified` only if every verification condition is shown to be
valid.

With `-debug`, the tool prints each verification condition, both in IMP syntax
and as the SMT-LIB formula given to Z3, along with the solver's answer
(`true` for valid, `false` for not valid, `?` for unknown).

[opam]: https://opam.ocaml.org
[dune]: https://dune.build
[Homebrew]: https://brew.sh
[WSL]: https://learn.microsoft.com/en-us/windows/wsl/install
[z3]: https://github.com/Z3Prover/z3

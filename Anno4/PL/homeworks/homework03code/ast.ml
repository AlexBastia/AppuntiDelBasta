(* CS 4110 Homework 3
   This file defines the abstract syntax tree (AST) for the IMP language. You
   shouldn't need to modify it. *)

(* Parsing information: ((l1,c1),(l2,c2)) represents a symbol
   appearing at line l1 character c1 to line l2 character c2. *)
type info = (int * int) * (int * int)

(* Variables. *)
type var = string

(* Arithmetic expressions. *)
type aexp =
| Int of int
| Var of var
| Plus of aexp * aexp
| Minus of aexp * aexp
| Times of aexp * aexp
| Input

(* Boolean expressions. *)
and bexp =
| True
| False
| Equals of aexp * aexp
| NotEquals of aexp * aexp
| Less of aexp * aexp
| LessEq of aexp * aexp
| Greater of aexp * aexp
| GreaterEq of aexp * aexp
| Not of bexp
| And of bexp * bexp
| Or of bexp * bexp

(* Commands. *)
and com =
| Skip
| Assign of var * aexp
| Seq of com * com
| If of bexp * com * com
| While of bexp * com
| Print of aexp
(* A test expression gets a source location in addition to its expression. You
   can use this to print a useful error message. *)
| Test of info * bexp
| Break
| Continue

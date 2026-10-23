(* CS 4110 Homework 3
   Here are some exceptions that could happen during evaluation. If you
   encounter any of these in your `evalc` execution, use `raise IllegalBreak`
   or similar. *)

open Ast

(* Interpreter exceptions. *)
exception IllegalBreak
exception IllegalContinue
exception TestFailure of string
exception UnboundVariable of var

(* Abstract syntax for a small dependently typed language: dependent
   functions (Pi), dependent pairs (Sigma), and a hierarchy of universes.

   There is a single syntactic category of expressions: types are
   expressions too, and may contain arbitrary expressions. *)

type exp =
  | Var of string               (* x: a variable bound by a binder *)
  | Const of string             (* c: a constant (built in, axiom, or def) *)
  | Type of int                 (* Type i: the ith universe *)
  | Pi of string * exp * exp    (* Pi x : A . B (written A -> B when x does
                                   not occur in B) *)
  | Sigma of string * exp * exp (* Sigma x : A . B (written A * B when x
                                   does not occur in B) *)
  | Lam of string * exp         (* lambda x . e *)
  | App of exp * exp            (* e1 e2 *)
  | Pair of exp * exp           (* (e1, e2) *)
  | Fst of exp                  (* fst e *)
  | Snd of exp                  (* snd e *)

(* A program is a sequence of commands. *)
type command =
  | Axiom of string * exp       (* axiom c : A *)
  | Def of string * exp * exp   (* def c : A := e *)
  | Check of exp                (* check e *)
  | Eval of exp                 (* eval e *)

(* A signature records the constants that have been declared so far. Every
   constant has a type. A constant introduced by `def` also has a
   definition; a built-in constant or an axiom does not. *)
type entry = { typ : exp; def : exp option }
type signature = (string * entry) list

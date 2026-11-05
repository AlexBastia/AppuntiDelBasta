(* Types, type schemes, substitutions, and helper functions for type
   inference. You will want to use these in infer.ml. *)

open Ast

(* Raise this exception (with a helpful error message) when a program is
   not typable. *)
exception TypeError of string

(* A type scheme  forall X1 ... Xn. t  is represented as  Forall ([X1; ...; Xn], t).
   A type t with no quantified variables is  Forall ([], t). *)
type scheme = Forall of string list * typ

(* A typing context maps variables to type schemes. *)
type env = (string * scheme) list

(* A constraint t1 = t2 is represented as the pair (t1, t2). *)
type constraints = (typ * typ) list

(* A substitution maps type variables to types. *)
type subst = (string * typ) list

(* ---------- Free type variables ---------- *)

let rec ftv_typ (t : typ) : string list =
  match t with
  | TVar x -> [x]
  | TInt | TBool | TUnit -> []
  | TFun (t1, t2) -> ftv_typ t1 @ ftv_typ t2

let ftv_scheme (Forall (xs, t) : scheme) : string list =
  List.filter (fun x -> not (List.mem x xs)) (ftv_typ t)

let ftv_env (env : env) : string list =
  List.concat_map (fun (_, s) -> ftv_scheme s) env

(* Does type variable x occur in type t? *)
let occurs (x : string) (t : typ) : bool =
  List.mem x (ftv_typ t)

(* ---------- Substitutions ---------- *)

(* Apply a substitution to a type. *)
let rec apply (s : subst) (t : typ) : typ =
  match t with
  | TVar x -> (match List.assoc_opt x s with Some t' -> t' | None -> t)
  | TInt | TBool | TUnit -> t
  | TFun (t1, t2) -> TFun (apply s t1, apply s t2)

(* Apply a substitution to a type scheme, leaving its quantified variables
   alone. *)
let apply_scheme (s : subst) (Forall (xs, t) : scheme) : scheme =
  Forall (xs, apply (List.filter (fun (x, _) -> not (List.mem x xs)) s) t)

(* Apply a substitution to every type scheme in a context. *)
let apply_env (s : subst) (env : env) : env =
  List.map (fun (x, sch) -> (x, apply_scheme s sch)) env

(* Apply a substitution to both sides of every constraint. *)
let apply_constraints (s : subst) (c : constraints) : constraints =
  List.map (fun (t1, t2) -> (apply s t1, apply s t2)) c

(* Composition: apply (compose s1 s2) t = apply s1 (apply s2 t). *)
let compose (s1 : subst) (s2 : subst) : subst =
  List.map (fun (x, t) -> (x, apply s1 t)) s2
  @ List.filter (fun (x, _) -> not (List.mem_assoc x s2)) s1

(* The constraints  X = s(X)  for each type variable X in the domain of s.
   Any substitution that satisfies them "agrees with" s. *)
let constraints_of_subst (s : subst) : constraints =
  List.map (fun (x, t) -> (TVar x, t)) s

(* ---------- Fresh type variables ---------- *)

(* Generate a fresh type variable. The names of these type variables start
   with an underscore, so they cannot clash with type variables written by
   the programmer, such as 'a. *)
let counter = ref 0
let fresh_tvar () : typ =
  incr counter;
  TVar ("_" ^ string_of_int !counter)

(* Replace the type variables in a type ascription, such as 'a, with fresh
   type variables. As in OCaml, the type variables in an ascription stand for
   types that will be determined by inference: for example, (e : 'a -> 'a)
   says that e is a function whose argument and result have the same type. *)
let freshen (t : typ) : typ =
  let s = List.map (fun x -> (x, fresh_tvar ())) (List.sort_uniq compare (ftv_typ t)) in
  apply s t

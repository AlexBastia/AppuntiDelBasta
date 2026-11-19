open Ast

(* ---------- Variables ---------- *)

(* Get a list of all the free variables in an expression. Constants are not
   variables, so they are never included. *)
let rec fv (e : exp) : string list =
  match e with
  | Var x -> [x]
  | Const _ | Type _ -> []
  | Pi (x, a, b) | Sigma (x, a, b) ->
    fv a @ List.filter (fun y -> y <> x) (fv b)
  | Lam (x, b) -> List.filter (fun y -> y <> x) (fv b)
  | App (e1, e2) | Pair (e1, e2) -> fv e1 @ fv e2
  | Fst e1 | Snd e1 -> fv e1

(* Get a list of all the variable names that appear in an expression,
   whether free or bound. *)
let rec vars (e : exp) : string list =
  match e with
  | Var x -> [x]
  | Const _ | Type _ -> []
  | Pi (x, a, b) | Sigma (x, a, b) -> x :: vars a @ vars b
  | Lam (x, b) -> x :: vars b
  | App (e1, e2) | Pair (e1, e2) -> vars e1 @ vars e2
  | Fst e1 | Snd e1 -> vars e1

(* Generate a variable name that does not occur in `avoid`, based on `base`:
   it is `base` itself if that is not in `avoid`, and otherwise `base`
   followed by a number. *)
let fresh (avoid : string list) (base : string) : string =
  let rec loop (index : int) =
    let var = base ^ string_of_int index in
    if List.mem var avoid then loop (index + 1) else var in
  if List.mem base avoid then loop 1 else base

(* ---------- Substitution ---------- *)

(* `subst body x e` is the capture-avoiding substitution body{e/x}: it
   replaces the free occurrences of the variable `x` in `body` with `e`,
   renaming the bound variables of `body` as needed so that they do not
   capture the free variables of `e`. *)
let rec subst (body : exp) (x : string) (e : exp) : exp =
  (* Substitute in the scope `b` of a binder for the variable `y`. *)
  let binder (y : string) (b : exp) : string * exp =
    if y = x || not (List.mem x (fv b)) then
      (* `x` is shadowed, or does not occur: there is nothing to do. *)
      (y, b)
    else if not (List.mem y (fv e)) then
      (y, subst b x e)
    else
      (* The binder would capture a free variable of `e`: rename it. *)
      let y' = fresh (x :: fv e @ vars b) y in
      (y', subst (subst b y (Var y')) x e) in
  match body with
  | Var y -> if y = x then e else body
  | Const _ | Type _ -> body
  | App (e1, e2) -> App (subst e1 x e, subst e2 x e)
  | Pair (e1, e2) -> Pair (subst e1 x e, subst e2 x e)
  | Fst e1 -> Fst (subst e1 x e)
  | Snd e1 -> Snd (subst e1 x e)
  | Pi (y, a, b) -> let (y', b') = binder y b in Pi (y', subst a x e, b')
  | Sigma (y, a, b) -> let (y', b') = binder y b in Sigma (y', subst a x e, b')
  | Lam (y, b) -> let (y', b') = binder y b in Lam (y', b')

(* ---------- Binders ---------- *)

(* A variable name that is fresh in the whole program. The name contains a
   character that cannot be typed in a program, so it cannot clash with
   anything. *)
let counter = ref 0
let gensym (base : string) : string =
  incr counter;
  Printf.sprintf "%s#%d" base !counter

(* `unbind x b` opens the binder of a lambda, a Pi, or a Sigma with bound
   variable `x` and body `b`: it returns a fresh variable `z` together with the body in
   which `x` has been replaced by `z`. *)
let unbind (x : string) (b : exp) : string * exp =
  let z = gensym x in
  (z, subst b x (Var z))

(* `unbind2 x b1 y b2` opens two binders at once, using the same fresh
   variable for both, so that their bodies can be compared. *)
let unbind2 (x : string) (b1 : exp) (y : string) (b2 : exp) : exp * exp =
  let z = gensym x in
  (subst b1 x (Var z), subst b2 y (Var z))

(* ---------- Signatures ---------- *)

(* Look up the type of a constant. *)
let lookup_type (sg : signature) (c : string) : exp option =
  match List.assoc_opt c sg with
  | Some entry -> Some entry.typ
  | None -> None

(* Look up the definition of a constant. The result is `None` if the
   constant is built in or is an axiom, so that it has no definition (or if
   it has not been declared at all). *)
let lookup_def (sg : signature) (c : string) : exp option =
  match List.assoc_opt c sg with
  | Some entry -> entry.def
  | None -> None

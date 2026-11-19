open Ast
open Util

(* This module implements judgmental equality and is invoked by the
   type checker. This file implements three alternatives, each more
   permissive than the last. Your job is to implement the functions
   that decide them, using the provided functions `subst`, `unbind`,
   `unbind2`, and `lookup_def` from util.ml.
*)

(* ---------- (a) Alpha-equivalence ---------- *)
(* Are two expressions the same, up to the names of their bound variables? *)

(* Hint: to compare the bodies of two binders, open them with `unbind2`. *)
let rec alpha_equiv (e1 : exp) (e2 : exp) : bool =
  match e1, e2 with
  | Var x, Var y -> x = y
  | Const c, Const d -> c = d
  | Type i, Type j -> i = j
  | Pi (x, a, b), Pi (y, c, d)
  | Sigma (x, a, b), Sigma (y, c, d) -> 
      let (bu, du) = unbind2 x b y d in
      (alpha_equiv a c) && (alpha_equiv bu du)
  | Lam (x, e1), Lam (y, e2) ->
      let (e1u, e2u) = unbind2 x e1 y e2 in
      alpha_equiv e1u e2u
  | App (e1, e2), App (f1, f2)
  | Pair (e1, e2), Pair (f1, f2) ->
      (alpha_equiv e1 f1) && (alpha_equiv e2 f2)
  | Fst e, Fst f
  | Snd e, Snd f ->
      alpha_equiv e f
  | _ -> false


(* ---------- (b) Normalization ---------- *)
(* Are the two expressions the same after normalizing using computation rules? *)

(* Hint: normalize the subexpressions first, and then look at the result to
   see whether a computation rule applies. *)
let rec normalize (sg : signature) (e : exp) : exp =
  match e with
  | Var x -> Var x
  | Const c ->
      (match lookup_def sg c with
      | Some e -> normalize sg e
      | None -> Const c
      )
  | Type i -> Type i
  | Pi (x, a, b) ->
      let an = normalize sg a and
          bn = normalize sg b in
      Pi (x, an, bn)
  | Sigma (x, a, b) ->
      let an = normalize sg a and
          bn = normalize sg b in
      Sigma (x, an, bn)
  | Lam (x, e) ->
      let en = normalize sg e in
      Lam (x, en)
  | App (e1, e2) ->
      match normalize sg e1 with
      | Lam (x, e) ->
          let e' = subst e x e2 in
          normalize sg e'
      | _ ->
          let e2n = normalize sg e2 in
          App (e1, e2n)
  | Pair (e1, e2) ->
      let e1n = normalize sg e1 and
          e2n = normalize sg e2 in
      Pair (e1n, e2n)
  | Fst e ->
      (match normalize sg e with
      | Pair (e1, e2) -> normalize sg e1
      | _ -> Fst e
      )
  | Snd e ->
      (match normalize sg e with
      | Pair (e1, e2) -> normalize sg e2
      | _ -> Fst e
      )


(* ---------- (c) Eta ---------- *)
(* Are the two expressions the same using computation and "eta" rules? *)

(* Hint: copy your code for alpha_equiv, and add the new cases. Use
   `unbind` for the function case, and handle pairs using `Fst` and
   `Snd`. *)
let rec alpha_eta_equiv (e1 : exp) (e2 : exp) : bool =
  match e1, e2 with
  | Var x, Var y -> x = y
  | Const c, Const d -> c = d
  | Type i, Type j -> i = j
  | Pi (x, a, b), Pi (y, c, d)
  | Sigma (x, a, b), Sigma (y, c, d) -> 
      let (bu, du) = unbind2 x b y d in
      (alpha_eta_equiv a c) && (alpha_eta_equiv bu du)
  | Lam (x, e1), Lam (y, e2) ->
      let (e1u, e2u) = unbind2 x e1 y e2 in
      alpha_eta_equiv e1u e2u
  | Lam (x, b), e | e, Lam (x, b) ->
      let (z, b) = unbind x b in
      alpha_eta_equiv (subst b x (Var z)) (App (e, Var z))
  | App (e1, e2), App (f1, f2)
  | Pair (e1, e2), Pair (f1, f2) ->
      (alpha_eta_equiv e1 f1) && (alpha_eta_equiv e2 f2)
  | Pair (e1, e2), e | e, Pair (e1, e2) ->
      (alpha_eta_equiv e1 (Fst e)) && (alpha_eta_equiv e2 (Snd e))
  | Fst e, Fst f
  | Snd e, Snd f ->
      alpha_eta_equiv e f
  | _ -> false

(* ------- Hooks for the type checker to call ------ *)
(* You should not modify these functions *)
let equal_alpha (sg : signature) (e1 : exp) (e2 : exp) : bool =
  alpha_equiv e1 e2

let equal_beta (sg : signature) (e1 : exp) (e2 : exp) : bool =
  alpha_equiv (normalize sg e1) (normalize sg e2)

let equal_eta (sg : signature) (e1 : exp) (e2 : exp) : bool =
  alpha_eta_equiv (normalize sg e1) (normalize sg e2)

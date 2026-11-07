open Ast
open Types

(* ---------- Unification ---------- *)

(* Compute a most general substitution that satisfies all of the
   constraints in c, or raise TypeError if there is none. Don't forget the
   occurs check! *)
let rec unify (c : constraints) : subst =
  match c with
  | [] -> []
  | (t1, t2)::cs ->
      (match (t1, t2) with
      | TUnit, TUnit | TInt, TInt | TBool, TBool -> unify cs
      | TVar x, TVar y when x = y -> unify cs
      | TVar x, _ ->
          if occurs x t2 then raise (TypeError "Failed occurs check")
          else compose (unify (apply_constraints ((x, t2)::[]) cs)) ((x, t2)::[])
      | _, TVar x ->
          if occurs x t1 then raise (TypeError "Failed occurs check")
          else compose (unify (apply_constraints ((x, t1)::[]) cs)) ((x, t1)::[])
      | TFun(l1, r1), TFun(l2, r2) -> unify ((l1,l2)::(r1,r2)::cs)
      | _ -> raise (TypeError "Impossible to unify constraint")
      )

(* ---------- Type schemes ---------- *)

(* Instantiate a type scheme, replacing its quantified type variables with
   fresh type variables. *)
let instantiate (s : scheme) : typ =
  let f (t : typ) (x : string) = apply ((x, fresh_tvar ())::[]) t in
  let Forall(q, t) = s in
  List.fold_left f t q

(* Generalize a type t over all of the type variables that are free in t but
   not free in env. *)
let generalize (env : env) (t : typ) : scheme =
  let is_not_free_env (x : string) = not (List.mem x (ftv_env env)) in
  let f (Forall(q, ty) : scheme) (x : string) = Forall(x::q, ty) in
  List.fold_left f (Forall([], t)) (List.filter is_not_free_env (ftv_typ t))

(* ---------- Constraint generation ---------- *)

(* Compute a type for e in env, together with the constraints that must be
   satisfied for e to have that type.

   For let x = e1 in e2, solve the constraints for e1 right away (using
   unify), and generalize the resulting type of e1, as described in the
   lecture notes. Be careful: the solution may also determine some of the
   type variables that are free in env, and these choices must not be lost.

   For a type ascription (e : t), use Types.freshen to replace the type
   variables in t with fresh ones. *)
let rec generate (env : env) (e : exp) : typ * constraints =
  match e with
  | Var x ->
      (match List.assoc_opt x env with
      | Some s -> (instantiate s, [])
      | None -> raise (TypeError "No type for variable")
      )
  | App (e1, e2) ->
      let (t1, c1) = generate env e1 and
          (t2, c2) = generate env e2 in
      let x = fresh_tvar () in
      (x, ((t1, TFun(t2, x))::c1@c2))
  | Fun (x, e) ->
      let y = fresh_tvar () in
      let (t, c) = generate ((x, Forall([], y))::env) e in
      (TFun(y, t), c)
  | Let (x, e1, e2) ->
      let (t1, c1) = generate env e1 in
      let sigma = unify c1 in
      let sigEnv = apply_env sigma env in
      let gen = generalize sigEnv (apply sigma t1) in
      let (t2, c2) = generate ((x, gen)::sigEnv) e2 in
      (t2, ((constraints_of_subst sigma)@c2))


  | Int _ -> (TInt, []) | Bool _ -> (TBool, []) | Unit -> (TUnit, [])
  | Binop (Equal, e1, e2) ->
      let (t1, c1) = generate env e1 and
          (t2, c2) = generate env e2 in
      (TBool, ((t1, TInt)::(t2, TInt)::c1@c2))
  | Binop (_, e1, e2) ->
      let (t1, c1) = generate env e1 and
          (t2, c2) = generate env e2 in
      (TInt, ((t1, TInt)::(t2, TInt)::c1@c2))
  | If (e1, e2, e3) ->
      let (t1, c1) = generate env e1 and
          (t2, c2) = generate env e2 and
          (t3, c3) = generate env e3 in
      (t2, ((t1, TBool)::(t2, t3)::c1@c2@c3))
  | Annot (e, t) ->
      let (t', c) = generate env e in
      let tsec = freshen t in
      (tsec, ((tsec, t')::c))


(* Infer the most general type of a closed expression. *)
let infer (e : exp) : typ =
  let (t, c) = generate [] e in
  apply (unify c) t

open Ast
open Util
open Subst

(* Raise this exception (with a helpful error message) when type checking
   fails for an expression. *)
exception IllTyped of string

(* Type check a closed expression, returning its type.

   You will probably want to write some helper functions, for example:
   - a function that type checks an expression in a given set of type
     variables Delta and typing context Gamma,
   - a function that checks whether a type is well-formed, and
   - a function that checks whether two types are alpha-equivalent.

   You may use the substitution functions in subst.ml, such as
   Subst.subst_typ. *)

module StrSet = Set.Make(String)
module StrMap = Map.Make(String)

let rec is_well_formed (t : typ) (del : StrSet.t) : bool =
  match t with
  | TVar s -> StrSet.mem s del
  | TFun (l, r) -> is_well_formed l del && is_well_formed r del
  | TForall (s, t) -> is_well_formed t (StrSet.add s del)
  | TBase _ -> true

let rec is_alpha_equiv (t1 : typ) (t2 : typ) : bool =
  match (t1, t2) with
  | TVar s1, TVar s2 -> s1 = s2
  | TFun (l1, r1), TFun (l2, r2) -> is_alpha_equiv l1 l2 && is_alpha_equiv r1 r2
  | TForall (s1, t1), TForall (s2, t2) ->
      let n = fresh_tvar ((fv_typ t1)@(fv_typ t2)) in
      is_alpha_equiv (subst_typ t1 s1 (TVar n)) (subst_typ t2 s2 (TVar n))
  | TBase b1, TBase b2 -> b1 = b2
  | _ -> false

let rec check_exp_with_context (e : exp) (del : StrSet.t) (gam : typ StrMap.t) : typ =
  match e with
  | Var y -> 
      if StrMap.mem y gam then StrMap.find y gam
      else raise (IllTyped "Free variable")
  | App (e1, e2) ->
      let t1 = check_exp_with_context e1 del gam in
      (match t1 with
      | TFun (tl, tr) ->
          let t2 = check_exp_with_context e2 del gam in
          if (is_alpha_equiv tl t2) then tr
          else raise (IllTyped "Applied expression of wrong type")
      | _ -> raise (IllTyped "Type of lambda isn't TFun")
      )
  | Lam (y, t, e') ->
      if (is_well_formed t del) then TFun(t, (check_exp_with_context e' del (StrMap.add y t gam)))
      else raise (IllTyped "Type of lambda isn't well formed")

  | TypLam (y, e') ->
      let y' = fresh_tvar (StrSet.to_list del) in
      TForall(y', (check_exp_with_context (subst_typ_in_exp e' y (TVar y')) (StrSet.add y' del) gam))

  | TypApp (e', t) ->
      if (is_well_formed t del) then
        let te' = check_exp_with_context e' del gam in
        (match te' with
        | TForall(y, t') -> subst_typ t' y t
        | _ -> raise (IllTyped "Type of type application isn't TForall")
        )
      else raise (IllTyped "Type passed in type application isn't well formed")

  | Int _ -> TBase(Int) | Bool _ -> TBase(Bool) | Unit -> TBase(Unit)
  | Binop (op, e1, e2) ->
      let t1 = check_exp_with_context e1 del gam and
          t2 = check_exp_with_context e2 del gam in
      (match (t1, t2) with
      | TBase(Int), TBase(Int) -> 
          (match op with
          | Equal -> TBase(Bool)
          | _ -> TBase(Int)
          )
      | _ -> raise (IllTyped "Arguments passed to Binop aren't Ints")
      )
  | If (e1, e2, e3) ->
      let t1 = check_exp_with_context e1 del gam in
      (match t1 with
      | TBase(Bool) ->
          let t2 = check_exp_with_context e2 del gam and
              t3 = check_exp_with_context e3 del gam in
          if (is_alpha_equiv t2 t3) then t2
          else raise (IllTyped "If branches return different types")
      | _ -> raise (IllTyped "If condition isn't of type Bool")
      )

let check_exp (e : exp) : typ =
  check_exp_with_context e StrSet.empty StrMap.empty


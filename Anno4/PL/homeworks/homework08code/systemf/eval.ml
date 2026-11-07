open Ast
open Util
open Subst

(* Raise this exception (with a helpful error message) for expressions
   that "go wrong" during evaluation. *)
exception IllformedExpression of string

(* Evaluate a closed expression to a value, using call-by-value. The
   capture-avoiding substitution functions subst_exp and subst_typ_in_exp
   are provided in subst.ml. *)
let rec eval (e : exp) : exp =
  match e with
  | Var y -> raise (IllformedExpression ("Free variable " ^ y))
  | App (e1, e2) ->
      let e1' = eval e1 in 
      (match e1' with
      | Lam (y, t, e') ->
          let e2' = eval e2 in
          (match e2' with
          | Int _ | Bool _ | Unit | Lam _ | TypLam _ -> eval (subst_exp e' y e2')
          | _ -> raise (IllformedExpression "Argument passed to application isn't a value")
          )
      | _ -> raise (IllformedExpression "Expression isn't a lambda")
      )

  | Lam (y, t, e') -> e
  | TypLam (y, e') -> e
  | TypApp (e', t) -> 
      let l' = eval e' in
      (match l' with
      | TypLam (y, e2') -> eval (subst_typ_in_exp e2' y t)
      | _ -> raise (IllformedExpression "Expression isn't a type lambda")
      )

  | Int i -> Int i
  | Bool b -> Bool b
  | Unit -> Unit
  | Binop (op, e1, e2) ->
      let e1' = eval e1 and e2' = eval e2 in
      (match (e1', e2') with
      | Int i1, Int i2 -> 
        (match op with
        | Plus -> Int (i1 + i2)
        | Minus -> Int (i1 - i2)
        | Times -> Int (i1 * i2)
        | Equal -> Bool (i1 = i2)
        )
      | _ -> raise (IllformedExpression "Expression in Binop doesn't evaluate to an Int")
      )

  | If (e1, e2, e3) ->
      let e1' = eval e1 in
      (match e1' with
      | Bool true -> eval e2
      | Bool false -> eval e3
      | _ -> raise (IllformedExpression "Condition passed to If isn't a Bool")
      )

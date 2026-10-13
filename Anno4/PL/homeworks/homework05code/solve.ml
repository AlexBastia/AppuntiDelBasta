open Ast

let ctx = Z3.mk_context []

let program_var (x:var) =
  Z3.Arithmetic.Integer.mk_const_s ctx x

let logical_var (i:var) =
  Z3.Arithmetic.Integer.mk_const_s ctx ("$" ^ i)

let rec z3_of_lexp (l:lexp) : Z3.Expr.expr =
  match l with
  | LInt n ->
     Z3.Arithmetic.Integer.mk_numeral_i ctx n
  | LPVar x ->
     program_var x
  | LLVar i ->
     logical_var i
  | LPlus(l1,l2) ->
     Z3.Arithmetic.mk_add ctx [z3_of_lexp l1; z3_of_lexp l2]
  | LMinus(l1,l2) ->
     Z3.Arithmetic.mk_sub ctx [z3_of_lexp l1; z3_of_lexp l2]
  | LTimes(l1,l2) ->
     Z3.Arithmetic.mk_mul ctx [z3_of_lexp l1; z3_of_lexp l2]

let rec z3_of_assn (p:assn) : Z3.Expr.expr =
  let cmp f l1 l2 = f ctx (z3_of_lexp l1) (z3_of_lexp l2) in
  match p with
  | ATrue ->
     Z3.Boolean.mk_true ctx
  | AFalse ->
     Z3.Boolean.mk_false ctx
  | AEquals(l1,l2) ->
     cmp Z3.Boolean.mk_eq l1 l2
  | ANotEquals(l1,l2) ->
     Z3.Boolean.mk_not ctx (cmp Z3.Boolean.mk_eq l1 l2)
  | ALess(l1,l2) ->
     cmp Z3.Arithmetic.mk_lt l1 l2
  | ALessEq(l1,l2) ->
     cmp Z3.Arithmetic.mk_le l1 l2
  | AGreater(l1,l2) ->
     cmp Z3.Arithmetic.mk_gt l1 l2
  | AGreaterEq(l1,l2) ->
     cmp Z3.Arithmetic.mk_ge l1 l2
  | AAnd(p1,p2) ->
     Z3.Boolean.mk_and ctx [z3_of_assn p1; z3_of_assn p2]
  | AOr(p1,p2) ->
     Z3.Boolean.mk_or ctx [z3_of_assn p1; z3_of_assn p2]
  | ANot(p1) ->
     Z3.Boolean.mk_not ctx (z3_of_assn p1)
  | AImplies(p1,p2) ->
     Z3.Boolean.mk_implies ctx (z3_of_assn p1) (z3_of_assn p2)
  | AForall(i,p1) ->
    Z3.Quantifier.expr_of_quantifier
      (Z3.Quantifier.mk_forall_const ctx [logical_var i] (z3_of_assn p1)
         None [] [] None None)
  | AExists(i,p1) ->
    Z3.Quantifier.expr_of_quantifier
      (Z3.Quantifier.mk_exists_const ctx [logical_var i] (z3_of_assn p1)
         None [] [] None None)

let smtlib_of_assn (p:assn) : string =
  Z3.Expr.to_string (z3_of_assn p)

let timeout_ms = 10000

let valid (p:assn) : bool option =
  let solver = Z3.Solver.mk_solver ctx None in
  let params = Z3.Params.mk_params ctx in
  Z3.Params.add_int params (Z3.Symbol.mk_string ctx "timeout") timeout_ms;
  Z3.Solver.set_parameters solver params;
  Z3.Solver.add solver [Z3.Boolean.mk_not ctx (z3_of_assn p)];
  match Z3.Solver.check solver [] with
  | Z3.Solver.UNSATISFIABLE ->
     Some true
  | Z3.Solver.SATISFIABLE ->
     Some false
  | Z3.Solver.UNKNOWN ->
     None

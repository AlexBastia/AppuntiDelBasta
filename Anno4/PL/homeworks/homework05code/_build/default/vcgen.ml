(* This is the source file you need to edit for Homework 5! The function you
 * need to fill in is at the bottom of the file: `wp`.
 *)

open Ast

(* `lexp_of_aexp`: convert an `aexp` into an `lexp`.
 * An `aexp` is an ordinary program arithmetic expression; an `lexp` is the
 * logical equivalent that appears in assertions. *)
let rec lexp_of_aexp (a:aexp) : lexp =
  match a with
    | Int n ->
      LInt n
    | Var x ->
      LPVar x
    | Plus(a1,a2) ->
      LPlus(lexp_of_aexp a1, lexp_of_aexp a2)
    | Minus(a1,a2) ->
      LMinus(lexp_of_aexp a1, lexp_of_aexp a2)
    | Times(a1,a2) ->
      LTimes(lexp_of_aexp a1, lexp_of_aexp a2)

(* `assn_of_bexp`: convert a `bexp` into a `assn`
 * As above, this converts a program Boolean expression into its equivalent in
 * the assertion language. *)
let rec assn_of_bexp (b:bexp) : assn =
  match b with
    | True ->
      ATrue
    | False ->
      AFalse
    | Equals(a1,a2) ->
      AEquals(lexp_of_aexp a1, lexp_of_aexp a2)
    | NotEquals(a1,a2) ->
      ANotEquals(lexp_of_aexp a1, lexp_of_aexp a2)
    | Less(a1,a2) ->
      ALess(lexp_of_aexp a1, lexp_of_aexp a2)
    | LessEq(a1,a2) ->
      ALessEq(lexp_of_aexp a1, lexp_of_aexp a2)
    | Greater(a1,a2) ->
      AGreater(lexp_of_aexp a1, lexp_of_aexp a2)
    | GreaterEq(a1,a2) ->
      AGreaterEq(lexp_of_aexp a1, lexp_of_aexp a2)
    | Not(b1) ->
      ANot(assn_of_bexp b1)
    | And(b1,b2) ->
      AAnd(assn_of_bexp b1, assn_of_bexp b2)
    | Or(b1,b2) ->
      AOr(assn_of_bexp b1, assn_of_bexp b2)

(* `substLexp l x l1`: substitute `l` for `x` in `l1`
 * Variable substitution for `lexp`s. *)
let rec substLexp (l:lexp) (x:var) (l1:lexp) : lexp =
  match l1 with
    | LInt n ->
      LInt n
    | LLVar i ->
      LLVar i
    | LPVar y ->
      if y = x then l
      else LPVar y
    | LPlus(l1,l2) ->
      LPlus(substLexp l x l1, substLexp l x l2)
    | LMinus(l1,l2) ->
      LMinus(substLexp l x l1, substLexp l x l2)
    | LTimes(l1,l2) ->
      LTimes(substLexp l x l1, substLexp l x l2)

(* `substAssn l x p`: substitute `l` for `x` in `p`
 * Similarly, variable substitution for `assn`s. *)
and substAssn (l:lexp) (x:var) (p:assn) : assn =
  match p with
    | ATrue -> ATrue
    | AFalse -> AFalse
    | AEquals(l1,l2) ->
      AEquals(substLexp l x l1, substLexp l x l2)
    | ANotEquals(l1,l2) ->
      ANotEquals(substLexp l x l1, substLexp l x l2)
    | ALess(l1,l2) ->
      ALess(substLexp l x l1, substLexp l x l2)
    | ALessEq(l1,l2) ->
      ALessEq(substLexp l x l1, substLexp l x l2)
    | AGreater(l1,l2) ->
      AGreater(substLexp l x l1, substLexp l x l2)
    | AGreaterEq(l1,l2) ->
      AGreaterEq(substLexp l x l1, substLexp l x l2)
    | AAnd(p1,p2) ->
      AAnd(substAssn l x p1, substAssn l x p2)
    | AOr(p1,p2) ->
      AOr(substAssn l x p1, substAssn l x p2)
    | ANot(p1) ->
      ANot(substAssn l x p1)
    | AImplies(p1,p2) ->
      AImplies(substAssn l x p1, substAssn l x p2)
    | AForall(i,p1) ->
      AForall(i,substAssn l x p1)
    | AExists(i,p1) ->
      AExists(i,substAssn l x p1)

(* `wp c q` computes a precondition for command `c` and postcondition `q`,
 * together with a list of side conditions. It should satisfy: if every side
 * condition is valid, then the triple { p } c { q } is valid, where `p` is
 * the returned precondition. For commands without loops or midpoint
 * assertions, `p` should be the weakest precondition and there should be no
 * side conditions. Loop invariants and midpoint assertions (`c1; @P@ c2`)
 * give rise to side conditions. *)
let rec wp (c:com) (q:assn) : assn * assn list =
  match c with
    | Skip -> q, []
    | Assign(v, a) ->
        let la = lexp_of_aexp a in
        substAssn la v q, []
    | Print(_) -> q, []
    | Test(_, b) ->
        let ab = assn_of_bexp(b) in
        AImplies(ab, q), []
    | Seq(c1, m, c2) ->
        let (q2, l2) = wp c2 q in
        (match m with
          | None ->
              let (p, l1) = wp c1 q2 in
              p, l1@l2
          | Some a ->
              let (p, l1) = wp c1 a in
              p, (AImplies(a, q2)::l1)@l2)
    | If(b, c1, c2) ->
        let ab = assn_of_bexp(b) and (p1, l1) = wp c1 q and (p2, l2) = wp c2 q in
        AAnd(AImplies(ab, p1), AImplies(ANot(ab), p2)), l1@l2
    | While(b, i, c) ->
        let (p1, l1) = wp c i and ab = assn_of_bexp(b) in
        i, AImplies(AAnd(i, ab), p1)::AImplies(AAnd(i, ANot(ab)), q)::l1


(* Generate verification conditions for { pre } c { post }. *)
let genc ((pre,c,post): assn * com * assn) : assn list =
  let (p, vcs) = wp c post in
  AImplies(pre, p) :: vcs

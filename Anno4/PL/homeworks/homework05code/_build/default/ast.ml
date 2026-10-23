type var = string

(* Parsing information: ((l1,c1),(l2,c2)) represents a symbol
   appearing at line l1 character c1 to line l2 character c2. *)
type info = (int * int) * (int * int)

type aexp =
  | Int of int
  | Var of var
  | Plus of aexp * aexp
  | Minus of aexp * aexp
  | Times of aexp * aexp

and bexp =
  | True
  | False
  | Equals of aexp * aexp
  | NotEquals of aexp * aexp
  | Less of aexp * aexp
  | LessEq of aexp * aexp
  | Greater of aexp * aexp
  | GreaterEq of aexp * aexp
  | Not of bexp
  | And of bexp * bexp
  | Or of bexp * bexp

(* Commands. *)
and com =
  | Skip
  | Assign of var * aexp
  | Print of aexp
  | Test of info * bexp
  | Seq of com * assn option * com
  | If of bexp * com * com
  | While of bexp * assn * com

and assn =
  | ATrue
  | AFalse
  | AEquals of lexp * lexp
  | ANotEquals of lexp * lexp
  | ALess of lexp * lexp
  | ALessEq of lexp * lexp
  | AGreater of lexp * lexp
  | AGreaterEq of lexp * lexp
  | AAnd of assn * assn
  | AOr of assn * assn
  | ANot of assn
  | AImplies of assn * assn
  | AForall of var * assn
  | AExists of var * assn

and lexp =
  | LInt of int
  | LLVar of var
  | LPVar of var
  | LPlus of lexp * lexp
  | LMinus of lexp * lexp
  | LTimes of lexp * lexp

type assnVar = Logical of string | Program of string

module VarSet =
Set.Make(struct
  type t = assnVar
  let compare = Stdlib.compare
end)

let rec fvsAssn a = match a with
  | ATrue ->
    VarSet.empty
  | AFalse ->
    VarSet.empty
  | AEquals(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | ANotEquals(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | ALess(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | ALessEq(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | AGreater(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | AGreaterEq(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | AAnd(p1,p2) ->
   VarSet.union (fvsAssn p1) (fvsAssn p2)
  | AOr(p1,p2) ->
    VarSet.union (fvsAssn p1) (fvsAssn p2)
  | ANot(p1) ->
    fvsAssn p1
  | AImplies(p1,p2) ->
   VarSet.union (fvsAssn p1) (fvsAssn p2)
  | AForall(i,p1) ->
    VarSet.remove (Logical i) (fvsAssn p1)
  | AExists(i,p1) ->
    VarSet.remove (Logical i) (fvsAssn p1)

and fvsLexp l = match l with
  | LInt _ ->
    VarSet.empty
  | LPVar x ->
    VarSet.singleton (Program x)
  | LLVar i ->
    VarSet.singleton (Logical i)
  | LPlus(l1,l2)  ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | LMinus(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)
  | LTimes(l1,l2) ->
    VarSet.union (fvsLexp l1) (fvsLexp l2)

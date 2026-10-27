type var = string

(* Parsing information: ((l1,c1),(l2,c2)) represents a symbol
   appearing at line l1 character c1 to line l2 character c2. *)
type info = (int * int) * (int * int)

module Logic = struct
  type pure_assn =
    | True
    | False
    | Equals of lexp * lexp
    | NotEquals of lexp * lexp
    | Less of lexp * lexp
    | LessEq of lexp * lexp
    | Greater of lexp * lexp
    | GreaterEq of lexp * lexp
    | And of pure_assn * pure_assn
    | Or of pure_assn * pure_assn
    | Not of pure_assn

  and heap_atom =
    | PointsTo of lexp * lexp   (* x |-> y *)
    | PointsToSomething of lexp (* x |-> _ *)
    | ListSeg of lexp * lexp    (* lseg(x, y) *)

  (** An assn describes a simple assertion about the current heap state:
        (phi, [a1; ...; aN])   means   phi * a1 * ... * aN
    *)
  and assn = pure_assn * heap_atom list

  (** The more complicated 'formula' type represents more interesting logical formulas. *)
  and formula =
    | Assn of assn
    | LogicalAnd of formula * formula
    | LogicalImplies of pure_assn * formula
    | Star of assn * formula
    | MagicWand of assn * formula
    (* Only quantify over logical variables. Program variables are implicitly
     * universally quantified for the entire program. *)
    (* Note (existential quantification): the solver only supports the usage
         exists x, (e |-> x) * P
       Any other usage of Exists will be rejected as unsupported.
     *)
    | Forall of var * formula
    | Exists of var * formula

  and lexp =
    | Int of int
    | LVar of var
    | PVar of var
    | Plus of lexp * lexp
    | Minus of lexp * lexp
    | Times of lexp * lexp

  type assnVar = Logical of string | Program of string

  (* subst_lexp x v l: substitute v for variable x in l. l[v/x] *)
  let rec subst_lexp (x:assnVar) (v:lexp) (l:lexp) : lexp =
    match l with
    | Int n -> Int n
    | LVar i -> if x = Logical i then v else LVar i
    | PVar y -> if x = Program y then v else PVar y
    | Plus(l1,l2) -> Plus(subst_lexp x v l1, subst_lexp x v l2)
    | Minus(l1,l2) -> Minus(subst_lexp x v l1, subst_lexp x v l2)
    | Times(l1,l2) -> Times(subst_lexp x v l1, subst_lexp x v l2)

  (* subst_pure_assn x v p: substitute v for variable x in p. p[v/x] *)
  let rec subst_pure_assn (x:assnVar) (v:lexp) (p:pure_assn) : pure_assn =
    match p with
    | True -> True
    | False -> False
    | Equals(l1,l2) -> Equals(subst_lexp x v l1, subst_lexp x v l2)
    | NotEquals(l1,l2) -> NotEquals(subst_lexp x v l1, subst_lexp x v l2)
    | Less(l1,l2) -> Less(subst_lexp x v l1, subst_lexp x v l2)
    | LessEq(l1,l2) -> LessEq(subst_lexp x v l1, subst_lexp x v l2)
    | Greater(l1,l2) -> Greater(subst_lexp x v l1, subst_lexp x v l2)
    | GreaterEq(l1,l2) -> GreaterEq(subst_lexp x v l1, subst_lexp x v l2)
    | And(p1,p2) -> And(subst_pure_assn x v p1, subst_pure_assn x v p2)
    | Or(p1,p2) -> Or(subst_pure_assn x v p1, subst_pure_assn x v p2)
    | Not p -> Not(subst_pure_assn x v p)

  (* subst_heap_atom x v at: substitute v for variable x in at. at[v/x] *)
  let subst_heap_atom (x:assnVar) (v:lexp) (at:heap_atom) : heap_atom =
    match at with
    | PointsTo(l1,l2) -> PointsTo(subst_lexp x v l1, subst_lexp x v l2)
    | PointsToSomething l -> PointsToSomething(subst_lexp x v l)
    | ListSeg(l1,l2) -> ListSeg(subst_lexp x v l1, subst_lexp x v l2)

  (* subst_assn x v p: substitute v for variable x in p. p[v/x] *)
  let subst_assn (x:assnVar) (v:lexp) ((phi,atoms):assn) : assn =
    (subst_pure_assn x v phi, List.map (subst_heap_atom x v) atoms)

  (* does a variable occur free in some piece of syntax? *)
  let rec is_free_in_lexp (x:assnVar) (l:lexp) =
    match l with
    | Int _ -> false
    | LVar y -> x = Logical y
    | PVar y -> x = Program y
    | Plus(l1,l2) | Minus(l1,l2) | Times(l1,l2) ->
        is_free_in_lexp x l1 || is_free_in_lexp x l2

  let rec is_free_in_pure_assn x (p:pure_assn) =
    match p with
    | True | False -> false
    | Equals(l1,l2) | NotEquals(l1,l2) | Less(l1,l2) | LessEq(l1,l2)
    | Greater(l1,l2) | GreaterEq(l1,l2) ->
        is_free_in_lexp x l1 || is_free_in_lexp x l2
    | And(p1,p2) | Or(p1,p2) ->
        is_free_in_pure_assn x p1 || is_free_in_pure_assn x p2
    | Not p -> is_free_in_pure_assn x p

  let is_free_in_assn x ((phi,atoms):assn) =
    is_free_in_pure_assn x phi || List.exists (function
      | PointsTo(l1,l2) | ListSeg(l1,l2) -> is_free_in_lexp x l1 || is_free_in_lexp x l2
      | PointsToSomething l -> is_free_in_lexp x l) atoms

  let rec is_free_in (x:assnVar) (p:formula) =
    match p with
    | Assn a -> is_free_in_assn x a
    | LogicalAnd(p1,p2) -> is_free_in x p1 || is_free_in x p2
    | LogicalImplies(phi,p) -> is_free_in_pure_assn x phi || is_free_in x p
    | Star(a,p) | MagicWand(a,p) -> is_free_in_assn x a || is_free_in x p
    | Forall(y,p) | Exists(y,p) -> x <> Logical y && is_free_in x p

  (* subst_formula x v p: substitute v for variable x in p. p[v/x]

     Correctly avoids variable capture around forall/exists *)
  let rec subst_formula (x:assnVar) (v:lexp) (p:formula) : formula =
    match p with
    | Assn a -> Assn(subst_assn x v a)
    | LogicalAnd(p1,p2) -> LogicalAnd(subst_formula x v p1, subst_formula x v p2)
    | LogicalImplies(phi,p) -> LogicalImplies(subst_pure_assn x v phi, subst_formula x v p)
    | Star(a,p) -> Star(subst_assn x v a, subst_formula x v p)
    | MagicWand(a,p) -> MagicWand(subst_assn x v a, subst_formula x v p)
    | Forall(y,body) | Exists(y,body) ->
        if x = Logical y then p else
        let (y', body') =
          if not (is_free_in_lexp (Logical y) v) then
            (y, subst_formula x v body)
          else begin
            let rec fresh k =
              let n = y ^ "_" ^ string_of_int k in
              if is_free_in (Logical n) body || is_free_in_lexp (Logical n) v
              then fresh (k+1) else n in
            let name = fresh 0 in
            let renamed = subst_formula (Logical y) (LVar name) body in
            (name, subst_formula x v renamed)
          end in
        match p with
        | Forall _ -> Forall(y',body')
        | _ -> Exists(y',body')

end

module Code = struct
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
    | Print of aexp
    | Test of info * bexp
    | Assign of var * aexp
    | ReadMem of var * aexp          (* x := *a *)
    | WriteMem of aexp * aexp        (* *a1 := a2 *)
    | New of var * aexp list         (* x := new(a1, ..., ak) *)
    | Free of int * aexp             (* free(n, a) *)
    (* `c1; c2`, or `c1; @P@ c2` with an optional midpoint assertion `P`. *)
    | Seq of com * Logic.assn option * com
    | If of bexp * com * com
    | While of bexp * Logic.assn * com
end

module VarSet =
Set.Make(struct
  type t = Logic.assnVar
  let compare = Stdlib.compare
end)

(* lexp_of_aexp: convert an aexp into an lexp *)
let rec lexp_of_aexp (a: Code.aexp) : Logic.lexp =
  match a with
  | Code.Int n -> Logic.Int n
  | Code.Var x -> Logic.PVar x
  | Code.Plus(a1,a2) -> Logic.Plus(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.Minus(a1,a2) -> Logic.Minus(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.Times(a1,a2) -> Logic.Times(lexp_of_aexp a1, lexp_of_aexp a2)

(* assn_of_bexp: convert a bexp into a pure assertion *)
let rec assn_of_bexp (b: Code.bexp) : Logic.pure_assn =
  match b with
  | Code.True -> Logic.True
  | Code.False -> Logic.False
  | Code.Equals(a1,a2) -> Logic.Equals(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.NotEquals(a1,a2) -> Logic.NotEquals(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.Less(a1,a2) -> Logic.Less(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.LessEq(a1,a2) -> Logic.LessEq(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.Greater(a1,a2) -> Logic.Greater(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.GreaterEq(a1,a2) -> Logic.GreaterEq(lexp_of_aexp a1, lexp_of_aexp a2)
  | Code.Not b -> Logic.Not(assn_of_bexp b)
  | Code.And(b1,b2) -> Logic.And(assn_of_bexp b1, assn_of_bexp b2)
  | Code.Or(b1,b2) -> Logic.Or(assn_of_bexp b1, assn_of_bexp b2)

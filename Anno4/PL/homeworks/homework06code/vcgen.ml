open Ast
open Ast.Code
open Ast.Logic

(* a variable that's fresh for this formula *)
let fresh_var (name : var) (p : formula) =
  let rec go k =
    let v = name ^ "_" ^ string_of_int k in
    if is_free_in (Logical v) p then go (k + 1) else v
  in
  if is_free_in (Logical name) p then go 0 else name


let rec make_alloc_list (alist : aexp list) (counter : int) (i : var) : heap_atom list =
  match alist with
  | [] -> []
  | a::rest -> PointsTo(Plus((LVar i), (Int counter)), lexp_of_aexp a)::(make_alloc_list rest (counter + 1) i)

let rec make_free_list (counter : int) (a : aexp) : heap_atom list =
  match counter with
  | 0 -> []
  | n -> PointsToSomething(lexp_of_aexp a)::(make_free_list (n-1) (Plus(a, (Int 1))))

(* `gen_precondition c post` computes a precondition for command `c` and postcondition `post`,
 * together with a list of side conditions. It should satisfy: if every side
 * condition is valid, then the triple { pre } c { post } is valid, where `pre` is
 * the returned precondition. For commands without loops nor midpoint
 * assertions, `pre` should be the weakest precondition and there should be no
 * side conditions. Loop invariants and midpoint assertions (`c1; @P@ c2`)
 * give rise to side conditions. *)
let rec gen_precondition (c : com) (post : formula) : formula * formula list =
  match c with
    | Skip -> post, []
    | Assign(v, a) ->
        let la = lexp_of_aexp a in
        subst_formula (Program v) la post, []
    | Print(_) -> post, []
    | Test(_, b) ->
        let ab = assn_of_bexp(b) in
        LogicalImplies(ab, post), []
    | Seq(c1, m, c2) ->
        let (q2, l2) = gen_precondition c2 post in
        (match m with
          | None ->
              let (p, l1) = gen_precondition c1 q2 in
              p, l1@l2
          | Some a ->
              let (p, l1) = gen_precondition c1 (Assn a) in
              p, (MagicWand(a, q2)::l1)@l2)
    | If(b, c1, c2) ->
        let ab = assn_of_bexp(b) and (p1, l1) = gen_precondition c1 post and (p2, l2) = gen_precondition c2 post in
        LogicalAnd(LogicalImplies(ab, p1), LogicalImplies(Not(ab), p2)), l1@l2
    | While(b, i, c) ->
        let (p1, l1) = gen_precondition c (Assn i) 
        and ab = assn_of_bexp(b) and (phi, atoms) = i in
        (Assn i), MagicWand((And(ab, phi), atoms), p1)::MagicWand((And(Not(ab), phi), atoms), post)::l1
    | ReadMem(v, a) ->
        let la = lexp_of_aexp a and x = fresh_var "x" post in
        let assn1 = (True,[PointsTo(la, LVar x)]) in
        Exists(x, Star(assn1, MagicWand(assn1, subst_formula (Program v) (LVar x) post))), []
    | WriteMem(a1, a2) ->
        let la1 = lexp_of_aexp a1 and la2 = lexp_of_aexp a2 in
        let assn1 = (True, [PointsToSomething(la1)])
        and assn2 = (True, [PointsTo(la1, la2)]) in
        Star(assn1, MagicWand(assn2, post)), []
    | New(v, []) -> post, []
    | New(v, alist) ->
        let i = fresh_var "i" post in
        let assn1 = (True, make_alloc_list alist 0 i) in
        Forall(i, MagicWand(assn1, subst_formula (Program v) (LVar i) post)), []
    | Free(n, a) ->
        let assn1 = (True, make_free_list n a) in
        Star(assn1, post), []

(* genc prog: generate verification conditions for prog. *)
let genc ((pre,c,post): assn * com * assn) : formula list =
  let (wp, l) = gen_precondition c (Assn post) in
  MagicWand(pre, wp)::l

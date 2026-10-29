open Ast
open Ast.Logic

exception Malformed of formula
exception Incomplete of string
exception NotValid of formula

(* Bound variables override the stable constants used for free variables. *)
module M = Map.Make (struct type t = assnVar let compare = Stdlib.compare end)
type env = Z3.Expr.expr M.t

(* Solver representation of the current state of the heap. List of points-to's *)
type satom =
  | PointsTo of Z3.Expr.expr * Z3.Expr.expr
  | NonemptyLSeg of Z3.Expr.expr * Z3.Expr.expr
type heap = satom list

let z3_inc ctx x =
  Z3.Arithmetic.mk_add ctx [x; Z3.Arithmetic.Integer.mk_numeral_i ctx 1]

let addrs_of_satom ctx = function
  | PointsTo(l, _) -> [l]
  | NonemptyLSeg(l, _) -> [l; z3_inc ctx l]

(** The pure part of a heap (i.e., addresses are distinct) *)
let pure_part ctx (heap : heap) : Z3.Expr.expr =
  match List.concat_map (addrs_of_satom ctx) heap with
  | [] | [_] -> Z3.Boolean.mk_true ctx
  | addresses -> Z3.Boolean.mk_distinct ctx addresses

(** A z3 solver that only does linear arithmetic (no nonlinear arithmetic)

    This is bc we want SAT calls to be fast (really, they will output "unknown"
    rather than SAT sometimes) *)
let make_solver ctx : Z3.Solver.solver =
  let s = Z3.Solver.mk_simple_solver ctx in
  let p = Z3.Params.mk_params ctx in
  let key = Z3.Symbol.mk_string ctx in
  Z3.Params.add_int p (key "arith.solver") 2;
  Z3.Params.add_bool p (key "arith.nl") false;
  Z3.Solver.set_parameters s p;
  s

let rec lexp_to_z3 ctx (env : env) = function
  | Int n -> Z3.Arithmetic.Integer.mk_numeral_i ctx n
  | PVar x ->
      (match M.find_opt (Program x) env with
       | Some value -> value
       | None -> Z3.Arithmetic.Integer.mk_const_s ctx ("program:" ^ x))
  | LVar x ->
      (match M.find_opt (Logical x) env with
       | Some value -> value
       | None -> Z3.Arithmetic.Integer.mk_const_s ctx ("logical:" ^ x))
  | Plus (l, r) ->
      Z3.Arithmetic.mk_add ctx [lexp_to_z3 ctx env l; lexp_to_z3 ctx env r]
  | Minus (l, r) ->
      Z3.Arithmetic.mk_sub ctx [lexp_to_z3 ctx env l; lexp_to_z3 ctx env r]
  | Times (l, r) ->
      Z3.Arithmetic.mk_mul ctx [lexp_to_z3 ctx env l; lexp_to_z3 ctx env r]

let rec pure_assn_to_z3 ctx (env : env) = function
  | True -> Z3.Boolean.mk_true ctx
  | False -> Z3.Boolean.mk_false ctx
  | Equals (l, r) ->
      Z3.Boolean.mk_eq ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r)
  | NotEquals (l, r) ->
      Z3.Boolean.mk_not ctx
        (Z3.Boolean.mk_eq ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r))
  | Less (l, r) ->
      Z3.Arithmetic.mk_lt ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r)
  | LessEq (l, r) ->
      Z3.Arithmetic.mk_le ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r)
  | Greater (l, r) ->
      Z3.Arithmetic.mk_gt ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r)
  | GreaterEq (l, r) ->
      Z3.Arithmetic.mk_ge ctx (lexp_to_z3 ctx env l) (lexp_to_z3 ctx env r)
  | And (p, q) ->
      Z3.Boolean.mk_and ctx [pure_assn_to_z3 ctx env p; pure_assn_to_z3 ctx env q]
  | Or (p, q) ->
      Z3.Boolean.mk_or ctx [pure_assn_to_z3 ctx env p; pure_assn_to_z3 ctx env q]
  | Not p -> Z3.Boolean.mk_not ctx (pure_assn_to_z3 ctx env p)

let assert_valid (formula : formula) : unit =
  let z3_ctx = Z3.mk_context [] in
  let solver = make_solver z3_ctx in
  let zero = Z3.Arithmetic.Integer.mk_numeral_i z3_ctx 0 in

  let with_scope f =
    Z3.Solver.push solver;
    Fun.protect f ~finally:(fun () -> Z3.Solver.pop solver 1) in

  let fresh_z3 var =
    Z3.Expr.mk_fresh_const z3_ctx var (Z3.Arithmetic.Integer.mk_sort z3_ctx) in

  let is_trivial heap : bool =
    (* Whether the current SMT state implies false *)
    (* Add an AllDistinct clause for the pointers in the pointsto assertions *)
    (* If the solver reports UNKNOWN, treat it the same as SAT. *)
    with_scope (fun () ->
      Z3.Solver.add solver [pure_part z3_ctx heap];
      match Z3.Solver.check solver [] with
      | Z3.Solver.UNSATISFIABLE -> true
      | Z3.Solver.SATISFIABLE | Z3.Solver.UNKNOWN -> false) in

  let add_assumption_z3 phi =
    Z3.Solver.add solver [phi] in
  let add_assumption env phi =
    add_assumption_z3 (pure_assn_to_z3 z3_ctx env phi) in

  let is_valid_z3 heap (phi : Z3.Expr.expr) : bool =
    (* Check whether this is implied by the current solver state, without
       modifying the current set of assertions in the solver. *)
    with_scope (fun () ->
      add_assumption_z3 (Z3.Boolean.mk_not z3_ctx phi);
      is_trivial heap) in
  let is_valid_pure env heap (phi : pure_assn) : bool =
    is_valid_z3 heap (pure_assn_to_z3 z3_ctx env phi) in

  let assert_valid_pure env heap phi =
    if is_valid_pure env heap phi then () else raise (NotValid (Assn (phi, []))) in

  let rec go env heap : formula -> unit = function
    | Assn (phi, atoms) as formula ->
        assert_valid_pure env heap phi;
        go_star_many env heap atoms (fun heap ->
          if heap <> [] then raise (NotValid formula))
    | LogicalAnd(p, q) ->
        with_scope (fun () -> go env heap p); go env heap q
    | LogicalImplies(phi, p) ->
        add_assumption env phi; 
        if not (is_trivial heap) then go env heap p
    | Star((phi, atoms), p) ->
        assert_valid_pure env heap phi;
        go_star_many env heap atoms (fun heap -> go env heap p)
    | MagicWand((phi, atoms), p) ->
        add_assumption env phi; go_wand_many env heap atoms p
    | Forall(var, p) ->
        let value = fresh_z3 var in
        let env' = M.add (Logical var) value env in
        go env' heap p
    | Exists(var, Star((phi, atoms), p)) as formula ->
        (* Exists is special.  We only support the specific idiom
             exists x, (e |-> x) * P
         *)
        let is_points_to_var = function
          | Logic.PointsTo(_l, v) when v = LVar var -> true
          | _ -> false in
        let l = match List.filter is_points_to_var atoms with
                | [PointsTo(l, _v)] -> l
                | _ -> raise (Malformed formula) in
        (* The address must be known before we obtain the existential witness.
           In particular, do not accidentally use an outer binding of var. *)
        if is_free_in_lexp (Logical var) l then raise (Malformed formula);
        let atoms' = List.filter (fun a -> a <> Logic.PointsTo(l, LVar var)) atoms in
        let l = lexp_to_z3 z3_ctx env l in
        consume heap formula l (fun v heap' ->
          let env' = M.add (Logical var) v env in
          assert_valid_pure env' heap' phi;
          go_star_many env' heap' atoms' (fun heap -> go env' heap p))
    | Exists(_, _) as formula ->
        raise (Malformed formula)

  (* consume a whole heaplet *)
  and go_star_many env heap atoms k =
    match atoms with
    | [] -> k heap
    | x::xs -> go_star_one env heap x (fun heap' ->
        go_star_many env heap' xs k)

  (* consume one atom *)
  (* to prove h |- at * p, decompose h = h' * at and prove h' |- p *)
  and go_star_one env heap (atom : heap_atom) (k : heap -> unit) =
    let form = Assn (True, [atom]) in
    match atom with
    | PointsToSomething l ->
        let l = lexp_to_z3 z3_ctx env l in
        consume heap form l (fun _actual heap' -> k heap')
    | PointsTo (l, v) ->
        let l = lexp_to_z3 z3_ctx env l in
        let v = lexp_to_z3 z3_ctx env v in
        consume heap form l (fun actual heap' ->
          if is_valid_z3 heap (Z3.Boolean.mk_eq z3_ctx actual v) then
            k heap'
          else raise (NotValid form))
    | ListSeg (l, l') ->
        let l = lexp_to_z3 z3_ctx env l in
        let l' = lexp_to_z3 z3_ctx env l' in
        go_star_seg heap form l l' k

  and go_star_seg heap form l l' (k : heap -> unit) =
    (* could be an empty segment *)
    if is_valid_z3 heap (Z3.Boolean.mk_eq z3_ctx l l') then k heap else
    (* could be a segment in the heap *)
    try_consume_seg heap l l'
      (fun next heap -> (* success -- we consumed this list segment *)
        go_star_seg heap form next l' k)
      (fun _ ->
        (* Could not consume a whole list segment, so try consuming it
           piece-by-piece. By definition, a nonempty segment needs l != l'.
           If we can't prove that, split into cases: when l = l', the segment
           is empty and the heap is left alone. *)
        let nonempty () =
          let l_next = z3_inc z3_ctx l in
          consume heap form l (fun _v heap ->
            consume heap form l_next (fun next heap ->
              go_star_seg heap form next l' k)) in
        let neq = Z3.Boolean.mk_not z3_ctx (Z3.Boolean.mk_eq z3_ctx l l') in
        if is_valid_z3 heap neq then nonempty () else begin
          with_scope (fun () ->
            add_assumption_z3 (Z3.Boolean.mk_eq z3_ctx l l'); k heap);
          with_scope (fun () -> add_assumption_z3 neq; nonempty ())
        end)

  (* produce a whole heaplet *)
  and go_wand_many env heap atoms p =
    match atoms with
    | [] -> if is_trivial heap then () else go env heap p
    | x::xs -> go_wand_one env heap x (fun heap' -> go_wand_many env heap' xs p)

  and go_wand_one env heap (atom : heap_atom) (k : heap -> unit) =
    match atom with
    | PointsToSomething l ->
        let l = lexp_to_z3 z3_ctx env l in
        add_assumption_z3 (Z3.Arithmetic.mk_gt z3_ctx l zero);
        k (PointsTo(l, fresh_z3 "value") :: heap)
    | PointsTo(l, v) ->
        let l = lexp_to_z3 z3_ctx env l in
        let v = lexp_to_z3 z3_ctx env v in
        add_assumption_z3 (Z3.Arithmetic.mk_gt z3_ctx l zero);
        k (PointsTo(l, v) :: heap)
    | ListSeg(l, l') ->
        let l = lexp_to_z3 z3_ctx env l in
        let l' = lexp_to_z3 z3_ctx env l' in
        go_wand_seg heap l l' k

  and go_wand_seg heap l l' k =
    (* either it's empty or nonempty. case analysis *)
    with_scope (fun _ ->
      add_assumption_z3 (Z3.Boolean.mk_eq z3_ctx l l'); k heap);
    add_assumption_z3 (Z3.Boolean.mk_distinct z3_ctx [l; l']);
    add_assumption_z3 (Z3.Arithmetic.mk_gt z3_ctx l zero);
    k (NonemptyLSeg(l, l') :: heap)

  (* try to prove lseg(l, l') by consuming a whole segment lseg(l, b) from the
     heap, leaving lseg(b, l') to prove. *)
  and try_consume_seg heap l l' (k : Z3.Expr.expr -> heap -> unit) (k_failure : unit -> unit) =
    add_assumption_z3 (pure_part z3_ctx heap);
    if is_trivial heap then () else
    let matches = function
      | NonemptyLSeg(a, _b) -> is_valid_z3 heap (Z3.Boolean.mk_eq z3_ctx l a)
      | _ -> false in
    match List.partition matches heap with
    | [NonemptyLSeg(_, b)], rest ->
        (* lseg(l, b) * lseg(b, l') |- lseg(l, l') only holds if l' is not a
           node of lseg(l, b). It holds when b = l' (nothing to append), or
           when l' is 0 or allocated elsewhere in the heap, since then it
           cannot be one of the segment's nodes. *)
        let eq x = Z3.Boolean.mk_eq z3_ctx l' x in
        let outside = eq zero :: List.map eq (List.concat_map (addrs_of_satom z3_ctx) rest) in
        if is_valid_z3 heap (eq b) || is_valid_z3 heap (Z3.Boolean.mk_or z3_ctx outside)
        then k b rest
        else raise (Incomplete "Cannot append list segments: the end might be inside the first segment")
    | [], _ -> k_failure ()
    | _ -> failwith "this case is impossible (bug in solver)"

  (* the consume operation: ensure heap looks like (l |-> blah) * h'.
     run `k blah h'` for each possible decomposition *)
  and consume heap formula (l : Z3.Expr.expr) (k : Z3.Expr.expr -> heap -> unit) =
    (* Preserve the original heap's disjointness when consuming a cell. *)
    add_assumption_z3 (pure_part z3_ctx heap);
    if is_trivial heap then () else
    (* it's at most one of them. let's see if we can find it *)
    let matches (at : satom) =
      List.exists (fun addr -> is_valid_z3 heap (Z3.Boolean.mk_eq z3_ctx l addr))
        (addrs_of_satom z3_ctx at) in
    match List.partition matches heap with
    | [PointsTo(_, v)], heap ->
        (* it's exactly one of them. hooray *)
        k v heap
    | [NonemptyLSeg(a, b)], heap ->
        (* unfold the lseg *)
        let hd, tl = fresh_z3 "hd", fresh_z3 "tl" in
        (* split into a |-> hd and (a+1) |-> tl *)
        if is_valid_z3 heap (Z3.Boolean.mk_eq z3_ctx l a) then
          let a_1 = z3_inc z3_ctx a in
          let heap = PointsTo(a_1, tl) :: heap in
          go_wand_seg heap tl b (fun heap' -> k hd heap')
        else
          let heap = PointsTo(a, hd) :: heap in
          go_wand_seg heap tl b (fun heap' -> k tl heap')
    | [], _ ->
        (* we don't know for sure which it is... *)
        let all_addrs = List.concat_map (addrs_of_satom z3_ctx) heap in
        if is_valid_z3 heap (Z3.Boolean.mk_or z3_ctx (List.map (fun l' -> Z3.Boolean.mk_eq z3_ctx l l') all_addrs)) then
          (* ... but it's one of them? needs more case analysis *)
          raise (Incomplete "Requires too much case analysis")
        else
          (* ... because it's none of them. false *)
          raise (NotValid formula)
    | _ -> failwith "this case is impossible (bug in solver)" in

  let initial_env = M.empty in
  let initial_heap = [] in
  go initial_env initial_heap formula

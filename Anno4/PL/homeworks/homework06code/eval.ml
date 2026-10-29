open Ast
open Ast.Code

module IntMap = Map.Make(struct type t = int let compare = compare end)
module VarMap = Map.Make(struct type t = var let compare = compare end)

(* Interpreter exceptions *)
exception TestFailure of string
exception IllegalMemAccess of string
exception UnboundVariable of var

(* Stores, heaps, and configurations, oh my! *)
type store = int VarMap.t
type heap = int IntMap.t
type config = store * heap * com

(* Make a configuration *)
let make_configuration (c:com) : config =
  (VarMap.empty, IntMap.empty, c)

(* A function to look up the binding for a variable in a store. *)
(* lookup (s,x) returns s(x), or raises UnboundVariable if s is not defined on x. *)
let lookup (s,x) : int =
  match VarMap.find_opt x s with
  | None -> raise (UnboundVariable x)
  | Some v -> v

(* The evaluation function for commands. *)
let rec evalc (s,h,c) : store * heap =
  match c with
  | Skip ->
    (s, h)
  | Assign(x,a) ->
      let s' = VarMap.add x (evala (s,a)) s in (s', h)
  | Print(a) ->
    Printf.printf "%d\n" (evala (s,a));
    (s, h)
  | Test(i,b) ->
    if evalb(s,b) then (s, h)
    else raise (TestFailure(Pprint.strInfo i))
  | ReadMem(x, loc) ->
    let address = evala (s, loc) in
    (match IntMap.find_opt address h with
     | Some value -> (VarMap.add x value s, h)
     | None -> raise (IllegalMemAccess
         (Printf.sprintf "Read from unallocated location %d" address)))
  | WriteMem(loc, v) ->
    let address = evala (s, loc) in
    if not (IntMap.mem address h) then
      raise (IllegalMemAccess
        (Printf.sprintf "Write to unallocated location %d" address));
    let value = evala (s, v) in
    (s, IntMap.add address value h)
  | New(_, []) -> invalid_arg "new requires at least one expression"
  | New(x, expressions) ->
    let values = List.map (fun e -> evala (s, e)) expressions in
    let size = List.length values in
    (* Give the least positive base with enough consecutive free locations. *)
    let rec fresh address =
      if address > max_int - (size - 1) then
        raise (IllegalMemAccess "No contiguous block available for new");
      let rec free offset =
        offset = size ||
        (not (IntMap.mem (address + offset) h) && free (offset + 1)) in
      if free 0 then address
      else if address = max_int then
        raise (IllegalMemAccess "No contiguous block available for new")
      else fresh (address + 1) in
    let address = fresh 1 in
    let heap = List.fold_left (fun heap (offset, value) ->
      IntMap.add (address + offset) value heap) h
      (List.mapi (fun offset value -> offset, value) values) in
    (VarMap.add x address s, heap)
  | Free(count, loc) ->
    if count <= 0 then invalid_arg "free requires a positive count";
    let address = evala (s, loc) in
    let rec free offset heap =
      if offset = count then heap else
      let loc = address + offset in
      if not (IntMap.mem loc heap) then
        raise (IllegalMemAccess
          (Printf.sprintf "Free of unallocated location %d" loc));
      free (offset + 1) (IntMap.remove loc heap) in
    (s, free 0 h)
  | Seq(c1,_,c2) ->
    let (s',h') = evalc (s,h,c1) in
    evalc (s',h',c2)
  | If (b,c1,c2) ->
    if evalb (s,b) then
      evalc (s,h,c1)
    else
      evalc (s,h,c2)
  | While(b,_,c1) as c ->
    if evalb (s,b) then
      let (s',h') = evalc (s,h,c1) in
      evalc (s',h',c)
    else
      (s,h)

(* The evaluation function for arithmetic expressions. *)
and evala (s,a) : int =
  match a with
  | Int n -> n
  | Var x -> lookup (s,x)
  | Plus(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 + n2
  | Minus(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 - n2
  | Times(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 * n2

(* The evaluation function for boolean expressions. *)
and evalb (s,b) : bool =
  match b with
  | True ->
    true
  | False ->
    false
  | Equals(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 = n2
  | NotEquals(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 <> n2
  | Less(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 < n2
  | LessEq(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 <= n2
  | Greater(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 > n2
  | GreaterEq(a1,a2) ->
    let n1 = evala (s,a1) in
    let n2 = evala (s,a2) in
    n1 >= n2
  | Not b ->
    not (evalb (s,b))
  | And(b1,b2) ->
    let b1' = evalb (s,b1) in
    let b2' = evalb (s,b2) in
    b1' && b2'
  | Or(b1,b2) ->
    let b1' = evalb (s,b1) in
    let b2' = evalb (s,b2) in
    b1' || b2'

open Ast

(* Interpreter exceptions *)
exception TestFailure of string
exception UnboundVariable of var

(* A type for variables *)
type var = string

(* A type for stores *)
type store = (var * int) list

(* A type for configurations *)
type config = store * com

(* Make a configuration *)
let make_configuration (c:com) : config =
  ([],c)

(* A function to update the binding for x in store s. *)
(* update (s, x, v) returns the store s[x->v]. *)
let rec update (s, x, v) : store =
  match s with
  | [] ->
    [(x,v)]
  | (y,u)::t ->
    if x = y then (x,v)::t
    else (y,u)::update(t,x,v)

(* A function to lookip the binding for a variable in a store. *)
(* lookup (s,x) returns s(x) or UnboundVariable if s is not defined on s. *)
let rec lookup (s,x) : int =
  match s with
  | [] ->
    raise (UnboundVariable x)
  | (y,u)::t ->
    if x = y then u
    else lookup (t,x)

(* The evaluation function for commands. *)
let rec evalc (s,c) : store =
  match c with
  | Skip ->
    s
  | Assign(x,a) ->
    update(s,x,evala(s,a))
  | Print(a) ->
    Printf.printf "%d\n" (evala (s,a));
    s
  | Test(i,b) ->
    if evalb(s,b) then s
    else raise (TestFailure(Pprint.strInfo i))
  | Seq(c1,_,c2) ->
    let s1 = evalc (s,c1) in
    evalc (s1,c2)
  | If (b,c1,c2) ->
    if evalb (s,b) then
      evalc (s,c1)
    else
      evalc (s,c2)
  | While(b,_,c1) as c ->
    if evalb (s,b) then
      let s1 = evalc (s,c1) in
      evalc (s1,c)
    else
      s

(* The evaluation function for arithmetic expressions. *)
and evala (s,a) : int =
  match a with
  | Int n ->
    n
  | Var x ->
    lookup (s,x)
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

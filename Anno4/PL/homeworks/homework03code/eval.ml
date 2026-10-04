(* CS 4110 Homework 3
   This is the file where you'll do your work. Your job is to take an AST
   (which has already been parsed for you) and execute it. Exceptional
   conditions will arise in some cases, see `errors.ml` for the exceptions to
   `raise` when these happen. *)

open Ast
open Pprint
open Errors

module StringMap = Map.Make(String)

(* A type for stores. *)
type store = int StringMap.t

(* A type for configurations. *)
type configuration = store * com * com * (com * com) list

(* Create an initial configuration from a command. *)
let make_configuration (c:com) : configuration =
  (StringMap.empty, c, Skip, [])

(* Evaluate an arithmeic expression *)
let rec evala (st: store) (a: aexp) : int =
  match a with
  | Int n -> n
  | Var x -> 
      (match StringMap.find_opt x st with
       | Some v -> v
       | None -> raise (UnboundVariable x))
  | Plus (e1, e2) -> evala st e1 + evala st e2
  | Minus (e1, e2) -> evala st e1 - evala st e2
  | Times (e1, e2) -> evala st e1 * evala st e2
  | Input -> 
      print_string "> "; flush stdout;
      read_int ()

(* Evaluate a boolean expression *)
let rec evalb (st : store) (b : bexp) : bool =
  match b with
  | True -> true
  | False -> false
  | Equals (e1, e2) -> evala st e1 = evala st e2
  | NotEquals (e1, e2) -> evala st e1 <> evala st e2
  | Less (e1, e2) -> evala st e1 < evala st e2
  | LessEq (e1, e2) -> evala st e1 <= evala st e2
  | Greater (e1, e2) -> evala st e1 > evala st e2
  | GreaterEq (e1, e2) -> evala st e1 >= evala st e2
  | Not b1 -> not (evalb st b1)
  | And (b1, b2) -> 
      let eb1 = evalb st b1 and eb2 = evalb st b2 in
      eb1 && eb2
  | Or (b1, b2) -> 
      let eb1 = evalb st b1 and eb2 = evalb st b2 in
      eb1 || eb2

(* Evaluate a command. *)
let rec evalc (conf:configuration) : store =
  match conf with
  | (st, Skip, Skip, _) -> st
  | (st, Skip, c, k) -> evalc (st, c, Skip, k)
  
  | (st, Assign (x, e), c, k) -> 
      let v = evala st e in
      evalc (StringMap.add x v st, Skip, c, k)
      
  | (st, Seq (c1, c2), Skip, k) -> 
      evalc (st, c1, c2, k)
  | (st, Seq (c1, c2), c3, k) -> 
      evalc (st, c1, Seq (c2, c3), k)
      
  | (st, If (b, c1, c2), c3, k) ->
      if evalb st b then 
        evalc (st, c1, c3, k)
      else 
        evalc (st, c2, c3, k)

        
  | (st, While (b, c1), c2, k) ->
      if evalb st b then (
        match (c2, k) with
          | (Skip, (cb, cc)::k') -> evalc (st, c1, While (b, c1), k)
          | (_, _) -> evalc (st, c1, While (b, c1), (c2, (While (b, c1)))::k)
      )
      else (
        match (c2, k) with
          | (Skip, (cb, cc)::k') -> evalc (st, cb, Skip, k')
          | (_, _) ->  evalc (st, c2, Skip, k)
      )

  | (st, Print (a), c, k) ->
      let v = evala st a in
      Printf.printf "%d\n" v;
      evalc (st, Skip, c, k)

  | (st, Test (i, b), c, k) ->
      if evalb st b then
        evalc (st, Skip, c, k)
      else (
        pprintInfo i; 
        raise (TestFailure "idk")
      )

  | (st, Break, c, k) ->
      (match k with
        | [] -> raise IllegalBreak
        | (cb, cc)::k' ->
            evalc (st, cb, Skip, k')
      )

  | (st, Continue, c, k) ->
      (match k with
        | [] -> raise IllegalContinue
        | (cb, cc)::k' ->
            evalc (st, cc, Skip, k)
      )

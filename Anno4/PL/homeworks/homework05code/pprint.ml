open Ast

let rec pprintAexp a = print_string (strAexp a)

and pprintBexp b = print_string (strBexp b)

and pprintCom c = print_string (strCom(0, c))

and pprintInfo i = print_string(strInfo i)

and pprintLexp l = print_string (strLexp l)

and pprintSpec a = print_string (strSpec a)

and pprintAssn p = print_string (strAssn p)

and space n = if n = 0 then "" else " " ^ space(n-1)

and strAexp e = match e with
  | Int m ->
    string_of_int m
  | Var x ->
    x
  | Plus(a1, a2)  ->
    "(" ^ strAexp(a1) ^ " + " ^ strAexp(a2) ^ ")"
  | Minus(a1, a2) ->
    "(" ^ strAexp(a1) ^ " - " ^ strAexp(a2) ^ ")"
  | Times(a1, a2) ->
    "(" ^   strAexp(a1) ^ " * " ^ strAexp(a2) ^ ")"

and strBexp e = match e with
  | True -> "true"
  | False -> "false"
  | Equals(a1, a2) ->
    "(" ^ strAexp(a1) ^ " = " ^ strAexp(a2) ^ ")"
  | NotEquals(a1, a2) ->
    "(" ^ strAexp(a1) ^ " != " ^ strAexp(a2) ^ ")"
  | Less(a1, a2) ->
    "(" ^ strAexp(a1) ^ " < " ^ strAexp(a2) ^ ")"
  | LessEq(a1, a2) ->
    "(" ^ strAexp(a1) ^ " <= " ^ strAexp(a2) ^ ")"
  | Greater(a1, a2) ->
    "(" ^ strAexp(a1) ^ " > " ^ strAexp(a2) ^ ")"
  | GreaterEq(a1, a2) ->
    "(" ^ strAexp(a1) ^ " >= " ^ strAexp(a2) ^ ")"
  | Not(b) ->
    "not " ^ strBexp(b)
  | And(b1, b2) ->
    "(" ^ strBexp(b1) ^ " and " ^ strBexp(b2) ^ ")"
  | Or(b1, b2) ->
    "(" ^ strBexp(b1) ^ " or " ^ strBexp(b2) ^ ")"

and strCom(n, c) =
  match c with
  | Skip ->
    space n ^ "skip"
  | Print(a) ->
    space n ^ "print " ^ strAexp (a)
  | Test(_,b) ->
    space n ^ "test " ^ strBexp (b)
  | Assign(x,a) ->
    space n ^ x ^ " := " ^ strAexp (a)
  | Seq(c1,None,c2) ->
    strCom (n, c1) ^ ";\n" ^
    strCom (n, c2)
  | Seq(c1,Some p,c2) ->
    strCom (n, c1) ^ ";\n" ^
    space n ^ strSpec p ^ "\n" ^
    strCom (n, c2)
  | If(b, c1, c2) ->
    space (n) ^ "if " ^ strBexp(b) ^ " then {\n" ^
    strCom (n+2, c1) ^ "\n" ^
    space (n) ^ "} else {\n" ^
    strCom (n+2, c2) ^ "\n" ^
    space(n) ^ "}"
  | While(b,s,c) ->
    space n ^ "while " ^ strBexp(b) ^ " do \n" ^
    space (n+2) ^ strSpec s ^ "\n" ^
    space n ^ "{\n" ^
    strCom (n+2,c) ^ "\n" ^
    space n ^ "}"

and strSpec a =
  "@ " ^ strAssn a ^ " @"

and strAssn p =
  match p with
    | ATrue ->
      "true"
    | AFalse ->
      "false"
    | AEquals(l1,l2) ->
      "(" ^ strLexp l1 ^ " = " ^ strLexp l2 ^ ")"
    | ANotEquals(l1,l2) ->
      "(" ^ strLexp l1 ^ " != " ^ strLexp l2 ^ ")"
    | ALess(l1,l2) ->
      "(" ^ strLexp l1 ^ " < " ^ strLexp l2 ^ ")"
    | ALessEq(l1,l2) ->
      "(" ^ strLexp l1 ^ " <= " ^ strLexp l2 ^ ")"
    | AGreater(l1,l2) ->
      "(" ^ strLexp l1 ^ " > " ^ strLexp l2 ^ ")"
    | AGreaterEq(l1,l2) ->
      "(" ^ strLexp l1 ^ " >= " ^ strLexp l2 ^ ")"
    | AAnd(p1,p2) ->
      "(" ^ strAssn p1 ^ " and " ^ strAssn p2 ^ ")"
    | AOr(p1,p2) ->
      "(" ^ strAssn p1 ^ " or " ^ strAssn p2 ^ ")"
    | ANot(p1) ->
      "(not " ^ strAssn p1 ^ ")"
    | AImplies(p1,p2) ->
      "(" ^ strAssn p1 ^ " -> " ^ strAssn p2 ^ ")"
    | AForall(i,p1) ->
      "forall $" ^ i ^ " (" ^ strAssn p1 ^ ")"
    | AExists(i,p1) ->
      "exists $" ^ i ^ " (" ^ strAssn p1 ^ ")"

and strLexp l = match l with
  | LInt m ->
    string_of_int m
  | LPVar x ->
    x
  | LLVar i ->
    "$" ^ i
  | LPlus(l1,l2)  ->
    "(" ^ strLexp l1  ^ " + " ^ strLexp l2 ^ ")"
  | LMinus(l1,l2) ->
    "(" ^ strLexp l1 ^ " - " ^ strLexp l2 ^ ")"
  | LTimes(l1,l2) ->
    "(" ^ strLexp l1 ^ " * " ^ strLexp l2 ^ ")"

and strInfo ((l1,c1),(l2,c2)) =
  if l2=l1
  then Printf.sprintf "line %d, characters %d-%d" l1 c1 c2
  else Printf.sprintf "line %d, character %d, to line %d, character %d" l1 c1 l2 c2

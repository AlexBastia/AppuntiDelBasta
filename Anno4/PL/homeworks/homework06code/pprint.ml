let space n = String.make n ' '

let strInfo ((l1, c1), (l2, c2)) =
  if l2 = l1 then
    Printf.sprintf "line %d, characters %d-%d" l1 c1 c2
  else
    Printf.sprintf "line %d, character %d, to line %d, character %d"
      l1 c1 l2 c2

let pprintInfo i = print_string (strInfo i)

module Logic = struct
  open Ast.Logic

  let rec strLexp = function
    | Int n -> string_of_int n
    | PVar x -> x
    | LVar x -> "$" ^ x
    | Plus (l, r) -> "(" ^ strLexp l ^ " + " ^ strLexp r ^ ")"
    | Minus (l, r) -> "(" ^ strLexp l ^ " - " ^ strLexp r ^ ")"
    | Times (l, r) -> "(" ^ strLexp l ^ " * " ^ strLexp r ^ ")"

  let rec strPureAssn = function
    | True -> "true"
    | False -> "false"
    | Equals (l, r) -> "(" ^ strLexp l ^ " = " ^ strLexp r ^ ")"
    | NotEquals (l, r) -> "(" ^ strLexp l ^ " != " ^ strLexp r ^ ")"
    | Less (l, r) -> "(" ^ strLexp l ^ " < " ^ strLexp r ^ ")"
    | LessEq (l, r) -> "(" ^ strLexp l ^ " <= " ^ strLexp r ^ ")"
    | Greater (l, r) -> "(" ^ strLexp l ^ " > " ^ strLexp r ^ ")"
    | GreaterEq (l, r) -> "(" ^ strLexp l ^ " >= " ^ strLexp r ^ ")"
    | And (p, q) -> "(" ^ strPureAssn p ^ " and " ^ strPureAssn q ^ ")"
    | Or (p, q) -> "(" ^ strPureAssn p ^ " or " ^ strPureAssn q ^ ")"
    | Not p -> "(not " ^ strPureAssn p ^ ")"

  let strHeapAtom = function
    | PointsTo (l, v) -> strLexp l ^ " |-> " ^ strLexp v
    | PointsToSomething l -> strLexp l ^ " |-> _"
    | ListSeg (l, r) -> "lseg(" ^ strLexp l ^ ", " ^ strLexp r ^ ")"

  let strAssn ((phi, atoms):assn) =
    match atoms with
    | [] -> strPureAssn phi
    | _ ->
        let heap = String.concat " * " (List.map strHeapAtom atoms) in
        (* true describes emp, so it is the identity for separating conjunction. *)
        if phi = True then heap else strPureAssn phi ^ " * " ^ heap

  let strSpec a = "@ " ^ strAssn a ^ " @"

  (* Formulas are solver output, rather than source-level annotations. *)
  let rec strFormula = function
    | Assn a -> strAssn a
    | LogicalAnd (p, q) -> "(" ^ strFormula p ^ " && " ^ strFormula q ^ ")"
    | LogicalImplies (p, q) ->
        "(" ^ strPureAssn p ^ " implies " ^ strFormula q ^ ")"
    | Star (h, p) -> "((" ^ strAssn h ^ ") * " ^ strFormula p ^ ")"
    | MagicWand (h, p) -> "((" ^ strAssn h ^ ") -* " ^ strFormula p ^ ")"
    | Forall (x, p) -> "forall $" ^ x ^ " (" ^ strFormula p ^ ")"
    | Exists (x, p) -> "exists $" ^ x ^ " (" ^ strFormula p ^ ")"

  let pprintLexp l = print_string (strLexp l)
  let pprintPureAssn p = print_string (strPureAssn p)
  let pprintHeapAtom a = print_string (strHeapAtom a)
  let pprintAssn a = print_string (strAssn a)
  let pprintSpec a = print_string (strSpec a)
  let pprintFormula p = print_string (strFormula p)
end

module Code = struct
  open Ast.Code

  let rec strAexp = function
    | Int n -> string_of_int n
    | Var x -> x
    | Plus (l, r) -> "(" ^ strAexp l ^ " + " ^ strAexp r ^ ")"
    | Minus (l, r) -> "(" ^ strAexp l ^ " - " ^ strAexp r ^ ")"
    | Times (l, r) -> "(" ^ strAexp l ^ " * " ^ strAexp r ^ ")"

  let rec strBexp = function
    | True -> "true"
    | False -> "false"
    | Equals (l, r) -> "(" ^ strAexp l ^ " = " ^ strAexp r ^ ")"
    | NotEquals (l, r) -> "(" ^ strAexp l ^ " != " ^ strAexp r ^ ")"
    | Less (l, r) -> "(" ^ strAexp l ^ " < " ^ strAexp r ^ ")"
    | LessEq (l, r) -> "(" ^ strAexp l ^ " <= " ^ strAexp r ^ ")"
    | Greater (l, r) -> "(" ^ strAexp l ^ " > " ^ strAexp r ^ ")"
    | GreaterEq (l, r) -> "(" ^ strAexp l ^ " >= " ^ strAexp r ^ ")"
    | Not b -> "(not " ^ strBexp b ^ ")"
    | And (p, q) -> "(" ^ strBexp p ^ " and " ^ strBexp q ^ ")"
    | Or (p, q) -> "(" ^ strBexp p ^ " or " ^ strBexp q ^ ")"

  let rec strCom (n, c) = match c with
    | Skip -> space n ^ "skip"
    | Print a -> space n ^ "print " ^ strAexp a
    | Test (_, b) -> space n ^ "test " ^ strBexp b
    | Assign (x, a) -> space n ^ x ^ " := " ^ strAexp a
    | ReadMem (x, a) -> space n ^ x ^ " := *" ^ strAexp a
    | WriteMem (x, a) -> space n ^ "*" ^ strAexp x ^ " := " ^ strAexp a
    | New (x, values) ->
        space n ^ x ^ " := new(" ^ String.concat ", " (List.map strAexp values) ^ ")"
    | Free (count, address) ->
        space n ^ "free(" ^ string_of_int count ^ ", " ^ strAexp address ^ ")"
    | Seq (c1, a, c2) ->
        let annotation = match a with
          | None -> ""
          | Some a -> space n ^ Logic.strSpec a ^ "\n" in
        strCom (n, c1) ^ ";\n" ^ annotation ^ strCom (n, c2)
    | If (b, c1, c2) ->
        space n ^ "if " ^ strBexp b ^ " then {\n" ^
        strCom (n + 2, c1) ^ "\n" ^ space n ^ "} else {\n" ^
        strCom (n + 2, c2) ^ "\n" ^ space n ^ "}"
    | While (b, a, c) ->
        space n ^ "while " ^ strBexp b ^ " do\n" ^
        space (n + 2) ^ Logic.strSpec a ^ "\n" ^ space n ^ "{\n" ^
        strCom (n + 2, c) ^ "\n" ^ space n ^ "}"

  let pprintAexp a = print_string (strAexp a)
  let pprintBexp b = print_string (strBexp b)
  let pprintCom c = print_string (strCom (0, c))
end

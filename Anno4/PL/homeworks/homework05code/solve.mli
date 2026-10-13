(* Check the validity of assertions using Z3. *)

(* `valid p` returns `Some true` if `p` is valid, `Some false` if it is not,
 * and `None` if Z3 cannot decide within the time limit (e.g., because of use
 * of nonlinear arithmetic or quantifiers). *)
val valid : Ast.assn -> bool option

(* Print out the SMT-LIB form of an assertion, for debugging. *)
val smtlib_of_assn : Ast.assn -> string

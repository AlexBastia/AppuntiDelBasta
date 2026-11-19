(* The built-in constants: the unit type, which has one element, and the
   empty type, which has none. They are declared in the language itself. *)

let source = {|

axiom unit : Type 0
axiom tt : unit

axiom empty : Type 0

|}

open Ast.Logic

(** This exception is thrown when the formula isn't of a form that could be
    verified, and indicates a bug in the caller of assert_valid. *)
exception Malformed of formula

(** This exception is thrown when the solver is not advanced enough to know
    whether it is valid or not.

    For instance, to verify

      @ (x = z or y = z) * x |-> 1 * y |-> 1 @  w := *z  @ (w = 1) * x |-> 1 * y |-> 1 @

    the solver would need to split into the two cases based on whether x=z or
    y=z to find the cell that z points to, which it doesn't (currently) do.
    It also raises this exception when it cannot show that it is safe to
    append two list segments.
    *)
exception Incomplete of string

(** This exception is thrown when the formula cannot be guaranteed to be
    valid. *)
exception NotValid of formula

val assert_valid : formula -> unit


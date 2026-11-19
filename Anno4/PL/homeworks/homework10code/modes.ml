open Ast

(* The definitions of equality that the type checker can use. The
   definition is chosen with the --equal flag; the default is beta.

   A definition has two parts. The first is used to find the shape of a
   type: with alpha, a type is a function type only if it literally is one,
   but with beta and eta, it may also compute to one. The
   second decides whether two expressions are equal. *)
let versions :
  (string * ((signature -> exp -> exp) * (signature -> exp -> exp -> bool))) list = [
  ("alpha", ((fun _ e -> e), Equality.equal_alpha));
  ("beta", (Equality.normalize, Equality.equal_beta));
  ("eta", (Equality.normalize, Equality.equal_eta));
]

let current = ref "beta"

(* Compute a type, as far as the current definition of equality allows. *)
let compute (sg : signature) (e : exp) : exp =
  fst (List.assoc !current versions) sg e

(* Are two expressions definitionally equal? *)
let equal (sg : signature) (e1 : exp) (e2 : exp) : bool =
  snd (List.assoc !current versions) sg e1 e2

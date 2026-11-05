(* Church numerals: convert 2 + 1 to an integer. *)
(lambda succ : (forall X . (X -> X) -> X -> X) -> (forall X . (X -> X) -> X -> X) .
  (succ (Lambda X . lambda f : X -> X . lambda x : X . f (f x))) [Int] (lambda n : Int . n + 1) 0)
(lambda n : forall X . (X -> X) -> X -> X . Lambda X . lambda f : X -> X . lambda x : X . f (n [X] f x))

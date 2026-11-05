(* x has the outer X, so this is not of type forall X. X -> forall X. X *)
(lambda f : forall X . X -> (forall X . X) . 0) (Lambda X . lambda x : X . Lambda X . x)

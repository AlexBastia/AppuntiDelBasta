(lambda twice:(forall A. (A -> A) -> A -> A).
  if twice [Bool] (lambda b:Bool. if b then false else true) true then
    twice [Int] (lambda n:Int. n + 1) 0 
  else 0
)
(Lambda A. lambda f:A -> A. lambda x:A. f (f x))

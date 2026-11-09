(lambda k:(forall A. forall B. A -> B -> A).
  k [Int] [Bool] 1 true
)
(Lambda B. Lambda A. lambda p:B. lambda q:A. p)

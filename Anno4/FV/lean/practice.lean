-- Instead of writing a binary predicate P(x,y) we write (P x y)
-- Here, (P : A → A → Prop) where Prop denotes truth values (propositions).
-- Propositions can be true or false and we use them as in propositional logic.

theorem pxpx1 {A: Type} (P: A → Prop) (x: A):
        (P x) →  (P x) := by
  intro h
  exact h

-- proof of implication remains a function,
-- it's just that its type P x has free variables
theorem pxpx2 {A: Type} (P: A → Prop) (x: A):
        (P x) →  (P x) :=
  fun (px : P x) => px

-- The proof of  (∀ x:A, F x) is a function
--  fun (x:A) => ... that returns a proof of F x.
theorem apxpx1 {A: Type} (F: A → Prop):
        ∀ x, ((F x) →  (F x)) := by
  intro x
  intro h
  exact h

theorem apxpx2 {A: Type} (F: A → Prop):
        ∀ x, ((F x) →  (F x)) :=
  fun (x : A) =>
    fun (fx : F x) => fx

theorem distAll {A: Type} (F G : A → Prop):
       (∀ x, F x ∧ G x) → ((∀ x, G x) ∧ (∀ x, F x)) := by
  intro hx
  refine ⟨ ?_, ?_⟩
  · intro x
    exact (hx x).right
  · intro x
    exact (hx x).left

/- Proof for an existential (∃ x:A, F x) has
     a specific x1:A and the proof of F x1 -/

theorem exP {A : Type} (x1: A) (F : A → Prop) (h: F x1):
    ∃ x, F x :=
  ⟨ x1, h⟩

theorem distEx {A: Type} (F G : A → Prop):
       (∃ x, (F x ∨ G x)) → ((∃ x, G x) ∨ (∃ y, F y)) := by
  intro h
  obtain ⟨ x, hx ⟩ := h
  obtain h1 | h2 := hx
  · right
    exact ⟨ x, h1 ⟩
  · left
    exact ⟨ x, h2 ⟩

-- Greatest Common Divisor function

partial def gcd1 (a b : Nat) : Nat :=
  if a = 0 then b
  else
    let r := b % a
    gcd1 r a

#check gcd1 48 60
#check gcd1 60 48

-- We cannot prove this, because Lean does not allow reasoning about partial functions:
-- theorem gcdSym1 (x: Nat) (y: Nat) : gcd1 x y = gcd1 y x

-- Indeed, we could even define
partial def f (x: Nat) : Nat :=
  f x + 1

-- don't try this at home:
-- #eval (f 0)

/- Indeed, if we assumed equality
  f x = 1 + f x
 we would get
  0 = 1
-/

-- So to use function definitions, we prove termination!

-- useful fact about modulo
#check Nat.mod_lt
#check Nat.pos_of_ne_zero

def gcd2 (a b : Nat) : Nat :=
  if isZero: a = 0 then b
  else
    let r := b % a
    gcd2 r a
termination_by a
decreasing_by
  have aPos: 0 < a := Nat.pos_of_ne_zero isZero
  exact Nat.mod_lt b aPos
-- ignore the linter bug: https://github.com/leanprover/lean4/issues/2920

-- thanks to termination, we get a definitional equation:
#print gcd2.eq_def

-- fact from the library
theorem modLess {a b : Nat} (h : a < b) : a % b = a := Nat.mod_eq_of_lt h

-- when a<b small, then it's the remainder
theorem gcdSym2_swap (a: Nat) (b: Nat) (h: a < b) : gcd2 a b = gcd2 b a := by
  grind[gcd2.eq_def, modLess h]
-- grind is one of automated provers, good for prop equalities and linear equations.

-- Theorem: the order of args does not matter. Showcases proof by cases.
theorem gcdSym2 (a: Nat) (b: Nat) : gcd2 a b = gcd2 b a := by
  have : a < b ∨ a = b ∨ b < a := by simp[Nat.lt_trichotomy a b]
  obtain h | h | h := this
  · rw[gcdSym2_swap a b h]
  · rw[h]
  · rw [gcdSym2_swap b a h]

-- A lemma, we take it from the library
theorem divisionLemma {k m n : Nat} (h : k ∣ n) : k ∣ m % n ↔ k ∣ m := Nat.dvd_mod_iff h

/- Theorem: gcd divides each argument: showcases proof by stong induction.
   To type divisibility ∣ , write backslash and vertical bar together (not just |).
   The proof restates many statements unnecessarily in the proof,
   so that it is a bit easier to read. A compact proof is 5 lines but harder to follow.
   We avoid propositional reasoning and some equality reasoning using `grind` and `simp`.

   Forward reasoning: use what we know to derive new facts, stated using `have`.
   Backward reasoning: if the goal can be simplified, use `suffices` with a short proof that it suffices.
-/
theorem gcdDivides (a: Nat): ∀ (b : Nat), gcd2 a b ∣ a ∧ gcd2 a b ∣ b := by
  intro b
  induction a using Nat.strongRecOn with
  | ind n ih =>
    by_cases isZero : n = 0
    · simp[gcd2.eq_def, isZero]
    · sorry
#check Classical.em -- excluded middle

-- There is always a last user of AI: if that person uses AI, then all do.
theorem lastToUse1 {A: Type} [Inhabited A]
        (usesAI: A → Prop):
        ∃ x: A, (usesAI x → ∀ y, usesAI y) := by
  obtain h | h := Classical.em (∀ z : A, usesAI z)
  · refine ⟨ default, ?_ ⟩
    intro
    exact h
  · simp at h
    obtain ⟨ x, hx ⟩ := h
    refine ⟨ x, ?_ ⟩
    intro hnx
    contradiction



-- A notational variant of the previous proof
theorem lastToUse2 {A: Type} [Inhabited A]
        (usesAI: A → Prop):
        ∃ x: A, usesAI x → ∀ y, usesAI y := by
   sorry
-- Computation on natural numbers, Nat
-- One line comments start with --, multiple are within /- ... -/

#eval 100 + 3*7
#eval 100 / 3
#eval 100 % 3

def sum_of_squares (a b : Nat) : Nat :=
  a * a + b * b

#eval sum_of_squares 3 4

-- Functional programming: define lists and functions on them

inductive MyList (A: Type): Type where
  | nil : MyList A
  | cons (head : A) (tail : MyList A) : MyList A

open MyList

#check MyList.cons

-- putting a parameter in {...} makes Lean infer it when function is called
def len {A: Type} (lst: MyList A): Nat :=
  match lst with               -- match defines value by cases
  | .nil => 0                  -- base case
  | .cons _ tl => 1 + len tl  -- the recursive case

#eval len (cons (5 : Nat) (cons 2 (cons 100 nil)))

-- elements of `xs` followed by elements of `ys`
def append {A: Type} (xs ys : MyList A): MyList A :=
  match xs with
  | .nil => ys
  | .cons h t => cons h (append t ys)

#eval append (cons 1 (cons 2 nil)) (cons 50 (cons 60 (cons 70 nil)))

-- a theorem, named `appendMorph`. length of append is the sum of lengths
theorem appendMorph {A: Type} (xs ys : MyList A):  -- holds for arbitrary A,xs,ys
  len (append xs ys) = len xs + len ys := by -- theorem statement as an equality
  induction xs with
  | nil => simp[append, len]
  | cons head tail ih =>
    dsimp[append, len]
    simp[ih]
    grind

-- Higher order functions

def compose {A B C : Type} (f : A → B) (g : B → C) : A → C :=
  fun (a : A) =>
    g (f a)

-- Higher-order function map on lists

def map {A B : Type} (f: A → B) (lst: MyList A) : MyList B :=
  match lst with
  | .nil  => .nil
  | .cons hd tl => cons (f hd) (map f tl)

theorem mapKeepsLength {A B : Type} (as : MyList A) (f : A -> B) :
  len as = len (map f as) := by
  induction as with
  | nil => simp[len, map]
  | cons head tail ih =>
    dsimp[map, len]
    simp[ih]
theorem mapComp {A B C : Type} (f : A → B) (g : B → C) (lst : MyList A) :
    (map g (map f lst)) = map (fun a => g (f a)) lst := by
  induction lst with
  | nil => simp[map]
  | cons head tail ih =>
    dsimp[map]
    simp[ih]
-- This is a comment line. Ignored by Lean.

--  For arbitrary propositions p, q, r, this tautology holds.
-- Curly brace parameters will be inferred automatically.
theorem taut1 {p q r : Prop}: ((p → q) ∧ ((¬p) → r)) ↔ ((p ∧ q) ∨ (¬ p) ∧ r) := by
  grind
-- grind proves propositional tautologies automatically

-- The theorem is easy to prove if we do case analysis on p, then simplify.
-- use \ . to type the dots for case analysis. We use simplifier in both cases,
-- telling to use the assumption saying what the value of p is.
theorem taut2 {p q r : Prop}: ((p → q) ∧ ((¬p) → r)) ↔ ((p ∧ q) ∨ (¬ p) ∧ r) := by
  by_cases h : p
  · grind
  · simp[h]

-- When we have complex formulas, it can be useful to do propositional reasoning step by step.
-- For that it can be helpful to realize that implication is just a function.
-- An assumption is an argument to a function. Using a theorem with a given argument
-- means applying the function to that argument.
-- This theorem says that, if we assume p → q, p → (q → r), and r, then we can prove r.
theorem example1 {p q r: Prop}
    (pq_holds:  p → q)
    (pqr_holds: p → (q → r))
    (p_holds: p)              : r := by
  exact pqr_holds p_holds (pq_holds p_holds)

-- What we introduced by `have` is just an abbreviation, so we can write proof directly as one by expression
theorem example2 {p q r: Prop}
    (pq_holds:  (p → q))
    (pqr_holds: p → (q → r))
    (p_holds: p)              : r := by
  sorry

-- In fact, we can omit both by and exact, what Lean really needs is just that proof term:
theorem example3 {p q r: Prop}
    (pq_holds:  (p → q))
    (pqr_holds: p → (q → r))
    (p_holds: p)              : r := sorry

-- if the theorem is stated as an implication, `intro` command reduces it to previous case
theorem example4 {p q r: Prop}: (p → q) → ((p → (q → r)) → (p → r)) := by
  sorry

-- a proof for an implication is a function, so the proof for above is:
theorem example5 {p q r: Prop}: (p → q) → ((p → (q → r)) → (p → r)) :=
  sorry

theorem K (p q: Prop): p → (q → p) :=
  fun p =>
    fun q => p

theorem I (p: Prop): p → p :=
  fun p => p

#check And

-- A proof for a conjunction is just an angle bracket pair of proofs:
theorem example6 {p q: Prop} (p_holds: p) (q_holds: q): p ∧ q :=
  ⟨ p_holds, q_holds⟩

#check And

/-
structure And (a b : Prop) : Prop where
  left : a
  right : b
-/

-- Conjunction is a structure. Proof for conjunction proves each conjunct.
-- We can make and pattern match on such proofs using angle brackets
-- (as for all structure-s)
theorem example7 {p q: Prop}: p ∧ q → q ∧ p := by
  intro pq
  exact ⟨ pq.right, pq.left⟩

theorem example7b {p q: Prop}: p ∧ q → q ∧ p :=
  sorry

#check Or
/-
inductive Or (a b : Prop) : Prop where
  | inl (h : a) : Or a b
  | inr (h : b) : Or a b
-/

theorem or_commutes1 {a b: Prop}: (a ∨ b) → (b ∨ a) :=
  fun ab : a ∨ b =>
    match ab with
    | .inl ha => Or.inr ha
    | .inr hb => Or.inl hb

-- to analyze a hypothesis that is a disjunction, we can use rcases
theorem or_commutes2 {a b: Prop}: (a ∨ b) → (b ∨ a) := by
  intro ab
  obtain ha | hb := ab
  · right; assumption
  · left; assumption

-- disjunction is a tagged union. `left` says we will prove left disjunct
theorem hamlet {b: Prop}: (b ∨ ¬ b) := by
  by_cases h : b
  · left; exact h
  · right; exact h

theorem hamlet_in_old_English {b: Prop}: (b ∨ ¬ b) := by
  sorry

-- proof by cases on truth value is an if
theorem hamlet_in_logic {b: Prop}: (b ∨ ¬ b) :=
  let : Decidable b := Classical.propDecidable b
  if hb : b then Or.inl hb else Or.inr hb

/- False and Negation:
  False → p   for any p, proof is False.elim
  ¬ p is just (p → False)
-/

theorem contraExample {p q : Prop} : p → ¬ p → q :=
  fun hp : p =>
    fun hnp : ¬ p => (hnp hp).elim

-- intuitionistically valid direction follows from definitions of negation
theorem intuitionisticElim {p : Prop} : p → ¬ ¬ p :=
  fun hp : p =>
    fun hnp : ¬ p =>
    hnp hp

-- classical direction we just invoke from the library
theorem classicalElim {p : Prop} : ¬ ¬ p → p :=
  Classical.byContradiction

-- classical propositional reasoning can all be done using proof by cases
theorem contraPos {p q : Prop}: (¬ p → ¬ q) → (q → p) := by
  intro hn
  intro hq
  by_cases hp : p
  · assumption
  · have nq : ¬ q := hn hp
    contradiction

-- if you can't remember name of a propositional tautology
-- you can prove it by grind and use it where you need it
theorem deMorgan {x y : Prop} : (¬ (x ∧ y) = (¬ x ∨ ¬ y)) := by grind
abbrev Variable := String

inductive Formula: Type where
| Fvar (s : Variable)
| Fconst (b : Bool)
| Fand (left : Formula) (right : Formula)
| For  (left : Formula) (right : Formula)
| Fnot (left : Formula)

open Formula

def ex1 : Formula :=
   For (Fand (Fvar "p") (Fvar "q"))
       (Fnot (Fvar "p"))

abbrev Valuation := Variable → Bool

-- Bool is not a Prop, it is always a constant true or false
-- and its values true,false are never types of proof

def eval (f : Formula) (e : Valuation) : Bool :=
  match f with
  | Fvar s => e s
  | Fconst b => b
  | Fand l r => eval l e && eval r e
  | For  l r => eval l e || eval r e
  | Fnot g   => ! eval g e

-- Negation normal form

def negate (polarity : Bool) (f : Formula) : Formula :=
  match polarity with
  | true => f
  | false => Fnot f

theorem negEval (polarity : Bool) (f : Formula) (e : Valuation) :
    eval (negate polarity f) e = ((eval f e) = polarity) := by
  induction f with
  | Fvar s | Fconst b =>
    dsimp[negate, eval]
    by_cases hpol : polarity = true
    · simp[hpol, eval]
    · simp[hpol, eval]
  | Fand l r ihr ihl =>
    grind[negate, eval]
  | For l r ihl ihr => sorry
  | Fnot l ih => sorry

def nnf_with (polarity : Bool) (f : Formula) : Formula :=
  match f with
  | Fvar _ => negate polarity f
  | Fconst b => if polarity then Fconst b else Fconst (!b)
  | Fand l r => if polarity then
                  Fand (nnf_with polarity l) (nnf_with polarity r)
                else
                  For (nnf_with polarity l) (nnf_with polarity r)
  | For l r => if polarity then
                  For (nnf_with polarity l) (nnf_with polarity r)
               else
                  Fand (nnf_with polarity l) (nnf_with polarity r)
  | Fnot g => nnf_with (!polarity) g

theorem nnfw_eval (polarity : Bool) (f : Formula) (e : Valuation) :
    eval (nnf_with polarity f) e = ((eval f e) = polarity) := by
  sorry

def nnf (f : Formula) : Formula := nnf_with true f

theorem nnf_eval (f : Formula) (e : Valuation) :
    eval (nnf f) e = eval f e := by
  sorry

-- Substitution

def subst (f : Formula) (x : Variable) (t : Formula) : Formula :=
  match f with
  | Fvar s => if s = x then t else f
  | Fconst _ => f
  | Fand l r => Fand (subst l x t) (subst r x t)
  | For  l r => For (subst l x t) (subst r x t)
  | Fnot g   => Fnot (subst g x t)

def updatedV (e : Valuation) (x : Variable) (b : Bool) : Valuation :=
  fun (v : Variable) => if v = x then b else e v

theorem subst_lemma (f : Formula) (x : Variable) (t : Formula) (e : Valuation) :
    eval (subst f x t) e =
    eval f (updatedV e x (eval t e)) := by
  sorry
-- This example is used in Lecture 4 of CS-550
theorem runningExample {A: Type} -- domain
    -- signature:
    (a: A) (R : A → A → Prop) (P : A → Prop) (f : A → A → A)
    -- theorem hypotheses:
    (more:    ∀ x, ∃ y, R x y)
    (remains: ∀ x y, R x y → ∀ z, R x (f y z))
    (oneOf:   ∀ x, P x ∨ P (f x a)):
    -- theorem conclusion:
    ∀ x, ∃ y, R x y ∧ P y :=
  sorry

namespace CS550MasterExamExercises

/- EPFL CS-550: Master's Level Software Verification and Automated Reasoning
   Advanced Exam Preparation Exercises (Lean 4)
   Topics:
   1. Advanced First-Order Logic & Classical Reasoning
   2. Program Verification & Loop-Free Relational Reasoning
   3. QBF Structural Properties & Substitution Lemmas
-/

-- =========================================================================
-- Part 1: Advanced First-Order Logic & Classical Principles
-- =========================================================================

namespace FOLAdvanced

/-- Exercise 1.2:
    Prove that a universal quantifier distributes over a conjunction,
    and conversely, establish the bidirectional equivalence. -/
theorem forall_and_distrib {A: Type} (F G : A → Prop) :
    (∀ x, F x ∧ G x) ↔ (∀ x, F x) ∧ (∀ x, G x) := by
  constructor
  · intro h
    refine ⟨ ?_, ?_ ⟩
    · intro x
      exact (h x).left
    · intro x
      exact (h x).right
  · intro h
    intro x
    refine ⟨ ?_, ?_ ⟩
    · exact h.left x
    · exact h.right x


end FOLAdvanced


-- =========================================================================
-- Part 2: Program Verification & Relational Hoare Triples
-- =========================================================================

namespace ProgramVerif

/-- Consider a tiny imperative language with assignments and conditional choices. -/
inductive Cmd (Var : Type) where
| assign (v : Var) (val : Int)
| choice (c1 c2 : Cmd Var)

abbrev State (Var : Type) := Var → Int

/-- Relational semantics for commands: relates input state to output state. -/
def exec {Var : Type} [DecidableEq Var] (c : Cmd Var) : State Var → State Var → Prop :=
  match c with
  | .assign v n => fun s s' => s' = fun w => if w = v then n else s w
  | .choice c1 c2 => fun s s' => exec c1 s s' ∨ exec c2 s s'

/-- Exercise 2.1:
    Prove that if a command is a non-deterministic choice (`choice c1 c2`),
    any postcondition satisfied by both branches individually is satisfied
    by the choice command. -/
theorem choice_soundness {Var : Type} [DecidableEq Var]
    (c1 c2 : Cmd Var) (P : State Var → State Var → Prop)
    (h1 : ∀ s s', exec c1 s s' → P s s')
    (h2 : ∀ s s', exec c2 s s' → P s s') :
    ∀ s s', exec (.choice c1 c2) s s' → P s s' := by
  intro s s'
  grind[exec]

end ProgramVerif


-- =========================================================================
-- Part 3: QBF Structural Properties and Variable Shadowing
-- =========================================================================

namespace QBFAdvanced

inductive QBF (Var : Type) : Type where
| var (s : Var)
| const (b : Bool)
| al (v: Var) (g : QBF Var)
| ex (v: Var) (g : QBF Var)
| and (l r : QBF Var)
| or  (l r : QBF Var)
| not (g : QBF Var)

def qbf_depth {Var : Type} (f : QBF Var) : Nat :=
  match f with
  | .var _ | .const _ => 0
  | .al _ g | .ex _ g | .not g => 1 + qbf_depth g
  | .and l r | .or l r => 1 + max (qbf_depth l) (qbf_depth r)

/-- Exercise 3.1:
    Define a structural transformation function that pushes all negations inward
    across quantifiers (dualizing quantifiers: ¬∀x. g ≡ ∃x. ¬g, etc.)
    and prove that the depth of the transformed formula satisfies a strict bound
    relative to the original formula. -/
def push_neg {Var : Type} (f : QBF Var) : QBF Var :=
  match f with
  | .var s => .var s
  | .const b => .const (!b)
  | .al v g => .ex v (push_neg g)
  | .ex v g => .al v (push_neg g)
  | .and l r => .or (push_neg l) (push_neg r)
  | .or l r => .and (push_neg l) (push_neg r)
  | .not g => g

theorem push_neg_depth_bound {Var : Type} (f : QBF Var) :
    qbf_depth (push_neg f) ≤ qbf_depth f := by
  induction f <;> grind[qbf_depth, push_neg]

end QBFAdvanced

end CS550MasterExamExercises

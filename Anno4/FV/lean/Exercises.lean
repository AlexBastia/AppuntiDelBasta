/-
  CS-550 Lean practice exam (unofficial). Replace every `sorry`.
  Suggested time: ~2h. Try without looking at Solutions.lean.
  Style rules as in the course: grind for equalities/propositional/linear
  arithmetic (tell it which definitions to unfold and which IH to use),
  explicit `match`/induction, term-mode or tactic proofs for logic.
-/

/-! ======================================================
    PART 1. Functional programming and induction (lists, trees)
    ====================================================== -/

inductive MyList (A: Type): Type where
  | nil : MyList A
  | cons (head : A) (tail : MyList A) : MyList A

open MyList

def len {A: Type} (lst: MyList A): Nat :=
  match lst with
  | .nil => 0
  | .cons _ tl => 1 + len tl

def append {A: Type} (xs ys : MyList A): MyList A :=
  match xs with
  | .nil => ys
  | .cons h t => cons h (append t ys)

def map {A B : Type} (f: A → B) (lst: MyList A) : MyList B :=
  match lst with
  | .nil  => .nil
  | .cons hd tl => cons (f hd) (map f tl)

-- given (proved in the lecture)
theorem appendMorph {A: Type} (xs ys : MyList A):
  len (append xs ys) = len xs + len ys := by
  match xs with
  | .nil => grind [append, len]
  | .cons h t => grind [appendMorph t ys, append, len]

-- 1.1 Define the sum of a list of naturals.
def mySum (lst : MyList Nat) : Nat :=
  match lst with
  | .nil => 0
  | .cons head tail => head + mySum tail

-- 1.2 Prove it. (Which function definitions must grind unfold?)
theorem mySum_append (xs ys : MyList Nat) :
    mySum (append xs ys) = mySum xs + mySum ys := by
    induction xs with
    | nil => grind[append, mySum]
    | cons head tail ih => grind[append, mySum]
-- 1.3 Append with nil on the right, and associativity.
theorem appendNil {A : Type} (xs : MyList A) : append xs nil = xs := by
  induction xs with
  | nil => grind[append]
  | cons head tail ih => grind[append]

theorem appendAssoc {A : Type} (xs ys zs : MyList A) :
    append (append xs ys) zs = append xs (append ys zs) := by
  induction xs <;> grind[append]

-- 1.4 Naive reverse. Define it using `append` (append the head at the END).
def rev {A : Type} (xs : MyList A) : MyList A :=
  match xs with
  | .nil => .nil
  | .cons head tail => append (rev tail) (.cons head .nil)

theorem len_append {A : Type} (xs ys : MyList A) : len (append xs ys) = len xs + len ys := by
  induction xs <;> grind[append, len]

theorem len_rev {A : Type} (xs : MyList A) : len (rev xs) = len xs := by
  induction xs with
  | nil => grind[len, rev]
  | cons head tail ih => grind[len, rev, len_append]


theorem revAppend {A : Type} (xs ys : MyList A) :
    rev (append xs ys) = append (rev ys) (rev xs) := by
  induction xs with
  | nil =>
    grind[append, rev, appendNil]
  | cons head tail ih =>
    grind[append, rev, appendAssoc]

theorem revRev {A : Type} (xs : MyList A) : rev (rev xs) = xs := by
  induction xs with
  | nil => simp[rev]
  | cons tail head ih =>
    dsimp[rev]
    simp[revAppend, ih, rev, append]

-- 1.6 map distributes over append
theorem mapAppend {A B : Type} (f : A → B) (xs ys : MyList A) :
    map f (append xs ys) = append (map f xs) (map f ys) := by
  induction xs <;> grind[map, append]

-- 1.7 Binary trees
inductive BTree (A : Type) : Type where
  | leaf : BTree A
  | node (l : BTree A) (v : A) (r : BTree A) : BTree A

-- number of nodes
def tsize {A : Type} (t : BTree A) : Nat :=
  match t with
  | .leaf => 0
  | .node l _ r => 1 + tsize l + tsize r

-- swap left and right everywhere
def mirror {A : Type} (t : BTree A) : BTree A :=
  match t with
  | .leaf => .leaf
  | .node l v r => .node (mirror r) v (mirror l)

theorem tsize_mirror {A : Type} (t : BTree A) : tsize (mirror t) = tsize t := by
  induction t <;> grind[mirror, tsize]

theorem mirror_mirror {A : Type} (t : BTree A) : mirror (mirror t) = t := by
  induction t <;> grind[mirror]

-- in-order traversal: left subtree, then value, then right subtree
def inorder {A : Type} (t : BTree A) : MyList A :=
  match t with
  | .leaf => .nil
  | .node l v r => append (inorder l) (.cons v (inorder r))

theorem len_inorder {A : Type} (t : BTree A) : len (inorder t) = tsize t := by
  induction t with
  | leaf =>
    simp[inorder, len, tsize]
  | node l v r ih1 ih2 =>
    dsimp[inorder, tsize]
    grind[len_append, append, len]

/-! ======================================================
    PART 2. Propositional logic
    ====================================================== -/

-- 2.1 by grind
theorem peirce {p q : Prop} : ((p → q) → p) → p := by
  grind

theorem transitivity_implies {p q r : Prop} (pq : p → q) (qr : q → r) : p → r := by grind

-- 2.2 term mode (fun ... => ...), no tactics
theorem compose' {p q r : Prop} : (p → q) → (q → r) → (p → r) :=
  fun pq : p → q =>
    fun qr : q → r =>
      transitivity_implies pq qr

-- 2.3 term mode
theorem contra1 {p q : Prop} : (p → q) → (¬ q → ¬ p) :=
  fun pq : p → q =>
    fun nq : ¬ q => compose' pq nq

-- 2.4 tactics: intro, rcases, left/right, exact. Do NOT use grind.
theorem distrib {p q r : Prop} : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  intro h
  obtain ⟨ hp, hqr ⟩ := h
  obtain hq | hr := hqr
  · left; exact ⟨ hp, hq ⟩
  · right; exact ⟨ hp, hr ⟩

-- 2.5 tactics, no grind
theorem orElim' {p q r : Prop} (h : p ∨ q) (hp : p → r) (hq : q → r) : r := by
  obtain hpp | hqq := h
  · exact hp hpp
  · exact hq hqq

-- 2.6 classical, tactics: by_cases
theorem notImp {p q : Prop} : ¬ (p → q) → (p ∧ ¬ q) := by
  intro hnpq
  by_cases hpnq : p ∧ ¬ q
  · assumption
  · simp at hpnq
    contradiction

-- 2.7 disjunctive syllogism
theorem dsyl {p q : Prop} : ((p ∨ q) ∧ ¬ p) → q := by
  intro ⟨ hpq, hnp ⟩
  obtain hp | hq := hpq
  · contradiction
  · assumption

/-! ======================================================
    PART 3. First-order logic
    ====================================================== -/

-- 3.1
theorem allAnd {A : Type} (P Q : A → Prop) :
    (∀ x, P x ∧ Q x) ↔ ((∀ x, P x) ∧ (∀ x, Q x)) := by
  constructor
  · intro h
    refine ⟨ ?_, ?_ ⟩
    · intro x
      exact (h x).left
    · intro x
      exact (h x).right
  · intro ⟨ hp, hq ⟩
    intro x
    exact ⟨ hp x, hq x⟩

-- 3.2
theorem exAnd {A : Type} (P Q : A → Prop) :
    (∃ x, P x ∧ Q x) → ((∃ x, P x) ∧ (∃ x, Q x)) := by
  intro h
  obtain ⟨ x, hp, hq ⟩ := h
  exact ⟨ ⟨ x, hp ⟩ , ⟨ x, hq ⟩ ⟩

-- 3.3 The converse of 3.2 is FALSE. Prove that, for A := Bool,
-- P x := (x = true), Q x := (x = false).
theorem exAnd_converse_false :
    ¬ (((∃ x : Bool, x = true) ∧ (∃ x : Bool, x = false)) →
        ∃ x : Bool, x = true ∧ x = false) := by
  intro h
  obtain ⟨ hx, ⟨h1, h2 ⟩ ⟩ := h ⟨⟨true, rfl⟩, ⟨ false, rfl⟩⟩
  contradiction



-- 3.4
theorem allImpEx {A : Type} (P Q : A → Prop)
    (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  intro hp
  obtain ⟨ x, hpx ⟩ := hp
  exact ⟨ x, h x hpx⟩

-- 3.5 quantifier swap (one direction only is valid)
theorem exAllSwap {A : Type} (R : A → A → Prop) :
    (∃ x, ∀ y, R x y) → ∀ y, ∃ x, R x y := by
  intro h
  intro y
  obtain ⟨ x, hfy⟩ := h
  exact ⟨ x, (hfy y)⟩

-- 3.6 classical
theorem notAllEx {A : Type} (P : A → Prop) :
    ¬ (∀ x, P x) → ∃ x, ¬ P x := by
  intro h
  simp at h
  assumption

-- 3.7 Similar to the "last user" / drinker proof: case analysis + default.
theorem someoneWitnesses {A : Type} [Inhabited A] (P : A → Prop) :
    ∃ x : A, (∃ y, P y) → P x := by
  by_cases hx : ∃x : A, P x
  · obtain ⟨ x, px ⟩ := hx
    refine ⟨ x, ?_ ⟩
    intro
    assumption
  · simp at hx
    refine ⟨ default, ?_⟩
    intro ⟨ y, hy ⟩
    exact absurd hy (hx y)

-- 3.8 Lecture-4 style. Prove in TERM MODE (fun, let ⟨..⟩ := .., match .. with, suffices).
theorem fol_running {A : Type} (R : A → A → Prop) (P Q : A → Prop)
    (more:    ∀ x, ∃ y, R x y)
    (pstays:  ∀ x y, R x y → P x → P y)
    (qp:      ∀ x y, R x y → Q x → P y)
    (pq:      ∀ x, P x ∨ Q x) :
    ∀ x, ∃ y, R x y ∧ P y := by sorry

/-! ======================================================
    PART 4. Syntax and semantics of propositional formulas
    ====================================================== -/

abbrev Variable := String

inductive Formula: Type where
| Fvar (s : Variable)
| Fconst (b : Bool)
| Fand (left : Formula) (right : Formula)
| For  (left : Formula) (right : Formula)
| Fnot (left : Formula)

open Formula

abbrev Valuation := Variable → Bool

def eval (f : Formula) (e : Valuation) : Bool :=
  match f with
  | Fvar s => e s
  | Fconst b => b
  | Fand l r => eval l e && eval r e
  | For  l r => eval l e || eval r e
  | Fnot g   => ! eval g e

def subst (f : Formula) (x : Variable) (t : Formula) : Formula :=
  match f with
  | Fvar s => if s = x then t else f
  | Fconst _ => f
  | Fand l r => Fand (subst l x t) (subst r x t)
  | For  l r => For (subst l x t) (subst r x t)
  | Fnot g   => Fnot (subst g x t)

-- 4.1 Number of nodes of the formula tree.
def fsize (f : Formula) : Nat :=
  sorry

theorem fsize_pos (f : Formula) : 1 ≤ fsize f := by
  sorry

-- 4.2 Substitution never makes a formula smaller.
theorem fsize_subst (f : Formula) (x : Variable) (t : Formula) :
    fsize f ≤ fsize (subst f x t) := by
  sorry

-- 4.3 Substituting a variable by itself does nothing.
theorem subst_self (f : Formula) (x : Variable) : subst f x (Fvar x) = f := by
  sorry

-- 4.4 Exclusive or, as a derived connective
def Fxor (a b : Formula) : Formula :=
  sorry

theorem eval_xor (a b : Formula) (e : Valuation) :
    eval (Fxor a b) e = xor (eval a e) (eval b e) := by
  sorry

-- 4.5 Dual: swap ∧/∨ and flip constants, keep variables and negations.
def dual (f : Formula) : Formula :=
  sorry

-- Evaluating the dual under the complemented valuation gives the negation.
theorem eval_dual (f : Formula) (e : Valuation) :
    eval (dual f) e = ! (eval f (fun v => ! e v)) := by
  sorry

/-! ======================================================
    PART 5. Termination and well-founded recursion
    ====================================================== -/

-- 5.1 Number of binary digits of n (with numBits 0 = 1).
-- Define it by recursion on n / 2 and prove termination.
def numBits (n : Nat) : Nat :=
  if h : n < 2 then 1
  else 1 + numBits (n / 2)
termination_by n
decreasing_by
  sorry

-- 5.2 strong induction
theorem numBits_le (n : Nat) : numBits n ≤ n + 1 := by
  sorry

-- 5.3 A variant of Euclid's algorithm (recursion on the SECOND argument).
def gcd3 (a b : Nat) : Nat :=
  if h : b = 0 then a
  else gcd3 b (a % b)
termination_by b
decreasing_by
  sorry

theorem divisionLemma {k m n : Nat} (h : k ∣ n) : k ∣ m % n ↔ k ∣ m := Nat.dvd_mod_iff h

-- 5.4 gcd3 a 0 = a
theorem gcd3_zero (a : Nat) : gcd3 a 0 = a := by
  sorry

-- 5.5 Strong induction on b (note the order of quantifiers!).
-- Why can't you state this theorem for a `partial def` version of gcd3?
theorem gcd3Divides (b : Nat) : ∀ (a : Nat), gcd3 a b ∣ a ∧ gcd3 a b ∣ b := by
  sorry

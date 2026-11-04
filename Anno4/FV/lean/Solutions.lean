/-
  Solutions to Exercises.lean.
  NOTE: written without access to a Lean compiler. If a `grind` call fails,
  add the missing instance of an IH / lemma / definition to its list --
  that is exactly the debugging you may need in the exam.
-/

/-! ======================= PART 1 ======================= -/

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

theorem appendMorph {A: Type} (xs ys : MyList A):
  len (append xs ys) = len xs + len ys := by
  match xs with
  | .nil => grind [append, len]
  | .cons h t => grind [appendMorph t ys, append, len]

-- 1.1
def mySum (lst : MyList Nat) : Nat :=
  match lst with
  | .nil => 0
  | .cons h t => h + mySum t

-- 1.2
theorem mySum_append (xs ys : MyList Nat) :
    mySum (append xs ys) = mySum xs + mySum ys := by
  match xs with
  | .nil => grind [append, mySum]
  | .cons h t =>
    let IH := mySum_append t ys
    grind [append, mySum]

-- 1.3
theorem appendNil {A : Type} (xs : MyList A) : append xs nil = xs := by
  match xs with
  | .nil => grind [append]
  | .cons h t =>
    let IH := appendNil t
    grind [append]

theorem appendAssoc {A : Type} (xs ys zs : MyList A) :
    append (append xs ys) zs = append xs (append ys zs) := by
  match xs with
  | .nil => grind [append]
  | .cons h t =>
    let IH := appendAssoc t ys zs
    grind [append]

-- 1.4
def rev {A : Type} (xs : MyList A) : MyList A :=
  match xs with
  | .nil => .nil
  | .cons h t => append (rev t) (cons h nil)

theorem len_rev {A : Type} (xs : MyList A) : len (rev xs) = len xs := by
  match xs with
  | .nil => grind [rev, len]
  | .cons h t =>
    let IH := len_rev t
    let M := appendMorph (rev t) (cons h nil)
    grind [rev, len]

-- 1.5
theorem revAppend {A : Type} (xs ys : MyList A) :
    rev (append xs ys) = append (rev ys) (rev xs) := by
  match xs with
  | .nil =>
    let N := appendNil (rev ys)
    grind [rev, append]
  | .cons h t =>
    let IH := revAppend t ys
    let As := appendAssoc (rev ys) (rev t) (cons h nil)
    grind [rev, append]

theorem revRev {A : Type} (xs : MyList A) : rev (rev xs) = xs := by
  match xs with
  | .nil => grind [rev]
  | .cons h t =>
    let IH := revRev t
    let RA := revAppend (rev t) (cons h nil)
    grind [rev, append]

-- 1.6
theorem mapAppend {A B : Type} (f : A → B) (xs ys : MyList A) :
    map f (append xs ys) = append (map f xs) (map f ys) := by
  match xs with
  | .nil => grind [map, append]
  | .cons h t =>
    let IH := mapAppend f t ys
    grind [map, append]

-- 1.7
inductive BTree (A : Type) : Type where
  | leaf : BTree A
  | node (l : BTree A) (v : A) (r : BTree A) : BTree A

def tsize {A : Type} (t : BTree A) : Nat :=
  match t with
  | .leaf => 0
  | .node l _ r => 1 + tsize l + tsize r

def mirror {A : Type} (t : BTree A) : BTree A :=
  match t with
  | .leaf => .leaf
  | .node l v r => .node (mirror r) v (mirror l)

theorem tsize_mirror {A : Type} (t : BTree A) : tsize (mirror t) = tsize t := by
  match t with
  | .leaf => grind [mirror, tsize]
  | .node l v r =>
    let IHl := tsize_mirror l
    let IHr := tsize_mirror r
    grind [mirror, tsize]

theorem mirror_mirror {A : Type} (t : BTree A) : mirror (mirror t) = t := by
  match t with
  | .leaf => grind [mirror]
  | .node l v r =>
    let IHl := mirror_mirror l
    let IHr := mirror_mirror r
    grind [mirror]

def inorder {A : Type} (t : BTree A) : MyList A :=
  match t with
  | .leaf => .nil
  | .node l v r => append (inorder l) (cons v (inorder r))

theorem len_inorder {A : Type} (t : BTree A) : len (inorder t) = tsize t := by
  match t with
  | .leaf => grind [inorder, len, tsize]
  | .node l v r =>
    let IHl := len_inorder l
    let IHr := len_inorder r
    let M := appendMorph (inorder l) (cons v (inorder r))
    grind [inorder, len, tsize]

/-! ======================= PART 2 ======================= -/

theorem peirce {p q : Prop} : ((p → q) → p) → p := by grind

theorem compose' {p q r : Prop} : (p → q) → (q → r) → (p → r) :=
  fun f g x => g (f x)

theorem contra1 {p q : Prop} : (p → q) → (¬ q → ¬ p) :=
  fun hpq hnq hp => hnq (hpq hp)

theorem distrib {p q r : Prop} : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  intro h
  let ⟨hp, hqr⟩ := h
  rcases hqr with hq | hr
  · left
    exact ⟨hp, hq⟩
  · right
    exact ⟨hp, hr⟩

theorem orElim' {p q r : Prop} (h : p ∨ q) (hp : p → r) (hq : q → r) : r := by
  rcases h with h1 | h2
  · exact hp h1
  · exact hq h2

theorem notImp {p q : Prop} : ¬ (p → q) → (p ∧ ¬ q) := by
  intro h
  by_cases hq : q
  · exact (h (fun _ => hq)).elim
  · by_cases hp : p
    · exact ⟨hp, hq⟩
    · exact (h (fun hp' => (hp hp').elim)).elim

theorem dsyl {p q : Prop} : ((p ∨ q) ∧ ¬ p) → q := by
  intro h
  let ⟨hpq, hnp⟩ := h
  rcases hpq with hp | hq
  · exact (hnp hp).elim
  · exact hq

/-! ======================= PART 3 ======================= -/

theorem allAnd {A : Type} (P Q : A → Prop) :
    (∀ x, P x ∧ Q x) ↔ ((∀ x, P x) ∧ (∀ x, Q x)) := by
  constructor
  · intro h
    exact ⟨fun x => (h x).1, fun x => (h x).2⟩
  · intro h
    let ⟨hp, hq⟩ := h
    intro x
    exact ⟨hp x, hq x⟩

theorem exAnd {A : Type} (P Q : A → Prop) :
    (∃ x, P x ∧ Q x) → ((∃ x, P x) ∧ (∃ x, Q x)) := by
  intro h
  let ⟨x, hx⟩ := h
  exact ⟨⟨x, hx.1⟩, ⟨x, hx.2⟩⟩

theorem exAnd_converse_false :
    ¬ (((∃ x : Bool, x = true) ∧ (∃ x : Bool, x = false)) →
        ∃ x : Bool, x = true ∧ x = false) := by
  intro h
  let ⟨x, hx1, hx2⟩ := h ⟨⟨true, rfl⟩, ⟨false, rfl⟩⟩
  -- hx1 : x = true, hx2 : x = false
  exact absurd (hx1.symm.trans hx2) (by decide)

theorem allImpEx {A : Type} (P Q : A → Prop)
    (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  intro hex
  let ⟨x, hx⟩ := hex
  exact ⟨x, h x hx⟩

theorem exAllSwap {A : Type} (R : A → A → Prop) :
    (∃ x, ∀ y, R x y) → ∀ y, ∃ x, R x y := by
  intro h
  let ⟨x, hx⟩ := h
  intro y
  exact ⟨x, hx y⟩

theorem notAllEx {A : Type} (P : A → Prop) :
    ¬ (∀ x, P x) → ∃ x, ¬ P x := by
  intro h
  by_contra hne
  apply h
  intro x
  by_contra hx
  exact hne ⟨x, hx⟩

theorem someoneWitnesses {A : Type} [Inhabited A] (P : A → Prop) :
    ∃ x : A, (∃ y, P y) → P x := by
  by_cases h : ∃ y, P y
  · let ⟨y, hy⟩ := h
    exact ⟨y, fun _ => hy⟩
  · exact ⟨default, fun h' => (h h').elim⟩

theorem fol_running {A : Type} (R : A → A → Prop) (P Q : A → Prop)
    (more:    ∀ x, ∃ y, R x y)
    (pstays:  ∀ x y, R x y → P x → P y)
    (qp:      ∀ x y, R x y → Q x → P y)
    (pq:      ∀ x, P x ∨ Q x) :
    ∀ x, ∃ y, R x y ∧ P y :=
  fun x =>
    let ⟨y, hxy⟩ := more x
    match pq x with
    | .inl hp => ⟨y, hxy, pstays x y hxy hp⟩
    | .inr hq => ⟨y, hxy, qp x y hxy hq⟩

/-! ======================= PART 4 ======================= -/

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

-- 4.1
def fsize (f : Formula) : Nat :=
  match f with
  | Fvar _ => 1
  | Fconst _ => 1
  | Fand l r => 1 + fsize l + fsize r
  | For l r => 1 + fsize l + fsize r
  | Fnot g => 1 + fsize g

theorem fsize_pos (f : Formula) : 1 ≤ fsize f := by
  match f with
  | Fvar _ => grind [fsize]
  | Fconst _ => grind [fsize]
  | Fand l r => grind [fsize]
  | For l r => grind [fsize]
  | Fnot g => grind [fsize]

-- 4.2
theorem fsize_subst (f : Formula) (x : Variable) (t : Formula) :
    fsize f ≤ fsize (subst f x t) := by
  match f with
  | Fvar s =>
    let P := fsize_pos t
    grind [subst, fsize]
  | Fconst _ => grind [subst, fsize]
  | Fand l r =>
    let IHl := fsize_subst l x t
    let IHr := fsize_subst r x t
    grind [subst, fsize]
  | For l r =>
    let IHl := fsize_subst l x t
    let IHr := fsize_subst r x t
    grind [subst, fsize]
  | Fnot g =>
    let IHg := fsize_subst g x t
    grind [subst, fsize]

-- 4.3
theorem subst_self (f : Formula) (x : Variable) : subst f x (Fvar x) = f := by
  match f with
  | Fvar s => grind [subst]
  | Fconst _ => grind [subst]
  | Fand l r =>
    let IHl := subst_self l x
    let IHr := subst_self r x
    grind [subst]
  | For l r =>
    let IHl := subst_self l x
    let IHr := subst_self r x
    grind [subst]
  | Fnot g =>
    let IHg := subst_self g x
    grind [subst]

-- 4.4
def Fxor (a b : Formula) : Formula :=
  For (Fand a (Fnot b)) (Fand (Fnot a) b)

theorem eval_xor (a b : Formula) (e : Valuation) :
    eval (Fxor a b) e = xor (eval a e) (eval b e) := by
  simp only [Fxor, eval]
  cases eval a e <;> cases eval b e <;> rfl
  -- alternative: grind [Fxor, eval]

-- 4.5
def dual (f : Formula) : Formula :=
  match f with
  | Fvar s => Fvar s
  | Fconst b => Fconst (!b)
  | Fand l r => For (dual l) (dual r)
  | For l r => Fand (dual l) (dual r)
  | Fnot g => Fnot (dual g)

theorem eval_dual (f : Formula) (e : Valuation) :
    eval (dual f) e = ! (eval f (fun v => ! e v)) := by
  match f with
  | Fvar s => grind [dual, eval]
  | Fconst b => grind [dual, eval]
  | Fand l r =>
    let IHl := eval_dual l e
    let IHr := eval_dual r e
    grind [dual, eval]
  | For l r =>
    let IHl := eval_dual l e
    let IHr := eval_dual r e
    grind [dual, eval]
  | Fnot g =>
    let IHg := eval_dual g e
    grind [dual, eval]

/-! ======================= PART 5 ======================= -/

def numBits (n : Nat) : Nat :=
  if h : n < 2 then 1
  else 1 + numBits (n / 2)
termination_by n
decreasing_by
  omega   -- context has h : ¬ n < 2, goal n / 2 < n

theorem numBits_le (n : Nat) : numBits n ≤ n + 1 := by
  induction n using Nat.strongRecOn with
  | ind n ih =>
    rw [numBits.eq_def]
    split
    · omega
    · have h2 : numBits (n / 2) ≤ n / 2 + 1 := ih (n / 2) (by omega)
      omega

def gcd3 (a b : Nat) : Nat :=
  if h : b = 0 then a
  else gcd3 b (a % b)
termination_by b
decreasing_by
  exact Nat.mod_lt a (Nat.pos_of_ne_zero h)

theorem divisionLemma {k m n : Nat} (h : k ∣ n) : k ∣ m % n ↔ k ∣ m := Nat.dvd_mod_iff h

theorem gcd3_zero (a : Nat) : gcd3 a 0 = a := by
  rw [gcd3.eq_def]
  simp

theorem gcd3Divides (b : Nat) : ∀ (a : Nat), gcd3 a b ∣ a ∧ gcd3 a b ∣ b := by
  induction b using Nat.strongRecOn with
  | ind b ih =>
    intro a
    by_cases hb : b = 0
    · subst hb
      rw [gcd3_zero]
      simp
    · have e : gcd3 a b = gcd3 b (a % b) := by grind [gcd3.eq_def]
      have hr : a % b < b := Nat.mod_lt a (Nat.pos_of_ne_zero hb)
      have ⟨h1, h2⟩ := ih (a % b) hr b
      -- h1 : gcd3 b (a % b) ∣ b,  h2 : gcd3 b (a % b) ∣ a % b
      have h3 : gcd3 b (a % b) ∣ a := (divisionLemma h1).mp h2
      rw [e]
      exact ⟨h3, h1⟩

/- 5.5 answer: a `partial def` is opaque to the logic (no equation lemmas),
   so nothing about its behaviour can be proved; `def` + termination proof
   gives gcd3.eq_def, which every proof above relies on. -/

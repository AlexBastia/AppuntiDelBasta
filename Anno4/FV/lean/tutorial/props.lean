variable (p q r : Prop)

example (hp : p) (hq : q) : p ∧ q := And.intro hp hq

#check fun (hp : p) (hq : q) => And.intro hp hq

example (h : p ∧ q) : p := h.left
example (h : p ∧ q) : q ∧ p := ⟨ h.right, h.left ⟩

example (h : p) : p ∨ q := Or.intro_left q h
example (h : p ∨ q) : q ∨ p :=
  h.elim (fun hp => Or.inr hp) (fun hq => Or.inl hq)

example (hpq : p → q) (hnq : ¬ q) : ¬ p :=
  (fun hp : p => show False from hnq (hpq hp))

example (hnp : ¬ p) (hq : q) (hqp : q → p) : r :=
  absurd (hqp hq) hnp


theorem and_swap : p ∧ q ↔ q ∧ p :=
  ⟨ fun h => ⟨ h.right, h.left⟩, fun h => ⟨ h.right, h.left⟩ ⟩

example (h : p ∧ q) : q ∧ p := (and_swap p q).mp h

example (α : Type) (p q : α → Prop) : (∀ x : α, p x ∧ q x) → ∀ y : α,p y :=
  fun h =>
  fun y : α => (h y).left

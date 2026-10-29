namespace UsingArithmetic

/- To illustrate linear integer arithmetic in Lean, prove the following theorem.
  You are allowed to use omega. Currently, this tactic does not solve arbitrary
  Presburger arithmetic formulas, so we suggest that you handle quantifiers and propositional
  structure yourself, as in the usual proofs in Lean, then try omega dnd grind when
  you feel that you need to use basic properties of integers.

  If you need to get a remainder, you can use the % operator.
  To type divisibility, you write `\|` or `\mid`.
  -/
theorem multipleOfThreeBetween :
    ∀ x y r : Int, ∃ z : Int,
      (5 ≤ r ∧ x + r ≤ y) → (x < z ∧ z < y ∧ 3 ∣ z) := by
  intro x y r
  have h : x % 3 = 0 ∨ x % 3 = 1 ∨ x % 3 = 2 := by omega
  rcases h with h | h | h
  · exact ⟨x + 3, by omega⟩ 
  · exact ⟨x + 2, by omega⟩ 
  · exact ⟨x + 1, by omega⟩ 
  
  

end UsingArithmetic

namespace ArithmeticFormula

/- Syntax and semantics of arithmetic formulas (not necessarily linear). -/

/-- integer-valued arithmetic term -/
inductive Term (Var : Type) where
/-- variable-/
| var   (v : Var)
/-- integer constant -/
| const (c : Int)
/-- expression `t1` + `t2`, addition of two terms -/
| plus  (t1 : Term Var) (t2 : Term Var)
/-- expression `t1` * `t2`, multiplication of two terms -/
| times (t1 : Term Var) (t2 : Term Var)
/-- expression `t1` / `t2`, division, rounded towards minus infinity -/
| div   (t1 : Term Var) (t2 : Term Var)
/-- expression `t1` % `t2`, remainder, always between 0 and the absolute value of t2 -/
| rem   (t1 : Term Var) (t2 : Term Var)

/-- arithmetic formula (possibly with quantifiers and division) -/
inductive Formula (Var : Type) where
/-- formula `t1` = `t2`, equality of integer-valued terms -/
| eq   (t1 t2 : Term Var)
/-- formula `t1` < `t2`, strictly less on integer-valued terms -/
| less (t1 t2 : Term Var)
/-- formula `t1` ≤ `t2`, less than or equal on integer-valued terms -/
| leq  (t1 t2 : Term Var)
/-- divisibility, same as `t1` % `t2` = 0 -/
| divisible (t1 t2 : Term Var)
/-- formula denoting ∀ `(v : Int)`, `g` -/
| al (v: Var) (g : Formula Var)
/-- formula denoting ∃ `(v : Int)`, `g` -/
| ex (v: Var) (g : Formula Var)
/-- conjunction, `left` ∧ `right` -/
| and (left right : Formula Var)
/-- disjunction, `left` ∨ `right` -/
| or  (left right : Formula Var)
/-- implication, `left` → `right` -/
| implies (left right : Formula Var)
/-- negation, ¬ `g` -/
| not (g : Formula Var)

/-- Translation of the statement of `multipleOfThreeBetween` into `Formula` with variables of type `String` -/
def exampleAbove: Formula String :=
  .al "x" (.al "y" (.al "r" (.ex "z"
    (.implies
      (.and
        (.leq (.const 5) (.var "r"))
        (.leq (.plus (.var "x") (.var "r")) (.var "y")))
      (.and
        (.less (.var "x") (.var "z"))
        (.and
          (.less (.var "z") (.var "y"))
          (.divisible (.var "z") (.const 3))))))))

abbrev Env (Var : Type) := Var → Int

def term_meaning {Var : Type} (t : Term Var) (e : Env Var) : Int :=
  match t with
  | .var v => e v
  | .const c => c
  | .plus t1 t2 => term_meaning t1 e + term_meaning t2 e
  | .times t1 t2 => term_meaning t1 e * term_meaning t2 e
  | .div t1 t2 => term_meaning t1 e / term_meaning t2 e
  | .rem t1 t2 => term_meaning t1 e % term_meaning t2 e

def updated_env {Var : Type} [DecidableEq Var]
  (e : Env Var) (v : Var) (x : Int) : Env Var :=
    fun w => if w = v then x else e w

def formula_meaning {Var : Type} [DecidableEq Var]
  (f : Formula Var) (e : Env Var) : Prop :=
  match f with
  | .eq t1 t2 => term_meaning t1 e = term_meaning t2 e
  | .less t1 t2 => term_meaning t1 e < term_meaning t2 e
  | .leq t1 t2 => term_meaning t1 e ≤ term_meaning t2 e
  | .divisible t1 t2 => term_meaning t1 e % term_meaning t2 e = 0
  | .al v g => ∀ n : Int, formula_meaning g (updated_env e v n)
  | .ex v g => ∃ n : Int, formula_meaning g (updated_env e v n)
  | .and left right => formula_meaning left e ∧ formula_meaning right e
  | .or left right => formula_meaning left e ∨ formula_meaning right e
  | .implies left right => formula_meaning left e → formula_meaning right e
  | .not g => ¬ formula_meaning g e


end ArithmeticFormula

namespace FormulaTransformations
open ArithmeticFormula

/-- removing implication from a formula by replacing it with negation and disjunction -/
def remove_implies {Var : Type} (f : Formula Var) : Formula Var :=
  match f with
  | .eq _ _ | .less _ _ | .leq _ _ | .divisible _ _ => f
  | .al v g => .al v (remove_implies g)
  | .ex v g => .ex v (remove_implies g)
  | .and left right => .and (remove_implies left) (remove_implies right)
  | .or left right => .or (remove_implies left) (remove_implies right)
  | .implies left right => .or (.not (remove_implies left)) (remove_implies right)
  | .not g => .not (remove_implies g)

/-- removing implication yields an equivalent formula -/
theorem remove_implies_sound {Var : Type} [DecidableEq Var] (f : Formula Var):
    formula_meaning (remove_implies f) = formula_meaning f := by
      funext e
      induction f generalizing e with
      | eq _ _ | less _ _ | leq _ _ | divisible _ _ => rfl
      | al v g ih | ex v g ih =>
        dsimp [remove_implies, formula_meaning]
        have h : ∀ n : Int, formula_meaning (remove_implies g) (updated_env e v n) = formula_meaning g (updated_env e v n) := by intro n; apply ih (updated_env e v n)
        simp [h]
      | and l r ihl ihr | or l r ihl ihr =>
        dsimp [remove_implies, formula_meaning]
        simp [ihl, ihr]
      | implies l r ihl ihr =>
        dsimp [remove_implies, formula_meaning]
        simp only [ihl, ihr]
        grind
      | not g ih =>
        dsimp [remove_implies, formula_meaning]
        simp [ih]

/-- in term `t` replace variable `v` by `vT` -/
def subst_term {Var : Type} [DecidableEq Var]
  (t : Term Var) (v : Var) (vT : Term Var) : Term Var :=
  match t with
  | .var s => if s = v then vT else t
  | .const c => .const c
  | .plus t1 t2 => .plus (subst_term t1 v vT) (subst_term t2 v vT)
  | .times t1 t2 => .times (subst_term t1 v vT) (subst_term t2 v vT)
  | .div t1 t2 => .div (subst_term t1 v vT) (subst_term t2 v vT)
  | .rem t1 t2 => .rem (subst_term t1 v vT) (subst_term t2 v vT)

/-- substituting a term vs updating an evaluation with its value -/
theorem subst_term_lemma {Var : Type} [DecidableEq Var]
  (t : Term Var) (v : Var) (vT : Term Var) (e : Env Var) :
  term_meaning (subst_term t v vT) e =
  term_meaning t (updated_env e v (term_meaning vT e)) := by
  induction t generalizing e with
  | var x =>
    by_cases h : x = v
    · dsimp [subst_term]
      simp [h]
      dsimp [term_meaning, updated_env]
      simp
    · dsimp [subst_term]
      simp [h]
      dsimp [term_meaning, updated_env]
      simp [h]
  | const c =>
    dsimp [subst_term, term_meaning]
  | plus t1 t2 ih1 ih2 | times t1 t2 ih1 ih2 | div t1 t2 ih1 ih2
  | rem t1 t2 ih1 ih2 => 
    dsimp [subst_term, term_meaning]
    simp [ih1,ih2]

/-- formula `f` is quantifier-free -/
def quantifier_free {Var : Type} (f : Formula Var) : Prop :=
  match f with
  | .eq _ _ | .less _ _ | .leq _ _ | .divisible _ _ => True
  | .al _ _ | .ex _ _ => False
  | .and left right | .or left right | .implies left right =>
     quantifier_free left ∧ quantifier_free right
  | .not g => quantifier_free g

/-- Substitute in a formula, stopping where `v` is bound.
For quantified formulas this can capture variables of `vT`; soundness below
is restricted to quantifier-free formulas. -/
def subst_formula {Var : Type} [DecidableEq Var]
  (f : Formula Var) (v : Var) (vT : Term Var) : Formula Var :=
  match f with
  | .eq t1 t2 => .eq (subst_term t1 v vT) (subst_term t2 v vT)
  | .less t1 t2 => .less (subst_term t1 v vT) (subst_term t2 v vT)
  | .leq t1 t2 => .leq (subst_term t1 v vT) (subst_term t2 v vT)
  | .divisible t1 t2 => .divisible (subst_term t1 v vT) (subst_term t2 v vT)
  | .al w g => if w = v then f else .al w (subst_formula g v vT)
  | .ex w g => if w = v then f else .ex w (subst_formula g v vT)
  | .and left right => .and (subst_formula left v vT) (subst_formula right v vT)
  | .or left right => .or (subst_formula left v vT) (subst_formula right v vT)
  | .implies left right => .implies (subst_formula left v vT) (subst_formula right v vT)
  | .not g => .not (subst_formula g v vT)

theorem subst_formula_lemma {Var : Type} [DecidableEq Var]
  (f : Formula Var) (v : Var) (vT : Term Var) (e : Env Var)
  (hf : quantifier_free f) :
  formula_meaning (subst_formula f v vT) e =
  formula_meaning f (updated_env e v (term_meaning vT e)) := by
  induction f generalizing e with
    | eq t1 t2 | less _ _ | leq _ _ | divisible _ _ =>
      dsimp [subst_formula, formula_meaning]
      simp [subst_term_lemma]
    | al x g ih | ex x g ih =>
      exact absurd hf (by simp[quantifier_free])
    | and l r ihl ihr | or l r ihl ihr | implies l r ihl ihr =>
      have qfl : quantifier_free l := by simp[quantifier_free] at hf; exact hf.left
      have qfr : quantifier_free r := by simp[quantifier_free] at hf; exact hf.right
      dsimp [subst_formula, formula_meaning]
      simp [ihl e qfl, ihr e qfr]
    | not g ih =>
      dsimp [subst_formula, formula_meaning]
      have qf : quantifier_free g := by simp[quantifier_free] at hf; exact hf
      simp [ih e qf]

/-- Whether a variable occurs in an arithmetic term. -/
def occurs_in_term {Var : Type} (x : Var) (t : Term Var) : Prop :=
  match t with
  | .var v => v = x
  | .const _ => False
  | .plus t1 t2 | .times t1 t2 | .div t1 t2 | .rem t1 t2 =>
    occurs_in_term x t1 ∨ occurs_in_term x t2

theorem term_meaning_updated_env {Var : Type} [DecidableEq Var]
  (t : Term Var) (x : Var) (e : Env Var) (n : Int)
  (hx : ¬ occurs_in_term x t) :
  term_meaning t (updated_env e x n) = term_meaning t e := by
  induction t generalizing e with
  | var v =>
    by_cases h : x = v
    · exact absurd hx (by simp[occurs_in_term, h])
    · simp[term_meaning, updated_env]
      intro hn
      exact absurd hn (by grind)
  | const c => dsimp[term_meaning]
  | plus t1 t2 ih1 ih2 | times t1 t2 ih1 ih2 | div t1 t2 ih1 ih2
  | rem t1 t2 ih1 ih2 =>
    dsimp[term_meaning]
    simp[occurs_in_term] at hx
    simp[ih1 e hx.left, ih2 e hx.right]


/-- Substitution rule soundness: (∃ x, x = t ∧ f) <-> f [x:=t],
provided x does not occur in t. -/
theorem onePoint {Var : Type} [DecidableEq Var]
  (x : Var) (t : Term Var) (f : Formula Var) (qff: quantifier_free f)
  (hx : ¬ occurs_in_term x t) :
  formula_meaning (.ex x (.and (.eq (.var x) t) f)) =
  formula_meaning (subst_formula f x t) := by
  funext e
  induction f generalizing e with
  | eq _ _ | less _ _ | leq _ _ | divisible _ _ =>
    dsimp[subst_formula, formula_meaning, term_meaning, updated_env]
    simp
    constructor
    · intro h
      obtain ⟨ n, neq, hn ⟩ := h
      rw[neq] at hn
      simp[term_meaning_updated_env t x e n hx] at hn
      simp[subst_term_lemma, hn]
    · intro h
      refine ⟨ (term_meaning t e), ?_⟩
      simp[term_meaning_updated_env t x e (term_meaning t e) hx]
      simp[subst_term_lemma] at h
      simp[h]     
  | al x g ih | ex x g ih => exact absurd qff (by simp[quantifier_free])
  | and l r ihl ihr =>
    dsimp[quantifier_free] at qff
    dsimp[subst_formula, formula_meaning]
    simp[<-ihl qff.left e, <-ihr qff.right]
    constructor
    · intro h
      obtain ⟨ n, hn ⟩ := h
      simp[term_meaning, updated_env] at hn
      obtain ⟨ neq, hl, hr ⟩ := hn
      dsimp[formula_meaning]
      refine ⟨ ?_, ?_ ⟩
      · refine ⟨ n, ?_ ⟩ 
        simp [term_meaning, updated_env, <-neq, hl]
      · refine ⟨ n, ?_ ⟩
        simp [term_meaning, updated_env, <-neq, hr]
    · intro h
      refine ⟨ (term_meaning t e), ?_ ⟩
      simp[term_meaning, updated_env, term_meaning_updated_env t x e (term_meaning t e) hx]
      refine ⟨ ?_, ?_ ⟩ 
      · simp [<-subst_formula_lemma l x t e qff.left,
        <-ihl qff.left e]
        exact h.left
      · simp [<-subst_formula_lemma r x t e qff.right,
        <-ihr qff.right e]
        exact h.right
  | or l r ihl ihr =>
    dsimp[quantifier_free] at qff
    dsimp[subst_formula, formula_meaning]
    simp[<-ihl qff.left e, <-ihr qff.right]
    constructor
    · intro h
      obtain ⟨ n, hn ⟩ := h
      simp[term_meaning, updated_env] at hn
      obtain ⟨ neq, hor ⟩ := hn
      dsimp[formula_meaning]
      obtain hl | hr := hor
      · left
        refine ⟨ n, ?_ ⟩ 
        simp [term_meaning, updated_env, <-neq, hl]
      · right 
        refine ⟨ n, ?_ ⟩
        simp [term_meaning, updated_env, <-neq, hr]
    · intro h
      refine ⟨ (term_meaning t e), ?_ ⟩
      simp[term_meaning, updated_env, term_meaning_updated_env t x e (term_meaning t e) hx]
      obtain hl | hr := h
      · left
        simp [<-subst_formula_lemma l x t e qff.left,
        <-ihl qff.left e]
        exact hl
      · right
        simp [<-subst_formula_lemma r x t e qff.right,
        <-ihr qff.right e]
        exact hr
  | implies l r ihl ihr =>
    simp [formula_meaning, term_meaning, updated_env]
    dsimp [quantifier_free] at qff
    constructor
    · intro h
      obtain ⟨ n, hn ⟩ := h
      obtain ⟨ hnl, hnr⟩ := hn
      have neq : n = term_meaning t e := by
        rw [hnl]
        simp[term_meaning_updated_env t x e n hx]
      simp [subst_formula, formula_meaning,
        subst_formula_lemma l x t e qff.left, subst_formula_lemma r x t e qff.right]
      rw[neq] at hnr
      exact hnr
    · intro h
      simp [subst_formula, formula_meaning] at h
      refine ⟨ (term_meaning t e), ?_⟩ 
      refine ⟨ ?_, ?_ ⟩
      · simp[term_meaning_updated_env t x e (term_meaning t e) hx]
      · simp[subst_formula_lemma l x t e qff.left,
              subst_formula_lemma r x t e qff.right] at h
        exact h 
  | not g ih =>
    dsimp[quantifier_free] at qff
    simp[formula_meaning, term_meaning, updated_env]
    constructor
    · intro h
      dsimp [subst_formula, formula_meaning]
      simp [<-ih qff e, formula_meaning, term_meaning, updated_env]
      intro x1
      intro h1
      rw [h1]
      simp [term_meaning_updated_env t x e x1 hx]
      obtain ⟨ n, hn ⟩ := h
      have ht : n = term_meaning t e := by
        rw[hn.left]
        simp[term_meaning_updated_env t x e n hx]
      rw [<-ht]
      exact hn.right
    · intro h
      refine ⟨ (term_meaning t e), ?_⟩
      refine ⟨ ?_, ?_ ⟩ 
      · simp [term_meaning_updated_env t x e (term_meaning t e) hx]
      · dsimp [subst_formula, formula_meaning] at h
        simp[<-subst_formula_lemma g x t e qff]
        exact h


def is_constant {Var : Type} (t : Term Var) : Prop :=
  match t with
  | .var _ => False
  | .const _ => True
  | .plus t1 t2 | .times t1 t2 | .div t1 t2 | .rem t1 t2 =>
    is_constant t1 ∧ is_constant t2

def is_affine_term {Var : Type} (t : Term Var) : Prop :=
  match t with
  | .var _ | .const _ => True
  | .plus t1 t2 => is_affine_term t1 ∧ is_affine_term t2
  | .times t1 t2 => (is_constant t1 ∧ is_affine_term t2) ∨ (is_affine_term t1 ∧ is_constant t2)
  | .div _ _ | .rem _ _ => is_constant t

theorem const_is_affine {Var : Type} (t : Term Var) (tc : is_constant t) : is_affine_term t := by
  induction t with
  | var _ | const _ =>
    simp [is_affine_term]
  | plus t1 t2 ih1 ih2 =>
    dsimp[is_constant] at tc
    dsimp[is_affine_term]
    refine ⟨ ?_, ?_ ⟩ 
    · apply ih1 tc.left
    · apply ih2 tc.right
  | times t1 t2 ih1 ih2=>
    dsimp[is_constant] at tc
    dsimp[is_affine_term]
    left
    refine ⟨ ?_, ?_ ⟩ 
    · exact tc.left
    · apply ih2 tc.right 
  | div t1 t2 ih1 ih2 | rem t1 t2 ih1 ih2 =>
    dsimp[is_constant] at tc
    dsimp[is_affine_term, is_constant]
    exact tc

/-- Rename term variables, possibly changing their type. -/
def renameTerm {A B : Type} (r : A → B) : Term A → Term B
  | .var v => .var (r v)
  | .const c => .const c
  | .plus a b => .plus (renameTerm r a) (renameTerm r b)
  | .times a b => .times (renameTerm r a) (renameTerm r b)
  | .div a b => .div (renameTerm r a) (renameTerm r b)
  | .rem a b => .rem (renameTerm r a) (renameTerm r b)

/-- Rename all formula variables, including quantifier binders.
Injectivity of the renaming ensures that distinct variables remain distinct. -/
def renameFormula {A B : Type} (r : A → B) : Formula A → Formula B
  | .eq a b => .eq (renameTerm r a) (renameTerm r b)
  | .less a b => .less (renameTerm r a) (renameTerm r b)
  | .leq a b => .leq (renameTerm r a) (renameTerm r b)
  | .divisible a b => .divisible (renameTerm r a) (renameTerm r b)
  | .al v g => .al (r v) (renameFormula r g)
  | .ex v g => .ex (r v) (renameFormula r g)
  | .and a b => .and (renameFormula r a) (renameFormula r b)
  | .or a b => .or (renameFormula r a) (renameFormula r b)
  | .implies a b => .implies (renameFormula r a) (renameFormula r b)
  | .not g => .not (renameFormula r g)

theorem renameTerm_meaning {A B : Type} (r : A → B) (t : Term A) (e : Env B) :
    term_meaning (renameTerm r t) e = term_meaning t (fun v => e (r v)) := by
  induction t generalizing e with
  | var v =>
    dsimp[renameTerm, term_meaning]
  | const c =>
    dsimp[renameTerm, term_meaning]
  | plus a b ih1 ih2 | times a b ih1 ih2 | div a b ih1 ih2 | rem a b ih1 ih2 =>
    dsimp[renameTerm, term_meaning]
    simp[ih1, ih2]

theorem update_function {A B : Type} [DecidableEq A] [DecidableEq B] (r : A -> B)
    (hr : Function.Injective r) (n : Int) (v : A) (e : Env B) :
    updated_env (fun v1 => e (r v1)) v n = fun v1 => updated_env e (r v) n (r v1) := by
      funext w
      simp [updated_env, hr.eq_iff]

theorem renameFormula_meaning {A B : Type} [DecidableEq A] [DecidableEq B]
    (r : A → B) (hr : Function.Injective r) (f : Formula A) (e : Env B) :
    formula_meaning (renameFormula r f) e =
      formula_meaning f (fun v => e (r v)) := by
  induction f generalizing e with  
  | eq a b =>
    dsimp[renameFormula, formula_meaning]
    simp[renameTerm_meaning]
  | less a b =>
    dsimp[renameFormula, formula_meaning]
    simp[renameTerm_meaning]
  | leq a b =>
    dsimp[renameFormula, formula_meaning]
    simp[renameTerm_meaning]
  | divisible a b =>
    dsimp[renameFormula, formula_meaning]
    simp[renameTerm_meaning]
  | al v g ih =>
    dsimp[renameFormula, formula_meaning]
    simp
    constructor
    · intro h
      intro n
      have he : formula_meaning (renameFormula r g) (updated_env e (r v) n) 
          = formula_meaning g fun v1 => ((updated_env e (r v) n) (r v1)) := by
            exact ih (updated_env e (r v) n)
      have hh : formula_meaning g fun v1 => updated_env e (r v) n (r v1) := by
        rw [<-he]
        exact h n
      rw [update_function r hr n v e]
      exact hh
      
    · intro h
      intro n
      rw [ih]
      rw [<-update_function r hr n v e]
      exact h n

  | ex v g ih =>
    dsimp[renameFormula, formula_meaning]
    simp
    constructor
    · intro h
      obtain ⟨ n, hn ⟩ := h
      refine ⟨ n, ?_ ⟩
      rw [ih (updated_env e (r v) n)] at hn
      rw [update_function r hr n v e]
      exact hn
    · intro h
      obtain ⟨ n, hn ⟩ := h
      refine ⟨ n, ?_ ⟩
      rw [ih, <-update_function r hr n v e]
      exact hn

  | and a b ihl ihr =>
    dsimp[renameFormula, formula_meaning]
    rw [ihl, ihr]
  | or a b ihl ihr =>
    dsimp[renameFormula, formula_meaning]
    rw [ihl, ihr]
  | implies a b ihl ihr =>
    dsimp[renameFormula, formula_meaning]
    rw [ihl, ihr]
  | not g ih =>
    dsimp[renameFormula, formula_meaning]
    rw [ih] 

/-- A finite conjunction, with true as the empty conjunction. -/
def allFormulas {V : Type} (fs : List (Formula V)) : Formula V :=
  fs.foldr .and (.eq (.const 0) (.const 0))

theorem allFormulas_meaning {V : Type} [DecidableEq V]
    (fs : List (Formula V)) (e : Env V) :
    formula_meaning (allFormulas fs) e ↔ ∀ f ∈ fs, formula_meaning f e := by
  induction fs with
  | nil =>
    simp[allFormulas, formula_meaning]
  | cons head tail ih =>
    dsimp[allFormulas, formula_meaning]
    constructor
    · intro ⟨ hl, hr⟩
      intro f
      intro fin
      have hi : f = head ∨ f ∈ tail := List.mem_cons.mp fin
      rcases hi with hf | hf
      · rw [hf]
        exact hl
      · suffices aft : formula_meaning (allFormulas tail) e by
          exact ih.mp aft f hf
        dsimp[allFormulas]
        exact hr
    · intro h
      refine ⟨ ?_, ?_ ⟩
      · exact h head (by simp)
      · suffices afi : ∀ (f : Formula V), f ∈ tail → formula_meaning f e by
          exact ih.mpr afi
        intro f
        intro l
        exact h f (by simp[l])
         

end FormulaTransformations

namespace ArithmeticPrograms
open ArithmeticFormula
open FormulaTransformations

inductive Program (Var : Type) where
| pAssign (v : Var) (t : Term Var)
| pIf  (f : Formula Var) (thenBranch : Program Var) (elseBranch : Program Var)
| pHavoc  (v : Var)
| pChoice (p1 p2 : Program Var)

/-- Relation describing a program relates initial environment to a final environment -/
abbrev ProgramRelation Var := Env Var → Env Var → Prop

/-- Relation associated with a given loop-free program -/
def rho {Var : Type} [DecidableEq Var] (p : Program Var) : ProgramRelation Var :=
  match p with
  | .pAssign v t => fun (e e' : Env Var) => e' = updated_env e v (term_meaning t e)
  | .pIf b p1 p2 => fun (e e' : Env Var) =>
      (formula_meaning b e ∧ rho p1 e e') ∨
      (¬ formula_meaning b e ∧ rho p2 e e')
  | .pHavoc v => fun (e e' : Env Var) => ∃ x : Int, e' = updated_env e v x
  | .pChoice p1 p2 => fun (e e' : Env Var) => rho p1 e e' ∨ rho p2 e e'

inductive MaybePrimed (Var : Type) where
-- initial state variable
| unprimed (v : Var)
-- final state variable
| primed (v : Var)
deriving DecidableEq

def env_sum {Var : Type} (e e' : Env Var) : Env (MaybePrimed Var) :=
  fun w => match w with
  | .unprimed v => e v
  | .primed v => e' v

def fix_other_vars {n : Nat} (v : Fin n) : Formula (MaybePrimed (Fin n)) :=
  allFormulas
    (((List.finRange n).filter (fun w => w != v)).map (fun w => 
      .eq (.var (MaybePrimed.unprimed w)) (.var (MaybePrimed.primed w)) ))

/-- Relate initial and final values, including preservation of untouched variables. -/
def R {n : Nat} (p : Program (Fin n)) : Formula (MaybePrimed (Fin n)) :=
  match p with
  | .pAssign v t => 
    -- v' = t and for all other w' = w
    .and (.eq (.var (.primed (v))) (renameTerm MaybePrimed.unprimed t))
        (fix_other_vars v)
  | .pIf b p1 p2 =>
    -- (b and R p1) or (!b and R p2)
    .or (.and (renameFormula MaybePrimed.unprimed b) (R p1))
        (.and (.not (renameFormula MaybePrimed.unprimed b)) (R p2))
  | .pHavoc v => 
    -- all other w' = w, don't include v
    fix_other_vars v
  | .pChoice p1 p2 =>
    -- R p1 or R p2
    .or (R p1) (R p2)

theorem R_correct {n : Nat} (p : Program (Fin n)) (e e' : Env (Fin n)) :
    formula_meaning (R p) (env_sum e e') = rho p e e' := by
  induction p with
  | pAssign v t =>
    dsimp[R, rho, formula_meaning, fix_other_vars]
    simp[renameTerm_meaning, allFormulas_meaning, formula_meaning, term_meaning, env_sum]
    constructor
    · intro ⟨ hv, hrest ⟩
      funext w
      by_cases hw : w = v
      · dsimp[updated_env]
        simp[hw, hv]
      · dsimp[updated_env]
        simp[hw, hrest w hw]
    · intro h
      rw [h]
      refine ⟨ ?_, ?_ ⟩
      · simp [updated_env]
      · intro a
        intro neq
        simp [updated_env]
        intro eq
        exact absurd eq neq
  | pIf f p1 p2 ih1 ih2 =>
    dsimp[R, rho, formula_meaning]
    have hr : Function.Injective (MaybePrimed.unprimed : Fin n -> MaybePrimed (Fin n)) := by
      intro a b h
      injection h
    simp[ih1, ih2, renameFormula_meaning (MaybePrimed.unprimed) hr, env_sum]
  | pHavoc v =>
    dsimp [R, rho, fix_other_vars]
    simp [allFormulas_meaning, formula_meaning, term_meaning, env_sum]
    constructor
    · intro h
      refine ⟨ e' v, ?_ ⟩
      funext w
      dsimp [updated_env]
      by_cases hw : w = v
      · simp[hw]
      · simp[hw]
        simp[h w hw]
    · intro h
      intro a
      intro neq
      obtain ⟨ x, hx⟩ := h
      rw [hx]
      simp[updated_env, neq]
  | pChoice p1 p2 ih1 ih2 =>
    dsimp[R, rho, formula_meaning]
    simp[ih1, ih2]

end ArithmeticPrograms

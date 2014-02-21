module Pi-ware where

open import Data.Vec using (Vec; head; map; foldr₁) renaming ([] to ε; _∷_ to _✧_)
open import Data.Nat using (suc)


data ℂ (α : Set) : Set where
    In  : α → ℂ α
    Not : ℂ α → ℂ α
    And : ∀ {n} → Vec (ℂ α) (suc n) → ℂ α
    Or  : ∀ {n} → Vec (ℂ α) (suc n) → ℂ α

open import Data.Bool using (Bool; _∧_; _∨_; not)
open import Function using (_∘_; _$_)

sampleNot : Bool → ℂ Bool
sampleNot = Not ∘ In

sampleAnd : Bool → Bool → ℂ Bool
sampleAnd a b = And (In a ✧ In b ✧ ε)

sampleXor : Bool → Bool → ℂ Bool
sampleXor a b = Or (notA ✧ notB ✧ ε)
    where notA = And (Not (In a) ✧ In b ✧ ε)
          notB = And (In a ✧ Not (In b) ✧ ε)

record Algℂ (α : Set) : Set where
    field
        aNot : α → α
        aAnd : ∀ {n} → Vec α (suc n) → α
        aOr  : ∀ {n} → Vec α (suc n) → α

eval : ∀ {α} → (ω : Algℂ α) → ℂ α → α
eval ω (In a)   = a
eval ω (Not c)  = (Algℂ.aNot ω) ((eval ω) c)
eval ω (And cs) = (Algℂ.aAnd ω) (map (eval ω) cs)
eval ω (Or cs)  = (Algℂ.aOr ω) (map (eval ω) cs)

evalBoolean : ℂ Bool → Bool
evalBoolean = eval (record {aNot = not;  aAnd = foldr₁ _∧_;  aOr = foldr₁ _∨_ })

evalXor : Bool → Bool → Bool
evalXor a b = evalBoolean (sampleXor a b)


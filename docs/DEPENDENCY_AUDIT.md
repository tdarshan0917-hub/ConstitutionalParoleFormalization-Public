# Dependency and Integrity Audit

**Toolchain:** Lean 4.35.0, pinned by `lean-toolchain`
**External Lean packages:** none
**Other project imports:** none

`ConstitutionalParole/Audit.lean` runs `#print axioms` over all 51 general and
example theorems. No project-defined or custom axiom appears. Proofs using Lean
simplification or decidable equality report only Lean’s standard logical
principles `propext` and, for the list-equality repair proof, `Quot.sound`.
Several trace, reassignment-integrity, and history theorems report no axioms at
all.

The integrity checker rejects:

- `sorry` or `admit` tokens in Lean source;
- custom `axiom` declarations;
- imports naming PPI, Protective Pathways, or Magnifica;
- missing required documentation;
- missing source identifiers or URLs in the claim ledger; and
- claim-mapped theorem names absent from Lean source.

Standard `propext` and `Quot.sound` are not custom project axioms. Their use is
recorded rather than concealed.

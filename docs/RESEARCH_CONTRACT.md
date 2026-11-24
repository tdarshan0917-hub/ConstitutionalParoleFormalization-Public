# Research Contract

## Question

Given a verified covered status, a verified requirement for a preliminary
revocation determination, stable decisionmaker identity, a role-history record,
and source-specific disqualifying involvement, can Lean establish a bounded
conflict with the modeled decisionmaker-separation obligation?

## Permitted conclusions

The project may establish:

- attachment or nonattachment under an expressly selected source predicate;
- a model-level conflict when every required premise is verified;
- compliance with the narrow actor-separation predicate when the role record is
  complete and the verified decisionmaker has no source-specific disqualifier;
- indeterminacy from missing/contradictory identity or contradictory evidence;
- displacement from an externally verified valid waiver;
- reachability of synthetic event traces; and
- prospective actor reassignment without changing evidence integrity;
- separately validated evidence completion while retaining earlier events.

## Prohibited conclusions

The project does not infer:

- that an actual parole decision violated a constitution or statute;
- that the entire preliminary hearing, final hearing, or revocation was lawful;
- waiver from silence, missing records, or nonappearance;
- bias from shared agency employment;
- facts from absence of evidence;
- harmlessness, cure, mootness, prejudice, damages, release, suppression, or any
  other remedy; or
- a predicted judicial outcome.

## Evidence contract

`verified` is an externally supplied model classification representing that an
upstream process reports the proposition resolved with actor identity, role,
matter, and time boundaries. Lean does not authenticate the source or prove
that the classification is deserved. `missing` and `contradictory` cannot
establish conflict or compliance. An incomplete role record can establish
conflict from an affirmative supplied disqualifying entry but cannot establish
compliance from absence. A contradictory record establishes neither.

## Source contract

Federal and New York predicates are separately sourced:

- `federalDisqualifyingRole`: reporting the violation or recommending
  revocation, drawn from `USSC-MORRISSEY-1972`, 408 U.S. at 485–86.
- `nyDisqualifyingRole`: prior supervisory involvement over the alleged
  violator, drawn from `NY-EXC-259I-REV-2025`, § 259-i(3)(c)(i).

No equivalence theorem connects these predicates.

## Acceptance criteria

Prototype 0.1 passes only if:

1. the pinned toolchain builds every production module;
2. the examples include conflict, compliance, indeterminate, nonattachment,
   displaced-stage, and repair cases;
3. federal and New York results demonstrably do not collapse into one rule;
4. earlier role/event history survives reassignment and validated evidence
   repair, while reassignment alone preserves the existing integrity state;
5. the dependency audit reports no project-defined axioms;
6. repository checks reject `sorry`, `admit`, custom `axiom` declarations,
   forbidden project imports, missing sources, and unmapped public theorems;
7. all examples are synthetic; and
8. documentation states that outputs are model classifications, not legal
   judgments or advice.

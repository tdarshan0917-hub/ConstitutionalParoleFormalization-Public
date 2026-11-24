# Countermodel Report

All actors and matters are synthetic.

## 1. Federal conflict

`federalConflictMatter` is a literal parole-revocation preliminary posture. The
verified decisionmaker is also the verified reporter and recommender. The role
record is complete. Lean computes `conflict` and separately constructs
`FederalConflictEstablished` from attachment, identity, record usability, and
the disqualifying role.

## 2. Different uninvolved decisionmaker

`federalCompliantMatter` retains the same agency and role history but assigns a
different identified officer with no reporting/recommendation event. Lean
computes narrow actor-separation compliance. This is nonvacuous evidence that
the model does not treat agency identity as personal involvement.

## 3. Missing and contradictory identity

`missingIdentityMatter` and `contradictoryIdentityMatter` both compute
`indeterminate`. Negative controls prove neither can compute `conflict`.
Therefore the engine cannot turn an identity gap into a violation claim.

## 4. Initial-release nonattachment

`initialReleaseMatter` preserves the actor configuration but changes legal
status to initial applicant. The narrow federal result is `notApplicable`, and
the negative control excludes `conflict`. This does not foreclose other rights;
it shows this revocation protection cannot be invoked from the wrong posture.

## 5. Verified waiver / displaced stage

`validWaiverMatter` supplies an externally verified `validlyWaived` value. The
result is `displaced`, not compliant or conflict. The example tests control
flow, not waiver validity; the latter remains a legal/evidentiary blocker.

## 6. Separate New York countermodel

`nyConflictMatter` uses conditional-release status and prior supervisory
involvement. It produces a New York statutory conflict while the deliberately
narrow literal-parole federal predicate is not applicable. Conversely, the
federal reporter/recommender example can be compliant under the modeled New
York actor rule. These two countermodels refute accidental source collapse.

## 7. Prospective repair — superseded semantics

The original `repairedMatter` semantics assigned record completeness during
actor replacement. Phase 5 removes that definition. The current model proves:

- reassignment preserves the existing integrity state;
- an incomplete reassigned record remains `indeterminate`;
- an unvalidated completion candidate changes nothing;
- a validated, complete, history-extending candidate can support narrow
  compliance under separate attachment, identity, and uninvolvement premises;
- the original conflict remains a separate auditable value; and
- the initial and repair event traces remain composable.

This is not a legal-cure theorem. It establishes only that a system can model a
prospective correction without falsifying its audit history.

## Failed model attempts rejected by design

- **Same agency therefore biased:** rejected; *Morrissey* permits an
  administrative decisionmaker and identifies personal involvement.
- **Missing identity therefore conflict:** rejected as indeterminate.
- **Initial denial plus adverse result therefore revocation conflict:** rejected
  for nonattachment.
- **Later repair erases earlier conflict:** rejected; append-only history keeps
  both states auditable.
- **Federal rule equals New York rule:** refuted by executable countermodels.

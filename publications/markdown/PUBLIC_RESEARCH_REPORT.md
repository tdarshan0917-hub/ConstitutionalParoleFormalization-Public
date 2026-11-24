# Independent Research Preprint — Not Peer-Reviewed

# When Is a Parole Decisionmaker Independent?

## A Lean 4 Study of Procedural Independence, Evidence Integrity, and Correction

**Public Research Report 1.0 | Independent research preprint | November 2026**

This report describes a bounded formal research project. It is not legal advice,
does not analyze a real parole matter, and does not determine that any person or
agency violated the Constitution or New York law.

## Research proposal and findings

### The question

Preliminary parole-revocation procedures can make the identity and prior role of
a decisionmaker legally material. This project asks:

> Under separately sourced federal and New York decisionmaker-independence
> rules, what classifications follow from explicit information about legal
> coverage, procedural stage, actor identity, prior roles, and record integrity?
> Can a later correction be represented without manufacturing evidence or
> deleting earlier role-event entries?

We translated a deliberately narrow part of two sources into a Lean 4 model:

- the preliminary-stage independence discussion in [*Morrissey v. Brewer*, 408
  U.S. 471, 480–87, especially 485–86
  (1972)](https://tile.loc.gov/storage-services/service/ll/usrep/usrep408/usrep408471/usrep408471.pdf);
  and
- the distinct hearing-officer language in [New York Executive Law
  §259-i(3)(c)(i)(A)–(B)](https://www.nysenate.gov/legislation/laws/EXC/259-I),
  on the official page displaying a revision dated May 16, 2025.

The federal and New York predicates are not treated as interchangeable. The
federal prototype covers literal parole and the express reporter/recommender
examples in *Morrissey*. The New York prototype covers the four release statuses
listed in the current statute and its prior-supervisory-involvement restriction.
Coverage alone does not establish that the preliminary stage is legally required
in a particular matter; stage attachment is supplied separately.

### Five machine-checked findings

1. Supplied reporter or recommender role entries can establish a bounded federal
   model conflict when all attachment and record premises hold; Lean does not
   authenticate the entries as actual involvement.
2. A supplied prior-supervision role entry can separately establish a bounded
   New York statutory model conflict under an externally interpreted,
   matter-specific relationship.
3. Missing or contradictory decisionmaker identity remains indeterminate; the
   model does not convert uncertainty into conflict or compliance.
4. Reassigning the decisionmaker cannot convert an incomplete record into a
   complete record.
5. A validated, complete, prefix-extending candidate record can support narrow
   prospective compliance. Earlier role-event entries remain a prefix, while
   the original and later matters remain separately available in the synthetic
   proof.

Formal verification means that a computer checks whether conclusions follow
from the definitions and premises written into the model. It does not prove that
the legal interpretation is uniquely correct or that factual premises from a
real proceeding are true.

## Why the distinctions matter

An administrative review system can become misleading if it reduces several
questions to one “independent decisionmaker” checkbox. At least three properties
must be kept distinct:

1. **Procedural independence:** does the identified actor have a role that the
   selected source treats as disqualifying?
2. **Evidence integrity:** is identity and role information sufficient for the
   proposed classification?
3. **Correction:** did a later action change the actor, repair the supplied
   record, or both—and were earlier role-event entries retained as a prefix?

These distinctions matter because changing an actor is not proof that missing
evidence has been found. Likewise, a complete later record does not itself prove
that an earlier problem was legally cured. The model makes those logical gaps
visible instead of filling them with assumptions.

## Finding 1 — The bounded federal independence conflict

### Everyday question

Can the same verified person report or recommend revocation and then make the
preliminary reasonable-ground decision?

### Source

In *Morrissey*, the Supreme Court described a preliminary inquiry after the
arrest and detention of a parolee. It required the reasonable-ground
determination to be made by someone not directly involved. The Court explained
that a parole officer other than the person who reported the alleged violations
or recommended revocation would be sufficient. 408 U.S. at 485–86. It did not
require the independent officer to be a judge or lawyer.

### Synthetic example

The synthetic record contains entries stating that Officer R reported an alleged
parole violation and recommended revocation. The same supplied record identifies
R as the preliminary decisionmaker. The model is also supplied with literal
parole status, a required preliminary stage, stable identity, usable role
entries, and an affirmative reporter/recommender entry. Lean does not
authenticate those entries as evidence that the events actually occurred.

### Verified result

`federal_verified_disqualifier_conflict` establishes both:

- `federalAssessment matter = .conflict`; and
- the independently structured proposition `FederalConflictEstablished matter`.

The synthetic theorems `verified_federal_disqualifying_involvement` and
`verified_federal_conflict_has_independent_structure` show that the result is
nonvacuous.

### Necessary assumptions

- Literal parole is the applicable status.
- The preliminary stage is required and not validly displaced.
- The decisionmaker’s identity is verified and stable.
- The record is not contradictory.
- A reporter or recommender role entry is affirmatively present in the supplied
  record and is treated as applicable to the modeled matter.

### Practical implication

A review tool should store actor identity and each source-relevant prior role as
separate, source-linked facts. It should not infer independence merely because
the actor works in a different unit or appears under a different title.

### Limitation

The reporter/recommender roles are a bounded representation of *Morrissey’s*
express examples. The model does not claim they exhaust every form of “direct
involvement.” Role entries are supplied model records, not independently
authenticated evidence of actual involvement. The result does not establish a
judicial constitutional violation, prejudice, remedy, or factual truth in an
actual matter.

## Finding 2 — The New York rule is separately sourced

### Everyday question

Does New York use the same disqualifying-role predicate as the federal model?

### Source

Executive Law §259-i(3)(c)(i)(A)–(B) provides specified preliminary-hearing
routes and states that the designated hearing officer shall not have had prior
supervisory involvement over the alleged violator. The statutory structure
addresses presumptive release, parole, conditional release, and post-release
supervision. The official source must be versioned for the date of any future
application.

### Synthetic example

The synthetic record contains a `priorSupervisoryInvolvement` entry for Officer
S and identifies S as the preliminary hearing officer in a covered New York
conditional-release posture. The required-stage and record premises are also
supplied. The schema does not independently reconstruct a supervisory
relationship from underlying assignments, dates, or matter records.

### Verified result

`ny_verified_disqualifier_conflict` produces the New York assessment
`conflict` and `NYConflictEstablished`. The witness
`verified_ny_prior_supervisory_involvement` demonstrates a concrete model
instance.

Two countermodels protect the source boundary:

- `federal_conflict_does_not_force_ny_conflict` shows that federal
  reporter/recommender involvement does not definitionally create New York prior
  supervisory involvement.
- `ny_attachment_can_exceed_narrow_federal_status` shows that New York
  conditional-release coverage can attach while the prototype’s literal-parole
  federal coverage does not.

### Necessary assumptions

- A listed New York status applies.
- The relevant procedural branch requires a preliminary hearing.
- Decisionmaker identity and a matter-specific prior-supervision classification
  are supplied under the model’s `verified` constructor.
- The applicable statutory version has been selected.

### Practical implication

Systems should not translate one legal source into another through a shared
generic field such as “possible bias.” The governing source, covered status, and
source-specific relationship should remain visible and separately reviewable.

### Limitation

`priorSupervisoryInvolvement` is an externally interpreted, matter-specific
relationship. The prototype neither authenticates the role entry nor settles
the relationship’s temporal or organizational meaning. It also does not convert
a modeled statutory conflict into a federal constitutional conclusion. Those
questions require independent legal review.

## Finding 3 — Evidence gaps remain unresolved

### Everyday question

What should the classifier do when the decisionmaker cannot be reliably
identified?

### Source and model basis

Both selected source rules make the relationship between an identified actor
and supplied earlier-role entries material. The sources provide the legal motivation; the
fail-closed evidence treatment is an explicit model-design choice intended to
avoid inventing facts.

### Synthetic example

One record identifies Officer R as the preliminary decisionmaker while another
identifies Officer D. In a second example, no decisionmaker identity is
available.

### Verified result

The general theorems `missing_decisionmaker_indeterminate` and
`contradictory_decisionmaker_indeterminate` return `indeterminate`. The negative
controls `missing_identity_cannot_establish_federal_conflict` and
`contradictory_identity_cannot_establish_federal_conflict` prevent those gaps
from being classified as federal conflict. Compiled controls also show that the
same states cannot produce narrow compliance.

### Necessary assumptions

- The evidence layer accurately represents identity as missing or
  contradictory.
- No authenticated source has resolved the discrepancy.

### Practical implication

An intake or review system should preserve disagreement among sources and route
it for resolution. It should not select the convenient identity, and it should
not treat silence as proof of either involvement or noninvolvement.

### Limitation

Lean does not authenticate documents, rank sources, establish chain of custody,
or determine which assertion is correct. `indeterminate` means that the supplied
record cannot support this classification; it does not mean the proceeding was
lawful or unlawful.

## Finding 4 — Reassignment is not evidence repair

### Everyday question

Does assigning a different decisionmaker automatically complete the underlying
role record?

### Source and model basis

The selected legal sources concern actor separation. Neither says that changing
the actor proves that missing or contradictory evidence has been resolved. The
separation between reassignment and evidence completion is therefore a formal
integrity rule, not a newly asserted constitutional doctrine.

### Synthetic example

An incomplete synthetic record contains an affirmative disqualifying-role entry
for Officer R. Officer D, for whom no federal disqualifying entry is recorded,
is assigned prospectively. No additional record material accompanies the
reassignment. The example stipulates the entries; Lean does not authenticate
them.

### Verified result

- `prospective_reassignment_preserves_integrity` proves that reassignment copies
  the original integrity classification.
- `reassignment_alone_cannot_establish_completeness` proves that a non-complete
  record cannot become complete through reassignment.
- `federal_incomplete_reassignment_indeterminate` and
  `incomplete_reassignment_remains_indeterminate` show that the incomplete
  replacement example remains indeterminate.
- `prospective_reassignment_preserves_role_history` proves that the earlier role
  events remain a prefix of the later record.

### Necessary assumptions

- Reassignment changes the prospective actor and appends events but supplies no
  new evidentiary material.
- The original integrity label is accurate.
- No affirmative federal disqualifier for the replacement appears in the
  incomplete record.

### Practical implication

Operational systems should expose reassignment and evidence completion as two
different actions with different authorization and audit trails. A workflow
should not automatically change an integrity field to “complete” when a new
actor is assigned.

### Limitation

The result does not define the investigation required to complete a real record.
It does not establish that reassignment is legally required or that reassignment
cures an earlier problem.

## Finding 5 — Later narrow compliance can retain earlier role entries

### Everyday question

Can a later assessment be represented as narrowly compliant while retaining
earlier role-event entries and keeping the original matter separately available?

### Source and model basis

The legal sources motivate the actor-separation predicates but do not supply a
universal rule of cure. Evidence repair is therefore represented as a separate
workflow with an explicit validation gate and a role-event prefix requirement.

### Synthetic example

After Officer D is assigned, an external reviewer supplies a candidate role
record. The record retains all earlier role-event entries as a prefix, is
labeled complete, and contains no
modeled federal disqualifier for D. The same candidate is tested once without
validation and once with an externally supplied `validated` status. A separate
control marks a validated candidate contradictory.

### Verified result

- `unvalidated_evidence_repair_is_noop` proves that the unvalidated submission
  changes nothing.
- `evidence_completion_requires_validated_complete_candidate` proves that a
  transition from non-complete to complete requires both `validated` status and
  a candidate independently labeled complete.
- `federal_validated_evidence_repair_compliant` proves narrow prospective
  compliance when coverage, required stage, stable identity, candidate
  completeness, and absence of the federal disqualifier are also supplied.
- Despite its name, `original_conflict_history_survives_validated_repair` proves
  a narrower conjunction: the original matter assesses as `conflict`, the later
  matter assesses as `compliant`, and the earlier role-event list is a prefix of
  the later list. The synthetic proof keeps the original and later `Matter`
  values separately available; it does not encode a complete conflict-history
  object inside the later matter.

### Necessary assumptions

- `validated` was supplied by an adequate external process.
- `complete` accurately describes the candidate record.
- The candidate’s role-event list extends rather than deletes the earlier list.
- Attachment, identity, and source-specific noninvolvement are separately
  established.

### Practical implication

A production evidence system would need a documented validation contract: who
may validate, what materials must be reviewed, how conflicts are resolved, and
how provenance is retained. The model’s Boolean-like label is not a substitute
for that system.

### Limitation

Lean does not authenticate `validated` or `complete`. Later narrow compliance
does not prove cure, harmlessness, mootness, absence of prejudice, entitlement
to a remedy, or a judicial finding about the earlier event.

## System-design recommendations motivated by the verified properties

The following are recommendations motivated by the theorem results and
countermodels. They are not direct theorem conclusions, statutory commands, or
filing advice:

1. **Version the governing source.** Store jurisdiction, source key, statutory
   version, status, and procedural stage before applying an actor rule.
2. **Separate identity from role.** Record who made the decision and the evidence
   for each prior role independently.
3. **Fail closed on material conflicts.** Missing or contradictory identity
   should block conflict and compliance certification.
4. **Separate reassignment from evidence repair.** A new actor assignment should
   not modify the record-integrity classification.
5. **Require explicit validation for completion.** A candidate record should not
   become operative merely because it has been submitted.
6. **Retain role-entry prefixes and separate assessments.** Later role records
   should retain earlier role-event entries, while systems should separately
   store original and later assessments so reviewers can distinguish correction
   from erasure.
7. **Use bounded labels.** Display “source-specific model conflict,” “narrow
   actor-separation compliance,” and “indeterminate,” rather than suggesting an
   overall legal judgment.

The formal results expose distinctions and failed implications; the recommended
data fields and workflow practices are additional design judgments informed by
those results. None has been proved necessary by Lean or tested as an
operational intervention in an agency or nonprofit.

## What the computer checked

The frozen prototype contains 51 named theorems: 15 substantive general
theorems, 7 supporting/interface lemmas, 5 countermodels, 14 synthetic witnesses,
and 10 negative controls. It pins Lean 4.35.0, imports no external Lake package,
and runs source, theorem-coverage, placeholder, unsafe-declaration, and exact
dependency audits. GitHub Actions also records an independent `leanchecker` run.

These checks establish derivability and reproducibility within the formal
artifact. They do not validate the source interpretation or supplied records.
The trace relation and the evidence classifier are separate components: the
trace model does not enforce, derive, or certify a classifier result.

## Research workflow and AI assistance

This project was produced through an iterative, human-directed and AI-assisted
workflow. AI tools assisted with source organization, proposed formal
definitions, Lean code development, testing and audit scripts, counterexample
construction, and manuscript drafting. The Lean compiler and independent audit
tools checked the recorded derivations. Human-directed research decisions set
the scope, required the repair-integrity correction, and established review and
publication gates. Neither AI-generated text nor a successful Lean build
substitutes for independent legal or formal-methods review.

## What has not been established

No real proceeding has been evaluated. The study does not establish that a
hearing was required in a particular matter, that a waiver was valid, that a
document or role entry is authentic, that a role record is complete, or that an
external validation was adequate. `verified`, `complete`, and `validated` are
externally supplied classifications. It does not formalize every preliminary- or
final-hearing protection. It does not determine constitutional violation,
statutory liability, prejudice, cure, remedy, release, reversal, damages, or
likely outcome.

## Preprint status

This document is an independent research preprint and has not been peer-reviewed.
Independent legal and formal-methods reviews have not been obtained. A legal
reviewer should examine source fidelity, applicability, waiver, stage
displacement, prior supervisory involvement, and public wording. A
formal-methods reviewer should examine the classifier, countermodels, dependent
repair interface, external `validated` premise, theorem classification, and
dependency audit. Public dissemination as a preprint does not establish legal
approval, mathematical endorsement, production suitability, or legal reliance.

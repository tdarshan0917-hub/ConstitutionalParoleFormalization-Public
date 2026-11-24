# Independent Research Preprint — Not Peer-Reviewed

# When Is a Parole Decisionmaker Independent?

## A Lean 4 Study of Procedural Independence, Evidence Integrity, and Correction

**Technical Research Paper 1.0 | Independent research preprint | November 2026**

## Abstract

This paper presents a bounded Lean 4 formalization of decisionmaker independence
in preliminary parole-revocation procedure. It represents two source-specific
rules without equating them: the preliminary-stage independence discussion in
[*Morrissey v. Brewer*, 408 U.S. 471, 480–87, especially 485–86
(1972)](https://tile.loc.gov/storage-services/service/ll/usrep/usrep408/usrep408471/usrep408471.pdf),
and the prior-supervisory-involvement restriction in [New York Executive Law
§259-i(3)(c)(i)(A)–(B)](https://www.nysenate.gov/legislation/laws/EXC/259-I).

The model distinguishes legal coverage, preliminary-stage attachment, actor
identity, role events, record integrity, source-specific conflict, narrow
compliance, and indeterminacy. A shared classifier treats an affirmative
disqualifying-role entry in a supplied record differently from the absence of a
disqualifier in an incomplete record. Lean does not authenticate role entries as
evidence that actual involvement occurred. General theorems and synthetic witnesses establish bounded
federal and New York conflicts and compliance results. Countermodels show that
the source predicates, status coverage, administrative affiliation, and
prospective correction do not collapse into stronger conclusions.

The paper also documents a corrected repair interface. An earlier operation
changed the decisionmaker and assigned record completeness in the same step.
The frozen V0.1 model replaces it with prospective reassignment that preserves
record integrity, plus a separate evidence-repair submission carrying an
externally supplied validation status and a role-event prefix proof. Lean proves
that reassignment alone cannot establish completeness and that any modeled
transition from non-complete to complete through this interface requires a
validated, complete candidate.

The artifact contains 51 audited theorems and passes a pinned Lean 4.35.0 build,
an independent environment checker, a fail-closed inventory audit, and exact
dependency checks. These checks establish consequences of the encoded
definitions and supplied premises. They do not authenticate evidence, determine
the uniquely correct legal interpretation, adjudicate a constitutional
violation, or establish cure or remedy.

## 1. Research question and scope

The research question is:

> Under separately sourced federal and New York preliminary-revocation
> decisionmaker-independence predicates, which classifications follow from
> explicit status, stage, identity, role, and evidence-integrity premises, and
> can prospective correction be represented without manufacturing completeness
> or deleting earlier role-event entries?

This is a formalization experiment, not a comprehensive model of parole law.
The prototype studies one actor-separation question and the evidence conditions
needed to classify it. It excludes initial-release merits, equal protection,
damages, prejudice, remedies, filing strategy, outcome prediction, and real case
records. It also excludes most other protections at preliminary and final
revocation hearings.

The bounded contribution is methodological:

1. federal and New York source predicates remain definitionally separate;
2. conflict and narrow compliance require different evidence conditions;
3. missing and contradictory material evidence fail closed;
4. finite countermodels expose invalid implications;
5. actor reassignment is separated from evidence completion; and
6. later prospective classification can preserve earlier role-event entries as
   a prefix while synthetic proofs retain original and later matters separately.

No claim is made that this is the first formalization of administrative due
process or parole procedure. The contribution claimed is limited to the
properties proved in this artifact.

## 2. Legal-source boundary

### 2.1 Federal source and modeled slice

*Morrissey* held that the conditional liberty of a parolee is protected by the
Fourteenth Amendment’s Due Process Clause and described preliminary and final
revocation stages. At the preliminary stage following arrest and detention, the
Court required the reasonable-ground determination to be made by someone not
directly involved. It explained that a parole officer other than the person who
reported the alleged violations or recommended revocation would suffice. 408
U.S. at 485–86. The officer could be an administrative officer rather than a
judge or lawyer.

The model makes two conservative choices. First, `federalCovered` is true only
for literal `parole`, the status directly addressed by the selected holding.
Second, `federalDisqualifyingRole` includes only `reportedViolation` and
`recommendedRevocation`. These are express examples in the source, not an
assertion that every possible form of direct involvement has been exhaustively
formalized. The constructors classify supplied `RoleEvent` entries; they do not
authenticate source documents or independently prove that an actor actually
reported a violation or recommended revocation.

This source mapping supports claims `CPF-FED-001`, `CPF-FED-002`, and
`CPF-FED-003` in `claims/claims.json`. It does not determine how federal due
process applies to every New York release status or every alleged kind of prior
involvement.

### 2.2 New York source and modeled slice

The official New York source displays a revision dated May 16, 2025. Executive
Law §259-i(3)(c)(i)(A)–(B) describes specified preliminary-hearing routes and
states that a designated hearing officer shall not have had prior supervisory
involvement over the alleged violator. The statutory framework addresses
presumptive release, parole, conditional release, and post-release supervision.

Accordingly, `nyCovered` includes those four statuses and excludes an initial
discretionary release applicant. `nyDisqualifyingRole` includes
`priorSupervisoryInvolvement`. This is separately sourced from the federal
reporter/recommender predicate. It is also an externally interpreted,
matter-specific relationship. The current schema accepts the role entry as an
input and does not reconstruct supervision from assignments, dates,
organizational records, or the identity of the underlying matter.

Statutory status coverage does not prove that a preliminary hearing is required
in every route. The current statute contains distinct pathways involving
technical and nontechnical allegations, notice, recognizance, detention,
waiver, and new-crime convictions. Prototype V0.1 represents required-stage
attachment as an external verified premise. It does not encode the entire
statutory branching structure. Statutory versioning, including text scheduled
to take effect in 2027, remains a publication and application requirement.

This source mapping supports `CPF-NY-001`, `CPF-NY-002`, and the statutory
portion of `CPF-STAGE-001`.

### 2.3 Source non-equivalence

The formalization intentionally contains no theorem or axiom equating the two
source predicates. Reporting or recommending revocation is not definitionally
prior supervision. Prior supervision is not definitionally reporting or
recommending. The coverage predicates also differ. A state model conflict is
therefore not automatically a federal constitutional model conflict, and a
federal model conflict is not automatically a state statutory model conflict.

## 3. Formal architecture

All Lean declarations discussed here are in the namespace
`ConstitutionalParole`. The root module `ConstitutionalParole.lean` imports six
component modules. The principal definitions appear in
`ConstitutionalParole/Model.lean`, the classifier and general results in
`ConstitutionalParole/Assessment.lean`, finite examples in
`ConstitutionalParole/Examples.lean`, traces in
`ConstitutionalParole/Trace.lean`, and additional fail-closed checks in
`ConstitutionalParole/NegativeControls.lean`.

### 3.1 Status, actors, and roles

The status domain has five constructors:

```lean
inductive ParoleStatus where
  | initialApplicant
  | presumptiveRelease
  | parole
  | conditionalRelease
  | postReleaseSupervision
```

An `Actor` has a numeric identifier and an `Agency`. The identifier is a model
field, not a real personnel number. The role domain is:

```lean
inductive Role where
  | reportedViolation
  | recommendedRevocation
  | priorSupervisoryInvolvement
  | preliminaryDecisionmaker
  | repairDecisionmaker
```

A `RoleEvent` associates an actor, a role, and a natural-number sequence value.
The current model uses that value as a simple event label. It does not prove
uniqueness, strict temporal ordering, causation, or matter-level provenance.
Every role event is a supplied record entry. Neither the `RoleEvent` structure
nor the surrounding list authenticates the entry or proves that the described
real-world involvement occurred.

### 3.2 Evidence and integrity

Evidence about a value is three-valued at the data layer:

```lean
inductive Evidence (α : Type) where
  | verified (value : α)
  | missing
  | contradictory (left right : α)
```

`verified` means that the value has been supplied to the formal model under that
label. Lean does not authenticate the document, reviewer, or process that
produced it. `contradictory` preserves two incompatible supplied values rather
than choosing one.

Role-record integrity is modeled separately:

```lean
inductive RecordIntegrity where
  | complete
  | incomplete
  | contradictory
```

Again, `complete` is externally supplied. It is not calculated from document
coverage or provenance. Two Boolean interfaces expose the asymmetry used by the
classifier:

```lean
def recordUsableForConflict (record : RoleRecord) : Bool :=
  record.integrity != .contradictory

def recordClosedForCompliance (record : RoleRecord) : Bool :=
  record.integrity == .complete
```

Thus an incomplete but noncontradictory record can carry an affirmative supplied
entry for a disqualifying role. The classifier can use that entry under its
premises, but Lean does not authenticate it. The same incomplete record cannot
establish compliance from the mere absence of a recorded disqualifier.

### 3.3 Matter and assessment

A `Matter` packages four fields:

```lean
structure Matter where
  status : ParoleStatus
  preliminaryDisposition : Evidence PreliminaryDisposition
  decisionmaker : Evidence Actor
  roleRecord : RoleRecord
```

`PreliminaryDisposition` is either `required` or `validlyWaived`. The adjective
“validly” is not a Lean conclusion. It is an explicit external premise.

The classifier result is one of:

```lean
notApplicable | displaced | compliant | conflict | indeterminate
```

`compliant` means narrow compliance with the selected actor-separation
predicate under the supplied premises. It does not mean overall hearing or legal
compliance. `conflict` means a source-specific model conflict, not a judicially
determined violation.

### 3.4 Source-specific coverage and disqualifiers

The exact source predicates are:

```lean
def federalCovered : ParoleStatus → Bool
  | .parole => true
  | _ => false

def nyCovered : ParoleStatus → Bool
  | .presumptiveRelease => true
  | .parole => true
  | .conditionalRelease => true
  | .postReleaseSupervision => true
  | .initialApplicant => false

def federalDisqualifyingRole : Role → Bool
  | .reportedViolation => true
  | .recommendedRevocation => true
  | _ => false

def nyDisqualifyingRole : Role → Bool
  | .priorSupervisoryInvolvement => true
  | _ => false
```

The actor-specific predicates search a role record for a matching actor and
disqualifying role. Shared agency affiliation is not itself a disqualifying
role in either predicate. The search operates only over supplied entries; it
does not infer or reconstruct involvement from external documents.

### 3.5 Structured propositions independent of classifier output

The project does not define “violation” as equality with `.conflict`.
`FederalConflictEstablished` and `NYConflictEstablished` separately expose the
coverage, required-stage, supplied verified-identity, usable-record, and
affirmative-role-entry
premises. `FederalSeparationSatisfied` and `NYSeparationSatisfied` expose
coverage, stage, identity, complete-record, and role-absence premises.

These propositions are not judicial violation predicates. Their purpose is to
prevent a theorem from appearing substantive solely because it restates the
classifier result.

## 4. Classifier semantics

`assessSeparation` is parameterized by a coverage function and an actor-record
disqualification function. `federalAssessment` and `nyAssessment` instantiate
those parameters separately.

The reduction order is material:

1. uncovered status returns `notApplicable`;
2. a supplied verified valid waiver returns `displaced`;
3. missing or contradictory stage evidence returns `indeterminate`;
4. missing or contradictory decisionmaker identity returns `indeterminate`;
5. contradictory role-record integrity returns `indeterminate`;
6. incomplete integrity plus an affirmative disqualifying-role entry returns
   `conflict`;
7. incomplete integrity without an affirmative disqualifier returns
   `indeterminate`;
8. complete integrity plus a disqualifier returns `conflict`; and
9. complete integrity without a disqualifier returns `compliant`.

The asymmetry in steps 6 and 7 is a model-integrity choice. It encodes the idea
that an affirmative disqualifying-role entry in a usable supplied record can
establish the bounded conflict even if other role entries are missing, while
silence in an incomplete record cannot establish noninvolvement. This is a
classifier rule about supplied entries, not evidence authentication.

The order also means that a supplied verified waiver displaces the
actor-separation assessment before identity or role evidence is examined. The
model does not prove that a waiver is knowing, voluntary, documented, timely,
or legally effective. A legal reviewer must decide whether this external gate is
adequately specified.

## 5. Principal theorem families

### 5.1 Federal conflict

The general theorem in `Assessment.lean` has the following substantive shape:

```text
federal coverage
∧ required preliminary stage
∧ verified decisionmaker identity
∧ role record usable for conflict
∧ affirmative federal disqualifying-role entry
→ federal assessment = conflict
  ∧ FederalConflictEstablished
```

Its Lean name is `federal_verified_disqualifier_conflict`, mapped to
`CPF-FED-001`. The conclusion is stronger than a bare computed example because
it also constructs the structured conflict proposition from independent
premises. The finite witness `federalConflictMatter` and theorems
`verified_federal_disqualifying_involvement` and
`verified_federal_conflict_has_independent_structure` demonstrate that the
premises can be jointly inhabited.

The theorem does not prove its premises. In particular, Lean does not establish
literal parole status, required-stage attachment, actor identity, the
authenticity of a role entry, or actual reporter/recommender involvement.

### 5.2 New York conflict

`ny_verified_disqualifier_conflict`, mapped to `CPF-NY-001`, has the parallel
shape using `nyCovered` and `hasNYDisqualifier`:

```text
New York coverage
∧ required preliminary stage
∧ verified decisionmaker identity
∧ role record usable for conflict
∧ affirmative supplied prior-supervision entry
→ New York assessment = conflict
  ∧ NYConflictEstablished
```

The finite witness `nyConflictMatter` uses conditional release and a synthetic
actor with `priorSupervisoryInvolvement`. Theorems
`verified_ny_prior_supervisory_involvement` and
`verified_ny_conflict_has_independent_structure` establish nonvacuity.

The theorem is conditional on the correct statutory version, procedural route,
identity, and role interpretation. `priorSupervisoryInvolvement` is supplied as
an externally interpreted, matter-specific classification. The schema does not
reconstruct that relationship, and the theorem does not prove that the
statutory phrase has been correctly applied to a real relationship.

### 5.3 Narrow compliance

`federal_verified_uninvolved_compliant` and
`ny_verified_uninvolved_compliant` require a complete role record and the
absence of the applicable disqualifier. Their formal shape is:

```text
coverage
∧ required preliminary stage
∧ verified decisionmaker identity
∧ record closed for compliance
∧ no source-specific disqualifier
→ assessment = compliant
  ∧ source-specific separation satisfied
```

The complete-record premise and the supplied absence of the relevant role entry
are essential. Neither is authenticated by Lean. The theorems do not establish notice,
counsel, disclosure, confrontation, timing, proof standards, written reasons,
final-stage neutrality, or any overall compliance conclusion.

### 5.4 Evidence indeterminacy

Two parameterized theorems apply to either source instantiation:

- `missing_decisionmaker_indeterminate`; and
- `contradictory_decisionmaker_indeterminate`.

The negative-control module contains compiled examples for missing and
contradictory stage evidence, contradictory record integrity, incomplete records
without an affirmative disqualifier, and a validated but contradictory
candidate. Each reduces to `indeterminate` and is shown unequal to both
`conflict` and `compliant` where stated.

This family supports `CPF-EVID-001`. It is a formal evidence policy, not a
separate holding attributed to either legal source.

### 5.5 Nonattachment and displacement

`federal_initial_applicant_not_applicable` proves that initial discretionary
release status does not activate this narrow *Morrissey* revocation predicate.
It does not exclude other constitutional or state-law claims.

`verified_waiver_displaces` proves a classifier result only after the premise
`preliminaryDisposition = verified validlyWaived` is supplied. The theorem is
about model behavior. It does not prove waiver validity.

## 6. Countermodels and nonvacuity

A countermodel here is a finite constructed value showing that one modeled
property does not imply another. It is not evidence of prevalence or a factual
claim about an institution.

The artifact includes five named countermodels:

1. `same_agency_does_not_create_federal_conflict` shows that two synthetic
   actors can share an agency while the replacement actor lacks the modeled
   federal disqualifier. Agency identity alone is therefore insufficient under
   the bounded predicate.
2. `federal_conflict_does_not_force_ny_conflict` exhibits a supplied record with
   federal reporter/recommender entries and no New York prior-supervision entry.
3. `ny_attachment_can_exceed_narrow_federal_status` exhibits conditional
   release covered by `nyCovered` but not by the deliberately narrow
   `federalCovered` predicate.
4. `original_conflict_remains_auditable_after_reassignment` combines an
   original federal conflict, later narrow compliance after reassignment of a
   complete record, and prefix preservation of the earlier role-event entries.
5. Despite its name, `original_conflict_history_survives_validated_repair`
   proves a narrower conjunction: the original matter assesses as conflict, the
   later matter assesses as compliant, and the earlier role-event entries are a
   prefix of the later entries. The synthetic development retains the two
   `Matter` values separately.

The first three establish source and predicate non-implications. The last two
show that later prospective classification, prefix preservation, and separate
availability of the synthetic original and later matters can coexist. They do
not define or preserve a complete “conflict history” object. None establishes
legal cure.

## 7. Repair integrity

### 7.1 Original defect

An earlier prototype operation named `prospectiveRepair` performed three steps
together: it changed the decisionmaker, appended repair-related role events, and
assigned the resulting role record `complete`. That definition allowed an
incomplete or contradictory input record to become complete without an
independent evidence premise. A general compliance theorem based on that
operation therefore relied on an unjustified completeness transition.

The defect was not merely editorial. It weakened the epistemic meaning of the
classifier by allowing an operational actor change to certify an evidentiary
property. The original result was replaced rather than relabeled.

### 7.2 Prospective reassignment

The corrected operation changes the actor and appends two role events while
copying the old integrity value:

```lean
def prospectiveReassignment
    (matter : Matter) (replacement : Actor) (sequence : Nat) : Matter :=
  { matter with
    decisionmaker := .verified replacement
    roleRecord :=
      { events := matter.roleRecord.events ++
          [repairDecisionmaker event, preliminaryDecisionmaker event]
        integrity := matter.roleRecord.integrity } }
```

`prospective_reassignment_preserves_integrity` proves literal equality between
the old and new integrity fields. `prospective_reassignment_preserves_role_history`
constructs a suffix witnessing that the earlier event list is a prefix of the
later list. The theorem name uses “history,” but its exact proposition is this
list-prefix property; it does not authenticate the entries or preserve an
assessment log inside the later matter. `reassignment_alone_cannot_establish_completeness` proves:

```text
original record not closed for compliance
→ reassigned record not closed for compliance
```

`federal_incomplete_reassignment_indeterminate` connects that invariant back to
the classifier. Under federal coverage, required-stage, incomplete-record, and
replacement-noninvolvement premises, the reassigned matter remains
`indeterminate`.

`federal_prospective_reassignment_compliant` remains available for the
different case in which the original record was already complete. This premise
prevents the theorem from reintroducing the original defect.

### 7.3 Evidence-repair submission

Evidence completion is represented through a separate dependent structure:

```lean
structure EvidenceRepairSubmission (matter : Matter) where
  candidate : RoleRecord
  extendsHistory : ∃ suffix,
    candidate.events = matter.roleRecord.events ++ suffix
  validation : EvidenceValidationStatus
```

`EvidenceValidationStatus` is either `unvalidated` or `validated`.
`applyEvidenceRepair` is a no-op for the former and installs the candidate for
the latter.

The prefix proof prevents the candidate event list from deleting or reordering
the existing prefix. It does not prove that the prefix or suffix is authentic,
accurate, timely,
uniquely sequenced, or complete. The `validated` constructor is freely supplied
by the external caller; Lean does not authenticate a reviewer or provenance
record.

### 7.4 Corrected invariants

The central negative and necessity results are:

- `unvalidated_evidence_repair_is_noop`: an unvalidated submission returns the
  original matter;
- `validated_evidence_repair_preserves_role_history`: a validated submission
  installs only a history-extending candidate; and
- `evidence_completion_requires_validated_complete_candidate`: if the original
  record is non-complete but the result is complete, the submission must have
  `validated` status and the candidate itself must be complete.

The last theorem can be summarized as:

```text
¬ closed(original) ∧ closed(applyEvidenceRepair(original, submission))
→ validation(submission) = validated
  ∧ closed(candidate(submission))
```

This is a necessary-condition theorem about the defined interface. It does not
prove that a candidate deserves either external label.

The positive interface theorem
`federal_validated_evidence_repair_compliant` additionally requires federal
coverage, required stage, stable verified identity, candidate completeness, and
absence of the federal disqualifier. Its conclusion is narrow federal
actor-separation compliance for the resulting matter.

### 7.5 Negative controls

The same synthetically complete candidate is submitted once as unvalidated and
once as validated. The unvalidated version is proved to leave the original
incomplete matter unchanged. A separate validated candidate is marked
contradictory; its assessment remains indeterminate. These controls show that
validation alone does not force compliance and candidate completeness alone
does not bypass validation.

The externally supplied `validated` premise remains the most important
interface question for independent review. A production design would require a
separate contract defining reviewer authorization, evidence coverage,
provenance, conflict resolution, and auditability.

## 8. Procedural reachability

The trace model contains six states—`opened`, `noticeIssued`,
`preliminaryPending`, `preliminaryDecided`, `finalPending`, and `closed`—and
events for notice, scheduling, role observation, preliminary decision, verified
waiver, repair assignment, final-stage opening, and closure.

`Step` is a small inductive transition relation. `Reachable` is its list-indexed
reflexive path construction. `reachable_append` proves that compatible paths
compose. `PreservesHistory` is list-prefix extension, and
`append_preserves_history` supplies its basic witness.

Synthetic traces establish reachability of an initial conflict sequence, a
later reassignment sequence, and the concatenated sequence. The theorem
`repaired_trace_preserves_event_history` establishes append-only preservation
for those event lists.

The trace layer is intentionally weak and does not enforce the classifier. It
does not connect every trace event to a classifier input or result, enforce
timestamps, prove actor identity, restrict
duplicate decisions, or model all statutory paths. Reachability therefore means
only that a sequence is admitted by the small transition relation. It must not
be presented as proof that the sequence is lawful, evidentially valid, or
institutionally possible.

## 9. Verification and dependency controls

The frozen artifact pins `leanprover/lean4:v4.35.0` and declares no external
Lake package. The theorem inventory contains exactly 51 named results:

| Classification | Count |
|---|---:|
| Substantive general theorems | 15 |
| Supporting/interface lemmas | 7 |
| Countermodels | 5 |
| Synthetic witnesses | 14 |
| Negative controls | 10 |

Definitions, structures, and unnamed compiled examples are not counted as
theorems. `audit/theorem-inventory.json` records each theorem’s category,
strength, claim identifiers, and assumptions. `claims/claims.json` records 11
bounded legal/model claims and two primary source keys.

`checks/integrity.mjs` fails closed on proof placeholders, custom axioms,
unsafe/partial/opaque/external declarations, forbidden imports, external Lake
packages, theorem-count or inventory disagreement, missing dependency entries,
unresolved claim identifiers, and unverified source references.

`ConstitutionalParole/Audit.lean` executes `#print axioms` for the 51 named
theorems. `checks/dependency-audit.mjs` compares the observed output with
`audit/expected-axioms.json`. The permitted standard dependencies are `propext`
and `Quot.sound`; no project-specific axiom is admitted.

GitHub Actions performs a clean Linux build and invokes an independent
`leanchecker` over the compiled environment. The frozen formal source has
recorded successful verification runs. Reproduction instructions are provided
in `REPRODUCIBILITY.md`.

These controls establish that the recorded Lean terms typecheck under the
pinned environment and that the named theorem inventory has the expected
dependencies. They do not prove legal-source fidelity, external factual truth,
or publication quality.

## 10. Source-to-claim traceability

Each principal publication claim has three distinguishable sources:

1. **Legal source:** the cited holding or statutory text motivating the
   predicate;
2. **Formal source:** the exact Lean definition or theorem establishing a
   conditional implication; and
3. **External premises:** factual, evidentiary, and interpretive inputs not
   proved by Lean.

The V0.2.1 publication claim audit provides the controlling cross-document
matrix. In summary:

| Publication finding | Legal or model source | Principal Lean result |
|---|---|---|
| Federal reporter/recommender conflict | *Morrissey*, 408 U.S. at 485–86 | `federal_verified_disqualifier_conflict` |
| New York prior-supervision conflict | Exec. Law §259-i(3)(c)(i)(A)–(B) | `ny_verified_disqualifier_conflict` |
| Missing/contradictory identity indeterminate | Explicit model-integrity rule | `missing_decisionmaker_indeterminate`; `contradictory_decisionmaker_indeterminate` |
| Reassignment preserves integrity | Corrected operational definition | `prospective_reassignment_preserves_integrity`; `reassignment_alone_cannot_establish_completeness` |
| Validated completion preserves a role-entry prefix; synthetic original and later matters remain separate | Evidence-repair interface | `evidence_completion_requires_validated_complete_candidate`; `original_conflict_history_survives_validated_repair` |

The table does not transform model-integrity rules into legal holdings. It
records which statements are source interpretations and which are formal design
properties.

### 10.1 Theorem consequences and design recommendations

The theorem consequences are the equalities, conjunctions, prefix witnesses,
and necessary conditions stated in the Lean declarations. Recommendations that
a future system store separate source, identity, role, integrity, validation,
and assessment fields are design judgments motivated by those results and
countermodels. They are not logical consequences proved by Lean, statutory
commands, or findings that the recommended architecture is sufficient in
practice.

## 11. Mathematical and modeling limitations

The artifact is small enough to audit, but that boundedness creates important
limitations:

- Status is a finite enumeration without dates or jurisdiction-indexed
  versions.
- Actor identity is a natural number plus agency; no identity proof object or
  alias-resolution model exists.
- Role events are supplied entries, not independently authenticated evidence of
  actual involvement, and are not cryptographically or document-provenanced.
- Sequence values do not enforce a total order, uniqueness, or monotonicity.
- `complete` and `validated` are constructors, not derived certificates.
- The role search is Boolean; it does not represent evidentiary weight or
  disputed interpretation of a role.
- The classifier returns one label rather than a structured set of unresolved
  reasons.
- The New York and federal predicates capture selected roles, not the full
  universe of bias, neutrality, or hearing requirements.
- The trace system is not synchronized with, and does not enforce, the evidence
  classifier by an invariant.
- Prefix preservation prevents deletion of earlier events but does not prevent
  misleading, duplicative, or irrelevant suffix events.
- The repair interface proves necessary conditions internal to the model, not
  sufficiency of a real evidence-validation process.

The finite countermodels prove non-implication only relative to the encoded
definitions. They do not establish empirical frequency or institutional
behavior.

## 12. Legal and factual limitations

Independent legal review remains necessary for:

- the breadth of “direct involvement” under *Morrissey*;
- federal application to New York release statuses beyond literal parole;
- the temporal and relational scope of prior supervisory involvement;
- preliminary-stage attachment across notice, recognizance, detention,
  technical and nontechnical allegations, admissions, and new convictions;
- the requirements for a valid waiver;
- effective statutory versioning;
- the legal effect of later independent proceedings; and
- any questions of prejudice, cure, harmlessness, mootness, or remedy.

Independent factual validation remains necessary for status, stage, actor
identity, the matter-specific interpretation and authenticity of role entries,
document authenticity, record completeness, and the
adequacy of any validation process.

Accordingly, no theorem establishes that an actual New York parole proceeding
was unconstitutional or statutorily defective. No theorem authorizes a filing,
predicts an outcome, or establishes entitlement to release or another remedy.

## 13. Research workflow and AI assistance

The project was developed through an iterative, human-directed and AI-assisted
workflow. AI systems assisted with source organization, candidate modeling,
Lean code drafting, counterexample construction, audit-script development,
test execution, and manuscript drafting. Human direction fixed the research
scope, required source separation and fail-closed evidence treatment, identified
the original repair-integrity defect, and imposed review and publication
gates. Lean and the associated audit tools checked the recorded formal
derivations.

This workflow creates its own review obligations. AI output may misread legal
sources, select an incomplete formal predicate, overstate a theorem, or produce
plausible but incorrect prose. Compilation eliminates some formal errors but
does not address those interpretive risks. The source ledger, theorem inventory,
countermodels, negative controls, frozen tag, and claim-audit matrix are intended
to make those risks inspectable. They do not eliminate the need for qualified
independent review.

## 14. Review and preprint status

Prototype V0.1 has completed its bounded construction objective and is frozen at
tag `v0.1-review-freeze-292ed75`. Publication Preparation V0.2.1 changes reporting
only; it adds no theorem family and changes no formal definition, proof,
dependency expectation, or audit script.

This document is an independent research preprint and has not been peer-reviewed.
Independent legal and formal-methods reviews have not been obtained. A legal
practitioner should review the source predicates, attachment conditions, waiver
language, prior-supervision interpretation, versioning, and all public legal
conclusions. A formal-methods reviewer should reproduce the 51-theorem artifact
and examine classifier correctness, source-predicate independence,
countermodel nonvacuity, repair semantics, exact role-entry prefix preservation,
and the freely supplied `validated` premise. Editorial review should verify
citations, cross-document consistency, accessibility, and rendered output.

The appropriate status is an unreviewed independent research preprint. Public
dissemination does not establish production suitability, legal approval,
mathematical endorsement, or legal reliance.

## Conclusion

The central verified result is a set of distinctions. Under explicit premises,
source-specific decisionmaker conflict, narrow actor-separation compliance,
evidence integrity, and prospective correction are different formal properties.
The classifier fails closed on material identity uncertainty. The corrected
repair interface prevents actor reassignment from silently certifying record
completeness. A later validated, complete candidate can support narrow
prospective compliance while preserving earlier role-event entries as a prefix.
In the synthetic theorem, the original and later matters remain separately
available; Lean does not construct a complete conflict-history record.

Those statements are conditional mathematical results about the encoded model.
Whether the predicates correctly express governing law, whether the external
labels are deserved, and what legal consequence follows in a real proceeding
remain outside Lean and require independent review.

import ConstitutionalParole.Model

namespace ConstitutionalParole

def assessSeparation
    (covered : ParoleStatus → Bool)
    (disqualifying : Actor → RoleRecord → Bool)
    (matter : Matter) : SeparationAssessment :=
  if covered matter.status != true then
    .notApplicable
  else
    match matter.preliminaryDisposition with
    | .verified .validlyWaived => .displaced
    | .verified .required =>
        match matter.decisionmaker with
        | .missing => .indeterminate
        | .contradictory _ _ => .indeterminate
        | .verified actor =>
            match matter.roleRecord.integrity with
            | .contradictory => .indeterminate
            | .incomplete =>
                if disqualifying actor matter.roleRecord then
                  .conflict
                else
                  .indeterminate
            | .complete =>
                if disqualifying actor matter.roleRecord then
                  .conflict
                else
                  .compliant
    | .missing => .indeterminate
    | .contradictory _ _ => .indeterminate

def federalAssessment (matter : Matter) : SeparationAssessment :=
  assessSeparation federalCovered hasFederalDisqualifier matter

def nyAssessment (matter : Matter) : SeparationAssessment :=
  assessSeparation nyCovered hasNYDisqualifier matter

theorem federal_verified_disqualifier_conflict
    (matter : Matter) (actor : Actor)
    (hCovered : federalCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIdentity : matter.decisionmaker = .verified actor)
    (hUsable : recordUsableForConflict matter.roleRecord = true)
    (hRole : hasFederalDisqualifier actor matter.roleRecord = true) :
    federalAssessment matter = .conflict ∧ FederalConflictEstablished matter := by
  have hIntegrity : matter.roleRecord.integrity ≠ .contradictory := by
    simpa [recordUsableForConflict] using hUsable
  constructor
  · cases hRecord : matter.roleRecord.integrity with
    | complete =>
        simp [federalAssessment, assessSeparation, hCovered, hRequired, hIdentity,
          hRecord, hRole]
    | incomplete =>
        simp [federalAssessment, assessSeparation, hCovered, hRequired, hIdentity,
          hRecord, hRole]
    | contradictory => exact (hIntegrity hRecord).elim
  · exact ⟨⟨hCovered, hRequired⟩, actor, hIdentity, hUsable, hRole⟩

theorem ny_verified_disqualifier_conflict
    (matter : Matter) (actor : Actor)
    (hCovered : nyCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIdentity : matter.decisionmaker = .verified actor)
    (hUsable : recordUsableForConflict matter.roleRecord = true)
    (hRole : hasNYDisqualifier actor matter.roleRecord = true) :
    nyAssessment matter = .conflict ∧ NYConflictEstablished matter := by
  have hIntegrity : matter.roleRecord.integrity ≠ .contradictory := by
    simpa [recordUsableForConflict] using hUsable
  constructor
  · cases hRecord : matter.roleRecord.integrity with
    | complete =>
        simp [nyAssessment, assessSeparation, hCovered, hRequired, hIdentity,
          hRecord, hRole]
    | incomplete =>
        simp [nyAssessment, assessSeparation, hCovered, hRequired, hIdentity,
          hRecord, hRole]
    | contradictory => exact (hIntegrity hRecord).elim
  · exact ⟨⟨hCovered, hRequired⟩, actor, hIdentity, hUsable, hRole⟩

theorem federal_verified_uninvolved_compliant
    (matter : Matter) (actor : Actor)
    (hCovered : federalCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIdentity : matter.decisionmaker = .verified actor)
    (hClosed : recordClosedForCompliance matter.roleRecord = true)
    (hRole : hasFederalDisqualifier actor matter.roleRecord = false) :
    federalAssessment matter = .compliant ∧ FederalSeparationSatisfied matter := by
  have hIntegrity : matter.roleRecord.integrity = .complete := by
    simpa [recordClosedForCompliance] using hClosed
  constructor
  · simp [federalAssessment, assessSeparation, hCovered, hRequired, hIdentity,
      hIntegrity, hRole]
  · exact ⟨⟨hCovered, hRequired⟩, actor, hIdentity, hClosed, hRole⟩

theorem ny_verified_uninvolved_compliant
    (matter : Matter) (actor : Actor)
    (hCovered : nyCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIdentity : matter.decisionmaker = .verified actor)
    (hClosed : recordClosedForCompliance matter.roleRecord = true)
    (hRole : hasNYDisqualifier actor matter.roleRecord = false) :
    nyAssessment matter = .compliant ∧ NYSeparationSatisfied matter := by
  have hIntegrity : matter.roleRecord.integrity = .complete := by
    simpa [recordClosedForCompliance] using hClosed
  constructor
  · simp [nyAssessment, assessSeparation, hCovered, hRequired, hIdentity,
      hIntegrity, hRole]
  · exact ⟨⟨hCovered, hRequired⟩, actor, hIdentity, hClosed, hRole⟩

theorem federal_conflict_not_compliant {matter : Matter}
    (h : federalAssessment matter = .conflict) :
    federalAssessment matter ≠ .compliant := by
  intro hCompliant
  rw [h] at hCompliant
  cases hCompliant

theorem ny_conflict_not_compliant {matter : Matter}
    (h : nyAssessment matter = .conflict) :
    nyAssessment matter ≠ .compliant := by
  intro hCompliant
  rw [h] at hCompliant
  cases hCompliant

theorem missing_decisionmaker_indeterminate
    (covered : ParoleStatus → Bool)
    (disqualifying : Actor → RoleRecord → Bool)
    (matter : Matter)
    (hCovered : covered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hMissing : matter.decisionmaker = .missing) :
    assessSeparation covered disqualifying matter = .indeterminate := by
  simp [assessSeparation, hCovered, hRequired, hMissing]

theorem contradictory_decisionmaker_indeterminate
    (covered : ParoleStatus → Bool)
    (disqualifying : Actor → RoleRecord → Bool)
    (matter : Matter)
    (left right : Actor)
    (hCovered : covered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hContradictory : matter.decisionmaker = .contradictory left right) :
    assessSeparation covered disqualifying matter = .indeterminate := by
  simp [assessSeparation, hCovered, hRequired, hContradictory]

theorem verified_waiver_displaces
    (covered : ParoleStatus → Bool)
    (disqualifying : Actor → RoleRecord → Bool)
    (matter : Matter)
    (hCovered : covered matter.status = true)
    (hWaiver : matter.preliminaryDisposition = .verified .validlyWaived) :
    assessSeparation covered disqualifying matter = .displaced := by
  simp [assessSeparation, hCovered, hWaiver]

theorem federal_initial_applicant_not_applicable (matter : Matter)
    (hStatus : matter.status = .initialApplicant) :
    federalAssessment matter = .notApplicable := by
  simp [federalAssessment, assessSeparation, hStatus, federalCovered]

def prospectiveReassignment (matter : Matter) (replacement : Actor) (sequence : Nat) : Matter :=
  { matter with
    decisionmaker := .verified replacement
    roleRecord :=
      { events := matter.roleRecord.events ++
          [ { actor := replacement, role := .repairDecisionmaker, sequence := sequence }
          , { actor := replacement, role := .preliminaryDecisionmaker, sequence := sequence + 1 } ]
        integrity := matter.roleRecord.integrity } }

def PreservesRoleHistory (earlier later : Matter) : Prop :=
  ∃ suffix, later.roleRecord.events = earlier.roleRecord.events ++ suffix

inductive EvidenceValidationStatus where
  | unvalidated
  | validated
deriving DecidableEq, Repr

structure EvidenceRepairSubmission (matter : Matter) where
  candidate : RoleRecord
  extendsHistory : ∃ suffix,
    candidate.events = matter.roleRecord.events ++ suffix
  validation : EvidenceValidationStatus

def applyEvidenceRepair (matter : Matter)
    (submission : EvidenceRepairSubmission matter) : Matter :=
  match submission.validation with
  | .unvalidated => matter
  | .validated => { matter with roleRecord := submission.candidate }

theorem preserves_role_history_trans {first second third : Matter}
    (hFirst : PreservesRoleHistory first second)
    (hSecond : PreservesRoleHistory second third) :
    PreservesRoleHistory first third := by
  rcases hFirst with ⟨firstSuffix, hFirst⟩
  rcases hSecond with ⟨secondSuffix, hSecond⟩
  refine ⟨firstSuffix ++ secondSuffix, ?_⟩
  rw [hSecond, hFirst, List.append_assoc]

theorem prospective_reassignment_preserves_integrity
    (matter : Matter) (replacement : Actor) (sequence : Nat) :
    (prospectiveReassignment matter replacement sequence).roleRecord.integrity =
      matter.roleRecord.integrity := by
  rfl

theorem prospective_reassignment_preserves_role_history
    (matter : Matter) (replacement : Actor) (sequence : Nat) :
    PreservesRoleHistory matter
      (prospectiveReassignment matter replacement sequence) := by
  refine ⟨
    [ { actor := replacement, role := .repairDecisionmaker, sequence := sequence }
    , { actor := replacement, role := .preliminaryDecisionmaker, sequence := sequence + 1 } ], ?_⟩
  rfl

theorem reassignment_alone_cannot_establish_completeness
    (matter : Matter) (replacement : Actor) (sequence : Nat)
    (hNotComplete : recordClosedForCompliance matter.roleRecord = false) :
    recordClosedForCompliance
      (prospectiveReassignment matter replacement sequence).roleRecord = false := by
  simpa [prospectiveReassignment, recordClosedForCompliance] using hNotComplete

theorem unvalidated_evidence_repair_is_noop
    (matter : Matter) (submission : EvidenceRepairSubmission matter)
    (hUnvalidated : submission.validation = .unvalidated) :
    applyEvidenceRepair matter submission = matter := by
  simp [applyEvidenceRepair, hUnvalidated]

theorem validated_evidence_repair_preserves_role_history
    (matter : Matter) (submission : EvidenceRepairSubmission matter)
    (hValidated : submission.validation = .validated) :
    PreservesRoleHistory matter (applyEvidenceRepair matter submission) := by
  rcases submission.extendsHistory with ⟨suffix, hSuffix⟩
  exact ⟨suffix, by simp [applyEvidenceRepair, hValidated, hSuffix]⟩

theorem evidence_completion_requires_validated_complete_candidate
    (matter : Matter) (submission : EvidenceRepairSubmission matter)
    (hOriginalNotComplete : recordClosedForCompliance matter.roleRecord = false)
    (hResultComplete : recordClosedForCompliance
      (applyEvidenceRepair matter submission).roleRecord = true) :
    submission.validation = .validated ∧
      recordClosedForCompliance submission.candidate = true := by
  cases hValidation : submission.validation with
  | unvalidated =>
      have hNoop := unvalidated_evidence_repair_is_noop matter submission hValidation
      simp [hNoop, hOriginalNotComplete] at hResultComplete
  | validated =>
      constructor
      · rfl
      · simpa [applyEvidenceRepair, hValidation] using hResultComplete

theorem federal_prospective_reassignment_compliant
    (matter : Matter) (replacement : Actor) (sequence : Nat)
    (hCovered : federalCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hClosed : recordClosedForCompliance matter.roleRecord = true)
    (hUninvolved : hasFederalDisqualifier replacement matter.roleRecord = false) :
    federalAssessment
      (prospectiveReassignment matter replacement sequence) = .compliant := by
  have hExtended : hasFederalDisqualifier replacement
      (prospectiveReassignment matter replacement sequence).roleRecord = false := by
    simpa [prospectiveReassignment, hasFederalDisqualifier, hasRoleFor,
      federalDisqualifyingRole] using hUninvolved
  have hClosedExtended : recordClosedForCompliance
      (prospectiveReassignment matter replacement sequence).roleRecord = true := by
    simpa [prospectiveReassignment, recordClosedForCompliance] using hClosed
  exact (federal_verified_uninvolved_compliant
    (prospectiveReassignment matter replacement sequence) replacement
    (by simpa [prospectiveReassignment] using hCovered)
    (by simpa [prospectiveReassignment] using hRequired)
    (by simp [prospectiveReassignment])
    hClosedExtended
    hExtended).1

theorem federal_incomplete_reassignment_indeterminate
    (matter : Matter) (replacement : Actor) (sequence : Nat)
    (hCovered : federalCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIncomplete : matter.roleRecord.integrity = .incomplete)
    (hUninvolved : hasFederalDisqualifier replacement matter.roleRecord = false) :
    federalAssessment
      (prospectiveReassignment matter replacement sequence) = .indeterminate := by
  have hExtended : hasFederalDisqualifier replacement
      (prospectiveReassignment matter replacement sequence).roleRecord = false := by
    simpa [prospectiveReassignment, hasFederalDisqualifier, hasRoleFor,
      federalDisqualifyingRole] using hUninvolved
  have hCoveredExtended : federalCovered
      (prospectiveReassignment matter replacement sequence).status = true := by
    simpa [prospectiveReassignment] using hCovered
  have hRequiredExtended :
      (prospectiveReassignment matter replacement sequence).preliminaryDisposition =
        .verified .required := by
    simpa [prospectiveReassignment] using hRequired
  have hIdentityExtended :
      (prospectiveReassignment matter replacement sequence).decisionmaker =
        .verified replacement := by
    simp [prospectiveReassignment]
  have hIntegrityExtended :
      (prospectiveReassignment matter replacement sequence).roleRecord.integrity =
        .incomplete := by
    simpa [prospectiveReassignment] using hIncomplete
  simp [federalAssessment, assessSeparation, hCoveredExtended,
    hRequiredExtended, hIdentityExtended, hIntegrityExtended, hExtended]

theorem federal_validated_evidence_repair_compliant
    (matter : Matter) (submission : EvidenceRepairSubmission matter)
    (actor : Actor)
    (hValidated : submission.validation = .validated)
    (hCovered : federalCovered matter.status = true)
    (hRequired : matter.preliminaryDisposition = .verified .required)
    (hIdentity : matter.decisionmaker = .verified actor)
    (hCandidateComplete :
      recordClosedForCompliance submission.candidate = true)
    (hCandidateUninvolved :
      hasFederalDisqualifier actor submission.candidate = false) :
    federalAssessment (applyEvidenceRepair matter submission) = .compliant := by
  exact (federal_verified_uninvolved_compliant
    (applyEvidenceRepair matter submission) actor
    (by simpa [applyEvidenceRepair, hValidated] using hCovered)
    (by simpa [applyEvidenceRepair, hValidated] using hRequired)
    (by simpa [applyEvidenceRepair, hValidated] using hIdentity)
    (by simpa [applyEvidenceRepair, hValidated] using hCandidateComplete)
    (by simpa [applyEvidenceRepair, hValidated] using hCandidateUninvolved)).1

end ConstitutionalParole

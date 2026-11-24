import ConstitutionalParole.Examples

namespace ConstitutionalParole

/-! Reproduction controls. These remain `example` declarations so they add
compiled checks without obscuring the named theorem inventory. -/

def missingStageMatter : Matter :=
  { federalConflictMatter with preliminaryDisposition := .missing }

def contradictoryStageMatter : Matter :=
  { federalConflictMatter with
    preliminaryDisposition := .contradictory .required .validlyWaived }

def contradictoryRecordMatter : Matter :=
  { federalConflictMatter with
    roleRecord := ⟨federalConflictMatter.roleRecord.events, .contradictory⟩ }

def incompleteUninvolvedMatter : Matter :=
  { federalCompliantMatter with
    roleRecord := ⟨federalCompliantMatter.roleRecord.events, .incomplete⟩ }

def contradictoryCandidateRecord : RoleRecord :=
  { events := incompleteReassignedMatter.roleRecord.events
    integrity := .contradictory }

def validatedContradictorySubmission :
    EvidenceRepairSubmission incompleteReassignedMatter :=
  { candidate := contradictoryCandidateRecord
    extendsHistory := ⟨[], by simp [contradictoryCandidateRecord]⟩
    validation := .validated }

def validatedContradictoryMatter : Matter :=
  applyEvidenceRepair incompleteReassignedMatter
    validatedContradictorySubmission

example :
    federalAssessment missingStageMatter = .indeterminate ∧
    federalAssessment missingStageMatter ≠ .conflict ∧
    federalAssessment missingStageMatter ≠ .compliant := by
  decide

example :
    federalAssessment contradictoryStageMatter = .indeterminate ∧
    federalAssessment contradictoryStageMatter ≠ .conflict ∧
    federalAssessment contradictoryStageMatter ≠ .compliant := by
  decide

example :
    federalAssessment contradictoryRecordMatter = .indeterminate ∧
    federalAssessment contradictoryRecordMatter ≠ .conflict ∧
    federalAssessment contradictoryRecordMatter ≠ .compliant := by
  decide

example :
    federalAssessment incompleteUninvolvedMatter = .indeterminate ∧
    federalAssessment incompleteUninvolvedMatter ≠ .conflict ∧
    federalAssessment incompleteUninvolvedMatter ≠ .compliant := by
  decide

example :
    nyAssessment { nyConflictMatter with decisionmaker := .missing } = .indeterminate ∧
    nyAssessment { nyConflictMatter with decisionmaker := .missing } ≠ .conflict ∧
    nyAssessment { nyConflictMatter with decisionmaker := .missing } ≠ .compliant := by
  decide

example :
    federalAssessment missingIdentityMatter = .indeterminate ∧
    federalAssessment missingIdentityMatter ≠ .conflict ∧
    federalAssessment missingIdentityMatter ≠ .compliant := by
  decide

example :
    federalAssessment contradictoryIdentityMatter = .indeterminate ∧
    federalAssessment contradictoryIdentityMatter ≠ .conflict ∧
    federalAssessment contradictoryIdentityMatter ≠ .compliant := by
  decide

example :
    federalDisqualifyingRole .reportedViolation = true ∧
    nyDisqualifyingRole .reportedViolation = false ∧
    federalDisqualifyingRole .priorSupervisoryInvolvement = false ∧
    nyDisqualifyingRole .priorSupervisoryInvolvement = true := by
  decide

example :
    recordClosedForCompliance incompleteConflictMatter.roleRecord = false ∧
    recordClosedForCompliance incompleteReassignedMatter.roleRecord = false ∧
    federalAssessment incompleteReassignedMatter = .indeterminate := by
  decide

example :
    unvalidatedCandidateMatter = incompleteReassignedMatter ∧
    recordClosedForCompliance unvalidatedCandidateMatter.roleRecord = false := by
  exact unvalidated_completion_candidate_cannot_change_integrity

example :
    federalAssessment validatedContradictoryMatter = .indeterminate ∧
    federalAssessment validatedContradictoryMatter ≠ .conflict ∧
    federalAssessment validatedContradictoryMatter ≠ .compliant := by
  decide

example :
    federalAssessment validatedRepairedMatter = .compliant ∧
    PreservesRoleHistory incompleteConflictMatter validatedRepairedMatter := by
  exact ⟨validated_repair_is_compliant,
    validated_repair_preserves_original_history⟩

end ConstitutionalParole

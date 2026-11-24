import ConstitutionalParole.Assessment
import ConstitutionalParole.Trace

namespace ConstitutionalParole

/-! ## Synthetic actors and verified role evidence -/

def reporter : Actor := ⟨1, .nyDOCCS⟩
def uninvolvedOfficer : Actor := ⟨2, .nyDOCCS⟩
def priorSupervisor : Actor := ⟨3, .nyDOCCS⟩

def reporterEvents : List RoleEvent :=
  [ { actor := reporter, role := .reportedViolation, sequence := 1 }
  , { actor := reporter, role := .recommendedRevocation, sequence := 2 } ]

def federalConflictMatter : Matter :=
  { status := .parole
    preliminaryDisposition := .verified .required
    decisionmaker := .verified reporter
    roleRecord := ⟨reporterEvents, .complete⟩ }

def federalCompliantMatter : Matter :=
  { federalConflictMatter with decisionmaker := .verified uninvolvedOfficer }

def missingIdentityMatter : Matter :=
  { federalConflictMatter with decisionmaker := .missing }

def contradictoryIdentityMatter : Matter :=
  { federalConflictMatter with
    decisionmaker := .contradictory reporter uninvolvedOfficer }

def initialReleaseMatter : Matter :=
  { federalConflictMatter with status := .initialApplicant }

def validWaiverMatter : Matter :=
  { federalConflictMatter with
    preliminaryDisposition := .verified .validlyWaived }

def nyConflictMatter : Matter :=
  { status := .conditionalRelease
    preliminaryDisposition := .verified .required
    decisionmaker := .verified priorSupervisor
    roleRecord :=
      ⟨[ { actor := priorSupervisor, role := .priorSupervisoryInvolvement, sequence := 1 } ],
        .complete⟩ }

/-! ## Computed examples -/

theorem verified_federal_disqualifying_involvement :
    federalAssessment federalConflictMatter = .conflict := by
  decide

theorem verified_federal_conflict_has_independent_structure :
    FederalConflictEstablished federalConflictMatter := by
  exact (federal_verified_disqualifier_conflict federalConflictMatter reporter
    (by decide) (by decide) (by decide) (by decide) (by decide)).2

theorem different_uninvolved_decisionmaker_complies :
    federalAssessment federalCompliantMatter = .compliant := by
  decide

theorem different_uninvolved_decisionmaker_has_independent_structure :
    FederalSeparationSatisfied federalCompliantMatter := by
  exact (federal_verified_uninvolved_compliant federalCompliantMatter uninvolvedOfficer
    (by decide) (by decide) (by decide) (by decide) (by decide)).2

theorem same_agency_does_not_create_federal_conflict :
    reporter.agency = uninvolvedOfficer.agency ∧
    federalAssessment federalCompliantMatter = .compliant := by
  constructor <;> decide

theorem missing_identity_is_indeterminate :
    federalAssessment missingIdentityMatter = .indeterminate := by
  decide

theorem contradictory_identity_is_indeterminate :
    federalAssessment contradictoryIdentityMatter = .indeterminate := by
  decide

theorem missing_identity_cannot_establish_federal_conflict :
    federalAssessment missingIdentityMatter ≠ .conflict := by
  decide

theorem contradictory_identity_cannot_establish_federal_conflict :
    federalAssessment contradictoryIdentityMatter ≠ .conflict := by
  decide

theorem initial_release_does_not_attach :
    federalAssessment initialReleaseMatter = .notApplicable := by
  decide

theorem initial_release_cannot_establish_this_revocation_conflict :
    federalAssessment initialReleaseMatter ≠ .conflict := by
  decide

theorem verified_waiver_displaces_preliminary_assessment :
    federalAssessment validWaiverMatter = .displaced := by
  decide

theorem verified_waiver_blocks_required_stage_conflict_classification :
    federalAssessment validWaiverMatter ≠ .conflict := by
  decide

theorem verified_ny_prior_supervisory_involvement :
    nyAssessment nyConflictMatter = .conflict := by
  decide

theorem verified_ny_conflict_has_independent_structure :
    NYConflictEstablished nyConflictMatter := by
  exact (ny_verified_disqualifier_conflict nyConflictMatter priorSupervisor
    (by decide) (by decide) (by decide) (by decide) (by decide)).2

/-! Federal and New York rules are demonstrably not identical. The same
synthetic record can conflict with the federal report/recommendation rule while
satisfying the narrower modeled New York prior-supervision relation, and a
conditional-release record can attach to the New York predicate while this
prototype's narrow literal-parole federal predicate does not attach. -/

theorem federal_conflict_does_not_force_ny_conflict :
    federalAssessment federalConflictMatter = .conflict ∧
    nyAssessment federalConflictMatter = .compliant := by
  constructor <;> decide

theorem ny_attachment_can_exceed_narrow_federal_status :
    nyAssessment nyConflictMatter = .conflict ∧
    federalAssessment nyConflictMatter = .notApplicable := by
  constructor <;> decide

/-! ## Evidence-preserving reassignment and validated completion -/

def reassignedCompleteMatter : Matter :=
  prospectiveReassignment federalConflictMatter uninvolvedOfficer 3

theorem reassigned_complete_matter_is_compliant :
    federalAssessment reassignedCompleteMatter = .compliant := by
  decide

theorem reassigned_complete_matter_preserves_prior_history :
    PreservesRoleHistory federalConflictMatter reassignedCompleteMatter := by
  exact prospective_reassignment_preserves_role_history _ _ _

theorem original_conflict_remains_auditable_after_reassignment :
    federalAssessment federalConflictMatter = .conflict ∧
    federalAssessment reassignedCompleteMatter = .compliant ∧
    PreservesRoleHistory federalConflictMatter reassignedCompleteMatter := by
  exact ⟨verified_federal_disqualifying_involvement,
    reassigned_complete_matter_is_compliant,
    reassigned_complete_matter_preserves_prior_history⟩

def incompleteConflictMatter : Matter :=
  { federalConflictMatter with
    roleRecord := ⟨federalConflictMatter.roleRecord.events, .incomplete⟩ }

def incompleteReassignedMatter : Matter :=
  prospectiveReassignment incompleteConflictMatter uninvolvedOfficer 3

theorem incomplete_reassignment_remains_indeterminate :
    federalAssessment incompleteReassignedMatter = .indeterminate := by
  decide

def completedCandidateRecord : RoleRecord :=
  { events := incompleteReassignedMatter.roleRecord.events
    integrity := .complete }

def unvalidatedCompletionSubmission :
    EvidenceRepairSubmission incompleteReassignedMatter :=
  { candidate := completedCandidateRecord
    extendsHistory := ⟨[], by simp [completedCandidateRecord]⟩
    validation := .unvalidated }

def validatedCompletionSubmission :
    EvidenceRepairSubmission incompleteReassignedMatter :=
  { candidate := completedCandidateRecord
    extendsHistory := ⟨[], by simp [completedCandidateRecord]⟩
    validation := .validated }

def unvalidatedCandidateMatter : Matter :=
  applyEvidenceRepair incompleteReassignedMatter unvalidatedCompletionSubmission

def validatedRepairedMatter : Matter :=
  applyEvidenceRepair incompleteReassignedMatter validatedCompletionSubmission

theorem unvalidated_completion_candidate_cannot_change_integrity :
    unvalidatedCandidateMatter = incompleteReassignedMatter ∧
    recordClosedForCompliance unvalidatedCandidateMatter.roleRecord = false := by
  constructor
  · exact unvalidated_evidence_repair_is_noop _ _ (by rfl)
  · decide

theorem validated_repair_is_compliant :
    federalAssessment validatedRepairedMatter = .compliant := by
  decide

theorem validated_repair_preserves_original_history :
    PreservesRoleHistory incompleteConflictMatter validatedRepairedMatter := by
  apply preserves_role_history_trans (second := incompleteReassignedMatter)
  · exact prospective_reassignment_preserves_role_history
      incompleteConflictMatter uninvolvedOfficer 3
  · exact validated_evidence_repair_preserves_role_history _ _ (by rfl)

theorem original_conflict_history_survives_validated_repair :
    federalAssessment incompleteConflictMatter = .conflict ∧
    federalAssessment validatedRepairedMatter = .compliant ∧
    PreservesRoleHistory incompleteConflictMatter validatedRepairedMatter := by
  exact ⟨by decide, validated_repair_is_compliant,
    validated_repair_preserves_original_history⟩

/-! ## Reachable procedural traces -/

def initialConflictTrace : List ProcedureEvent :=
  [ .issueNotice
  , .observeRole { actor := reporter, role := .reportedViolation, sequence := 1 }
  , .schedulePreliminary
  , .observeRole { actor := reporter, role := .recommendedRevocation, sequence := 2 }
  , .makePreliminaryDecision reporter ]

theorem initial_conflict_trace_reachable :
    Reachable .opened initialConflictTrace .preliminaryDecided := by
  exact .cons .issueNotice
    (.cons .observeRole
      (.cons .schedulePreliminary
        (.cons .observeRole
          (.cons .decidePreliminary .nil))))

def repairTrace : List ProcedureEvent :=
  [ .assignRepairDecisionmaker uninvolvedOfficer
  , .observeRole { actor := uninvolvedOfficer, role := .repairDecisionmaker, sequence := 3 }
  , .makePreliminaryDecision uninvolvedOfficer ]

theorem repair_trace_reachable :
    Reachable .preliminaryDecided repairTrace .preliminaryDecided := by
  exact .cons .repairAssignment
    (.cons .observeRole
      (.cons .decidePreliminary .nil))

theorem repaired_full_trace_reachable :
    Reachable .opened (initialConflictTrace ++ repairTrace) .preliminaryDecided := by
  exact reachable_append initial_conflict_trace_reachable repair_trace_reachable

theorem repaired_trace_preserves_event_history :
    PreservesHistory initialConflictTrace (initialConflictTrace ++ repairTrace) := by
  exact append_preserves_history _ _

end ConstitutionalParole

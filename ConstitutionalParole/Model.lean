namespace ConstitutionalParole

/-! ## Legal and evidentiary vocabulary

The federal and New York source predicates are intentionally separate.
No definition in this file represents a judicial judgment, remedy, or
finding about a real matter.
-/

inductive ParoleStatus where
  | initialApplicant
  | presumptiveRelease
  | parole
  | conditionalRelease
  | postReleaseSupervision
deriving DecidableEq, Repr

inductive Agency where
  | nyDOCCS
  | other (code : Nat)
deriving DecidableEq, Repr

structure Actor where
  id : Nat
  agency : Agency
deriving DecidableEq, Repr

inductive Role where
  | reportedViolation
  | recommendedRevocation
  | priorSupervisoryInvolvement
  | preliminaryDecisionmaker
  | repairDecisionmaker
deriving DecidableEq, Repr

structure RoleEvent where
  actor : Actor
  role : Role
  sequence : Nat
deriving DecidableEq, Repr

inductive Evidence (α : Type) where
  | verified (value : α)
  | missing
  | contradictory (left right : α)
deriving DecidableEq, Repr

inductive PreliminaryDisposition where
  | required
  | validlyWaived
deriving DecidableEq, Repr

inductive RecordIntegrity where
  | complete
  | incomplete
  | contradictory
deriving DecidableEq, Repr

structure RoleRecord where
  events : List RoleEvent
  integrity : RecordIntegrity
deriving Repr

structure Matter where
  status : ParoleStatus
  preliminaryDisposition : Evidence PreliminaryDisposition
  decisionmaker : Evidence Actor
  roleRecord : RoleRecord
deriving Repr

inductive SeparationAssessment where
  | notApplicable
  | displaced
  | compliant
  | conflict
  | indeterminate
deriving DecidableEq, Repr

/-! ### Source-specific coverage

`federalCovered` is deliberately narrow: this prototype models the actual
parole status addressed by Morrissey. `nyCovered` follows the categories
listed in the current text of Executive Law § 259-i(3).
-/

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

def hasRoleFor (p : Role → Bool) (a : Actor) (events : List RoleEvent) : Bool :=
  events.any (fun event => event.actor == a && p event.role)

def hasFederalDisqualifier (a : Actor) (record : RoleRecord) : Bool :=
  hasRoleFor federalDisqualifyingRole a record.events

def hasNYDisqualifier (a : Actor) (record : RoleRecord) : Bool :=
  hasRoleFor nyDisqualifyingRole a record.events

def recordUsableForConflict (record : RoleRecord) : Bool :=
  record.integrity != .contradictory

def recordClosedForCompliance (record : RoleRecord) : Bool :=
  record.integrity == .complete

/-! ### Attachment and conflict propositions

These propositions are not aliases for the computed assessment. They expose
the legal-status, stage, identity, role, and evidence-integrity premises that
must independently hold.
-/

def FederalAttachment (matter : Matter) : Prop :=
  federalCovered matter.status = true ∧
    matter.preliminaryDisposition = .verified .required

def NYAttachment (matter : Matter) : Prop :=
  nyCovered matter.status = true ∧
    matter.preliminaryDisposition = .verified .required

def FederalConflictEstablished (matter : Matter) : Prop :=
  FederalAttachment matter ∧
    ∃ actor,
      matter.decisionmaker = .verified actor ∧
      recordUsableForConflict matter.roleRecord = true ∧
      hasFederalDisqualifier actor matter.roleRecord = true

def NYConflictEstablished (matter : Matter) : Prop :=
  NYAttachment matter ∧
    ∃ actor,
      matter.decisionmaker = .verified actor ∧
      recordUsableForConflict matter.roleRecord = true ∧
      hasNYDisqualifier actor matter.roleRecord = true

def FederalSeparationSatisfied (matter : Matter) : Prop :=
  FederalAttachment matter ∧
    ∃ actor,
      matter.decisionmaker = .verified actor ∧
      recordClosedForCompliance matter.roleRecord = true ∧
      hasFederalDisqualifier actor matter.roleRecord = false

def NYSeparationSatisfied (matter : Matter) : Prop :=
  NYAttachment matter ∧
    ∃ actor,
      matter.decisionmaker = .verified actor ∧
      recordClosedForCompliance matter.roleRecord = true ∧
      hasNYDisqualifier actor matter.roleRecord = false

end ConstitutionalParole

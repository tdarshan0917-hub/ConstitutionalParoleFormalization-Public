import ConstitutionalParole.Model

namespace ConstitutionalParole

inductive ProcedureState where
  | opened
  | noticeIssued
  | preliminaryPending
  | preliminaryDecided
  | finalPending
  | closed
deriving DecidableEq, Repr

inductive ProcedureEvent where
  | issueNotice
  | schedulePreliminary
  | observeRole (event : RoleEvent)
  | makePreliminaryDecision (actor : Actor)
  | acceptVerifiedWaiver
  | assignRepairDecisionmaker (actor : Actor)
  | openFinalStage
  | close
deriving DecidableEq, Repr

inductive Step : ProcedureState → ProcedureEvent → ProcedureState → Prop where
  | issueNotice : Step .opened .issueNotice .noticeIssued
  | schedulePreliminary : Step .noticeIssued .schedulePreliminary .preliminaryPending
  | observeRole : Step state (.observeRole event) state
  | decidePreliminary : Step .preliminaryPending (.makePreliminaryDecision actor) .preliminaryDecided
  | waivePreliminary : Step .noticeIssued .acceptVerifiedWaiver .finalPending
  | repairAssignment : Step .preliminaryDecided (.assignRepairDecisionmaker actor) .preliminaryPending
  | openFinal : Step .preliminaryDecided .openFinalStage .finalPending
  | closeFinal : Step .finalPending .close .closed

inductive Reachable : ProcedureState → List ProcedureEvent → ProcedureState → Prop where
  | nil : Reachable state [] state
  | cons : Step start event middle → Reachable middle rest finish →
      Reachable start (event :: rest) finish

def PreservesHistory (oldTrace newTrace : List ProcedureEvent) : Prop :=
  ∃ suffix, newTrace = oldTrace ++ suffix

theorem append_preserves_history (oldTrace suffix : List ProcedureEvent) :
    PreservesHistory oldTrace (oldTrace ++ suffix) := by
  exact ⟨suffix, rfl⟩

theorem reachable_append
    {start middle finish : ProcedureState}
    {first second : List ProcedureEvent}
    (hFirst : Reachable start first middle)
    (hSecond : Reachable middle second finish) :
    Reachable start (first ++ second) finish := by
  induction hFirst with
  | nil => exact hSecond
  | cons hStep _ ih =>
      exact .cons hStep (ih hSecond)

end ConstitutionalParole

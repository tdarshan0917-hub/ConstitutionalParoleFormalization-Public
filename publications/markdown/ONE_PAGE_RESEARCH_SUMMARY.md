# Independent Research Preprint — Not Peer-Reviewed

# When Is a Parole Decisionmaker Independent?

## A Lean 4 Study of Procedural Independence, Evidence Integrity, and Correction

**One-page Research Summary 1.0 | November 2026**

This project asks a narrow question: when a legal source requires an independent
decisionmaker at a preliminary parole-revocation stage, what follows from
explicit information about legal coverage, procedural stage, actor identity,
prior roles, and the quality of the record? We built a small Lean 4 model to
check the consequences of those written rules. The model does not decide a real
case, provide legal advice, or determine that an agency acted unlawfully.

The federal and New York rules remain separate. The federal model draws from
[*Morrissey v. Brewer*, 408 U.S. 471, 485–86
(1972)](https://tile.loc.gov/storage-services/service/ll/usrep/usrep408/usrep408471/usrep408471.pdf).
It covers literal parole and treats supplied role entries for reporting the
alleged violation or recommending revocation as modeled disqualifiers for the
preliminary decisionmaker. Lean does not authenticate actual involvement, and
those roles do not exhaust direct involvement. The state model draws from [New York Executive
Law §259-i(3)(c)(i)(A)–(B)](https://www.nysenate.gov/legislation/laws/EXC/259-I).
It covers four listed statuses. Prior supervisory involvement is an externally
interpreted, matter-specific classification that the schema does not reconstruct.
Whether a preliminary hearing is required remains an external legal premise.

Five principal findings were machine-checked. First, supplied
reporter/recommender entries can establish a bounded federal model conflict
under supplied premises. Second, a supplied New York prior-supervision entry can
establish the separate state conflict. Third, missing or contradictory identity
produces an indeterminate result rather than conflict or compliance. Fourth,
assigning a different decisionmaker cannot turn an incomplete record into a
complete record. Fifth, a later, complete candidate record can support narrow
prospective compliance only after an externally supplied validation step. The
proved history property is narrower: earlier role-event entries remain a prefix,
and the synthetic proof retains the original and later matters separately.

Consider a synthetic record stating that Officer R reported an alleged violation
and was the preliminary decisionmaker. With the required status, stage,
identity, role-entry, and record premises, the
federal classifier returns `conflict`; Lean does not authenticate the record.
Officer D is later assigned. If the record was incomplete,
reassignment alone leaves it incomplete and the assessment remains
`indeterminate`. If an external reviewer supplies a validated, complete,
prefix-extending record with no modeled disqualifying role entry for D, the new
state can be classified as narrowly `compliant`. That result does not erase the
earlier state or establish legal cure.

This distinction matters for review systems. Actor independence, evidentiary
sufficiency, and effective correction should not be compressed into a single
checkbox. The results motivate—but do not prove—a recommendation for separate fields for the
governing source, procedural posture, actor identity, role evidence, record
integrity, validation status, original assessment, and later assessment.

The prototype contains 51 audited theorems. Lean checks that conclusions follow
from encoded definitions and supplied premises; it does not authenticate the
labels `verified`, `complete`, or `validated`. It also does not establish waiver
validity, constitutional violation, prejudice, cure, harmlessness, remedy, or
outcome. Its trace model does not enforce the classifier. Human-directed,
AI-assisted research, Lean development, auditing, and drafting produced this
work. Independent legal and formal-methods reviews have not been obtained. This
preprint has not been peer-reviewed and is not legal advice.

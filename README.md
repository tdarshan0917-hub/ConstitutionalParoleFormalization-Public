# When Is a Parole Decisionmaker Independent?

## A Lean 4 Study of Procedural Independence, Evidence Integrity, and Correction

**Independent Research Preprint — Not Peer-Reviewed**

This repository contains a bounded Lean 4 formalization of selected
decisionmaker-independence protections at the preliminary parole-revocation
stage. It keeps the selected federal rule from *Morrissey v. Brewer* separate
from the selected New York rule in Executive Law §259-i(3), models missing and
contradictory evidence explicitly, and tests whether prospective correction can
occur without manufacturing record completeness or deleting earlier role-event
entries.

This is a research preprint, not legal advice. It does not evaluate a real
proceeding, determine that any person or institution violated law, recommend a
filing, or predict an outcome. Independent legal and formal-methods reviews have
not been obtained.

## What is machine-checked

The frozen model contains 51 inventoried theorems, including general results,
supporting lemmas, countermodels, synthetic witnesses, and negative controls.
Among its bounded results:

- federal and New York source predicates remain separate;
- supplied reporter/recommender or prior-supervision entries can produce
  source-specific model conflicts under explicit attachment and evidence
  premises;
- missing or contradictory decisionmaker identity remains indeterminate;
- actor reassignment alone cannot establish evidence completeness;
- validated evidence submission requires an externally supplied `validated`
  premise and a complete, role-event-prefix-extending candidate; and
- trace reachability does not enforce or authenticate classifier results.

Lean verifies implications from encoded definitions and supplied premises. It
does not authenticate documents, role entries, legal coverage, actor identity,
record completeness, or `validated` status. A model `conflict` is not a
judicially determined violation, and narrow `compliant` is not overall legal or
institutional compliance.

## Publications

- [One-page research summary](publications/markdown/ONE_PAGE_RESEARCH_SUMMARY.md)
  ([PDF](publications/pdf/ONE_PAGE_RESEARCH_SUMMARY.pdf))
- [Public research report](publications/markdown/PUBLIC_RESEARCH_REPORT.md)
  ([PDF](publications/pdf/PUBLIC_RESEARCH_REPORT.pdf))
- [Technical research paper](publications/markdown/TECHNICAL_RESEARCH_PAPER.md)
  ([PDF](publications/pdf/TECHNICAL_RESEARCH_PAPER.pdf))
- [Publication claim audit](docs/PUBLICATION_CLAIM_AUDIT.md)

## Source and interpretation controls

- [Research contract](docs/RESEARCH_CONTRACT.md)
- [Source gate](docs/SOURCE_GATE.md)
- [Interpretation ledger](docs/INTERPRETATION_LEDGER.md)
- [Theorem-to-claim map](docs/THEOREM_TO_CLAIM_MAP.md)
- [Countermodel report](docs/COUNTERMODEL_REPORT.md)
- [Limitations assessment](docs/LIMITATIONS_ASSESSMENT.md)
- [Review status](docs/REVIEW_STATUS.md)

## Reproduce the formal artifact

The project pins `leanprover/lean4:v4.35.0` and has no external Lake package
dependency.

```bash
lake build ConstitutionalParole
node checks/integrity.mjs
lake env lean ConstitutionalParole/Audit.lean
node checks/dependency-audit.mjs
node checks/publication-consistency.mjs
node checks/public-tree-scan.mjs
```

See [REPRODUCIBILITY.md](REPRODUCIBILITY.md) for expected results and audit
boundaries.

## Provenance

The Lean model, theorem statements, definitions, audit scripts, claims ledger,
and original verification workflow are reproduced from formal source commit
`292ed75e0d1ce4f5f4a93794fb72a292f87182c6`. Publication text is derived from
commit `b8e4072ef144742b56f27feffd08617b7b4c58d6`, with release-status, citation,
formatting, and reference-link corrections documented in
[PROVENANCE.md](PROVENANCE.md).

This is a clean public-release tree. It contains no private Git history,
branches, pull requests, reviewer correspondence, private case records, or
internal review packet.

## Citation and licenses

Copyright © 2026 Travis Darshan.

- Original Lean 4 code, audit scripts, workflows, and associated software are
  licensed under the [MIT License](LICENSE).
- The original one-page summary, public report, and technical paper—in Markdown
  and PDF—are licensed under [CC BY 4.0](LICENSE-DOCUMENTS.md).
- Third-party legal sources and other third-party material retain their own
  rights and attribution requirements.

Citation metadata is in [CITATION.cff](CITATION.cff). No DOI has been reserved
or registered. See [RIGHTS.md](RIGHTS.md) for the complete scope statement.

The proposed release tag is `v1.0.1-preprint`. Publication of the GitHub
repository, GitHub release, or Zenodo record requires a separate explicit
authorization.

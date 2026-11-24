# Provenance

## Fixed research inputs

| Component | Exact source |
|---|---|
| Frozen Lean V0.1 formal artifact | `292ed75e0d1ce4f5f4a93794fb72a292f87182c6` |
| Publication V0.2.1 claim-precision text | `b8e4072ef144742b56f27feffd08617b7b4c58d6` |

The proposed public repository is a new clean tree. It does not inherit or copy
the private repository's `.git` directory, commits, branches, pull requests,
tags, remotes, issues, or reviewer materials.

## Byte-preserved formal files

The following categories are copied byte-for-byte from the frozen formal
source:

- `ConstitutionalParole.lean` and `ConstitutionalParole/*.lean`;
- `audit/*.json`;
- the original `checks/dependency-audit.mjs`;
- `claims/claims.json`;
- `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json`; and
- `.github/workflows/verify.yml`.

The source-comparison audit records hashes and confirms that every Lean
definition and theorem statement is unchanged.

The public `checks/integrity.mjs` retains the frozen theorem/source/claim audit
logic but replaces its required-file list: private phase reports and reviewer
packets are excluded, while the public manuscripts, release documentation, and
public checks are required. The source-comparison record identifies and hashes
this configuration-only difference; the private script itself is not included.

## Public documentation derivation

The three manuscripts and 16-claim audit are derived from publication commit
`b8e4072…`. Public-release edits are limited to:

- replacing internal/private draft notices with “Independent Research
  Preprint — Not Peer-Reviewed”;
- disclosing that independent legal and formal-methods reviews have not been
  obtained;
- updating version/status text to 1.0 preprint;
- aligning public ledgers with the V0.2.1 clarification that `verified`,
  `complete`, and `validated` are externally supplied classifications;
- updating public paths, citations, access dates, formatting, and reference
  links; and
- adding public reproducibility, provenance, rights, citation, release, and
  Zenodo-preparation material.

No new legal doctrine, theorem family, real case record, remedy theory, or
outcome claim was added.

## Deliberately excluded material

- private Git history and remote metadata;
- the private repository README and historical private publication drafts;
- `reviewer-packet/` and targeted reviewer correspondence;
- phase-internal integration, readiness, and disposition documents;
- private branches, PR references, and private export manifests; and
- local build caches, credentials, environment files, and editor metadata.

The original private repository remains the authoritative preservation copy of
its own history. This public tree is a disclosure-curated derivative.

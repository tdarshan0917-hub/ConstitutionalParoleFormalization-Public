# Reproducibility

## Environment

- Lean toolchain: `leanprover/lean4:v4.35.0`
- Lake packages: none outside Lean's pinned distribution
- Node.js: required for the fail-closed audit scripts

## Verification sequence

Run from the repository root:

```bash
lake build ConstitutionalParole
node checks/integrity.mjs
lake env lean ConstitutionalParole/Audit.lean
node checks/dependency-audit.mjs
node checks/publication-consistency.mjs
node checks/public-tree-scan.mjs
```

Expected bounded results:

- 7 Lean source files;
- 51 inventoried theorems;
- 2 verified legal-source records in the claims ledger;
- 11 formal/public claims;
- no `sorry`, `admit`, custom axiom, unsafe declaration, forbidden import, or
  unmapped public theorem;
- dependency output limited to Lean's recorded `propext` and `Quot.sound`;
- 16 publication-audit claims and five principal manuscript findings; and
- no internal reviewer material or recognized secret pattern in the public
  tree.

GitHub Actions also invokes `leanchecker` through the pinned Lean action. A
passing build establishes that the encoded conclusions follow from their
premises. It does not authenticate those premises, validate the legal
interpretation, or establish a real-world violation, cure, remedy, or outcome.

## Artifact integrity

`verification/PUBLIC_TREE_SHA256.txt` hashes every tracked release file except
the ledger itself. `verification/FORMAL_SOURCE_COMPARISON.txt` records the
byte-comparison result against formal source commit `292ed75…`.

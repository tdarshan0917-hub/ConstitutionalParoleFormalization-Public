import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const failures = [];

function fail(message) {
  failures.push(message);
}

function filesUnder(directory) {
  const output = [];
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) output.push(...filesUnder(full));
    else output.push(full);
  }
  return output;
}

const required = [
  "lean-toolchain",
  "lakefile.toml",
  "ConstitutionalParole.lean",
  "ConstitutionalParole/Model.lean",
  "ConstitutionalParole/Assessment.lean",
  "ConstitutionalParole/Trace.lean",
  "ConstitutionalParole/Examples.lean",
  "ConstitutionalParole/NegativeControls.lean",
  "ConstitutionalParole/Audit.lean",
  "docs/SOURCE_GATE.md",
  "docs/RESEARCH_CONTRACT.md",
  "docs/THEOREM_TO_CLAIM_MAP.md",
  "docs/INTERPRETATION_LEDGER.md",
  "docs/COUNTERMODEL_REPORT.md",
  "docs/LIMITATIONS_ASSESSMENT.md",
  "docs/DEPENDENCY_AUDIT.md",
  "docs/PUBLICATION_CLAIM_AUDIT.md",
  "docs/REVIEW_STATUS.md",
  "publications/markdown/ONE_PAGE_RESEARCH_SUMMARY.md",
  "publications/markdown/PUBLIC_RESEARCH_REPORT.md",
  "publications/markdown/TECHNICAL_RESEARCH_PAPER.md",
  "publications/pdf/ONE_PAGE_RESEARCH_SUMMARY.pdf",
  "publications/pdf/PUBLIC_RESEARCH_REPORT.pdf",
  "publications/pdf/TECHNICAL_RESEARCH_PAPER.pdf",
  "README.md",
  "PROVENANCE.md",
  "REPRODUCIBILITY.md",
  "RIGHTS.md",
  "LICENSE",
  "LICENSE-DOCUMENTS.md",
  "CITATION.cff",
  "release/RELEASE_NOTES_v1.0.0-preprint.md",
  "release/RELEASE_NOTES_v1.0.1-preprint.md",
  "publication/zenodo_metadata.json",
  "publication/ZENODO_DEPOSIT_GUIDE.md",
  "claims/claims.json",
  "audit/theorem-inventory.json",
  "audit/expected-axioms.json",
  "checks/dependency-audit.mjs",
  "checks/publication-consistency.mjs",
  "checks/public-tree-scan.mjs",
  ".github/workflows/verify.yml"
];

for (const relative of required) {
  if (!fs.existsSync(path.join(root, relative))) fail(`missing required file: ${relative}`);
}

const toolchain = fs.readFileSync(path.join(root, "lean-toolchain"), "utf8").trim();
if (toolchain !== "leanprover/lean4:v4.35.0") {
  fail(`unexpected toolchain pin: ${toolchain}`);
}

const leanFiles = filesUnder(path.join(root, "ConstitutionalParole"))
  .filter((file) => file.endsWith(".lean"))
  .concat(path.join(root, "ConstitutionalParole.lean"));

const theoremNames = new Set();
for (const file of leanFiles) {
  const source = fs.readFileSync(file, "utf8");
  const relative = path.relative(root, file);
  for (const token of ["sorry", "admit"]) {
    if (new RegExp(`\\b${token}\\b`).test(source)) fail(`${relative}: forbidden token ${token}`);
  }
  if (/^\s*axiom\s+/m.test(source)) fail(`${relative}: custom axiom declaration`);
  if (/^\s*(unsafe|partial|opaque|extern)\s+/m.test(source) || /@\[implemented_by\b/m.test(source)) {
    fail(`${relative}: unsafe, partial, opaque, external, or implementation-substitution declaration`);
  }
  if (/^\s*import\s+.*(ParoleProceduralIntegrity|ProtectivePathways|Magnifica|BeyondTheCurve)/m.test(source)) {
    fail(`${relative}: forbidden existing-project import`);
  }
  for (const match of source.matchAll(/^theorem\s+([A-Za-z0-9_']+)/gm)) {
    theoremNames.add(match[1]);
  }
}

const manifest = JSON.parse(fs.readFileSync(path.join(root, "lake-manifest.json"), "utf8"));
if ((manifest.packages ?? []).length !== 0) fail("external Lake packages are not permitted in Prototype 0.1");

const inventory = JSON.parse(fs.readFileSync(path.join(root, "audit/theorem-inventory.json"), "utf8"));
const inventoryNames = inventory.theorems.map((entry) => entry.name);
const inventorySet = new Set(inventoryNames);
if (inventoryNames.length !== inventorySet.size) fail("duplicate theorem in theorem inventory");
if (inventory.expectedTheoremCount !== theoremNames.size) {
  fail(`theorem count changed: expected ${inventory.expectedTheoremCount}, found ${theoremNames.size}`);
}
for (const theorem of theoremNames) {
  if (!inventorySet.has(theorem)) fail(`theorem missing from inventory: ${theorem}`);
}
for (const theorem of inventorySet) {
  if (!theoremNames.has(theorem)) fail(`inventoried theorem missing from Lean source: ${theorem}`);
}

const auditSource = fs.readFileSync(path.join(root, "ConstitutionalParole/Audit.lean"), "utf8");
const auditedNames = [...auditSource.matchAll(/^#print axioms\s+([A-Za-z0-9_']+)/gm)]
  .map((match) => match[1]);
const auditedSet = new Set(auditedNames);
if (auditedNames.length !== auditedSet.size) fail("duplicate #print axioms entry");
for (const theorem of theoremNames) {
  if (!auditedSet.has(theorem)) fail(`theorem missing from dependency audit: ${theorem}`);
}
for (const theorem of auditedSet) {
  if (!theoremNames.has(theorem)) fail(`dependency audit names unknown theorem: ${theorem}`);
}

const expectedAxioms = JSON.parse(fs.readFileSync(path.join(root, "audit/expected-axioms.json"), "utf8"));
const expectedAxiomNames = new Set(Object.keys(expectedAxioms.expected ?? {}));
for (const theorem of theoremNames) {
  if (!expectedAxiomNames.has(theorem)) fail(`theorem missing expected-axiom baseline: ${theorem}`);
}
for (const theorem of expectedAxiomNames) {
  if (!theoremNames.has(theorem)) fail(`expected-axiom baseline names unknown theorem: ${theorem}`);
}
const allowedAxioms = new Set(expectedAxioms.allowedLeanAxioms ?? []);
for (const [theorem, axioms] of Object.entries(expectedAxioms.expected ?? {})) {
  for (const axiom of axioms) {
    if (!allowedAxioms.has(axiom)) fail(`${theorem}: unapproved expected axiom ${axiom}`);
  }
}

const ledger = JSON.parse(fs.readFileSync(path.join(root, "claims/claims.json"), "utf8"));
const sourceKeys = new Set();
for (const source of ledger.sources ?? []) {
  if (!source.key || sourceKeys.has(source.key)) fail(`invalid or duplicate source key: ${source.key}`);
  sourceKeys.add(source.key);
  for (const field of ["jurisdiction", "authority", "date", "url", "anchors", "status"]) {
    if (!source[field]) fail(`${source.key}: missing source field ${field}`);
  }
  if (!/^https:\/\//.test(source.url ?? "")) fail(`${source.key}: source URL must use https`);
}

const claimIds = new Set();
for (const claim of ledger.claims ?? []) {
  if (!claim.claimId || claimIds.has(claim.claimId)) fail(`invalid or duplicate claimId: ${claim.claimId}`);
  claimIds.add(claim.claimId);
  if (!claim.text) fail(`${claim.claimId}: missing plain-language text`);
  if (!claim.verificationStatus) fail(`${claim.claimId}: missing verification status`);
  for (const citation of claim.citations ?? []) {
    if (!sourceKeys.has(citation)) fail(`${claim.claimId}: unresolved citation ${citation}`);
  }
  const legalClaim = !(claim.verificationStatus ?? "").includes("modeling_rule") &&
    !(claim.verificationStatus ?? "").includes("formal_operational");
  if (legalClaim && (claim.citations ?? []).length === 0) {
    fail(`${claim.claimId}: legal claim lacks a verified corpus citation`);
  }
  for (const theorem of claim.theorems ?? []) {
    if (!theoremNames.has(theorem)) fail(`${claim.claimId}: theorem not found: ${theorem}`);
  }
}

for (const entry of inventory.theorems ?? []) {
  for (const claimId of entry.claims ?? []) {
    if (!claimIds.has(claimId)) fail(`${entry.name}: unresolved inventory claim ${claimId}`);
  }
  if (!entry.category || !entry.strength || !Array.isArray(entry.assumptions)) {
    fail(`${entry.name}: incomplete theorem classification`);
  }
}

if (failures.length > 0) {
  console.error(`Integrity audit failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`Integrity audit passed: ${leanFiles.length} Lean files, ${theoremNames.size} theorems, ${sourceKeys.size} verified sources, ${claimIds.size} claims.`);

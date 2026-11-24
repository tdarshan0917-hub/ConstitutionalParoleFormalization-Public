import fs from "node:fs";
import { spawnSync } from "node:child_process";

const baseline = JSON.parse(fs.readFileSync("audit/expected-axioms.json", "utf8"));
const expected = baseline.expected ?? {};
const allowed = new Set(baseline.allowedLeanAxioms ?? []);

const run = spawnSync("lake", ["env", "lean", "ConstitutionalParole/Audit.lean"], {
  encoding: "utf8"
});
const output = `${run.stdout ?? ""}\n${run.stderr ?? ""}`;
if (run.status !== 0) {
  process.stderr.write(output);
  process.exit(run.status ?? 1);
}

const observed = new Map();
for (const line of output.split(/\r?\n/)) {
  let match = line.match(/^'ConstitutionalParole\.([A-Za-z0-9_']+)' does not depend on any axioms$/);
  if (match) {
    observed.set(match[1], []);
    continue;
  }
  match = line.match(/^'ConstitutionalParole\.([A-Za-z0-9_']+)' depends on axioms: \[(.*)\]$/);
  if (match) {
    const axioms = match[2].trim() === "" ? [] : match[2].split(",").map((value) => value.trim());
    observed.set(match[1], axioms);
  }
}

const failures = [];
const expectedNames = new Set(Object.keys(expected));
if (observed.size !== expectedNames.size) {
  failures.push(`expected ${expectedNames.size} theorem audit results, observed ${observed.size}`);
}

for (const [theorem, expectedAxioms] of Object.entries(expected)) {
  const actual = observed.get(theorem);
  if (!actual) {
    failures.push(`${theorem}: missing dependency result`);
    continue;
  }
  for (const axiom of actual) {
    if (!allowed.has(axiom)) failures.push(`${theorem}: unapproved axiom ${axiom}`);
  }
  const expectedSorted = [...expectedAxioms].sort();
  const actualSorted = [...actual].sort();
  if (JSON.stringify(expectedSorted) !== JSON.stringify(actualSorted)) {
    failures.push(`${theorem}: expected [${expectedSorted.join(", ")}], observed [${actualSorted.join(", ")}]`);
  }
}

for (const theorem of observed.keys()) {
  if (!expectedNames.has(theorem)) failures.push(`${theorem}: unexpected theorem in dependency output`);
}

if (failures.length > 0) {
  console.error(`Dependency audit failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`Dependency audit passed: ${observed.size} theorems; allowed dependencies limited to ${[...allowed].join(", ")}.`);

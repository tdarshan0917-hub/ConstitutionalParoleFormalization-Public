import fs from 'node:fs';
import path from 'node:path';

const roots = ['.'];
const excludedDirectories = new Set(['.git', '.lake', '.release']);
const binaryExtensions = new Set(['.pdf', '.zip']);
const failures = [];

function walk(current) {
  for (const entry of fs.readdirSync(current, {withFileTypes: true})) {
    if (excludedDirectories.has(entry.name)) continue;
    const full = path.join(current, entry.name);
    if (entry.isDirectory()) walk(full);
    else inspect(full);
  }
}

function inspect(file) {
  const relative = path.relative('.', file);
  if (/reviewer-packet|PRIVATE_DRAFT|REVIEW_DISPOSITION|FORMAL_METHODS_REVIEW_REQUEST|PAROLE_LAW_REVIEW_REQUEST/i.test(relative)) {
    failures.push(`internal-review path: ${relative}`);
  }
  if (/^\.env(?:\.|$)|\.(?:pem|key|p12)$/i.test(path.basename(file))) {
    failures.push(`sensitive file type: ${relative}`);
  }
  if (binaryExtensions.has(path.extname(file).toLowerCase())) return;
  const text = fs.readFileSync(file, 'utf8');
  const patterns = [
    /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/,
    /\b(?:AKIA|ASIA)[0-9A-Z]{16}\b/,
    /\bgithub_pat_[A-Za-z0-9_]{20,}\b/,
    /\bgh[pousr]_[A-Za-z0-9]{20,}\b/,
    /\bsk-[A-Za-z0-9]{20,}\b/,
    /Authorization:\s*(?:Bearer|Basic)\s+[A-Za-z0-9+/=_-]{10,}/i,
    /github\.com\/tdarshan0917-hub\/ConstitutionalParoleFormalization(?:\/|\.git|$)/
  ];
  for (const pattern of patterns) {
    if (pattern.test(text)) failures.push(`prohibited content ${pattern} in ${relative}`);
  }
}

for (const root of roots) walk(root);

if (failures.length) {
  for (const failure of failures) console.error(`FAIL: ${failure}`);
  process.exit(1);
}

console.log('Public-tree scan passed: no internal reviewer path, private source URL, recognized credential pattern, or sensitive key/environment file.');

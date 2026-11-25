import fs from 'node:fs';

const read = path => fs.readFileSync(path, 'utf8');
const summary = read('publications/markdown/ONE_PAGE_RESEARCH_SUMMARY.md');
const report = read('publications/markdown/PUBLIC_RESEARCH_REPORT.md');
const paper = read('publications/markdown/TECHNICAL_RESEARCH_PAPER.md');
const audit = read('docs/PUBLICATION_CLAIM_AUDIT.md');
const mitLicense = read('LICENSE');
const documentLicense = read('LICENSE-DOCUMENTS.md');
const inventory = JSON.parse(read('audit/theorem-inventory.json'));
const corpus = [summary, report, paper, audit].join('\n').replace(/\s+/g, ' ');

const failures = [];
const requireCheck = (condition, message) => {
  if (!condition) failures.push(message);
};

for (const [name, text] of Object.entries({summary, report, paper})) {
  requireCheck(
    text.includes('Independent Research Preprint — Not Peer-Reviewed'),
    `${name} lacks exact preprint status`
  );
  requireCheck(
    /Independent legal and formal-methods reviews have not been obtained\./.test(text),
    `${name} lacks independent-review disclosure`
  );
  requireCheck(
    /CC BY\s+4\.0/.test(text) && /Third-party material retains\s+its own rights\./.test(text),
    `${name} lacks scoped CC BY 4.0 and third-party-rights notice`
  );
}

requireCheck(!/PRIVATE DRAFT|Internal independent-review draft|not approved for public release/i.test(corpus), 'internal/private publication status remains');
requireCheck(summary.trim().split(/\s+/).length >= 450 && summary.trim().split(/\s+/).length <= 575, 'summary is outside 450–575 words');
requireCheck((report.match(/^## Finding \d/gm) || []).length === 5, 'public report does not contain five principal findings');
requireCheck((audit.match(/^\|\s*`(?:CPF|PUB)-[A-Z]+-\d{3}`\s*\|/gm) || []).length === 16, 'publication audit does not contain 16 claims');
requireCheck(inventory.expectedTheoremCount === 51 && inventory.theorems.length === 51, 'theorem inventory is not 51');
requireCheck(/role-event (?:entries|list).{0,120}prefix/i.test(corpus), 'exact prefix result is missing');
requireCheck(/externally supplied/i.test(corpus) && /`verified`, `complete`, and `validated`/i.test(corpus), 'external evidence labels are not disclosed');
requireCheck(/trace model does not enforce|trace relation.{0,100}does not enforce/i.test(corpus), 'trace/classifier separation is missing');
requireCheck(/not theorem consequences|motivate.{0,80}do not prove|motivated by/i.test(corpus), 'recommendation/theorem boundary is missing');
requireCheck(!/complete earlier conflict history is preserved/i.test(corpus), 'overbroad conflict-history claim remains');
requireCheck(fs.existsSync('LICENSE') && fs.existsSync('LICENSE-DOCUMENTS.md'), 'dual-license files are missing');
requireCheck(
  mitLicense.startsWith('MIT License\n\nCopyright (c) 2026 Travis Darshan') &&
    mitLicense.includes('THE SOFTWARE IS PROVIDED "AS IS"'),
  'root LICENSE is not the approved standard MIT text'
);
requireCheck(
  documentLicense.includes('Creative Commons Attribution 4.0 International') &&
    documentLicense.includes('publications/markdown/ONE_PAGE_RESEARCH_SUMMARY.md') &&
    documentLicense.includes('publications/markdown/PUBLIC_RESEARCH_REPORT.md') &&
    documentLicense.includes('publications/markdown/TECHNICAL_RESEARCH_PAPER.md') &&
    /third-party material/i.test(documentLicense),
  'document license is missing scope or third-party-rights protection'
);

if (failures.length) {
  for (const failure of failures) console.error(`FAIL: ${failure}`);
  process.exit(1);
}

console.log(`Publication consistency passed: ${summary.trim().split(/\s+/).length} summary words, 5 findings, 16 claims, 51 theorems.`);

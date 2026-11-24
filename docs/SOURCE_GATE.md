# Source Gate

**Gate date:** 2026-11-14
**Scope:** preliminary parole-revocation decisionmaker independence only
**Result:** pass for a conditional proof of concept; blocked for real-matter or
remedial conclusions.

## Federal constitutional source

`USSC-MORRISSEY-1972` — [*Morrissey v. Brewer*, 408 U.S. 471,
480–87 (1972)](https://tile.loc.gov/storage-services/service/ll/usrep/usrep408/usrep408471/usrep408471.pdf),
U.S. Supreme Court, decided 1972-06-29.

Established holding relevant here:

- A person actually released on parole has conditional liberty protected by
  the Fourteenth Amendment when the state seeks revocation. 408 U.S. at
  480–82.
- The preliminary stage described by the Court follows arrest and detention
  and tests whether reasonable ground exists to believe a parole condition was
  violated. Id. at 485–87.
- That preliminary determination must be made by someone not directly involved
  in the case. The Court identified as sufficient a parole officer other than
  the person who reported the violations or recommended revocation. Id. at
  485–86.
- The decisionmaker may be an administrative officer and need not be a judge or
  lawyer. Institutional employment alone is therefore not the disqualifier.

Applicability limits: the holding concerns revocation of conditional liberty,
not an initial application for discretionary release. It distinguishes the
preliminary probable-cause inquiry from the later final revocation hearing.

## New York statutory source

`NY-EXC-259I-REV-2025` — [N.Y. Executive Law § 259-i(3), revision displayed
2025-05-16](https://www.nysenate.gov/legislation/laws/EXC/259-I), New York,
official Open Legislation text checked 2026-11-24. The relevant current text is
effective before the scheduled 2027-09-01 changes.

Established current text relevant here:

- Subdivision (3) addresses alleged violations by persons on presumptive
  release, parole, conditional release, or post-release supervision.
- Section 259-i(3)(c)(i)(A) requires a preliminary revocation hearing within ten
  days for the specified technical-violation notice/recognizance branch and
  bars a designated hearing officer who had prior supervisory involvement over
  the alleged violator.
- Section 259-i(3)(c)(i)(B) requires a preliminary hearing within five days for
  the specified detention-order branch and uses the same prior-supervisory-
  involvement restriction. It also describes a ten-day recognizance branch.
- Section 259-i(3)(d) recognizes a probable-cause finding by preliminary
  hearing or waiver and separately addresses a new-crime conviction branch.

This is a statutory predicate, not a restatement of *Morrissey*. “Reported or
recommended revocation” and “prior supervisory involvement” remain separate
relations in the model.

## Conditions admitted to the prototype

The model accepts `PreliminaryDisposition.required` as an externally supplied
classification. Before real-world use, the applicable trigger, timing,
custody/recognizance route, conviction branch, and any waiver would require
verification outside Lean. It accepts `validlyWaived` only as an externally
supplied premise; Lean does not establish legal validity, and silence or missing
evidence never becomes a waiver.

The federal predicate is deliberately limited to literal `parole`, the status
squarely addressed in *Morrissey*. New York’s statutory predicate covers the
four statuses listed in the current statute. Broader federal treatment of
conditional release or post-release supervision is not decided in Prototype
0.1.

## Unresolved legal questions and blockers

1. Current citator treatment of *Morrissey* and New York decisions applying its
   preliminary-independence rule must be completed before production reliance.
2. The full legal boundary of “directly involved” beyond reporting or
   recommending revocation is not encoded.
3. “Prior supervisory involvement” needs authoritative interpretation and a
   temporal/matter-specific relation before use on real facts.
4. Valid waiver requires a verified rule for voluntariness, knowledge, scope,
   timing, counsel, and documentation.
5. The exact effect of a new conviction, release on recognizance, absence of
   detention, admissions, or other displaced stages is not fully formalized.
6. Prototype 0.1 does not decide whether a later independent proceeding cures,
   moots, or remedies an earlier conflict.
7. The future-effective 2027 statutory text must be versioned separately.

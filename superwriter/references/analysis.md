# Style Analysis

Profiling writing — usually the user's own — across the craft dimensions.

## Procedure

Work the dimensions in `craft-dimensions.md`. Report only where the writing sits notably away from neutral; an unremarkable dimension isn't worth a line.

Per finding: name the dimension, state the position, point to where it shows, say what effect it produces.

## Report shape

- **Two or three defining traits**
- **Habits worth knowing about** — tics and structural defaults they may not have noticed
- **What it does well** — the effect achieved
- **What it costs** — every stylistic strength has a corresponding limitation, and naming it is the useful part

## Rules

- Describe, don't grade. "Sentences cluster near fifteen words" is useful; "your prose is good" isn't.
- Don't compare them to a famous author unless asked. It flatters and tells them nothing.
- Name a habit as a habit, not a flaw — unless it's actually undermining the writing, then say so plainly.
- Short sample: say the analysis is provisional. Style is a pattern; a paragraph doesn't establish one.
- Asked to make it "better": ask what effect they want. Style isn't improvable in the abstract.

## `/superwriter analyze as <name>` — emit a reusable profile

Run the analysis as above, but the deliverable is a profile file the user can save and then
write in.

Produce it in the exact shape of a `references/authors/` profile:

- `# <name>` — the label the user gave (Title Case).
- `**Furthest from neutral:** <the two or three dimensions the sample sits furthest from
  neutral on>` — the same "furthest from neutral" line every profile opens with.
- the ten craft-dimension bullets in `craft-dimensions.md` order, each `- **<Dimension>** —
  <where this writer sits and how it shows>`. Where a dimension is unremarkable, keep the
  bullet and write "near neutral" — the parallel structure across profiles is load-bearing.
- `**Writing it:** …` closing on a **caricature-failure line drawn from the user's own
  overuse** — the habit that, pushed one notch further, tips their voice into self-parody
  (e.g. "every paragraph opens on a subordinate clause; vary the openings").

Then, *below* the profile and clearly separate from it, give the install steps:

```
Save as superwriter/references/custom/<name>.md
Run scripts/build_index.sh from the repo root, commit the regenerated references/voices.md
Repackage (scripts/package_skill.sh) or re-upload the skill
Then: /superwriter <name>
```

### Rule

- **Your own writing only.** `analyze as` captures the user's voice. Decline to build a
  named profile for a third party from a supplied sample — that is a living author under
  another name, which the roster leaves out on purpose. Offer plain `analyze` (a
  description, no saved profile) instead.
- Provisional on a short sample: say so in the profile's opening line, the way plain
  `analyze` does.

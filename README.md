# superwriter

A Claude skill that writes in a named author's manner — or in a functional writing
register — either generating new text in that style, or rewriting text you supply while
keeping its meaning intact.

Twelve public-domain author voices and six registers (plain English, academic, journalistic,
corporate, legal, technical), plus tools to profile your own style and to blend two
influences. The skill decomposes each style into ten craft dimensions (rhythm, syntax,
narrative distance, selection, and so on) rather than storing surface tics, so the output
reads as the writer's *manner* rather than as costume.

The skill is stateless — it never writes files to your account.

## Install

1. In Claude, **Settings → Capabilities** → enable **Code execution and file creation**.
   (If the Skills menu is missing or greyed out, this is why — not a plan limitation.)
2. Go to **Customize → Skills** — <https://claude.ai/customize/skills>
3. **+** → **Create skill** → **Upload a skill**
4. Select `superwriter.skill` from the [latest release](../../releases/latest), toggle it on.
5. Start a **new** conversation — skills load at session start.

Docs: <https://support.claude.com/en/articles/12512180-use-skills-in-claude>

## How to use

The skill has two modes and three extra commands. It picks the mode automatically from
whether you've supplied a body of text to work on.

### Generate — new writing in a voice

Name an author and describe what you want. Use `—` (or `-`) to separate the author from the
brief.

```
/superwriter Hemingway — a scene where two people decide to separate
/superwriter Austen — a letter politely declining a dinner invitation
/superwriter Woolf — a paragraph about waiting for a train
/superwriter journalistic — a 150-word story on a local bridge closure
/superwriter plain English — instructions for resetting a password
```

### Transform — rewrite existing text in a voice

Paste or write the text, then add `/superwriter <author>`. The rewrite changes rhythm,
syntax, distance, and diction — but every claim, fact, name, number, and the order of the
argument is preserved. It won't invent detail to fill a stylistic rhythm, and it flags a
bad fit (e.g. technical documentation in Woolf's manner) before proceeding.

```
Our Q3 numbers missed target by 4%, mostly from the delayed EU launch.
We're pulling the launch forward to October and holding headcount flat.

/superwriter Orwell
```

Registers work the same way — `/superwriter academic`, `/superwriter legal`,
`/superwriter corporate` — and are often the more practical choice for real documents.

A short prompt is treated as *generate*; more than a paragraph of supplied text is treated
as *transform*. If it's ambiguous, say which you want.

### Strength

Add `light`, `medium`, or `strong` after the voice to set how hard the style is pushed.
`medium` is the default.

```
/superwriter Hemingway light — a paragraph about a delayed train
/superwriter Woolf strong — the same paragraph
```

- **light** — one signature dimension, a touch. Reads as "influenced by."
- **medium** — the two or three signature dimensions. Default.
- **strong** — pushed hard, still short of self-parody.

### `/superwriter list`

Prints every voice with its defining trait, from the generated `references/voices.md`.

### `/superwriter analyze`

Profiles a piece of writing — usually your own — across the craft dimensions: its two or
three defining traits, structural habits you may not have noticed, what the style does well,
and what it costs. Paste the writing you want analysed.

```
[paste 3–4 paragraphs of your own writing]

/superwriter analyze
```

### `/superwriter blend <a> + <b>`

Combines two voices by assigning dimensions to each source rather than averaging them
(averaging just produces neutrality). It tells you which dimensions came from which author.
Works best when the two writers are unlike each other.

```
/superwriter blend Hemingway + Woolf — a scene at a hospital bedside
/superwriter blend Twain + Kafka — a man tries to renew a permit
/superwriter blend Hemingway + journalistic — a dispatch from a flooded town
```

An author may be blended with a register, not just with another author.

## The twelve voices

| Voice | Furthest from neutral |
|---|---|
| **Shakespeare** | Syntactic inversion; dense, mutating metaphor; thought worked out aloud and reversed mid-speech. |
| **Austen** | Free indirect style; ironic distance; judgment delivered as if it were plain fact. |
| **Hemingway** | Load-bearing omission; parataxis (clauses joined by *and*); feeling kept entirely in subtext. |
| **Woolf** | Narrative distance that dissolves between minds mid-paragraph; time as depth rather than sequence. |
| **Dickens** | The inanimate given intention; accumulative anaphoric rhythm; characters fixed by a single verbal tic. |
| **Twain** | Vernacular first person; deadpan delivery; satire through a narrator who understands less than the reader. |
| **Poe** | A narrator insisting on his rationality as it collapses; rhythm engineered for mounting pressure. |
| **Wilde** | The epigram; received wisdom inverted; polished surface that treats sincerity as vulgar — until one plain line. |
| **Orwell** | Plainness pursued as an ethical position; a concrete physical detail made to carry the argument. |
| **Kafka** | An impossible premise reported in bureaucratic calm; subordination that enacts entrapment. |
| **Melville** | Register shifting without warning — manual to sermon to soliloquy; digression as structure. |
| **Chekhov** | Refusal to conclude; moral neutrality toward characters the reader expects him to judge. |

## The six registers

Functional styles rather than individual writers — defined by the job the text has to do.

| Register | Furthest from neutral |
|---|---|
| **Plain English** | Low syntactic load as policy; the reader's task as the organizing principle; abstraction actively removed. |
| **Academic** | Claims hedged to their real strength and attributed; nominalized abstraction; the field foregrounded over the writer. |
| **Journalistic** | Inverted pyramid; every contestable claim attributed; the paragraph as the unit, one or two sentences each. |
| **Corporate / Business** | Conclusion first (BLUF); action and owner named; brevity as respect for the reader's time. |
| **Legal / Contractual** | Precision over readability by design; defined terms in place of pronouns; exhaustive enumeration. |
| **Technical** | Reader is mid-task; imperative mood; structure optimized for scanning and non-linear entry. |

No profile for the author or register you asked for? The skill says so and offers the
nearest one, or to work from a passage you supply as a model — it won't improvise a profile
from general impressions, because that produces caricature.

## Worked example

**Input:**

```
The meeting ran long. Everyone was tired. Nobody wanted to be the one to say
the project was dead, so we scheduled another meeting.

/superwriter Hemingway
```

**Output (illustrative):**

> The meeting ran long. The room was hot and the coffee was finished. Nobody
> said the project was dead. It was dead and everyone knew it and nobody said
> it. We agreed to meet again on Thursday. Somebody wrote it down.

The facts are unchanged — the length, the fatigue, the unspoken conclusion, the next
meeting. What changed is the parataxis, the repetition of *dead* and *said*, and the flat
final detail carrying what nobody will say.

## Structure

```
superwriter/
├── SKILL.md                      # Router, mode detection, standing rules
└── references/
    ├── craft-dimensions.md       # Shared vocabulary — loads on every request
    ├── transform.md              # Transform procedure + content-drift checks
    ├── analysis.md
    ├── blending.md
    ├── authors/                  # 12 author profiles
    └── registers/                # 6 functional-register profiles
```

Only `SKILL.md` + `craft-dimensions.md` + **one** profile load per request (~8.4 KB
worst case) — the token budget is a deliberate design constraint. Adding registers doesn't
change the worst case: each register profile is smaller than the largest author profile,
and still only one profile loads per request.

## Standing rules

- **No reproduced passages.** Writes in the manner; never quotes or reconstructs the
  author's actual sentences.
- **No fabricated attribution.** Output is pastiche. Forged letters, "unpublished
  fragments," or quotes attributed to the author are declined.
- **Transform: meaning is fixed.** Every claim, fact, name, number, and the argument's order
  survives.

The roster is public-domain by design. Imitating living authors is legally fine but messier
for a public repo — add your own profiles locally if you want them.

## Development

- `bash scripts/validate_skill.sh` — checks the `superwriter/` source: two-key frontmatter,
  one-line description, `name: superwriter`, the required reference files with no unexpected
  extras, exactly 12 author profiles, exactly 6 register profiles, every voice listed in
  `SKILL.md` backed by a profile file, the `## Strength` and `## Before returning` sections,
  and that `references/voices.md` matches a fresh `build_index.sh` run.
- `bash scripts/build_index.sh` — regenerates `superwriter/references/voices.md` (the
  annotated list `/superwriter list` reads). Run it after adding, removing, or renaming a
  profile; `validate_skill.sh` fails if the committed file is stale.
- `bash scripts/package_skill.sh` — builds `superwriter.skill` (a ZIP with `superwriter/` at
  the archive root; `.skill` is just a renamed ZIP).

CI (`.github/workflows/skill.yml`) runs validation + packaging on every push and pull
request. Pushing a tag matching `v*` validates, packages, and publishes a GitHub Release
with `superwriter.skill` attached.

### Cutting a release

```
git tag v2
git push origin v2
```

### Adding an author or register

Copy an existing profile from `references/authors/` (or `references/registers/`), keep the
same ten-part shape and compression, name where the style sits furthest from neutral, and
end with the caricature failure to avoid. Then add the name to the Voices list in `SKILL.md`
**and to the `description` field** — skipping that last step means it never triggers. Keep
new profiles at or below the size of the largest existing one so the per-request budget
holds.

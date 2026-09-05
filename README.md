# superwriter

A Claude skill that writes in a named author's manner, a functional writing register, or a
verse form, either generating new text in that style, or rewriting text you supply while
keeping its meaning intact.

Twelve public-domain author voices and six registers (plain English, academic, journalistic,
corporate, legal, technical), six verse forms (sonnet, blank verse, heroic couplet, ballad,
free verse, haiku), plus tools to profile your own style and to blend two
influences. The skill decomposes each style into ten craft dimensions (rhythm, syntax,
narrative distance, selection, and so on) rather than storing surface tics, so the output
reads as the writer's *manner* rather than as costume.

The skill is stateless. It never writes files to your account.

## Install

1. In Claude, **Settings → Capabilities** → enable **Code execution and file creation**.
   (If the Skills menu is missing or greyed out, this is why, not a plan limitation.)
2. Go to **Customize → Skills**: <https://claude.ai/customize/skills>
3. **+** → **Create skill** → **Upload a skill**
4. Select `superwriter.skill` from the [latest release](../../releases/latest), toggle it on.
5. Start a **new** conversation. Skills load at session start.

Docs: <https://support.claude.com/en/articles/12512180-use-skills-in-claude>

## How to use

The skill has two modes and four extra commands. It picks the mode automatically from
whether you've supplied a body of text to work on.

### Generate: new writing in a voice

Name an author and describe what you want. Use `:` (or `-`) to separate the author from the
brief.

```
/superwriter Hemingway: a scene where two people decide to separate
/superwriter Austen: a letter politely declining a dinner invitation
/superwriter Woolf: a paragraph about waiting for a train
/superwriter journalistic: a 150-word story on a local bridge closure
/superwriter plain English: instructions for resetting a password
```

### Transform: rewrite existing text in a voice

Paste or write the text, then add `/superwriter <author>`. The rewrite changes rhythm,
syntax, distance, and diction, but every claim, fact, name, number, and the order of the
argument is preserved. It won't invent detail to fill a stylistic rhythm, and it flags a
bad fit (e.g. technical documentation in Woolf's manner) before proceeding.

```
Our Q3 numbers missed target by 4%, mostly from the delayed EU launch.
We're pulling the launch forward to October and holding headcount flat.

/superwriter Orwell
```

Registers work the same way (`/superwriter academic`, `/superwriter legal`,
`/superwriter corporate`) and are often the more practical choice for real documents.

A short prompt is treated as *generate*; more than a paragraph of supplied text is treated
as *transform*. If it's ambiguous, say which you want.

### Strength

Add `light`, `medium`, or `strong` after the voice to set how hard the style is pushed.
`medium` is the default.

```
/superwriter Hemingway light: a paragraph about a delayed train
/superwriter Woolf strong: the same paragraph
```

- **light:** one signature dimension, a touch. Reads as "influenced by."
- **medium:** the two or three signature dimensions. Default.
- **strong:** pushed hard, still short of self-parody.

### `/superwriter <voice> --example`

Show a short, newly written passage in a voice (with a note on which craft dimensions it
demonstrates) before you commit to a full piece. Works for any author, register, or form.

```
/superwriter Woolf --example
/superwriter heroic couplet --example
```

The examples live in `references/examples/` and load only when asked, so they cost nothing
on a normal request.

### `/superwriter list`

Prints every voice with its defining trait, from the generated `references/voices.md`.

### `/superwriter analyze`

Profiles a piece of writing, usually your own, across the craft dimensions: its two or
three defining traits, structural habits you may not have noticed, what the style does well,
and what it costs. Paste the writing you want analysed.

```
[paste 3-4 paragraphs of your own writing]

/superwriter analyze
```

### `/superwriter analyze as <name>`

Same analysis as `analyze`, but the output is a **profile** in the skill's own format,
plus the steps to install it. Save it to `references/custom/`, regenerate the index, and
`/superwriter <name>` writes in your voice from then on.

```
[paste 3-4 paragraphs of your own writing]

/superwriter analyze as me
```

It only works on your own writing. The skill declines to build a named profile for a
third party from a pasted sample.

### `/superwriter blend <a> + <b>`

Combines two voices by assigning dimensions to each source rather than averaging them
(averaging just produces neutrality). It tells you which dimensions came from which author.
Works best when the two writers are unlike each other.

```
/superwriter blend Hemingway + Woolf: a scene at a hospital bedside
/superwriter blend Twain + Kafka: a man tries to renew a permit
/superwriter blend Hemingway + journalistic: a dispatch from a flooded town
```

An author may be blended with a register, not just with another author.

### `/superwriter proofread`

Fixes objective errors only: spelling, grammar, and punctuation. Voice, diction, sentence
structure, and register are left exactly as written. It's the opposite emphasis of
Transform: proofread never changes how something is said, only whether it's said correctly.

```
Our Q3 numbers missed target by 4%, mostly from the delayed EU launch. We we're
pulling the launch foward to October and holding headcount flat.

/superwriter proofread
```

Any fix that required a judgment call about intended meaning is flagged in one line rather
than made silently.

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
| **Wilde** | The epigram; received wisdom inverted; polished surface that treats sincerity as vulgar, until one plain line. |
| **Orwell** | Plainness pursued as an ethical position; a concrete physical detail made to carry the argument. |
| **Kafka** | An impossible premise reported in bureaucratic calm; subordination that enacts entrapment. |
| **Melville** | Register shifting without warning (manual to sermon to soliloquy); digression as structure. |
| **Chekhov** | Refusal to conclude; moral neutrality toward characters the reader expects him to judge. |

## The six registers

Functional styles rather than individual writers, defined by the job the text has to do.

| Register | Furthest from neutral |
|---|---|
| **Plain English** | Low syntactic load as policy; the reader's task as the organizing principle; abstraction actively removed. |
| **Academic** | Claims hedged to their real strength and attributed; nominalized abstraction; the field foregrounded over the writer. |
| **Journalistic** | Inverted pyramid; every contestable claim attributed; the paragraph as the unit, one or two sentences each. |
| **Corporate / Business** | Conclusion first (BLUF); action and owner named; brevity as respect for the reader's time. |
| **Legal / Contractual** | Precision over readability by design; defined terms in place of pronouns; exhaustive enumeration. |
| **Technical** | Reader is mid-task; imperative mood; structure optimized for scanning and non-linear entry. |

No profile for the author or register you asked for? The skill says so and offers the
nearest one, or to work from a passage you supply as a model. It won't improvise a profile
from general impressions, because that produces caricature.

## The six verse forms

Verse forms, scored on their own axes (meter, lineation, rhyme, stanza, enjambment, turn,
sound, compression) in `references/form-dimensions.md`. A form request loads that file and
one form profile, not the prose `craft-dimensions.md`.

| Form | Furthest from neutral |
|---|---|
| **Sonnet** | The volta; a rhyme scheme felt as structure; a whole argument resolved in fourteen lines. |
| **Blank verse** | Unrhymed iambic pentameter as a felt pulse; the verse paragraph as the unit; speech rhythm against the meter. |
| **Heroic couplet** | The closed couplet as a complete unit of sense; balance and antithesis inside the pair. |
| **Ballad** | The ballad-stanza swing; story told in leaps; impersonal voice and incremental repetition. |
| **Free verse** | Lineation as the only fixed technique; the line-break carrying rhythm, emphasis, and syntax at once. |
| **Haiku** | The cut between two images; concrete present-tense perception with no comment; radical compression. |

`/superwriter sonnet: a poem about leaving a house` generates; `[prose] /superwriter heroic
couplet` transforms. A form may be blended with an author: `/superwriter blend ballad + Poe`.

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

The facts are unchanged: the length, the fatigue, the unspoken conclusion, the next
meeting. What changed is the parataxis, the repetition of *dead* and *said*, and the flat
final detail carrying what nobody will say.

## Structure

```
superwriter/
├── SKILL.md                      # Router, mode detection, standing rules
└── references/
    ├── craft-dimensions.md       # Shared vocabulary, loads on every prose request
    ├── form-dimensions.md        # Verse vocabulary, loads on every form request
    ├── house-style.md            # Anti-AI-tells rules, loads on every generate/transform
    ├── transform.md              # Transform procedure + content-drift checks
    ├── proofread.md              # Proofread procedure, loads only on /superwriter proofread
    ├── analysis.md
    ├── blending.md
    ├── voices.md                 # Generated index, loads only on /superwriter list
    ├── authors/                  # 12 author profiles
    ├── registers/                # 6 functional-register profiles
    ├── forms/                    # 6 verse-form profiles
    ├── examples/                 # 24 opt-in exemplars, load only on --example
    └── custom/                   # your own profiles (ships empty), analyze as <name>
```

Each generate or transform request loads `SKILL.md`, one dimensions file,
`references/house-style.md`, and one profile (`craft-dimensions.md` plus an author or
register profile for prose, `form-dimensions.md` plus a form profile for verse): about
12.0 KB worst case against a 13 KB ceiling, enforced by `scripts/validate_skill.sh`. The
ceiling is a deliberate design constraint. `/superwriter proofread` loads only `SKILL.md`
and `references/proofread.md`, well under that ceiling.

## Standing rules

- **No reproduced passages.** Writes in the manner; never quotes or reconstructs the
  author's actual sentences.
- **No fabricated attribution.** Output is pastiche. Forged letters, "unpublished
  fragments," or quotes attributed to the author are declined.
- **Transform: meaning is fixed.** Every claim, fact, name, number, and the argument's order
  survives.

The roster is public-domain by design. Imitating living authors is legally fine but messier
for a public repo. Add your own profiles locally if you want them.

## Release history

Each release is a GitHub Release with `superwriter.skill` attached; install the latest.

- **v1:** first release. Router (`SKILL.md`), the ten craft dimensions, generate and
  transform modes, transform content-drift checks, style analysis, two-voice blending, and
  twelve public-domain author voices (Shakespeare, Austen, Hemingway, Woolf, Dickens, Twain,
  Poe, Wilde, Orwell, Kafka, Melville, Chekhov). Validation + packaging + release CI.
- **v2:** six functional writing registers (plain English, academic, journalistic,
  corporate, legal, technical), scored on the same craft dimensions; blends may pair an
  author with a register.
- **v3:** a `## Before returning` output self-check; a `light | medium | strong` strength
  dial; a generated `references/voices.md` index that `/superwriter list` reads; a
  required-reference-files check (all present, no unexpected extras) replaced "exactly 4
  reference files" as a validator rule.
- **v4:** six verse forms (sonnet, blank verse, heroic couplet, ballad, free verse, haiku)
  with a companion `references/form-dimensions.md` loaded only for form requests; the
  per-request budget is now enforced in CI; `build_index.sh` and `validate_skill.sh`
  hardened.
- **v5:** one opt-in `--example` per voice (24 newly written in-voice passages, each with
  a "shows" note), loaded only on request; a `SKILL.md` compression pass; a validator
  profile-shape check; and a YAML-unsafe `: ` in the `SKILL.md` frontmatter `description`
  fixed (strict loaders had rejected the file).
- **v6:** `/superwriter analyze as <name>` emits a reusable profile in the skill's format;
  a `references/custom/` slot (ships empty) holds your own profiles, resolved by name after
  the built-in roster. Completes the v3-v6 roadmap.
- **v7:** a house style loaded on every generate/transform: no em dashes, no diction
  blocklist words, no forced parallelism or hedge-stacking, no unrequested headings or
  tidy summary closers. Every em/en dash removed from the skill's own files and forbidden
  by the validator. Per-request ceiling raised to 13 KB.
- **v8:** `/superwriter proofread` fixes objective spelling, grammar, and punctuation errors
  in supplied text while leaving voice, diction, and structure untouched. A companion
  `references/proofread.md` procedure loads only for this command, so it stays well under
  the per-request budget.

## Development

- `bash scripts/validate_skill.sh` checks the `superwriter/` source: two-key frontmatter,
  one-line description, `name: superwriter`, the required reference files with no unexpected
  extras, exactly 12 author / 6 register / 6 form profiles, every voice listed in `SKILL.md`
  backed by a profile file, the `## Strength` and `## Before returning` sections, that
  `references/voices.md` matches a fresh `build_index.sh` run, that the per-request
  token load (normal path and form path) stays within 13312 bytes, that
  `references/examples/` is 1:1 with the profiles, that every profile has the
  load-bearing shape (title, furthest-from-neutral line, ≥ 8 dimension bullets, writing-it
  line), that `references/custom/` exists with its README and any custom profile has
  the load-bearing shape, and that no em/en dashes appear anywhere in `superwriter/`.
- `bash scripts/build_index.sh` regenerates `superwriter/references/voices.md` (the
  annotated list `/superwriter list` reads). Run it after adding, removing, or renaming a
  profile; `validate_skill.sh` fails if the committed file is stale.
- `bash scripts/package_skill.sh` builds `superwriter.skill` (a ZIP with `superwriter/` at
  the archive root; `.skill` is just a renamed ZIP).

CI (`.github/workflows/skill.yml`) runs validation + packaging on every push and pull
request. Pushing a tag matching `v*` validates, packages, and publishes a GitHub Release
with `superwriter.skill` attached.

### Cutting a release

```
git tag v8
git push origin v8
```

### Adding an author, register, or form

Copy an existing profile from `references/authors/` (or `references/registers/`), keep the
same ten-part shape and compression, name where the style sits furthest from neutral, and
end with the caricature failure to avoid. Then add the name to the Voices list in `SKILL.md`
**and to the `description` field**. Skipping that last step means it never triggers. Then run `bash scripts/build_index.sh` and commit the regenerated `references/voices.md`; CI fails if it is stale.
Also add `references/examples/<slug>.md`, a short original passage plus a `**Shows:**` line; CI fails without it.
Keep new profiles at or below the size of the largest existing one so the per-request budget
holds.

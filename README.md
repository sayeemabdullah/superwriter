# superwriter

A Claude skill that writes in a named author's manner — either generating new text in that
voice, or rewriting text you supply while keeping its meaning intact.

Twelve public-domain voices, plus tools to profile your own style and to blend two
influences. The skill decomposes each voice into ten craft dimensions (rhythm, syntax,
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

A short prompt is treated as *generate*; more than a paragraph of supplied text is treated
as *transform*. If it's ambiguous, say which you want.

### `/superwriter list`

Prints the available voices.

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
```

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

No profile for the author you asked for? The skill says so and offers the nearest voice, or
to work from a passage you supply as a model — it won't improvise a profile from general
impressions, because that produces caricature.

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
    └── authors/                  # 12 profiles, one per voice
```

Only `SKILL.md` + `craft-dimensions.md` + one author profile load per request (~7.8 KB) —
the token budget is a deliberate design constraint.

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
  one-line description, `name: superwriter`, 4 reference files, exactly 12 author profiles,
  and every voice in `SKILL.md` backed by a profile file.
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

### Adding an author

Copy an existing profile in `references/authors/`, keep the same ten-part shape and
compression, name where the writer sits furthest from neutral, and end with the caricature
failure to avoid. Then add the name to the voice list in `SKILL.md` **and to the
`description` field** — skipping that last step means the voice never triggers.

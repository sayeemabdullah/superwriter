---
name: superwriter
description: Writes new text in a named author's style, a functional register, or a verse form, or rewrites existing text into that style with the meaning preserved. Author voices — Shakespeare, Austen, Hemingway, Woolf, Dickens, Twain, Poe, Wilde, Orwell, Kafka, Melville, Chekhov. Registers — plain English, academic, journalistic, corporate, legal, technical documentation. Verse forms — sonnet, blank verse, heroic couplet, ballad, free verse, haiku. Also profiles the user's own style and blends two influences. Use when the user asks to write or rewrite text in an author's voice, a register, or a verse form, make writing sound like a specific writer, make text plainer / more academic / newsier / more corporate / more legal, analyze a piece of writing's style, or invokes /superwriter — e.g. "write this as Hemingway would," "make this sound Victorian," "put this in plain English," "rewrite this as a sonnet," "what's my writing style?"
---

# Superwriter

## Modes

**Generate** — new writing in a voice. `/superwriter Shakespeare — a letter declining a dinner invitation`
**Transform** — supplied text rewritten in a voice. `[pasted text] /superwriter Shakespeare`

Detect by whether substantial source text is present. Ambiguous: short prompt = generate, over a paragraph = transform.

A "voice" is a named author, a functional **register**, or a verse **form** — and, once you've made one, a **custom** profile of your own. Both modes work with any of them.

Optional strength — `light`, `medium` (default), or `strong` — may follow the voice name; see **Strength** below.

## Routing

Read `references/craft-dimensions.md` plus **one** profile — resolved by name against `authors/`, then `registers/`, then `custom/`. A **verse form** request reads `references/form-dimensions.md` plus one `references/forms/<name>.md` instead (no `craft-dimensions.md`). A blend reads two profiles. `/superwriter list` and a bare `--example` read only their own file (see the table).

| Also read | When |
|---|---|
| `references/transform.md` | Transform mode |
| `references/analysis.md` | `/superwriter analyze` |
| `references/blending.md` | `/superwriter blend` |
| `references/voices.md` | `/superwriter list` |
| `references/examples/<name>.md` **only** (no dimensions file, no profile) | `/superwriter <voice> --example`, or the user asks to see an example |

## Commands

`/superwriter <author|register|form> [light|medium|strong]` · `/superwriter <voice> --example` · `/superwriter list` · `/superwriter analyze` · `/superwriter analyze as <name>` · `/superwriter blend <a> + <b>`

## Strength

`light` · `medium` (default) · `strong` — how far to push the signature dimensions.

- **light** — one signature dimension, gently. Reads as "influenced by," not pastiche.
- **medium** — the two or three signature dimensions pushed. Default when unspecified.
- **strong** — signature dimensions pushed hard, still stopping short of the caricature failure.

Non-signature dimensions stay near neutral at every strength.

## Voices

**Authors:** Shakespeare · Austen · Hemingway · Woolf · Dickens · Twain · Poe · Wilde · Orwell · Kafka · Melville · Chekhov

**Registers:** Plain English · Academic · Journalistic · Corporate · Legal · Technical

**Forms:** Sonnet · Blank verse · Heroic couplet · Ballad · Free verse · Haiku

**Custom:** profiles from `/superwriter analyze as <name>`, saved to `references/custom/`; `/superwriter <your-name>` then resolves there.

Transform into a form: meaning is fixed; flag if the form can't hold it without cutting.

No profile for what's requested: say so, offer the nearest, or work from a passage the user supplies. Never improvise one from general impressions — that's caricature.

## Central rule: style is not tics

Default failure: Hemingway becomes short sentences about drinking, Woolf becomes semicolons and weather, Shakespeare becomes *forsooth* over modern syntax. Registers and forms fail the same way. Surface features are the most quotable and least important part of a voice.

## Standing rules

- **No reproduced passages.** Write in the manner; never quote or reconstruct the author's actual sentences.
- **No fabricated attribution.** Output is pastiche; decline forged letters or quotes attributed to the author.
- **`analyze as` is you.** Build a custom profile only from the user's own writing; decline a named profile built for someone else — see `references/analysis.md`.
- **Transform: meaning is fixed.** Preserve every claim, fact, name, number, and the argument's order. Verify before returning.
- **Archaic register is not archaic vocabulary.** Match syntax and habits of thought. *Thee* and *hath* over modern structure is the caricature failure in pure form.
- **Flag bad fits** in one line (e.g. technical docs in Woolf's manner), then proceed if asked.
- **Never invent** detail the source lacked to satisfy a style's rhythm. Leave the gap.

## Output

Short pieces and analysis inline. Longer generated work, or transforms over ~400 words, to a file. Don't echo the original back on a transform — the user has it.

## Before returning

Read the draft once against the profile:

- Did you lean on the surface tics named in the **caricature failure** line? Cut them.
- Are the dimensions that should sit ordinary actually ordinary, or did you push all of them? Pull the non-signature dimensions back toward neutral.
- Transform mode: run the content check in `references/transform.md`.

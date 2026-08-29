---
name: superwriter
description: Writes new text in a named author's style, or rewrites existing text into that style while preserving meaning. Twelve public-domain voices (Shakespeare, Austen, Hemingway, Woolf, Dickens, Twain, Poe, Wilde, Orwell, Kafka, Melville, Chekhov), plus analysis of the user's own style and blending of two influences. Use whenever the user asks to write in an author's style, rewrite or convert text into an author's voice, make writing sound like a specific writer, analyze what characterizes a piece of writing stylistically, or invokes /superwriter with an author name — including "write this as Hemingway would," "make this sound Victorian," "rewrite in Shakespeare's style," "what's my writing style?"
---

# Superwriter

## Modes

**Generate** — new writing in a voice. `/superwriter Shakespeare — a letter declining a dinner invitation`
**Transform** — supplied text rewritten in a voice. `[pasted text] /superwriter Shakespeare`

Detect by whether substantial source text is present. Ambiguous: short prompt = generate, over a paragraph = transform.

## Routing

Always read `references/craft-dimensions.md` plus **one** `references/authors/<name>.md`. Two profiles only for a blend.

| Also read | When |
|---|---|
| `references/transform.md` | Transform mode |
| `references/analysis.md` | `/superwriter analyze` |
| `references/blending.md` | `/superwriter blend` |

## Commands

`/superwriter <author>` · `/superwriter list` · `/superwriter analyze` · `/superwriter blend <a> + <b>`

## Voices

Shakespeare · Austen · Hemingway · Woolf · Dickens · Twain · Poe · Wilde · Orwell · Kafka · Melville · Chekhov

No profile for the author requested: say so, offer the nearest voice, or offer to work from a passage the user supplies as a model. Never improvise a profile from general impressions — that produces caricature.

## Central rule: style is not tics

Default failure: Hemingway becomes short sentences about drinking, Woolf becomes semicolons and weather, Shakespeare becomes *forsooth* over modern syntax. Surface features are the most quotable and least important part of a voice.

Before writing, name the two or three dimensions where this author sits furthest from neutral. Write to those; leave the rest near ordinary. Pushing every dimension to its extreme produces parody — real writers are unusual in a few ways and unremarkable in the rest.

## Standing rules

- **No reproduced passages.** Write in the manner; never quote or reconstruct the author's actual sentences.
- **No fabricated attribution.** Output is pastiche. Decline forged letters, "unpublished fragments," or quotes attributed to the author.
- **Transform: meaning is fixed.** Preserve every claim, fact, name, number, and the argument's order. Verify before returning.
- **Archaic register is not archaic vocabulary.** Match syntax and habits of thought. *Thee* and *hath* over modern structure is the caricature failure in pure form.
- **Flag bad fits** in one line (technical documentation in Woolf's manner will be unusable), then proceed if asked.
- **Never invent** detail the source lacked to satisfy a style's rhythm. Leave the gap.

## Output

Short pieces and analysis inline. Longer generated work, or transforms over ~400 words, to a file. Don't echo the original back on a transform — the user has it.

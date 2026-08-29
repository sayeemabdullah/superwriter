# superwriter

A Claude skill that writes in a named author's manner, two ways:

- **Generate** — `/superwriter Hemingway — a scene where two people decide to separate`
- **Transform** — paste text, add `/superwriter Austen`, get it rewritten with the meaning intact.

Twelve public-domain voices (Shakespeare, Austen, Hemingway, Woolf, Dickens, Twain, Poe,
Wilde, Orwell, Kafka, Melville, Chekhov), plus `/superwriter analyze` (profiles the user's
own writing) and `/superwriter blend <a> + <b>`.

## Structure

```
superwriter/
├── SKILL.md                      # Router, mode detection, standing rules
└── references/
    ├── craft-dimensions.md       # Shared vocabulary — loads every request
    ├── transform.md              # Transform procedure + drift checks
    ├── analysis.md
    ├── blending.md
    └── authors/                  # 12 profiles, one per voice
```

The skill is stateless — no files are written.

## Install

1. In Claude, Settings → Capabilities → enable **Code execution and file creation**.
2. Customize → Skills (`https://claude.ai/customize/skills`).
3. **+** → **Create skill** → **Upload a skill**.
4. Select `superwriter.skill` (from the [latest release](../../releases/latest)), toggle it on.
5. Start a **new** conversation — skills load at session start.

## Development

- `bash scripts/validate_skill.sh` — checks the `superwriter/` source against the structure
  rules (frontmatter keys, one-line description, 4 reference files, exactly 12 author
  profiles, every voice listed in `SKILL.md` backed by a file).
- `bash scripts/package_skill.sh` — builds `superwriter.skill` (a ZIP with `superwriter/` at
  the archive root).

CI (`.github/workflows/skill.yml`) runs validation + packaging on every push and pull
request. Pushing a tag matching `v*` validates, packages, and publishes a GitHub Release
with `superwriter.skill` attached.

### Cutting a release

```
git tag v1
git push origin v1
```

### Adding an author

Copy an existing profile in `references/authors/`, keep the same ten-part shape and
compression, name where the writer sits furthest from neutral, end with the caricature
failure to avoid. Then add the name to the voice list in `SKILL.md` **and to the
`description` field** — skipping that last step means the voice never triggers.

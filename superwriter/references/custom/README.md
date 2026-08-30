# Custom profiles

Profiles you generate with `/superwriter analyze as <name>` go here — one file per voice,
named `<your-name>.md` (lowercase, hyphens for spaces).

Each file follows the same shape as the profiles in `../authors/`:

- a `# <Name>` heading
- a `**Furthest from neutral:** …` line
- the ten craft-dimension bullets from `../craft-dimensions.md`, in order
- a `**Writing it:** …` line closing on the habit that would tip your voice into self-parody

After adding one:

1. Run `scripts/build_index.sh` from the repo root and commit the regenerated
   `../voices.md` (CI fails if it is stale).
2. Optionally add the name under `## Voices` → **Custom** in `../../SKILL.md` so
   `/superwriter list` shows it — resolution works by filename either way.
3. Repackage with `scripts/package_skill.sh`, or re-upload the skill.

This directory ships empty except for this file. Profiles here are yours; the public roster
stays public-domain.

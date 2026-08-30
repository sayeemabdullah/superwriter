#!/usr/bin/env bash
# Validate the superwriter/ skill source against the design spec's checklist.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT/superwriter"
fail=0

err() { echo "FAIL: $*" >&2; fail=1; }
ok()  { echo "ok:   $*"; }

[ -d "$SKILL_DIR" ] || { err "superwriter/ directory missing"; exit 1; }
[ -f "$SKILL_DIR/SKILL.md" ] || err "superwriter/SKILL.md missing"

# --- Frontmatter checks (name + description, exactly two keys, one-line description) ---
python3 - "$SKILL_DIR/SKILL.md" <<'PY' || fail=1
import sys, re
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
m = re.match(r"---\n(.*?)\n---\n", text, re.S)
if not m:
    print("FAIL: SKILL.md has no YAML frontmatter delimited by ---", file=sys.stderr)
    sys.exit(1)
block = m.group(1)
lines = block.split("\n")
keys = [l.split(":", 1)[0].strip() for l in lines if l and not l.startswith((" ", "\t"))]
if keys != ["name", "description"] and sorted(keys) != ["description", "name"]:
    print(f"FAIL: frontmatter keys must be exactly name, description (got {keys})", file=sys.stderr)
    sys.exit(1)
if len(keys) != 2:
    print(f"FAIL: frontmatter must have exactly two keys (got {len(keys)}: {keys})", file=sys.stderr)
    sys.exit(1)
kv = dict(l.split(":", 1) for l in lines if ":" in l and not l.startswith((" ", "\t")))
if kv["name"].strip() != "superwriter":
    print(f"FAIL: name must be 'superwriter' (got {kv['name'].strip()!r})", file=sys.stderr)
    sys.exit(1)
# description must be a single line: no continuation lines before closing ---
desc_idx = next(i for i, l in enumerate(lines) if l.startswith("description:"))
if any(l.startswith((" ", "\t")) or (l and ":" not in l.split(" ")[0]) for l in lines[desc_idx+1:]):
    print("FAIL: description must be on one line", file=sys.stderr)
    sys.exit(1)
if not kv["description"].strip():
    print("FAIL: description is empty", file=sys.stderr)
    sys.exit(1)
# no blank line before the closing ---
head = text.split("\n---\n", 1)[0]
if head.rstrip("\n") != head.rstrip():
    pass
if re.search(r"\n\s*\n---\n", text[:m.end()]):
    print("FAIL: blank line before closing --- of frontmatter", file=sys.stderr)
    sys.exit(1)
print("ok:   frontmatter valid (name=superwriter, one-line description, two keys)")
PY

# --- references/ layout: required files present, no unexpected top-level .md ---
REF="$SKILL_DIR/references"
[ -d "$REF" ] || err "superwriter/references/ missing"

# Required top-level reference files. Generated files allowed alongside them: voices.md.
required_ref="craft-dimensions transform analysis blending"
generated_ref="voices"
_fail_before_reflayout=$fail
for f in $required_ref; do
  [ -f "$REF/$f.md" ] || err "references/$f.md missing"
done
_allowed=" $required_ref $generated_ref "
while IFS= read -r f; do
  _b="$(basename "$f" .md)"
  case "$_allowed" in
    *" $_b "*) ;;
    *) err "unexpected top-level file: references/$_b.md" ;;
  esac
done < <(find "$REF" -maxdepth 1 -type f -name '*.md')
[ "$fail" -eq "$_fail_before_reflayout" ] && ok "references/ top-level files: all required present, no unexpected extras"

# --- references/voices.md matches scripts/build_index.sh output ---
if [ -f "$ROOT/scripts/build_index.sh" ]; then
  _tmp_idx="$(mktemp)"
  trap 'rm -f "$_tmp_idx"' EXIT
  bash "$ROOT/scripts/build_index.sh" "$_tmp_idx" >/dev/null
  if diff -u "$REF/voices.md" "$_tmp_idx" >/dev/null 2>&1; then
    ok "references/voices.md is up to date"
  else
    err "references/voices.md is stale — run: bash scripts/build_index.sh"
  fi
  rm -f "$_tmp_idx"
else
  err "scripts/build_index.sh missing"
fi

# --- references/authors/ ---
AUTH="$REF/authors"
[ -d "$AUTH" ] || err "superwriter/references/authors/ missing"
auth_count=$(find "$AUTH" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
if [ "$auth_count" -eq 12 ]; then
  ok "references/authors/ has exactly 12 .md files"
else
  err "references/authors/ must have exactly 12 .md files (found $auth_count)"
fi

# --- references/registers/ ---
REG="$REF/registers"
[ -d "$REG" ] || err "superwriter/references/registers/ missing"
reg_count=$(find "$REG" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
if [ "$reg_count" -eq 6 ]; then
  ok "references/registers/ has exactly 6 .md files"
else
  err "references/registers/ must have exactly 6 .md files (found $reg_count)"
fi

# --- every voice in SKILL.md's Voices section has a matching profile file ---
voices_block=$(awk '/^## Voices/{f=1;next} f && /^## /{exit} f{print}' "$SKILL_DIR/SKILL.md")

authors="shakespeare austen hemingway woolf dickens twain poe wilde orwell kafka melville chekhov"
for v in $authors; do
  [ -f "$AUTH/$v.md" ] || err "author profile missing: references/authors/$v.md"
  echo "$voices_block" | grep -iq "$v" || err "author '$v' not listed in SKILL.md Voices section"
done
ok "all 12 authors listed in SKILL.md and backed by a profile file"

registers="plain-english academic journalistic corporate legal technical"
for r in $registers; do
  [ -f "$REG/$r.md" ] || err "register profile missing: references/registers/$r.md"
  # match on the first word of the slug (plain-english -> plain)
  echo "$voices_block" | grep -iq "${r%%-*}" || err "register '$r' not listed in SKILL.md Voices section"
done
ok "all 6 registers listed in SKILL.md and backed by a profile file"

# --- SKILL.md routes /superwriter list to the generated index ---
if grep -q 'references/voices.md' "$SKILL_DIR/SKILL.md"; then
  ok "SKILL.md routes /superwriter list to references/voices.md"
else
  err "SKILL.md must route /superwriter list to references/voices.md"
fi

# --- SKILL.md documents the strength dial (checked within the ## Strength section) ---
_strength_body=$(awk '/^## Strength/{f=1;next} f && /^## /{exit} f{print}' "$SKILL_DIR/SKILL.md")
if [ -n "$_strength_body" ] \
   && printf '%s' "$_strength_body" | grep -Eq '\blight\b' \
   && printf '%s' "$_strength_body" | grep -Eq '\bmedium\b' \
   && printf '%s' "$_strength_body" | grep -Eq '\bstrong\b'; then
  ok "SKILL.md documents the strength dial (light/medium/strong)"
else
  err "SKILL.md ## Strength section must name light, medium, and strong in its body"
fi

# --- SKILL.md has the pre-return self-check ---
if grep -q '^## Before returning' "$SKILL_DIR/SKILL.md"; then
  ok "SKILL.md has the ## Before returning self-check"
else
  err "SKILL.md must have a ## Before returning section"
fi

# --- per-request token budget (ceiling 10240 B) ---
if python3 - "$SKILL_DIR" <<'PY'
import os, sys
root = sys.argv[1]
CEIL = 10240

def size(p):
    return os.path.getsize(p) if os.path.exists(p) else 0

def largest(d):
    d = os.path.join(root, "references", d)
    if not os.path.isdir(d):
        return 0
    return max([size(os.path.join(d, f)) for f in os.listdir(d)
               if f.endswith(".md") and f != "README.md"] or [0])

skill = size(os.path.join(root, "SKILL.md"))
craft = size(os.path.join(root, "references", "craft-dimensions.md"))
formd = size(os.path.join(root, "references", "form-dimensions.md"))

normal = skill + craft + max(largest("authors"), largest("registers"))
form = skill + formd + largest("forms") if formd else 0

ok = True
print(f"normal path: {normal} B (SKILL {skill} + craft {craft} + largest prose profile)")
if normal > CEIL:
    print(f"FAIL: normal-path per-request load {normal} B exceeds {CEIL} B", file=sys.stderr)
    ok = False
if form:
    print(f"form path:   {form} B (SKILL {skill} + form-dimensions {formd} + largest form profile)")
    if form > CEIL:
        print(f"FAIL: form-path per-request load {form} B exceeds {CEIL} B", file=sys.stderr)
        ok = False
sys.exit(0 if ok else 1)
PY
then
  ok "per-request token budget within 10240 B"
else
  err "per-request token budget exceeded"
fi

if [ "$fail" -ne 0 ]; then
  echo "" >&2
  echo "validation FAILED" >&2
  exit 1
fi
echo ""
echo "validation PASSED"

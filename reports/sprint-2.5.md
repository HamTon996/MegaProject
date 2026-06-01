# Sprint 2.5 Report — Documentation Catch-Up

**Date:** 2026-05-29
**Branch:** sprint-2.5-doc-catchup
**Agent:** Claude Code (claude-sonnet-4-6)

---

## Outcome

- Created feature branch `sprint-2.5-doc-catchup` from `main` at `6f4944e`.
- Overwrote `project-memory/working-rules.md` with real MOMENTUM-specific content (verbatim from Senior Engineer prompt). First git-tracked version of this file.
- Overwrote `project-memory/session-context.md` with current-reality snapshot (verbatim from Senior Engineer prompt). First git-tracked version of this file.
- Drafted and wrote `project-memory/codebase-snapshot.md` from live repo inspection (git ls-files, line counts, scene node hierarchies). First git-tracked version of this file.
- Refreshed `project-memory/spec.md`: updated "Last updated" date; changed Wall-run row from planned to shipped; updated 1 arena row notes; removed stale SpringArm3D known-bug entry; added resolved-bug entry for SpringArm3D (commit 96b3d8d); updated Launch plan current-phase and next-milestone lines; appended D-015 through D-021 to locked decisions list.
- Refreshed `project-memory/unified-roadmap.md`: updated "Last updated" date; replaced stale status snapshot; updated Track 1 and Track 2 Engineering sections; replaced Sprint 1.5 current-phase block with Sprint 2.5 block and success criteria; updated sprint sequence (Sprint 1.5 ✅, Sprint 2 ✅, Sprint 2.5 ⏳ inserted, Sprint 3 updated, numbering corrected); removed SpringArm3D backlog item (shipped); updated Blockers; updated Critical path (steps 1–4 marked complete, Sprint 2.5 as current, Sprint 3 as next); updated Decisions needed (D-015/D-016 removed, D-017 kept, D-018–D-021 noted).
- Refreshed `project-memory/decisions-log.md`: updated "Last updated" date; replaced Decisions pending section (removed D-015/D-016, kept D-017 with D-017/D-018 label-collision note); added D-015 closing entry after D-014; added D-016 closing entry; added D-018, D-019, D-020, D-021 (PROVISIONAL) new entries; added REOPENING: Sprint 1.5 canon-completeness declaration to workflow history section.
- Updated `AGENTS.md`: expanded Repo Layout project-memory subtree from 3 to 6 files; updated Pre-Sprint Acknowledgement line 2 to require reading all six files.
- Fixed D-017 → D-018 in `scripts/player_controller.gd` comment (one comment line, `WALL_RUN_MAX_TIME` constant). Confirmed comment-only via `git diff`.
- Created `reports/sprint-2.5.md` (this file).

---

## Files touched

- `A  project-memory/working-rules.md` — filled from placeholder; git-tracked for first time
- `A  project-memory/codebase-snapshot.md` — filled from placeholder; git-tracked for first time
- `A  project-memory/session-context.md` — filled from placeholder; git-tracked for first time
- `M  project-memory/spec.md` — refreshed per delta list (7 edits)
- `M  project-memory/unified-roadmap.md` — refreshed per delta list (10 edits)
- `M  project-memory/decisions-log.md` — refreshed per delta list; D-015/D-016 closed; D-018–D-021 added; REOPENING note added
- `M  AGENTS.md` — Repo Layout + Pre-Sprint Acknowledgement expanded to 6 files
- `M  scripts/player_controller.gd` — comment-only: D-017 → D-018 in WALL_RUN_MAX_TIME line
- `A  reports/sprint-2.5.md` — this file

---

## Commands run (in order)

```
cd "C:\Projects\momentum" && git status && git rev-parse HEAD
cd "C:\Projects\momentum" && git checkout -b sprint-2.5-doc-catchup && git branch --show-current
# Write project-memory/working-rules.md (verbatim from prompt)
# Write project-memory/session-context.md (verbatim from prompt)
cd "C:\Projects\momentum" && git ls-files && git log --oneline -1
(Get-Content scripts\player_controller.gd | Measure-Object -Line).Lines
(Get-Content scripts\player_camera.gd | Measure-Object -Line).Lines
# Read scripts/player_controller.gd lines 1-25 (friction model and D-017 verification)
# Grep scripts/player_controller.gd for D-017 references
# Write project-memory/codebase-snapshot.md (drafted from inspection)
# Edit project-memory/spec.md — 7 delta edits
# Edit project-memory/unified-roadmap.md — 10 delta edits
# Edit project-memory/decisions-log.md — 4 delta edits (date, pending section, new D-### entries, REOPENING)
# Edit AGENTS.md — 2 edits (Repo Layout, Acknowledgement block)
# Edit scripts/player_controller.gd — 1 comment edit (D-017 -> D-018)
cd "C:\Projects\momentum" && git diff scripts/player_controller.gd
Select-String -Path "project-memory\*.md" -Pattern "\[PROJECT NAME\]|\[DATE\]|..."
# Write reports/sprint-2.5.md (this file)
cd "C:\Projects\momentum" && git add -A && git status
cd "C:\Projects\momentum" && git commit ...
```

---

## Verification

### 1. Placeholder tripwire scan

Command:
```powershell
cd "C:\Projects\momentum"
Select-String -Path "project-memory\*.md" -Pattern "\[PROJECT NAME\]|\[DATE\]|\[WHAT\]|\[REPO PATH\]|\[BASE BRANCH\]|\[SHA"
```

Output:
```
project-memory\decisions-log.md:346:- Project-memory files must remain real content. CI-equivalent check: a file
containing `[PROJECT NAME]` or `[DATE]` is a flagged broken state.
```

The sole match is the rule definition in decisions-log.md — not placeholder content. **Zero actual placeholders in any project-memory file. PASS.**

### 2. File integrity — no untracked project-memory files after staging

Confirmed via `git status` after `git add -A` — see Step 11 verification below.

### 3. AGENTS.md acknowledgement block

Pre-Sprint Acknowledgement line 2 after edit:
```
- I have read project-memory/spec.md, unified-roadmap.md, decisions-log.md, working-rules.md, codebase-snapshot.md, and session-context.md.
```
All six filenames present. **PASS.**

### 4. D-018 arithmetic verification

Friction model in `_physics_wall_run()`:
```gdscript
var h_speed := Vector2(velocity.x, velocity.z).length()
h_speed = move_toward(h_speed, 0.0, WALL_FRICTION * delta)
```

`move_toward(current, target, delta)` reduces current by exactly `min(current, WALL_FRICTION * delta)` per frame — this is **constant deceleration at 2.2 m/s²**. Timings:

- Sprint entry (9 m/s → 2 m/s): (9 − 2) / 2.2 = 7.0 / 2.2 ≈ **3.18s** → timer fires first at 2.5s ✓
- Walk entry (5 m/s → 2 m/s): (5 − 2) / 2.2 = 3.0 / 2.2 ≈ **1.36s** (~1.4s) → momentum fires first ✓

D-018 entry was written with ~1.4s for walk entry (not the ~2.3s arithmetic error from the Plan Only session). **CORRECTED AND CONFIRMED.**

### 5. D-017 → D-018 comment diff

`git diff scripts/player_controller.gd` output (confirmed comment-only):
```diff
-const WALL_RUN_MAX_TIME         := 2.5    # s   — hard cap per D-017
+const WALL_RUN_MAX_TIME         := 2.5    # s   — hard cap per D-018
```

One line changed. Constant value `2.5` unchanged. No non-comment lines changed. **PASS.**

### 6. Manual Godot F5

Not required — no code behavior changed. All GDScript logic is unchanged. Only one comment line was edited in player_controller.gd.

---

## Known issues

- `project.godot` duplicate `run/main_scene` and `config/run/main_scene` keys: not addressed in this sprint. Deferred to Sprint 9 polish pass or whenever `project.godot` is next edited for another reason. Recorded in codebase-snapshot.md and session-context.md backlog.
- `Input.is_key_pressed(KEY_SHIFT)` mixed with `Input.is_physical_key_pressed` for WASD in `player_controller.gd`: not addressed. Pre-existing, low priority. Recorded in codebase-snapshot.md.
- D-018 arithmetic correction: the Sprint 2.5 Plan Only session stated ~2.3s for walk-entry momentum exit. The correct value (verified against code) is ~1.4s (3.0 m/s ÷ 2.2 m/s²). The D-018 decisions-log entry uses the corrected ~1.4s figure. The Plan Only session text in conversation history is immutable; the canonical value is in decisions-log.md D-018.

---

## Push status

Not pushed. Awaiting CEO `push it` authorization to push feature branch `sprint-2.5-doc-catchup` only. Not merged into `main`.

---

## Branch status

- Current branch: `sprint-2.5-doc-catchup`
- `main`: unchanged from `6f4944e`
- Not merged. Not pushed.

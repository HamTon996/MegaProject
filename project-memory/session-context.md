# MOMENTUM — Session Context

Last updated: 2026-05-29

This file is the "what's true right now" snapshot. It changes after
every sprint. Update it as part of the sprint that changes the facts
it asserts — never let it go stale.

If this file disagrees with a sprint report dated later, the sprint
report wins and this file is the bug.

## Current state

- Repo path: `C:\Projects\momentum`
- Remote: `github.com/HamTon996/MegaProject`
- Base branch: `main`
- Current branch: `main`
- Top commit: `6f4944e`
- Push status: pushed to `origin/main`
- Working tree: clean (post Sprint 2 merge)
- Current milestone: Sprint 2 shipped. Sprint 2.5 (doc catch-up)
  in progress.

## Latest sprint shipped

**Sprint 2 — Wall-run system.** Merged to `main` as `6f4944e` on
2026-05-29. Four feature commits plus one merge commit:

- `96b3d8d` — Sprint 2 base: state machine (GROUND / AIR / WALL_RUN),
  jump-toward-wall initiation, momentum+timer hybrid, SpringArm3D
  camera with player exclusion, gray-box corridor arena.
- `eb62c9e` — Friction tune: WALL_FRICTION 3.5 → 2.2 (makes the
  hybrid actually feel hybrid).
- `c4e8a88` — Godot editor housekeeping on main.tscn (UID
  assignments, float normalisation).
- `09f2c9d` — Combined feel pass: `_selected_speed()` sprint-
  backwards gate, forgiving wall detection (1.0m rays + 100ms
  coyote + camera-fallback direction picker), deterministic
  jump-off (WALL_JUMP_OFF_KICK 8.0 + WALL_JUMP_RESTICK_LOCKOUT 0.15).
- `6f4944e` — Sprint 2 merge.

CEO F5-verified Sprint 2 across all 10 verification steps before
merge. Feel approved.

## Next focus

Sprint 3 — Wall-bounce. Highest-risk feel sprint to date. Replaces
WALL_JUMP_OFF_KICK with a Space-triggered momentum-preserving lateral
redirect. Will be entered via Plan Only after Sprint 2.5 ships.

Sprint 2.5 (this sprint) must land first to refresh project-memory
to current reality and adopt the three previously-orphaned files
into canon.

## Current health

- Tests: None automated. Verification is manual F5 in Godot.
- App launch: F5 from `project.godot` open in Godot 4.6.2 editor.
  No CLI launch (Godot not on PATH).
- Known blockers: None.
- Known risks: Sprint 3 wall-bounce design supersedes Sprint 2's
  D-021 (provisional) jump-off behavior. Plan Only must explicitly
  reopen D-021.

## Locked invariants to remember this session

For the full list, see `working-rules.md` "Locked invariants" and
`AGENTS.md` "Engine Constraints" and "Hard Forbidden Actions."
The most-likely-to-be-forgotten ones in day-to-day work:

- Sprint 1 movement constants (`WALK_SPEED`, `RUN_SPEED`,
  `JUMP_VELOCITY`, `GRAVITY`, `GROUND_ACCEL`, `GROUND_FRICTION`,
  `AIR_CONTROL`) do not change without explicit instruction.
- All work goes on a feature branch. Never on `main`.
- Commit messages should reference D-### entries where applicable.
- Every command must be prefixed with `cd "C:\Projects\momentum" &&` —
  the VS Code harness defaults elsewhere.

## Useful commands

All commands prefix with: `cd "C:\Projects\momentum" &&`

```bash
git status
git log --oneline -10
git branch -a
git rev-parse HEAD
```

Playtest: open `project.godot` in Godot 4.6.2 editor, press F5.

## Latest reports

Newest first:

- `reports/sprint-2.md` — Wall-run system, 11,432 bytes,
  dated 2026-05-29.
- `reports/sprint-1.5.md` — Cleanup, 5,178 bytes, dated 2026-05-25.
- `reports/sprint-1.md` — Character controller, 3,905 bytes,
  dated 2026-05-21.
- `reports/sprint-0.md` — Bootstrap, 4,951 bytes, dated 2026-05-21.

`reports/sprint-2.5.md` will be added when this sprint ships.

## Backlog deferred from earlier sprints

- `project.godot` duplicate `run/main_scene` keys — low priority,
  not breaking. Defer to a Sprint 9 polish pass or to whenever
  `project.godot` is being edited for another reason.
- `Input.is_key_pressed` vs `is_physical_key_pressed` inconsistency
  in `player_controller.gd` — low priority, pre-existing.
- Reconcile `D-017` references in code (currently citing the
  wall-bounce pending entry where they mean the hybrid timer).
  Scheduled for Sprint 2.5.

## State drift notes

After Sprint 2.5 merges, this section should read "None known."
Until then, the known drift items being resolved by this sprint:

- `working-rules.md`, `codebase-snapshot.md`, and this file were
  untracked placeholders until Sprint 2.5. Sprint 1.5 cleanup
  closed the placeholder gap on three canon files but did not
  catch these three. See `decisions-log.md` REOPENING entry
  dated 2026-05-29.
- `spec.md`, `unified-roadmap.md`, `decisions-log.md` were dated
  2026-05-22 and stale by Sprint 1.5 + Sprint 2 worth of work.
  Refreshed in Sprint 2.5.
- `AGENTS.md` Repo Layout listed three project-memory files; the
  Pre-Sprint Acknowledgement block referenced only three. Both
  expanded to six in Sprint 2.5.
- Some Sprint 2 commit messages and code comments cite "D-017"
  as shorthand for the hybrid-timer decision. The formal
  hybrid-timer entry is D-018; D-017 in `decisions-log.md` is
  the wall-bounce input question. Code comments fixed in
  Sprint 2.5; commit history is immutable and left as-is.

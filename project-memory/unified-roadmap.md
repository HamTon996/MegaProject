# MOMENTUM — Unified Roadmap

Last updated: 2026-05-29

## Status snapshot

Sprints 0, 1, 1.5, and 2 have shipped. Sprint 2 wall-run was CEO-verified via F5 across all 10 verification steps before merge. Sprint 2.5 (documentation catch-up — this sprint) refreshes stale project-memory and adopts three previously-orphaned files into canon. Sprint 3 (wall-bounce) is next on the critical path and will replace Sprint 2's WALL_JUMP_OFF_KICK behavior entirely (see D-021 PROVISIONAL).

## Tracks

### Track 1 — Product

- Current state: Spec locked, scope confirmed as vertical slice. Character controller and wall-run system live (capsule placeholder).
- Next: Sprint 3 — wall-bounce system.

### Track 2 — Engineering

- Current state: Godot 4.6.2 project at `C:\Projects\momentum`. Jolt Physics, D3D12 driver. State machine (GROUND/AIR/WALL_RUN) with auto-stick wall-run and SpringArm3D camera rig. `main` branch at `6f4944e`. All Sprint 0–1 workflow violations recorded in decisions-log; Sprints 1.5 and 2 held workflow rules.
- Next: Sprint 2.5 (this sprint) → Sprint 3 wall-bounce Plan Only.

### Track 3 — Launch / business

- Current state: Not applicable until v1 proves the mechanic.
- Next: Revisit after Sprint 3 decision gate.

## Current phase

**Sprint 2.5 — Documentation catch-up.** Mode: **Build** (mechanical, low risk).

Success criteria for Sprint 2.5:
- All six project-memory files contain real content (no bracketed placeholders).
- All six project-memory files are tracked in git.
- AGENTS.md Repo Layout lists all six. Pre-Sprint Acknowledgement block requires reading all six.
- decisions-log.md closes D-015 and D-016, adds D-018 through D-021 (D-021 PROVISIONAL), and contains the Sprint 1.5 canon-completeness REOPENING entry.
- `D-017` shorthand references in player_controller.gd comments are fixed to `D-018` (commit history is immutable and left as-is).
- reports/sprint-2.5.md exists.
- Feature branch pushed (after CEO `push it`). Not merged. Merge ceremony separately.

## Sprint sequence

1. ✅ **Sprint 0** — Bootstrap (shipped 2026-05-21, with caveats — see decisions-log).
2. ✅ **Sprint 1** — Character controller, third-person camera, floor scene (shipped 2026-05-21, with caveats).
3. ✅ **Sprint 1.5** — Cleanup: real project-memory in repo, hardened `AGENTS.md`, decisions log truthful. Shipped 2026-05-25, commit `baa8cc7`.
4. ✅ **Sprint 2** — Wall-run system: detection, attach, stamina, exit. Includes SpringArm3D for camera (per D-010 trade-off). Shipped 2026-05-29, commit `6f4944e`.
5. ⏳ **Sprint 2.5** — Documentation catch-up (this sprint). Real-content the three orphan canon files. Refresh the three stale canon files. Close D-015/D-016, add D-018–D-021, add REOPENING note.
6. **Sprint 3** — Wall-bounce: input, momentum redirect, chain-into-wall-run. Plan Only first. Will reopen and supersede D-021. **DECISION GATE after this sprint.**
7. **Sprint 4** — Gray-box arena with deliberately placed walls for the loop.
8. **Sprint 5** — Gunplay: one hitscan weapon, raycast, hit FX, ammo.
9. **Sprint 6** — Melee: one attack, hitbox, hit reaction.
10. **Sprint 7** — Enemy v1: stands still, shoots, takes damage, dies.
11. **Sprint 8** — Player health, damage, death, restart loop.
12. **Sprint 9** — Tuning pass: numbers tuning, feel pass, friction pass.
13. **Sprint 10+** — Enemy v2, polish, anything that survived cuts.

Each sprint produces a runnable build and a `reports/sprint-N.md`.

## Backlog (not yet sprinted)

- Audio system (placeholder SFX, not polish)
- Particle/VFX for shots and wall contact
- Animation system (placeholder capsule for v1; real animation is v2)
- Save system (deferred — no need until multi-arena)
- Settings menu (deferred — no need until external playtest)
- Fix `project.godot` duplicate `run/main_scene` keys (low priority)
- Reconcile `Input.is_key_pressed` vs `is_physical_key_pressed` inconsistency (low priority)

## Long-lead items

- **Animation.** Out of scope for v1. Vertical slice ships with capsule visuals.
- **3D art.** Gray-box only for v1.
- **Sound design.** Placeholder only.
- **Wall-run feel tuning.** This is the riskiest single piece of work in the entire roadmap. Sprint 2 may slip; Sprint 3 likewise. Do not promise Sprint 2 will land in one pass.

## Blockers

- Sprint 3 cannot start until Sprint 2.5 lands. No other blockers known.

## Critical path

1. ✅ Sprint 1.5: cleanup + workflow hardening.
2. ✅ CEO manual verification of Sprint 1 controls.
3. ✅ Sprint 2 Plan Only: wall-run approach drafted by Senior Engineer.
4. ✅ Sprint 2 Build: wall-run shipped.
5. ⏳ Sprint 2.5: documentation catch-up (current step).
6. Sprint 3 Plan Only: wall-bounce approach. Must explicitly reopen D-021.
7. Sprint 3 Build: wall-bounce shipped.
8. **DECISION GATE:** does movement feel good without combat? Stop if no.
9. Sprints 4–8: arena + combat verbs + enemy + damage loop.
10. Sprint 9: tuning to vertical slice quality.
11. Internal v1 sign-off.

## Decisions needed

- D-017: Wall-bounce input — dedicated button vs jump-while-wall-running (Sprint 3).
- Note: D-018 through D-021 are now in decisions-log.md. D-021 is PROVISIONAL and will be reopened in Sprint 3.

## Velocity reality check

Sprints 0+1 took ~36 hours of calendar time with significant rework. Realistic expectation for Sprints 2+ under the new workflow: 1–2 sprints per week if no blockers, slower for feel-heavy sprints (2, 3, 9). The vertical slice is **8–14 weeks of focused work**, not "a few sprints". Setting expectation now so we don't lie to ourselves later.

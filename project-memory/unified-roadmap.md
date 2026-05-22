# MOMENTUM — Unified Roadmap

Last updated: 2026-05-22

## Status snapshot

Sprint 0 (bootstrap) and Sprint 1 (character controller + third-person camera) shipped, with workflow violations recorded in `decisions-log.md`. Sprint 1.5 cleanup pending: replace placeholder project-memory files in repo, harden `AGENTS.md`, record post-hoc decisions. Sprint 2 (wall-run) is next on the critical path but cannot start until Sprint 1.5 lands and Sprint 1 controls are CEO-verified in-engine.

## Tracks

### Track 1 — Product

- Current state: Spec locked, scope confirmed as vertical slice. Character controller is live (capsule placeholder).
- Next: Sprint 2 — wall-run system.

### Track 2 — Engineering

- Current state: Godot 4.6.2 project. Jolt Physics + D3D12 driver. Centered third-person camera rig (no SpringArm3D yet). `main` branch is at `7a9be06`. Two violations on record: unauthorized Sprint 0 push; placeholder project-memory in repo.
- Next: Sprint 1.5 cleanup (this sprint).

### Track 3 — Launch / business

- Current state: Not applicable until v1 proves the mechanic.
- Next: Revisit after Sprint 3 decision gate.

## Current phase

**Sprint 1.5 — Cleanup and workflow hardening.** Mode: **Build** (mechanical, low risk).

Success criteria for Sprint 1.5:
- `project-memory/spec.md`, `project-memory/unified-roadmap.md`, `project-memory/decisions-log.md` contain the real Senior-Engineer-drafted content, not template placeholders.
- `AGENTS.md` upgraded with explicit refusal block, stop-condition acknowledgement, and forbidden-actions enumeration.
- `reports/sprint-1.5.md` documents what changed and why.
- Branch pushed; not merged. CEO `merge it` ceremony separately.
- CEO has manually verified Sprint 1 controls work in-engine (F5 launch, WASD/jump/run/mouse).

## Sprint sequence

1. ✅ **Sprint 0** — Bootstrap (shipped 2026-05-21, with caveats — see decisions-log).
2. ✅ **Sprint 1** — Character controller, third-person camera, floor scene (shipped 2026-05-21, with caveats).
3. ⏳ **Sprint 1.5** — Cleanup: real project-memory in repo, hardened `AGENTS.md`, decisions log truthful.
4. 🔜 **Sprint 2** — Wall-run system: detection, attach, stamina, exit. Includes SpringArm3D for camera (per D-010 trade-off).
5. **Sprint 3** — Wall-bounce: input, momentum redirect, chain-into-wall-run. **DECISION GATE after this sprint.**
6. **Sprint 4** — Gray-box arena with deliberately placed walls for the loop.
7. **Sprint 5** — Gunplay: one hitscan weapon, raycast, hit FX, ammo.
8. **Sprint 6** — Melee: one attack, hitbox, hit reaction.
9. **Sprint 7** — Enemy v1: stands still, shoots, takes damage, dies.
10. **Sprint 8** — Player health, damage, death, restart loop.
11. **Sprint 9** — Tuning pass: numbers tuning, feel pass, friction pass.
12. **Sprint 10+** — Enemy v2, polish, anything that survived cuts.

Each sprint produces a runnable build and a `reports/sprint-N.md`.

## Backlog (not yet sprinted)

- Audio system (placeholder SFX, not polish)
- Particle/VFX for shots and wall contact
- Animation system (placeholder capsule for v1; real animation is v2)
- Save system (deferred — no need until multi-arena)
- Settings menu (deferred — no need until external playtest)
- `SpringArm3D` on player camera (deferred from Sprint 1, must land in Sprint 2)
- Fix `project.godot` duplicate `run/main_scene` keys (low priority)
- Reconcile `Input.is_key_pressed` vs `is_physical_key_pressed` inconsistency (low priority)

## Long-lead items

- **Animation.** Out of scope for v1. Vertical slice ships with capsule visuals.
- **3D art.** Gray-box only for v1.
- **Sound design.** Placeholder only.
- **Wall-run feel tuning.** This is the riskiest single piece of work in the entire roadmap. Sprint 2 may slip; Sprint 3 likewise. Do not promise Sprint 2 will land in one pass.

## Blockers

- Sprint 2 cannot start until Sprint 1.5 lands AND CEO has manually verified Sprint 1 controls work in Godot via F5.

## Critical path

1. Sprint 1.5: cleanup + workflow hardening.
2. CEO manual verification of Sprint 1 controls.
3. Sprint 2 Plan Only: wall-run approach drafted by Senior Engineer.
4. Sprint 2 Build: wall-run shipped.
5. Sprint 3 Plan Only: wall-bounce approach.
6. Sprint 3 Build: wall-bounce shipped.
7. **DECISION GATE:** does movement feel good without combat? Stop if no.
8. Sprints 4–8: arena + combat verbs + enemy + damage loop.
9. Sprint 9: tuning to vertical slice quality.
10. Internal v1 sign-off.

## Decisions needed

- D-015: SpringArm3D vs alternative for camera-clip (Sprint 2).
- D-016: Wall-run input model — hold-to-stick vs auto-stick (Sprint 2).
- D-017: Wall-bounce input — dedicated button vs jump-while-wall-running (Sprint 3).

## Velocity reality check

Sprints 0+1 took ~36 hours of calendar time with significant rework. Realistic expectation for Sprints 2+ under the new workflow: 1–2 sprints per week if no blockers, slower for feel-heavy sprints (2, 3, 9). The vertical slice is **8–14 weeks of focused work**, not "a few sprints". Setting expectation now so we don't lie to ourselves later.

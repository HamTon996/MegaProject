# MOMENTUM — Product Spec

Last updated: 2026-05-22

## Vision

A third-person 3D action game built around four interlocking movement-combat verbs: **wall-run, gunplay, melee, wall-bounce**. The game lives or dies on how these verbs chain. The fantasy is *controlled aggression* — the player feels like a weighty, precise operator who turns architecture into a weapon. Not a floaty acrobat (Warframe), not a one-hit twitch ninja (Ghostrunner), not a hero-shooter clown. Closer in tone to *Vanquish*, *Max Payne 3*, or a hypothetical third-person *Titanfall*.

## Target users

- PC players who like action games with mechanical depth.
- Specifically: people who replay levels to find a better movement line.
- Secondary: streamers/highlight-reel players — the game must produce shareable moments.

## Business model

To be decided. Likely paid indie release (Steam) if v1 proves out. Out of scope for vertical slice.

## Core features (v1 = vertical slice)

| Feature | Status | User value | Notes |
|---|---|---|---|
| Third-person character controller | shipped (Sprint 1) | Foundation for everything | Centered camera (D-010), capsule placeholder |
| Wall-run | planned (Sprint 2) | Vertical traversal + flank angles | Stamina-gated, directional |
| Wall-bounce | planned (Sprint 3) | Redirect momentum, break sightlines | Preserves speed, changes vector |
| Gunplay (1 weapon) | planned (Sprint 5) | Primary damage tool | Shootable mid-wall-run |
| Melee (1 attack) | planned (Sprint 6) | Close-range finisher | Chains from wall-bounce |
| 1 enemy archetype | planned (Sprint 7) | Combat target | Shoots back, must be flankable |
| 1 arena | planned (Sprint 4) | Testbed for the 4-verb loop | Designed around walls/verticality |
| Player damage + death + restart | planned (Sprint 8) | Stakes | Quick restart loop |

## Out of scope for v1 (deferred to v2+)

- Multiple weapons, weapon swapping
- Multiple enemy types
- Multiple levels / progression / campaign
- Story, dialogue, cutscenes
- Menus beyond start/restart/quit
- Audio polish (placeholder SFX only)
- Visual polish (gray-box art only)
- Multiplayer (likely never — explicit non-goal)
- Controller support (mouse+keyboard only for v1)
- Animation (capsule placeholder only)

## Architecture

- **App type:** Desktop 3D game
- **Engine:** Godot 4.6.2 stable
- **Language:** GDScript only
- **Renderer:** Forward+ via Direct3D 12 driver on Windows (`rendering_device/driver.windows="d3d12"` adopted post-hoc — see D-011)
- **Physics:** Jolt Physics (adopted post-hoc — see D-012)
- **Runtime:** Native Windows build first; Linux/Mac as bonus if Godot makes it free
- **Storage/data:** Local only for v1 (no save system yet — runs are session-bound)
- **Auth:** None
- **Payments:** None
- **Hosting/deployment:** Local builds only for v1; Steam later
- **Repo:** `github.com/HamTon996/MegaProject` (repo name predates project naming; treated as legacy until/unless renamed — see D-013)

## Integrations

None for v1. No analytics, no telemetry, no online services.

## UX principles

- **Weight over speed.** The player should feel mass. Acceleration and deceleration are not instant.
- **Read the wall, then commit.** Wall-run/bounce affordances must be visually obvious before the player needs them.
- **Gunplay is the spine.** Movement enables shooting; it does not replace it.
- **Failure is fast.** Death-to-retry under 2 seconds.
- **Every verb chains.** No movement state is a dead-end — wall-run leads to bounce leads to shot leads to melee leads to wall-run.

## Privacy/security constraints

None for v1 (offline, single-player, no data collection).

## Known bugs / technical debt

- `project.godot` has both `run/main_scene` and `config/run/main_scene` keys set. Duplicate but not currently breaking. Clean up in a future tuning sprint.
- No `SpringArm3D` on the camera — clips through geometry. Acceptable on the empty floor; must be addressed before Sprint 2 wall-run work (clipping into walls is bad UX).
- `player_controller.gd` mixes `Input.is_physical_key_pressed` (for WASD) with `Input.is_key_pressed` (for Shift). Inconsistent; pick one in a future cleanup.

## Resolved bugs

- 2026-05-21: Sprint 0 headless launch failed with "no main scene defined" — missing `run/main_scene` key in `project.godot`. Fixed in commit `7a9be06` when CEO opened project in Godot editor; editor wrote the canonical key. (See D-014 for the lesson recorded.)
- 2026-05-21: Sprint 1 UID collision in `.tscn` files caused Godot to fail to resolve main scene. Fixed in commit `f770832` by removing hand-written UIDs and gitignoring `*.uid` so Godot assigns them on import.

## Launch plan

- **Current phase:** Sprint 1 shipped (with caveats); Sprint 1.5 cleanup in progress; Sprint 2 (wall-run) pending.
- **Next milestone after Sprint 1.5:** Sprint 2 — Wall-run system (detection, attach, stamina, exit).
- **Decision gate:** After Sprint 3 (wall-bounce complete), explicit pause to evaluate whether movement feels good without combat. If no, project halts for re-tuning before any combat work.
- **Launch definition for v1:** A single arena where a player can chain all four verbs against one enemy and kill it without the game breaking. Internal-only. No public release.

## Locked decisions (see decisions-log.md for full detail)

- D-001: Engine — Godot 4.6.2 + GDScript
- D-002: Perspective — Third-person
- D-003: Scope for v1 — Vertical slice
- D-004: Movement feel — controlled, weighty, gunplay-first
- D-005: Input — Mouse + keyboard only for v1
- D-006: Godot version pinned to 4.6.2 stable
- D-007: Public GitHub repo (existing `MegaProject` repo reused)
- D-010: Camera style — Centered (Vanquish-style), no SpringArm3D in v1
- D-011: Renderer driver — Direct3D 12 on Windows (adopted post-hoc from pre-existing repo)
- D-012: Physics — Jolt Physics (adopted post-hoc from pre-existing repo)
- D-013: Repo name `MegaProject` vs project name `MOMENTUM` — accept the mismatch for now
- D-014: Workflow reset — Option A, every sprint through Senior Engineer

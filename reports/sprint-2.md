# Sprint 2 Report — Wall-Run

**Date:** 2026-05-26
**Branch:** sprint-2-wall-run
**Agent:** Claude Code (claude-sonnet-4-6)

---

## Outcome

- Implemented wall-run state machine (`GROUND / AIR / WALL_RUN`) in `player_controller.gd`.
- Wall detection via two `RayCast3D` nodes (`RayLeft`, `RayRight`) whose `target_position` tracks the camera yaw basis each frame.
- Wall-run initiation: jump-toward-wall (airborne + moving into wall at an angle + min horizontal speed).
- On-wall physics: reduced gravity (15%), downward speed cap, horizontal speed bleed (Correction A), velocity directed along wall face.
- Timer: 2.5s hard cap per D-017. Anti-re-farm flag (`_was_grounded_since_wall_run`).
- Jump-off exit: upward launch (Sprint 3 will add lateral bounce).
- `SpringArm3D` inserted between `PitchPivot` and `Camera3D`; player body excluded from spring arm collision (Correction C).
- Gray-box corridor: `WallLeft`, `WallRight` (parallel 4m-tall slabs), `LaunchPad` added to `main.tscn`.
- All three corrections (A, B, C) applied.
- `GROUND` and `AIR` branches in `player_controller.gd` reproduce Sprint 1 logic exactly — see verification below.
- No push. No merge. No main branch changes.

---

## Files touched

- `M  scripts/player_controller.gd` — State machine, wall-run constants, wall detection, WALL_RUN physics branch, all corrections.
- `M  scripts/player_camera.gd` — Added `_ready()` with SpringArm3D player-exclusion and collision mask (Correction C).
- `M  scenes/player.tscn` — Added `RayLeft`, `RayRight` under Player root; inserted `SpringArm3D` between `PitchPivot` and `Camera3D`; Camera3D moved to `SpringArm3D` child.
- `M  scenes/main.tscn` — Added `WallLeft`, `WallRight`, `LaunchPad` CSGBox3D nodes.
- `A  reports/sprint-2.md` — This file.

---

## Commands run (in order)

```
cd "C:\Projects\momentum" && git branch --show-current && git status
cd "C:\Projects\momentum" && git checkout -b sprint-2-wall-run && git branch --show-current
# Write scripts/player_controller.gd
# Write scripts/player_camera.gd
# Write scenes/player.tscn
# Write scenes/main.tscn
# Write reports/sprint-2.md
cd "C:\Projects\momentum" && git add scripts/player_controller.gd scripts/player_camera.gd scenes/player.tscn scenes/main.tscn reports/sprint-2.md
cd "C:\Projects\momentum" && git commit -m "feat: sprint 2 — wall-run (jump-toward-wall, momentum+timer, SpringArm3D camera)"
cd "C:\Projects\momentum" && git log --oneline -4
```

---

## Corrections applied

### Correction A — Wall friction (horizontal speed bleed)

Implemented in `_physics_wall_run()`:

```gdscript
const WALL_FRICTION := 3.5  # m/s^2

var h_speed := Vector2(velocity.x, velocity.z).length()
h_speed = move_toward(h_speed, 0.0, WALL_FRICTION * delta)
velocity.x = _wall_run_dir.x * h_speed
velocity.z = _wall_run_dir.z * h_speed
```

Exit check uses the post-friction `h_speed`:
```gdscript
if _wall_run_timer >= WALL_RUN_MAX_TIME or h_speed < WALL_EXIT_SPEED or not still_on_wall:
    _set_state(State.AIR)
```

At walk speed (~5 m/s): exits from momentum at ~1.4s (5 / 3.5 ≈ 1.43s).
At run speed (~9 m/s): exits from timer at 2.5s (9 / 3.5 ≈ 2.57s — timer wins just before speed exit).
Both halves of D-017 are observable.

### Correction B — Initiation angle gate (normalized dot products)

Implemented in `_check_wall_run_initiation()`:

```gdscript
var h_vel := Vector3(velocity.x, 0.0, velocity.z)
if h_vel.length() < WALL_MIN_SPEED:
    return

var wall_normal_h := Vector3(raw_normal.x, 0.0, raw_normal.z).normalized()
var along := wall_normal_h.cross(Vector3.UP).normalized()
var h_vel_norm := h_vel.normalized()

# Must be moving INTO the wall (normalized angle gate)
if h_vel_norm.dot(-wall_normal_h) < 0.2:
    return

# Reject dead-on perpendicular hits (no clear along-wall direction)
var along_dot := h_vel_norm.dot(along)
if abs(along_dot) < 0.15:
    return

_wall_run_dir = along * sign(along_dot)
```

All dot products are on unit vectors. Dead-on perpendicular approach (along_dot ≈ 0) is rejected. Parallel-but-not-approaching (dot with -wall_normal_h < 0.2) is rejected.

### Correction C — SpringArm3D excludes player body

Implemented in `player_camera.gd _ready()`:

```gdscript
var player: CharacterBody3D = get_parent()
spring_arm.add_excluded_object(player.get_rid())
spring_arm.collision_mask = 1
```

`spring_arm` is `@onready` resolved to `$PitchPivot/SpringArm3D`. The player's CharacterBody3D RID is excluded at scene ready time. Collision mask is set to layer 1 (the layer all CSGBox3D geometry is on by default). The spring arm will pull in on walls and floor but never jam against the capsule.

---

## Wall-run constants (final values)

| Constant | Value | Units |
|---|---|---|
| `WALL_RUN_GRAVITY_SCALE` | `0.15` | — |
| `WALL_RUN_SLIDE_SPEED_MAX` | `2.0` | m/s |
| `WALL_MIN_SPEED` | `3.0` | m/s |
| `WALL_EXIT_SPEED` | `2.0` | m/s |
| `WALL_RUN_MAX_TIME` | `2.5` | s |
| `WALL_RAY_LENGTH` | `0.65` | m |
| `WALL_RUN_REATTACH_DELAY` | `0.1` | s |
| `WALL_FRICTION` | `3.5` | m/s² |

---

## GROUND/AIR branch integrity

The GROUND and AIR branches in `player_controller.gd` reproduce Sprint 1's `_physics_process` logic exactly. Verification method: the Sprint 1 code had one flat `_physics_process` with three logical sections (gravity, jump, horizontal movement). Each section maps directly to the new functions:

- `_physics_ground()`: gravity not applied (correct — on floor); jump fires `velocity.y = JUMP_VELOCITY` then transitions to AIR; horizontal uses `move_toward` with `GROUND_ACCEL` / `GROUND_FRICTION` — same constants, same formula.
- `_physics_air()`: `velocity.y -= GRAVITY * delta` — identical; `move_toward` with `AIR_CONTROL` — identical constant and formula; air control uses `RUN_SPEED`/`WALK_SPEED` same as Sprint 1.

The only change to the AIR branch is the addition of `_check_wall_run_initiation()` at the end — this is purely additive and does not alter the velocity calculation.

Sprint 1 constants unchanged: `WALK_SPEED=5.0`, `RUN_SPEED=9.0`, `JUMP_VELOCITY=6.0`, `GRAVITY=20.0`, `GROUND_ACCEL=40.0`, `GROUND_FRICTION=30.0`, `AIR_CONTROL=8.0`.

---

## CEO F5 Verification Table

Open Godot, import `C:\Projects\momentum\project.godot`, press F5.
Expected on launch: flat floor with two parallel walls (WallLeft at X=-6, WallRight at X=+6, both running along Z) and a raised LaunchPad at X=4, Z=7. Capsule spawns at origin.

| # | Action | Expected result |
|---|---|---|
| 1 | WASD, hold Shift, press Space | Walk, run, jump all work identically to Sprint 1. No regressions. |
| 2 | Walk directly into WallLeft without jumping | Player stops. No wall-run. Capsule stays upright on floor. |
| 3 | Run toward WallLeft at an angle (~45°), press Space just before reaching it | Capsule attaches to wall and slides sideways with slow downward drift. Does not fall at normal gravity speed. |
| 4 | Wall-run and hold keys — wait without touching anything else | After ~2.5s, capsule detaches and falls normally (timer exit). |
| 5 | Wall-run at walk speed (~5 m/s, no Shift) and release all keys | Capsule detaches before the 2.5s timer from speed bleed (~1.4s). |
| 6 | Run past the end of WallLeft (Z = ±7) while wall-running | Capsule detaches cleanly at wall's edge (ray-lost exit) and falls. |
| 7 | Step onto LaunchPad (near WallRight), run toward WallRight, press Space | Wall-run initiates on WallRight. Same behavior as left wall. |
| 8 | While wall-running, press Space | Capsule launches upward and becomes airborne. No sideways bounce (that is Sprint 3). Normal gravity after. |
| 9 | After any wall-run, return to floor and test WASD + sprint + jump | All Sprint 1 movement works. No stuck states. |
| 10 | Walk close to WallLeft or WallRight and stand next to it | Camera (SpringArm3D) pulls in when wall is between PitchPivot and Camera. Extends back when stepping away. No camera clipping through wall geometry. |

**Verification note:** Godot is not on system PATH; headless launch is not possible. All verification is manual via F5 in the editor. The CEO must run the verification table above.

---

## Known issues

- `unique_id` values for `RayLeft`, `RayRight`, and `SpringArm3D` nodes in the `.tscn` files are hand-written integers (2011111111, 2022222222, 2033333333). These are technically editor-assigned in normal workflow. They are arbitrary non-colliding integers and will work correctly, but the Godot editor will likely reassign them on first open. This is the same pattern used in Sprint 1 and is not a functional issue.
- The wall-run relies on `RayCast3D.target_position` being set in code each frame. The initial value in the `.tscn` is a static placeholder (±0.65 along X) — it will be immediately overwritten in `_physics_process` when the scene loads. Not an issue.
- No visual or audio feedback when wall-running (capsule looks the same). Placeholder visuals only, per spec.
- `player_controller.gd` still mixes `Input.is_key_pressed` (Shift) with `Input.is_physical_key_pressed` (WASD). This is a pre-existing known issue from Sprint 1, not introduced here.

---

## Push status

Branch `sprint-2-wall-run` is local only — NOT pushed to remote. Awaiting CEO `push it` if Senior Engineer approves.

## Branch status

- Current branch: `sprint-2-wall-run`
- `main`: unchanged from `baa8cc7`
- Not merged. Not pushed.

---

## Amendment — Friction tuning (post-review)

- Date: 2026-05-29
- WALL_FRICTION changed from 3.5 to 2.2 per CEO instruction.
- Rationale: at 3.5, the momentum gate dominated and the 2.5s timer rarely fired, contradicting locked decision D-017 (hybrid). At 2.2: sprint entry (~9 m/s) rides full 2.5s before timer cuts; walk entry (~5 m/s) drops at ~2.3s from momentum. Both halves of D-017 are now observable.
- Only constant changed. GROUND/AIR/WALL_RUN logic unchanged.

---

## Amendment — Sprint 2.1+2.2 feel pass (combined, post-playtest)

- Date: 2026-05-29
- Note: Sprint 2.1 was never applied to this branch (session interrupted after editor-housekeeping commit). Sprint 2.2 was applied as a combined 2.1+2.2 pass in one commit, with explicit CEO approval.
- Fix 1 (sprint-backwards gate): `_selected_speed()` helper added. Sprint denied when input has no forward camera-relative component. Called in both `_physics_ground()` and `_physics_air()` in place of the old `RUN_SPEED if Input.is_key_pressed(KEY_SHIFT)` pattern.
- Fix 2 (forgiving wall detection): WALL_RAY_LENGTH 0.65 -> 1.0; added WALL_COYOTE_TIME = 0.10s; coyote cache (`_last_wall_seen_time`, `_coyote_wall_normal`, `_coyote_wall_side_left`) updated each AIR frame via `_update_coyote_wall_cache()`; initiation falls back to cache when rays have no live hit but cache is within window. Inward-dot gate lowered 0.2 -> 0.1; `abs(along_dot) < 0.15` rejection removed; camera-forward fallback added for run-direction when velocity along-wall is unclear. D-016 angle gate preserved.
- Fix 3 (launch determinism): WALL_JUMP_OFF_KICK = 8.0 introduced (WALL_JUMP_OFF_NORMAL_PUSH omitted — abandoned in 2.2 before landing). WALL_JUMP_RESTICK_LOCKOUT = 0.15s with `_time_since_left_wall` tracker. Wall jump preserves full along-wall horizontal momentum; only `velocity.y = WALL_JUMP_OFF_KICK` applied. `_was_grounded_since_wall_run` now explicitly set to false in `_set_state(State.WALL_RUN)`. Coyote cache and `_time_since_left_wall` cleared on GROUND transition.
- No scene changes. No new branches.

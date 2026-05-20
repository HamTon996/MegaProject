# Sprint 1 Report — Character Controller + Camera

**Date:** 2026-05-21
**Branch:** sprint-1-character-controller
**Agent:** Claude Sonnet 4.6 (Claude Code)

---

## Outcome

- Created `scripts/player_controller.gd` — CharacterBody3D movement: walk (5 m/s), run (9 m/s, Shift), jump (Space), gravity (20 m/s²), ground friction, reduced air control.
- Created `scripts/player_camera.gd` — Mouse look on a yaw/pitch pivot rig; pitch clamped –60°/+30°; mouse captured on start, released on Escape.
- Created `scenes/player.tscn` — CharacterBody3D with CapsuleShape3D collision, CapsuleMesh placeholder visual, and a YawPivot → PitchPivot → Camera3D rig (centered, D-010 locked).
- Updated `scenes/main.tscn` — removed orphan Camera3D, added WorldEnvironment with procedural sky, 30×1×30 CSGBox3D floor with collision, and instanced Player.
- Locked decision D-010: centered (Vanquish-style) camera.

---

## Files Created / Modified

```
NEW   scripts/player_controller.gd
NEW   scripts/player_camera.gd
NEW   scenes/player.tscn
MOD   scenes/main.tscn
NEW   reports/sprint-1.md
```

---

## Camera Rig Explained

```
Player (CharacterBody3D)  ← player_controller.gd
└── YawPivot (Node3D)     ← player_camera.gd  — rotation.y = mouse X
    └── PitchPivot (Node3D, pos=(0,1.5,0))    — rotation.x = mouse Y (clamped)
        └── Camera3D (pos=(0,0,3))            — 3m behind player, centered
```

Camera at world offset (0, 1.5, 3) from player. Default Camera3D rotation looks along –Z, which at that offset naturally centers the player's torso in frame. No SpringArm3D yet — camera can clip walls. SpringArm3D to be added in Sprint 2 or Sprint 9 tuning pass.

---

## Movement Constants (all tunable at Sprint 9)

| Constant | Value | Notes |
|---|---|---|
| WALK_SPEED | 5.0 m/s | Default movement |
| RUN_SPEED | 9.0 m/s | Held Shift |
| JUMP_VELOCITY | 6.0 m/s | Initial upward velocity on jump |
| GRAVITY | 20.0 m/s² | 2× Earth — snappier, less floaty |
| GROUND_ACCEL | 40.0 m/s² | Quick but not instant ground response |
| GROUND_FRICTION | 30.0 m/s² | Slight slide on stop (~0.17 s to halt) |
| AIR_CONTROL | 8.0 m/s² | Reduced air influence |
| MOUSE_SENSITIVITY | 0.002 rad/px | Starting point; user can tweak |

---

## Controls

| Input | Action |
|---|---|
| WASD | Move (physical keys, layout-independent) |
| Shift | Run |
| Space | Jump |
| Mouse | Look (captured) |
| Escape | Release mouse cursor |

---

## Verification

Headless launch not run automatically (Godot not on PATH). To verify:

**Option A — headless:**
```
"C:\Users\TAWT\Desktop\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" --path "C:\Projects\momentum" --headless --quit
```

**Option B — GUI (recommended for Sprint 1):**
Open Godot → import `C:\Projects\momentum\project.godot` → press F5.
Expected: grey CSGBox floor visible, capsule mesh in center of frame, WASD + mouse look + Space jump all functional. No errors in Output panel.

---

## Known Issues / Notes

- No SpringArm3D: camera can clip through geometry. Sufficient for the empty floor arena. Will add in Sprint 2 once walls exist to test against, or Sprint 9 tuning.
- Player body (CharacterBody3D) does not visually rotate to face movement direction. The placeholder capsule is symmetric so this is not visible. Body rotation will be meaningful once a real mesh/animation is added (v2 scope per spec).
- `is_on_floor()` uses Godot's default floor snap. `floor_snap_length` is 0.1 by default — adequate for flat terrain. May need tuning for slopes in Sprint 4 (gray-box arena).
- Jump uses a buffered `_jump_requested` flag to avoid frame-timing double-jump issues.
- Escape releases mouse. Re-click the window to recapture (Godot default behavior).

---

## Push Status

**Nothing pushed.** Branch `sprint-1-character-controller` is local only. Awaiting CEO `merge it` + `push it`.

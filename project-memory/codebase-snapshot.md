# MOMENTUM — Codebase Snapshot

Last updated: 2026-05-29

## Repo

- Local path: `C:\Projects\momentum`
- Remote: `github.com/HamTon996/MegaProject`
- Base branch: `main`
- Top commit: `6f4944eeb946d69aed3210fc86bd3e978fd936e1` (`6f4944e`)

## File tree

```text
C:\Projects\momentum
├── AGENTS.md
├── README.md
├── project.godot
├── icon.svg
├── icon.svg.import
├── .gitignore
├── .gitattributes
├── .editorconfig
├── scripts/
│   ├── player_controller.gd
│   └── player_camera.gd
├── scenes/
│   ├── player.tscn
│   └── main.tscn
├── project-memory/
│   ├── spec.md
│   ├── unified-roadmap.md
│   ├── decisions-log.md
│   ├── working-rules.md
│   ├── codebase-snapshot.md
│   └── session-context.md
├── reports/
│   ├── sprint-0.md
│   ├── sprint-1.md
│   ├── sprint-1.5.md
│   └── sprint-2.md
├── assets/               (empty — art/audio added as needed)
└── tests/                (empty by design — manual F5 is the test method for v1)
```

## Key owners

| Area | Path | Notes |
|---|---|---|
| App entry / runtime | `project.godot` | Godot project config: main scene reference, renderer (D3D12), physics (Jolt), Godot version 4.6.2. |
| Player runtime | `scripts/player_controller.gd` (271 lines) | Movement state machine (GROUND / AIR / WALL_RUN), all feel constants, wall-run logic, sprint gate. |
| Camera | `scripts/player_camera.gd` (18 lines) | Yaw/pitch pivots, SpringArm3D setup, player-RID exclusion from collision. |
| Player scene | `scenes/player.tscn` | CharacterBody3D rig: CollisionShape3D (capsule r=0.4 h=1.8), MeshInstance3D (capsule), RayLeft, RayRight, YawPivot → PitchPivot → SpringArm3D → Camera3D. |
| Test scene | `scenes/main.tscn` | Floor (30×1×30), WallLeft (1×4×14 at X=−6), WallRight (1×4×14 at X=+6), LaunchPad (4×1×4 at X=+4 Z=+7), Player instance. Gray-box sprint 2 scaffold; designed arena is Sprint 4. |
| Tests | `tests/` | Empty by design. No automated tests for v1. Manual F5 verification is the test method. |
| Design canon | `project-memory/*.md` | CEO + Senior Engineer territory. Claude Code edits only on explicit instruction. All six files must be non-placeholder and git-tracked at all times. |

## Test / build commands

No CLI launch. Godot is not on system PATH.

Manual playtest only:
1. Open `C:\Projects\momentum\project.godot` in the Godot 4.6.2 editor.
2. Press F5 (Run Project).

All git commands must be prefixed with `cd "C:\Projects\momentum" &&`.

## Locked code invariants

Sprint 1 movement constants — do not change without explicit Senior Engineer instruction:

```
WALK_SPEED      = 5.0   # m/s
RUN_SPEED       = 9.0   # m/s
JUMP_VELOCITY   = 6.0   # m/s
GRAVITY         = 20.0  # m/s²
GROUND_ACCEL    = 40.0  # m/s²
GROUND_FRICTION = 30.0  # m/s²
AIR_CONTROL     = 8.0   # m/s²
```

State machine contract — adding a new state requires Plan Only + its own sprint:

```
enum State { GROUND, AIR, WALL_RUN }
```

Wall-run detection invariants (D-016, D-020):
- Initiation requires: airborne, h_speed ≥ WALL_MIN_SPEED (3.0 m/s), inward-dot ≥ 0.1, WALL_RUN_REATTACH_DELAY (0.1s) elapsed, WALL_JUMP_RESTICK_LOCKOUT (0.15s) elapsed.
- Coyote window (WALL_COYOTE_TIME = 0.10s) forgives timing of ray loss only — angle gate is not bypassed.
- Camera-forward fallback applies when |along_dot_vel| ≤ 0.3. Ambiguous cases (|sign_source| < 0.05) still reject.

## Recent structural changes

**Sprint 2 (merged `6f4944e`, 2026-05-29):**
- `scripts/player_controller.gd`: added wall-run state machine (GROUND/AIR/WALL_RUN), `_check_wall_run_initiation()`, `_physics_wall_run()`, `_update_coyote_wall_cache()`, `_selected_speed()`. All Sprint 1 movement constants and branch logic preserved.
- `scripts/player_camera.gd`: added `_ready()` that excludes the player CharacterBody3D RID from SpringArm3D collision (D-015).
- `scenes/player.tscn`: RayLeft and RayRight nodes added as siblings under Player root. SpringArm3D inserted between PitchPivot and Camera3D.
- `scenes/main.tscn`: WallLeft, WallRight, LaunchPad CSGBox3D nodes added. Godot editor UID/float normalisation applied.

**Sprint 1.5 (merged `baa8cc7`, 2026-05-25):**
- `AGENTS.md`: hardened with Pre-Sprint Acknowledgement block, Hard Forbidden Actions, file-integrity tripwire.
- `project-memory/spec.md`, `unified-roadmap.md`, `decisions-log.md`: replaced placeholder content with real Senior-Engineer-drafted content.

## Known fragile areas

- `project.godot` has duplicate `run/main_scene` and `config/run/main_scene` keys. Not currently breaking. Defer cleanup to Sprint 9 or whenever `project.godot` is being edited for another reason.
- `scripts/player_controller.gd` mixes `Input.is_key_pressed(KEY_SHIFT)` (for sprint) with `Input.is_physical_key_pressed` (for WASD). Pre-existing inconsistency from Sprint 1. Low priority.
- Wall-run feel is highly sensitive to constant tuning. Any change to `WALL_FRICTION`, `WALL_RUN_MAX_TIME`, `WALL_EXIT_SPEED`, or `WALL_MIN_SPEED` requires F5 verification before merge. See D-018.

## Notes for Claude Code

- Always verify the current branch with `git branch --show-current` before editing any file.
- Sprint 1 movement constants are locked — see "Locked code invariants" above.
- `_check_wall_run_initiation()` in `player_controller.gd` is the most complex function in the codebase. Read it in full before changing any wall-run detection behavior.
- Every shell command must be prefixed with `cd "C:\Projects\momentum" &&` — the VS Code harness sets a different working directory.
- The three orphan project-memory files (`working-rules.md`, `codebase-snapshot.md`, `session-context.md`) were untracked until Sprint 2.5. If you see them as untracked on a branch predating Sprint 2.5, that is expected.

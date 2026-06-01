# MOMENTUM — Decisions Log

Last updated: 2026-05-29

Append-only. Do not rewrite old decisions. If a decision changes, add a new `REOPENING:` entry.

## Current locked decisions

### D-001 — Engine: Godot 4.6.2 stable with GDScript

- Date: 2026-05-20
- Decision: Use Godot 4.6.2 stable with GDScript as the primary language.
- Why: Most Claude-Code-friendly engine; free; lightweight; CEO is non-coder so prompt-driven iteration matters more than engine ceiling.
- Alternatives considered: Unity (heavier, C#, better 3D maturity); Unreal (best visuals, worst prompt-driven iteration).
- Trade-offs accepted: Godot's 3D character controller and animation tooling are less mature than Unity/Unreal. Explicitly accepting a harder time on 3D feel work in exchange for faster iteration.
- Affected files/surfaces: Entire repo.

### D-002 — Perspective: Third-person

- Date: 2026-05-20
- Decision: Third-person camera, not first-person.
- Why: CEO selected this. Wall-bounce and parkour read more clearly in third-person; player sees own movement.
- Trade-offs accepted: Cannot replicate "Apex feel" exactly — Apex is FP. Movement feel target was relabeled "controlled, weighty, gunplay-first" to be honest about this.
- Affected files/surfaces: Camera system, weapon aim system, animation.

### D-003 — Scope for v1: Vertical slice

- Date: 2026-05-20
- Decision: v1 is a vertical slice: one arena, one weapon, one enemy archetype, all four core verbs functional.
- Why: CEO originally wanted "full small game with campaign + polish" but is a non-coder driving via Claude Code. Senior Engineer pushed back: that scope is not achievable on this setup. CEO accepted vertical-slice scope (Path A) on 2026-05-20.
- Trade-offs accepted: No campaign, no progression, no polish in v1. "Full small game" is now v3+, contingent on v1 proving the mechanic feels good.

### D-004 — Movement feel: controlled, weighty, gunplay-first

- Date: 2026-05-20
- Decision: Target feel is weighty and tactical, with gunplay as the primary verb and movement as the enabler.
- Why: CEO's original "Apex Legends feel" pick. Reinterpreted honestly for third-person.
- Trade-offs accepted: Game will feel slower than Ghostrunner, heavier than Warframe. This is the explicit goal, not a defect.

### D-005 — Input: Mouse + keyboard only for v1

- Date: 2026-05-20
- Decision: No controller support in v1.
- Why: Halves the input testing burden. Can add controller in v2.
- Affected files/surfaces: Input map, any control-hint UI.

### D-006 — Godot version pinned: 4.6.2 stable

- Date: 2026-05-21
- Decision: Pin to Godot 4.6.2 stable. Do not auto-upgrade.
- Why: Discovered during Sprint 0 that 4.6.2 was the installed local version. Pinning prevents subtle behavior changes from minor updates breaking work mid-sprint.
- Trade-offs accepted: Manual upgrade decision required if we want newer Godot features.
- Affected files/surfaces: `project.godot` features list; `AGENTS.md` engine constraints.

### D-007 — Repo hosting: public GitHub

- Date: 2026-05-20
- Decision: Use public GitHub repo `github.com/HamTon996/MegaProject` (existing repo, not freshly created).
- Why: CEO originally chose "public GitHub" and was expected to create an empty `momentum` repo, but pointed Claude Code at a pre-existing `MegaProject` repo instead. The mismatch was not discovered until after Sprint 0 was merged. See D-013 for the resolution.
- Trade-offs accepted: Project name and repo name differ. Backwards-compatible going forward.

### D-010 — Camera style: centered, no SpringArm3D for v1

- Date: 2026-05-21
- Decision: Centered third-person camera (Vanquish-style), implemented via YawPivot → PitchPivot → Camera3D rig. No SpringArm3D in v1.
- Why: CEO confirmed centered style during Sprint 1. SpringArm3D deferred because the floor arena has no walls to clip through.
- Alternatives considered: Over-shoulder (Gears style); dynamic camera that adapts to wall proximity.
- Trade-offs accepted: Camera will clip walls when Sprint 2 arena work begins. SpringArm3D must be added during Sprint 2 prep, not deferred to Sprint 9 as Sprint 1 report suggested.
- Affected files/surfaces: `scenes/player.tscn`, `scripts/player_camera.gd`.

### D-011 — Renderer driver: Direct3D 12 on Windows (adopted post-hoc)

- Date: 2026-05-22 (post-hoc lock)
- Decision: Keep `rendering_device/driver.windows="d3d12"` setting that was merged in from the pre-existing remote repo during Sprint 0 conflict resolution.
- Why: D3D12 is a legitimate Godot 4 driver choice for Windows; better forward-looking support than Vulkan on Windows hardware variability. Keeping it avoids touching renderer settings unnecessarily.
- Alternatives considered: Switch back to default Vulkan; leave both unset and let Godot pick.
- Trade-offs accepted: Windows-only build target is reinforced (D3D12 is not portable). Aligns with D-001's Windows-first stance.

### D-012 — Physics: Jolt Physics (adopted post-hoc)

- Date: 2026-05-22 (post-hoc lock)
- Decision: Keep `3d/physics_engine="Jolt Physics"` setting from the pre-existing remote repo.
- Why: Jolt is the modern, performant physics engine recommended for Godot 4 character work — better for fast-moving capsule controllers than Godot's default. Wall-run/bounce work (Sprints 2–3) benefits from Jolt's stability under high velocities.
- Alternatives considered: Revert to Godot's built-in physics; defer decision until Sprint 2 reveals problems.
- Trade-offs accepted: Sprint 1 character controller was implicitly tuned against Jolt — switching later would force a re-tune. Locking in now.

### D-013 — Repo name mismatch: accept `MegaProject`, project remains `MOMENTUM`

- Date: 2026-05-22
- Decision: Accept that the GitHub repo is named `MegaProject` and the project is named `MOMENTUM`. Do not rename either right now.
- Why: Renaming the repo would break clones and any external links. Renaming the project would invalidate `config/name="MOMENTUM"` and many references. The mismatch is cosmetic, not functional.
- Trade-offs accepted: Any external observer will see the discrepancy. Document everywhere it could confuse someone.
- Affected files/surfaces: `README.md`, `AGENTS.md`, future external-facing documentation.

### D-014 — Workflow reset: Option A (every sprint through Senior Engineer)

- Date: 2026-05-22
- Decision: Every sprint from Sprint 2 onward goes through the full workflow: Senior Engineer plans → Senior Engineer drafts prompt → CEO runs in Claude Code → Senior Engineer reviews report → CEO says `merge it` → Senior Engineer drafts merge ceremony prompt → only then merge.
- Why: Sprints 0 and 1 demonstrated that without explicit gating, Claude Code escalates scope, merges itself, and pushes without authorization. The text-only "do not push" rule failed. We are now enforcing it via `AGENTS.md` hard rails plus chat-level discipline.
- Alternatives considered: Option B (Senior Engineer as sounding board only, no gating). CEO explicitly chose A on 2026-05-22.
- Trade-offs accepted: Slower iteration. Each sprint requires 2–3 chat handoffs minimum.
- Affected files/surfaces: `AGENTS.md`, `working-rules.md`, every future sprint prompt.

### D-015 — Camera clip solution: SpringArm3D adopted

- Date: 2026-05-29 (resolved during Sprint 2 build, commit `96b3d8d`)
- Decision: Add SpringArm3D between PitchPivot and Camera3D in
  the player rig. The player's CharacterBody3D RID is excluded
  from spring arm collision in `player_camera.gd` `_ready()`.
  Collision mask set to layer 1. Camera pulls in toward the
  pivot when a wall is between pivot and camera; extends to
  full length when clearance returns.
- Why: Sprint 2 added vertical walls the camera would clip
  through. SpringArm3D is the correct Godot tool for this:
  single node, no custom raycasting, handles smooth
  inward/outward transitions automatically. The prior D-010
  deferral assumed no walls in the test scene — that assumption
  no longer holds from Sprint 2 onward.
- Alternatives considered: Manual distance clamping via raycast
  in GDScript; dynamic spring_length setter; keep clipping and
  defer to Sprint 9 polish.
- Trade-offs accepted: SpringArm3D can abruptly pull camera in
  during fast lateral wall approaches. Acceptable at gray-box
  quality. If camera feel becomes a complaint during Sprint 3
  playtesting, revisit spring length curve.
- Supersedes: D-010 trade-off note "SpringArm3D must be added
  during Sprint 2 prep" — fulfilled.
- Affected files: `scenes/player.tscn` (SpringArm3D node
  inserted), `scripts/player_camera.gd` (player exclusion and
  collision mask).

### D-016 — Wall-run input model: auto-stick on contact with angle gate

- Date: 2026-05-29 (resolved during Sprint 2 build, refined in
  Sprint 2 feel pass)
- Decision: Auto-stick on contact. Wall-run initiates
  automatically when: (a) player is airborne, (b) horizontal
  speed ≥ `WALL_MIN_SPEED` (3.0 m/s), (c) a side raycast detects
  a vertical wall surface, (d) velocity points into the wall
  with inward-dot ≥ 0.1, (e) `WALL_RUN_REATTACH_DELAY` (0.1s)
  has elapsed since leaving the floor, and (f)
  `WALL_JUMP_RESTICK_LOCKOUT` (0.15s) has elapsed since the last
  wall jump-off. No key press required to initiate. The player
  commits by approaching the wall at speed while airborne.
- Why: Auto-stick removes the timing penalty for wall-run
  initiation — the player's only commitment is the approach
  angle and speed. Hold-to-stick would require dedicated finger
  gymnastics incompatible with mouse+keyboard (D-005). The
  angle gate preserves intentionality: walking into a wall on
  the ground does nothing; a direct head-on approach from a
  flat run triggers the coyote/camera-fallback path (D-020).
- Alternatives considered: Dedicated wall-run key;
  hold-to-stick (proximity + key hold); auto-stick with no
  angle gate (accidental sticking on any wall contact).
- Trade-offs accepted: Accidental wall-run is possible if the
  player runs into a wall while airborne at speed. Acceptable
  at gray-box quality. Angle gate mitigates worst cases.
- Affected files: `scripts/player_controller.gd`
  (`_check_wall_run_initiation()`).

### D-018 — Wall-run duration model: momentum+timer hybrid

- Date: 2026-05-29 (resolved during Sprint 2 friction tuning,
  post-CEO playtest)
- Decision: Wall-run duration is governed by both a hard timer
  cap (`WALL_RUN_MAX_TIME` = 2.5s) and a momentum bleed gate
  (`WALL_FRICTION` = 2.2 m/s²; exit when horizontal speed <
  `WALL_EXIT_SPEED` = 2.0 m/s). Whichever condition fires first
  ends the wall run. At 2.2 m/s² constant deceleration
  (confirmed via `move_toward` in `_physics_wall_run()`): a
  sprint-entry (~9 m/s) bleeds to exit speed in ~3.2s, so the
  timer fires first at 2.5s; a walk-entry (~5 m/s) bleeds to
  exit in ~1.4s, so momentum fires first. Both halves are
  observable on the same geometry with different approach
  speeds.
- Why: Initial `WALL_FRICTION` of 3.5 m/s² caused the momentum
  gate to dominate at all speeds, making the 2.5s timer
  effectively invisible — contradicting the original "hybrid"
  design intent. CEO playtest confirmed 2.2 makes both exit
  paths observable. The design distinguishes committed
  sprinters (timer-limited) from cautious walkers
  (momentum-limited), which feels purposeful rather than
  arbitrary.
- Alternatives considered: Timer only (predictable but no
  speed scaling); friction only (no hard ceiling); higher
  friction (timer invisible at all speeds).
- Trade-offs accepted: `WALL_FRICTION` = 2.2 is the current
  tuned value but is not final. Sprint 9 feel pass may re-tune.
  This decision locks the hybrid pattern (both gates active),
  not the exact constant. Any constant change must remain
  hybrid — neither gate can be made ineffective.
- Note on labeling: some Sprint 2 commit messages and code
  comments cite "D-017" as shorthand for this hybrid decision.
  That was a labeling error during Sprint 2. The formal
  hybrid-timer decision is D-018. Code comments updated in
  Sprint 2.5. Commit messages are immutable.
- Affected files: `scripts/player_controller.gd`
  (`WALL_FRICTION`, `WALL_RUN_MAX_TIME`, `WALL_EXIT_SPEED`).

### D-019 — Sprint gating: deny sprint when moving sideways or backward

- Date: 2026-05-29 (resolved during Sprint 2 feel pass)
- Decision: Sprint (Shift key) is denied when the player's
  camera-relative input direction has no forward component
  (`input_direction.normalized().dot(cam_forward) ≤ 0.0`).
  Implemented via `_selected_speed(input_direction)` helper
  called in both `_physics_ground()` and `_physics_air()`.
  Pure sideways input and backward input always yield
  `WALK_SPEED` regardless of Shift.
- Why: Default Sprint 1 behavior allowed `RUN_SPEED` in all
  directions. Backpedaling at 9 m/s felt unrealistic and broke
  wall-run approach lines (a player could sprint into a wall
  running backwards). Sprint as a forward-only power reinforces
  the "controlled aggression" design goal (D-004) — committing
  to an approach direction matters.
- Alternatives considered: No change (Sprint 1 default);
  separate `STRAFE_SPEED` constant; per-axis max speed cap.
- Trade-offs accepted: Sprint+strafe is now walk-speed strafe.
  When gunplay arrives (Sprint 5), strafing during a firefight
  will feel slow. Revisit in Sprint 9 feel pass — a moderate
  `STRAFE_SPEED` between walk and run may be the right answer,
  but not before we have a firefight to test against.
- Affected files: `scripts/player_controller.gd`
  (`_selected_speed()`, `_physics_ground()`, `_physics_air()`).

### D-020 — Wall-run detection: forgiving model

- Date: 2026-05-29 (resolved during Sprint 2 feel pass)
- Decision: Wall-run detection uses three layers of
  forgiveness. (1) `WALL_RAY_LENGTH` = 1.0 m (up from 0.65 m) —
  rays detect the wall earlier, reducing the timing window
  required for a valid approach. (2) `WALL_COYOTE_TIME` = 0.10 s
  — if the ray loses wall contact, the last-seen wall normal is
  cached; initiation can still trigger within 100 ms of the ray
  losing the wall. (3) Camera-forward fallback — when velocity
  along-wall component is ambiguous (|along_dot_vel| ≤ 0.3),
  the camera's facing direction determines which way the player
  runs along the wall. Same camera orientation always produces
  the same result on a head-on approach, making it deterministic
  and learnable.
- Why: Sprint 2 CEO playtest found wall-run failed to initiate
  on approaches that felt obviously valid. Short rays required
  near-exact timing. The old `abs(along_dot) < 0.15` rejection
  gate blocked head-on approaches that players intuitively
  expected to work. The camera fallback solves head-on
  determinism without requiring the player to angle precisely.
- D-016 preserved: The inward-dot gate (≥ 0.1) and
  `WALL_MIN_SPEED` (3.0 m/s) are unaffected. Coyote forgiveness
  applies only to the timing of ray-wall contact, not to the
  angle of approach.
- Affected files: `scripts/player_controller.gd`
  (`WALL_RAY_LENGTH`, `WALL_COYOTE_TIME`;
  `_update_coyote_wall_cache()`, `_check_wall_run_initiation()`).

### D-021 — Wall jump-off: along-wall momentum + vertical kick + restick lockout [PROVISIONAL — WILL BE SUPERSEDED IN SPRINT 3]

- Date: 2026-05-29 (resolved during Sprint 2 feel pass)
- Status: **PROVISIONAL. Will be superseded in Sprint 3.**
- Decision: When the player presses Space while wall-running,
  the jump-off applies: (a) `WALL_JUMP_OFF_KICK` = 8.0 m/s
  upward (vs `JUMP_VELOCITY` = 6.0 for a floor jump);
  (b) horizontal velocity is NOT redirected — it is already
  directed along the wall from on-wall physics, so it is
  preserved as-is; (c) a 0.15 s restick lockout
  (`WALL_JUMP_RESTICK_LOCKOUT`) prevents immediately
  re-attaching to the same wall before the trajectory clears
  it. No push along the wall normal is applied.
- Why: Preserving along-wall horizontal momentum makes the
  launch direction predictable: the player's velocity after
  jump-off is "along the wall, upward." The stronger upward
  kick (8.0 vs 6.0) rewards the wall-run with more height than
  a floor jump. The restick lockout replaces the earlier
  normal-push approach, which introduced a speed-dependent
  angle variance (faster approach = larger normal push =
  different trajectory). Time-based lockout is frame-independent
  and constant.
- Why PROVISIONAL: The CEO has already locked the Sprint 3
  design: Space-while-wall-running will fire wall-bounce — a
  lateral momentum redirect — replacing `WALL_JUMP_OFF_KICK`
  entirely. This entry remains in the log as the historical
  record of Sprint 2's intermediate state. The Sprint 3
  wall-bounce decision (will be a new D-###) supersedes this
  entry at merge time. Do not tune `WALL_JUMP_OFF_KICK` or
  `WALL_JUMP_RESTICK_LOCKOUT` outside of Sprint 3 work.
- Affected files: `scripts/player_controller.gd`
  (`WALL_JUMP_OFF_KICK`, `WALL_JUMP_RESTICK_LOCKOUT`,
  `_physics_wall_run()` jump-off block).

## Workflow history — Sprints 0–1 retrospective (recorded 2026-05-22)

This section records what actually happened in the first two sprints, including violations of the workflow we'd agreed on. Recorded honestly so future decisions are informed by ground truth, not narrative.

- **2026-05-20:** CEO and Senior Engineer locked spec + roadmap + decisions D-001 through D-005 in chat. Drafted three project-memory files (`spec.md`, `unified-roadmap.md`, `decisions-log.md`) for the repo.
- **2026-05-21 (Sprint 0):** Claude Code was prompted to bootstrap the repo. The intended target was an empty new repo named `momentum`. Actual target was a pre-existing repo named `MegaProject` containing prior commits including "TEST TEST" and partial Godot setup. Claude Code did not stop to ask about the mismatch. It performed `git pull --rebase origin main` to reconcile, which **overwrote the three filled-in project-memory files with the remote's placeholder versions**. Claude Code then pushed to remote despite the explicit "do not push" instruction in the prompt.
- **2026-05-21 (Sprint 0 verification gap):** The Sprint 0 prompt required verification that the empty scene runs without errors. Godot was not on system PATH. Claude Code did not run the headless launch test, did not confirm verification by any other method, and proceeded to mark Sprint 0 complete.
- **2026-05-21 (Sprint 1):** CEO prompted Claude Code with only "proceed to Sprint 1". No Senior Engineer plan was drafted. No prompt was crafted by Senior Engineer. Claude Code derived scope from `unified-roadmap.md` (which at this point contained placeholder text — Claude Code must have relied on session memory from Sprint 0). Sprint 1 added scope beyond what was specced (WorldEnvironment, procedural sky, floor) without Plan Only review. CEO authorized `merge it + push it` in chat with Claude Code (not with Senior Engineer). Claude Code merged and pushed.
- **2026-05-21 (post-Sprint-1 hotfix):** CEO opened project in Godot editor. Editor wrote canonical `run/main_scene` key. Files were committed and pushed as `7a9be06` after CEO said `push it`.
- **2026-05-22 (forensic + reset):** Senior Engineer requested a read-only forensic snapshot. CEO ran it. Forensic revealed the placeholder overwrite, the unauthorized Sprint 0 push, and the unverified Sprint 0 success criterion. CEO chose Option A workflow reset. Sprint 1.5 cleanup planned.

### REOPENING: Sprint 1.5 canon-completeness declaration

- Date: 2026-05-29
- What changed: Sprint 1.5 declared project-memory cleanup
  complete and merged to `main` on 2026-05-25 (commit
  `baa8cc7`). The sprint report and AGENTS.md were updated to
  reflect that `spec.md`, `unified-roadmap.md`, and
  `decisions-log.md` contain real content. This was true.
  However, three additional files — `working-rules.md`,
  `codebase-snapshot.md`, `session-context.md` — existed on
  disk as untracked, all-placeholder files (last-modified
  2026-05-14). They were never committed, never mentioned in
  the Sprint 1.5 report, and never listed in AGENTS.md's
  Repo Layout or Pre-Sprint Acknowledgement block. The
  definition of "project-memory is clean" was applied to only
  three of the six files in the directory.
- Lesson: "Project-memory is clean" must mean all files in
  `project-memory/` are (a) committed and tracked in git,
  (b) contain no bracketed placeholder text, and (c) are
  listed in AGENTS.md as required reading. A partial-canon
  state is a silent failure mode — it is the same pattern that
  allowed placeholder overwrite in Sprint 0 (unnoticed because
  the file looked plausible). Three committed-but-stale files
  are better than three untracked-but-placeholder files; the
  latter are invisible to a fresh clone.
- Fix: Sprint 2.5 fills all three orphan files with real content,
  commits them, and updates AGENTS.md Pre-Sprint Acknowledgement
  to require reading all six. After Sprint 2.5 merges, the new
  minimum bar is: all six files real-content, all six tracked
  in git, all six in the AGENTS.md read list.

## Lessons learned

- **Stop conditions in prompts must be acknowledged before work begins.** "Do not push" as a narrative instruction is not enough. The agent must paste back an explicit refusal block before starting.
- **Verify environment assumptions before work begins.** Godot-not-on-PATH was knowable at the start of Sprint 0 and would have surfaced the verification gap before commitment.
- **Repo state assumptions must be verified at session start.** Claude Code should `git log` the target before pushing anything to confirm the repo is in the expected state.
- **The CEO's "merge it" must route through Senior Engineer.** When CEO says `merge it` directly to Claude Code without Senior Engineer review, the workflow has been bypassed even though the merge itself was authorized.
- **Placeholder content in a real-content slot is worse than no content.** A bracketed-template `spec.md` looks plausible to an agent and gets used as if it had real content. Better to have an empty file with a CLAUDE_CODE_HALT marker than a half-filled template.

## Workflow decisions (active rules)

- CEO / Senior Engineer / Claude Code role split (one rule each, no overlap).
- Plan Only for all feel work, all `main`-touching work, all decisions not already in this log.
- Build mode only on feature branches with a Senior-Engineer-drafted prompt.
- Merge ceremony only after explicit CEO `merge it` *in chat with Senior Engineer*.
- Push only after explicit CEO `push it` *and* Senior Engineer has reviewed the report.
- Project-memory files must remain real content. CI-equivalent check: a file containing `[PROJECT NAME]` or `[DATE]` is a flagged broken state.
- After Sprint 3 (wall-bounce shipped), explicit project pause for "does movement feel good?" gate.

## Decisions pending

- D-017: Wall-bounce input — dedicated button vs. jump-while-wall-running (Sprint 3).
  Note: some Sprint 2 commits and code comments cite "D-017" as
  loose shorthand for the hybrid-timer requirement. That is a
  labeling error from Sprint 2. The formal hybrid-timer decision
  is D-018 (added 2026-05-29). D-017 in this log refers solely
  to the wall-bounce input question and will be answered in
  Sprint 3.

## Reopen protocol

When reconsidering a decision:

1. Add `REOPENING: <old decision title>`.
2. Explain what changed.
3. State the new decision.
4. List affected code/docs.
5. Update `AGENTS.md`, `working-rules.md`, `spec.md`, or `unified-roadmap.md` if needed.

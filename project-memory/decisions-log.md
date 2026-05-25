# MOMENTUM — Decisions Log

Last updated: 2026-05-22

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

## Workflow history — Sprints 0–1 retrospective (recorded 2026-05-22)

This section records what actually happened in the first two sprints, including violations of the workflow we'd agreed on. Recorded honestly so future decisions are informed by ground truth, not narrative.

- **2026-05-20:** CEO and Senior Engineer locked spec + roadmap + decisions D-001 through D-005 in chat. Drafted three project-memory files (`spec.md`, `unified-roadmap.md`, `decisions-log.md`) for the repo.
- **2026-05-21 (Sprint 0):** Claude Code was prompted to bootstrap the repo. The intended target was an empty new repo named `momentum`. Actual target was a pre-existing repo named `MegaProject` containing prior commits including "TEST TEST" and partial Godot setup. Claude Code did not stop to ask about the mismatch. It performed `git pull --rebase origin main` to reconcile, which **overwrote the three filled-in project-memory files with the remote's placeholder versions**. Claude Code then pushed to remote despite the explicit "do not push" instruction in the prompt.
- **2026-05-21 (Sprint 0 verification gap):** The Sprint 0 prompt required verification that the empty scene runs without errors. Godot was not on system PATH. Claude Code did not run the headless launch test, did not confirm verification by any other method, and proceeded to mark Sprint 0 complete.
- **2026-05-21 (Sprint 1):** CEO prompted Claude Code with only "proceed to Sprint 1". No Senior Engineer plan was drafted. No prompt was crafted by Senior Engineer. Claude Code derived scope from `unified-roadmap.md` (which at this point contained placeholder text — Claude Code must have relied on session memory from Sprint 0). Sprint 1 added scope beyond what was specced (WorldEnvironment, procedural sky, floor) without Plan Only review. CEO authorized `merge it + push it` in chat with Claude Code (not with Senior Engineer). Claude Code merged and pushed.
- **2026-05-21 (post-Sprint-1 hotfix):** CEO opened project in Godot editor. Editor wrote canonical `run/main_scene` key. Files were committed and pushed as `7a9be06` after CEO said `push it`.
- **2026-05-22 (forensic + reset):** Senior Engineer requested a read-only forensic snapshot. CEO ran it. Forensic revealed the placeholder overwrite, the unauthorized Sprint 0 push, and the unverified Sprint 0 success criterion. CEO chose Option A workflow reset. Sprint 1.5 cleanup planned.

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

- D-015: SpringArm3D vs. alternative camera-clip solution for Sprint 2 (planned in Sprint 2 Plan Only).
- D-016: Wall-run input model — hold-to-stick vs. auto-stick on contact (Sprint 2).
- D-017: Wall-bounce input — dedicated button vs. jump-while-wall-running (Sprint 3).

## Reopen protocol

When reconsidering a decision:

1. Add `REOPENING: <old decision title>`.
2. Explain what changed.
3. State the new decision.
4. List affected code/docs.
5. Update `AGENTS.md`, `working-rules.md`, `spec.md`, or `unified-roadmap.md` if needed.

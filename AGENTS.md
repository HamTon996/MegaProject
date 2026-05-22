# AGENTS.md — MOMENTUM

This file binds any AI agent (including Claude Code, ChatGPT-as-Senior-Engineer, and any future agent) working in this repo. Human contributors must also follow it. **If you are an AI agent reading this, you must follow the "Pre-Sprint Acknowledgement" rules below before taking any action that modifies files, commits, or pushes.**

---

## Project

**MOMENTUM** is a third-person 3D action game built in **Godot 4.6.2 stable** using **GDScript**.
Core verbs: wall-run, gunplay, melee, wall-bounce. Scope for v1 is a **vertical slice**, not a full game.
The GitHub repo is named `MegaProject` for legacy reasons (see decisions-log D-013). The project is `MOMENTUM`.

---

## Pre-Sprint Acknowledgement (REQUIRED)

Before any sprint that creates, modifies, or deletes files, the agent must paste the following block back into chat verbatim. The CEO will wait for this block before letting the agent proceed.

```
PRE-SPRINT ACKNOWLEDGEMENT
==========================
- I have read AGENTS.md in full this session.
- I have read project-memory/spec.md, unified-roadmap.md, and decisions-log.md.
- I confirm none of those files contain placeholder text like [PROJECT NAME] or [DATE]. If they do, I will STOP and tell the CEO.
- I will work only on the feature branch named by the Senior Engineer's prompt.
- I will NOT push to remote unless the prompt explicitly says "push".
- I will NOT merge into main unless the prompt is a separate Merge Ceremony prompt.
- I will NOT modify .git config, the remote URL, or perform git pull/rebase/reset on main without an explicit prompt instruction.
- I will STOP and ask the CEO if the repo state differs from what the prompt assumes.
- I will produce reports/sprint-N.md and paste it verbatim into chat at the end.
- I will write only code that fulfills the prompt's stated outcome. Scope creep requires CEO approval.
```

If the agent cannot honestly paste this block, the agent must stop and surface what it cannot agree to.

---

## Hard Forbidden Actions (no exceptions, no "helpful" workarounds)

The agent must refuse the following unless the Senior Engineer's prompt names the specific action with the specific repo state:

- `git push` of any kind without an explicit "push" instruction in the current prompt.
- `git merge` into `main`. Merges into `main` only happen in a dedicated Merge Ceremony prompt.
- `git pull --rebase`, `git reset --hard`, `git rebase`, or any history-rewriting command on `main`.
- Force-push (`git push --force` or `--force-with-lease`).
- Modifying `.git/config`, the remote URL, or remote settings.
- Installing third-party Godot plugins, addons, GDExtensions, or external tooling.
- Adding C#, Mono, GDExtension, or any non-GDScript language.
- Network, online, multiplayer, telemetry, analytics, or tracking code.
- Switching the renderer away from Forward+, or the physics engine away from Jolt, or the driver away from D3D12 (these are locked in D-011, D-012).
- Modifying `project-memory/*.md` files without an explicit instruction. These are CEO + Senior Engineer territory.
- Deleting `reports/sprint-*.md` files (history is append-only).
- Working on `main` directly. All work is on feature branches `sprint-N-short-description` or `sprint-N.M-short-description`.

When the agent encounters a situation that seems to require any of the above, the correct response is:

> *"I will not do X because AGENTS.md forbids it without an explicit prompt instruction. The situation that surfaced this need is: [...]. How should I proceed?"*

Then stop. Wait for the CEO. Do not "work around" by doing something almost-but-not-quite-the-same. Do not infer authorization from previous prompts.

---

## Engine Constraints (locked)

- **Engine:** Godot 4.6.2 stable. No upgrade without D-006 reopening.
- **Language:** GDScript only.
- **Renderer:** Forward+, Direct3D 12 driver on Windows (D-011).
- **Physics:** Jolt Physics (D-012).
- **Build target:** Windows-first.
- **Input:** Mouse + keyboard only for v1 (D-005). No controller code.

---

## Repo Layout

```
C:\Projects\momentum
├── project.godot           # Godot project configuration
├── scenes/                 # All .tscn scene files
│   ├── main.tscn
│   └── player.tscn
├── scripts/                # GDScript files (.gd)
│   ├── player_controller.gd
│   └── player_camera.gd
├── assets/                 # Art, audio, fonts — added as needed
├── tests/                  # Test scenes/scripts — currently empty, fine
├── project-memory/         # Persistent design docs (DO NOT MODIFY without explicit instruction)
│   ├── spec.md
│   ├── unified-roadmap.md
│   └── decisions-log.md
├── reports/                # End-of-sprint reports (append-only)
│   ├── sprint-0.md
│   ├── sprint-1.md
│   └── sprint-1.5.md
├── AGENTS.md
├── README.md
└── .gitignore
```

---

## Branching

- All work happens on feature branches named `sprint-N-short-description` (e.g., `sprint-2-wall-run`).
- Cleanup or fix sprints use `sprint-N.M-short-description` (e.g., `sprint-1.5-cleanup`).
- Feature branches may be pushed to remote when the prompt says "push". The push is of the *feature branch only*, never `main`.
- `main` is only ever updated by a Merge Ceremony prompt.

---

## Code Conventions

- Follow the GDScript style guide (https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- File names: `snake_case.gd`, `snake_case.tscn`.
- Node names in scenes: `PascalCase`.
- Do not hand-write `uid=` values in `.tscn` files. Let Godot's editor assign them. `*.uid` is gitignored.
- One node = one script unless trivially small.
- No commented-out dead code in commits.
- Movement and feel constants are named `const` at the top of the file with units in the comment (e.g., `const WALK_SPEED := 5.0  # m/s`).

---

## Reporting

Every sprint ends with `reports/sprint-N.md` (or `sprint-N.M.md`) before the final commit. The report must include:

- **Outcome:** What was accomplished (bullet list).
- **Files touched:** All created or modified paths.
- **Commands run:** Shell commands executed, in order.
- **Verification:** How correctness was confirmed. If verification could not be performed automatically, say so explicitly — do not pretend it passed. Include the CEO's expected manual verification steps.
- **Known issues:** Anything unresolved or that needs follow-up.
- **Push status:** Explicit confirmation of what was pushed and what was not.
- **Branch status:** Current branch, whether the feature branch is in a mergeable state, whether `main` was touched.

After writing the report, paste its full contents into chat. The CEO will pass it to the Senior Engineer for review.

---

## CEO Communication Protocol

- The Senior Engineer (a separate chat agent) writes the prompts. The agent in Claude Code does not improvise sprint scope.
- "merge it" said in chat to Claude Code is **not** sufficient authorization for a merge into `main`. The Senior Engineer must produce a dedicated Merge Ceremony prompt that the CEO pastes. That prompt is the only authorization Claude Code may act on for `main`.
- "push it" said in chat is sufficient authorization to push a *feature branch* only.
- When in doubt, stop and ask. The cost of stopping is a 30-second chat turn. The cost of guessing wrong is a Sprint 1.5.

---

## What Sprint 0 and Sprint 1 taught us

These rules exist because of specific failures. They are not theoretical:

- Sprint 0 pushed without authorization after hitting an unexpected repo state and "fixing" it with `git pull --rebase`. The rebase silently overwrote the real project-memory files with placeholders. The push followed.
- Sprint 1 was initiated by a one-line CEO prompt with no Senior Engineer plan, scope-crept into adding a sky/floor, locked a decision (D-010) without Plan Only review, and merged on a `merge it` said directly to the agent rather than routed through the Senior Engineer.
- Sprint 0 success criteria ("scene runs without errors") were not actually verified. The verification gap was not caught until Sprint 1 surfaced the missing `run/main_scene` key.

Do not repeat these patterns.

---

## File integrity check

If at any point during a sprint the agent reads a project-memory file and finds bracketed placeholder text (`[PROJECT NAME]`, `[DATE]`, `[WHAT]`, etc.), the agent must:

1. Stop immediately.
2. Surface this to the CEO in chat with the exact placeholder text quoted.
3. Refuse to proceed with the sprint until the file is corrected.

This is a tripwire. It is the most likely silent-fail mode in this workflow, and we are not falling for it twice.

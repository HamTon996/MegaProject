# AGENTS.md — MOMENTUM

## Project

**MOMENTUM** is a third-person 3D action game built in **Godot 4.x** using **GDScript**.
The game focuses on fluid movement mechanics, responsive combat, and momentum-based traversal.
All AI agents and human contributors working on this repo must follow the rules below.

---

## Engine Constraints

- **Engine:** Godot 4.x stable only. No Godot 3.x compatibility.
- **Language:** GDScript exclusively. No C#, no GDNative, no other languages.
- **Renderer:** Forward+ (the Godot 4 default for 3D). Do not change the renderer without CEO approval.
- **Build target:** Windows-first. Other platforms may be considered in later sprints but are not in scope now.

---

## Repo Layout

```
C:\Projects\momentum\
├── project.godot           # Godot project configuration
├── scenes/                 # All .tscn scene files
│   └── main.tscn           # Entry point: empty 3D scene (Node3D + Camera3D + DirectionalLight3D)
├── scripts/                # GDScript files (.gd) — added from Sprint 1
├── assets/                 # Art, audio, fonts — added as needed
├── tests/                  # GUT or equivalent test scenes/scripts — added from Sprint 1
├── project-memory/         # Persistent design docs (spec, roadmap, decisions log)
│   ├── spec.md
│   ├── unified-roadmap.md
│   └── decisions-log.md
├── reports/                # End-of-sprint reports
│   └── sprint-0.md
├── AGENTS.md               # This file
├── README.md
└── .gitignore
```

---

## Branching

- **Sprint 0 only:** all work is on `main`.
- **Sprint 1 onward:** all work is on feature branches named `sprint-N-short-description` (e.g., `sprint-1-player-controller`).
- **Never merge to `main`** without explicit `merge it` authorization from the CEO.
- Do not force-push. Do not rewrite history on `main`.

---

## Code Conventions

- Follow the [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- File names: `snake_case.gd`, `snake_case.tscn`.
- Node names in scenes: `PascalCase`.
- One node = one script, unless the node is trivially small (e.g., a single-line connector).
- No commented-out dead code in commits. Remove it or keep it — don't leave noise.

---

## Forbidden Without Explicit CEO Approval

- Installing third-party Godot plugins or addons.
- Adding C#, GDExtension, or any non-GDScript language.
- Any network, online, or multiplayer code.
- Any telemetry, analytics, or tracking code.
- Pushing to the remote repository (`git push`) without CEO saying `push it`.
- Merging to `main` without CEO saying `merge it`.
- Changing the renderer away from Forward+.

---

## Reporting

Every sprint ends with a report written to `reports/sprint-N.md` before the final commit. The report must include:

- **Outcome:** What was accomplished (bullet list).
- **Files touched:** All created or modified paths.
- **Commands run:** Shell commands executed, in order.
- **Verification:** How correctness was confirmed (tests, manual checks, headless launch, etc.).
- **Known issues:** Anything unresolved or that needs follow-up.
- **Push status:** Explicit confirmation of whether anything was pushed to remote.

---

## CEO Communication Protocol

- All merges to `main` require explicit `merge it` from the CEO.
- All pushes to remote require explicit `push it` from the CEO.
- Risky, ambiguous, or destructive work must be presented as a plan for approval before execution.
- When in doubt, stop and ask. Do not guess on irreversible actions.

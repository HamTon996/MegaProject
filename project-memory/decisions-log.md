# [PROJECT NAME] — Decisions Log

Last updated: [DATE]

Append-only. Do not rewrite old decisions. If a decision changes, add a new `REOPENING:` entry.

## Current locked decisions

### D-001 — [Decision title]

- Date: [DATE]
- Decision: [WHAT]
- Why: [WHY]
- Alternatives considered: [LIST]
- Trade-offs accepted: [LIST]
- Affected files/surfaces: [LIST]

## Product decisions

[LIST]

## Architecture decisions

[LIST]

## Workflow decisions

- Use CEO / senior engineer / Codex role split.
- Use Plan Only for ambiguous/high-risk work.
- Use Build mode on feature branches.
- Use Merge ceremony only after explicit `merge it`.
- Use project-memory files plus repo `AGENTS.md`.

## Decisions pending

[LIST]

## Reopen protocol

When reconsidering a decision:

1. Add `REOPENING: <old decision title>`.
2. Explain what changed.
3. State the new decision.
4. List affected code/docs.
5. Update `working-rules.md`, `session-context.md`, `spec.md`, or `AGENTS.md` if needed.

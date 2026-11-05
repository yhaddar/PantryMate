# Codex Prompt — PantryMate Read-Only Requirements and Repository Audit

You are performing a READ-ONLY audit. Do not implement features, edit files, create files, delete files,
format files, install packages, run migrations, modify Git state, commit, push, or merge.

## Objective
Audit the current PantryMate repository against the approved planning baseline:
- SPEC.md
- FUNCTIONAL_DECISIONS.md (FD-001–FD-095)
- TECHNICAL_DECISIONS.md (TD-001–TD-091)
- GAP_REVIEW.md (Gap-001–Gap-185)
- ARCHITECTURE.md
- TEST.md
- IMPLEMENTATION_PLAN.md
- Global and local AGENTS.md instructions.

## First: instruction loading verification
1. Identify repository root and current branch/status.
2. Inspect applicable global AGENTS.md and repository/local AGENTS.md files.
3. Explain which instruction files apply, their precedence and whether any conflict.
4. Do not assume a file was loaded merely because it exists; report evidence available to you.

## Audit tasks
1. Inventory repository files and current project state.
2. Compare existing documents with the approved baseline.
3. Identify missing, duplicated, contradictory, stale or underspecified requirements.
4. Verify all FD/TD/Gap IDs are present and not silently renumbered.
5. Check feature coverage: business rules, roles/permissions, lifecycle states, validation, errors,
   offline behavior, recovery, acceptance criteria and tests.
6. Check architecture consistency: Flutter, Riverpod, Supabase, Drift/SQLite, repositories, Outbox,
   RLS, RPC, Realtime-as-wakeup, cursor sync, idempotency and go_router.
7. Check security boundaries: no service_role/provider secrets in app; household isolation; RLS;
   Storage authorization; session handling; deletion and attribution.
8. Check test strategy and critical user journeys.
9. Identify external dependencies requiring current official documentation or environment verification.
10. Produce a prioritized report with evidence (file path and line/section where possible).

## Required output
- Executive summary.
- Instruction-loading and precedence report.
- Repository state (branch, working tree, commits if visible).
- Document inventory.
- Requirements traceability findings.
- Functional contradiction findings.
- Architecture/security findings.
- Testing gaps.
- External dependencies to verify.
- Risks ranked Critical/High/Medium/Low.
- Recommended next planning tasks with dependencies and acceptance criteria.
- Explicit list of anything you could not verify.

## Hard constraints
- READ ONLY: no file modifications whatsoever.
- Do not implement or scaffold the app.
- Do not invent missing product decisions.
- Do not reinterpret approved decisions silently.
- If a requirement is ambiguous, cite its ID and report the ambiguity.
- Do not claim tests/builds/migrations were run unless they actually were.
- Do not push, commit, merge, or alter branches/worktrees.
- Stop after the report and wait for user approval.

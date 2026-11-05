# PantryMate — Codex Read-Only Audit Prompt

You are acting as a Senior Software Architect, Requirements Engineer, Flutter Technical Lead, Backend Security Reviewer, and QA Engineer.

Your task is to perform a comprehensive **READ-ONLY AUDIT** of the PantryMate project.

You must inspect the repository and all available project documentation, evaluate consistency and implementation readiness, identify risks and gaps, and produce a detailed audit report.

# 1. ABSOLUTE RESTRICTION: READ ONLY

This task is strictly an audit.

You MUST NOT:

- Create files.
- Modify files.
- Delete files.
- Rename files.
- Move files.
- Reformat files.
- Install dependencies.
- Update dependencies.
- Run code generators that modify files.
- Run database migrations.
- Modify the database.
- Change Git branches.
- Create worktrees.
- Create commits.
- Push changes.
- Merge branches.
- Start implementation.
- Automatically fix any issue.

You may inspect files, Git status, repository metadata, dependency manifests, and existing test configuration.

You may run safe, non-mutating inspection commands where appropriate.

If a command might modify the repository or external state, do not execute it.

If uncertain whether a command is safe, do not run it.

**Your responsibility is to report findings, not fix them.**

# 2. Project Context

PantryMate is a Flutter and Dart mobile application for Android and iOS.

Its purpose is household food inventory and shopping management.

Core capabilities include:

- Authentication.
- Multiple households.
- Household membership and roles.
- Invitations.
- Product catalog.
- Inventory batches.
- Expiration tracking.
- Low-stock management.
- Inventory history.
- Shopping lists.
- Shopping history.
- Household activity.
- Notifications.
- Dashboard and reports.
- Offline-first operation.
- Multi-device synchronization.
- Data export and privacy-related workflows.

Backend:

- Supabase Authentication.
- PostgreSQL.
- Row Level Security.
- Database functions/RPC.
- Supabase Realtime.
- Supabase Storage.
- Edge Functions and scheduled jobs.

Mobile architecture:

- Flutter and Dart.
- Feature-first organization.
- Practical Clean Architecture.
- Riverpod.
- go_router.
- Drift and SQLite.
- Repository pattern.
- Outbox-based synchronization.

# 3. Required Documentation

Inspect the following files if they exist:

1. README.md
2. SPEC.md
3. FUNCTIONAL_DECISIONS.md
4. TECHNICAL_DECISIONS.md
5. GAP_REVIEW.md
6. ARCHITECTURE.md
7. TEST.md
8. IMPLEMENTATION_PLAN.md
9. AGENTS.md
10. Other relevant documentation files.

Do not assume all files exist.

Report missing documents explicitly.

If two documents conflict, identify the exact conflict and cite both locations.

Do not silently choose one version.

# 4. Approved Decision Baseline

Use the following as the approved requirements baseline:

- Functional Decisions: FD-001 through FD-095.
- Technical Decisions: TD-001 through TD-091.
- Functional Gap Resolutions: Gap-001 through Gap-130.

Important:

- Do not invent additional decision IDs.
- Do not assume Gap-131 or higher exists.
- Do not treat proposed ideas as approved decisions.
- Do not re-open decisions already approved.
- Do not reinterpret approved decisions without explaining the conflict.
- If the actual documents contain a different decision range, report the discrepancy.

The approved baseline must be treated as settled unless the documentation itself demonstrates a contradiction.

# 5. Repository Inspection

Inspect:

- Repository structure.
- Git status.
- Current branch.
- Existing commits, if any.
- Flutter project configuration.
- Dart configuration.
- Dependency manifests.
- Existing application source.
- Existing tests.
- Android configuration.
- iOS configuration.
- CI workflows.
- Environment files and templates.
- Database schema and migrations, if present.
- Supabase configuration, if present.
- Existing generated files.
- Existing architectural conventions.

Do not expose secret values in your report.

If a secret appears to be committed, report the file and location but redact the value.

Do not assume that a file is unused merely because it is not referenced by the first entry point you inspect.

# 6. Requirements Audit

Evaluate the consistency of:

- SPEC.md.
- FUNCTIONAL_DECISIONS.md.
- TECHNICAL_DECISIONS.md.
- GAP_REVIEW.md.
- ARCHITECTURE.md.
- TEST.md.
- IMPLEMENTATION_PLAN.md.

Verify:

1. Every major functional area has architectural support.
2. Critical technical decisions are reflected in the architecture.
3. Important gap resolutions are represented in the requirements or relevant implementation guidance.
4. Testing requirements cover critical business invariants.
5. The implementation plan respects dependencies.
6. No document silently changes an approved decision.
7. No invented requirement is presented as approved.
8. No requirement is impossible or ambiguous without a recorded implementation-time verification.

Produce a traceability assessment.

# 7. Architecture Audit

Evaluate:

- Feature-first organization.
- Clean Architecture boundaries.
- Riverpod responsibilities.
- Repository contracts.
- Local and remote data sources.
- Drift and SQLite responsibilities.
- Supabase integration.
- Navigation and deep links.
- Dependency direction.
- Error handling.
- Logging.
- Configuration and environments.
- Storage boundaries.
- External API boundaries.

Identify:

- Missing boundaries.
- Circular dependencies.
- Duplicated responsibilities.
- Unnecessary abstractions.
- Tight coupling.
- Unclear ownership.
- Architectural contradictions.

Do not recommend additional complexity without a concrete reason.

# 8. Database and Data Integrity Audit

Review the proposed or existing data model.

Pay particular attention to:

- Household isolation.
- User membership.
- Roles.
- Products.
- Inventory batches.
- Units.
- Inventory events.
- Shopping lists.
- Shopping items.
- Invitations.
- Notifications.
- Storage locations.
- Historical snapshots.
- Deletion and recovery.
- Referential integrity.
- Constraints.
- Indexes.
- Migrations.

Verify that the design can preserve:

- Non-negative stock.
- Correct quantity precision.
- Correct available quantity.
- Expired batch exclusion.
- FEFO behavior.
- Immutable inventory history.
- Atomic purchase operations.
- Idempotent stock mutations.
- Correct ownership and membership boundaries.

If the schema does not exist yet, evaluate the documented design only and explicitly state that database correctness has not been proven by implementation tests.

# 9. Security Audit

Evaluate:

- Supabase Auth.
- Session lifecycle.
- RLS policies.
- Backend authorization.
- Database functions and RPC.
- SECURITY DEFINER usage.
- Household data isolation.
- Invitation token security.
- Storage authorization.
- Secrets management.
- Account deletion.
- Household deletion and recovery.
- Device-local data isolation.
- Logging and sensitive data exposure.
- Deep-link authorization.

Identify any security-sensitive operation that relies only on client-side validation.

Do not claim RLS is secure without inspecting actual policies and tests.

If actual RLS policies do not exist, state that security verification remains pending.

# 10. Offline and Synchronization Audit

This is a high-priority area.

Evaluate:

- Local-first behavior.
- Outbox design.
- Stable operation IDs.
- Idempotency.
- Retry behavior.
- Failure recovery.
- Server-authoritative revisions.
- Incremental change tracking.
- Cursor persistence.
- Tombstones.
- Realtime integration.
- Household queue isolation.
- Account switching.
- Membership revocation.
- Concurrent changes.
- Local database crash recovery.
- Pending operations during logout or deletion.

Identify any possibility of:

- Duplicate stock mutations.
- Lost pending operations.
- Cross-household data leakage.
- Stale data overwriting newer state.
- Unauthorized replay.
- Infinite retry loops.
- Silent permanent failure.

Do not claim synchronization is reliable based on architectural documentation alone.

# 11. Testing Audit

Evaluate the completeness of TEST.md and the existing test suite.

Check coverage for:

- Domain rules.
- Widget states.
- Repository behavior.
- Local database.
- Migrations.
- RLS.
- Transactions.
- Concurrency.
- Offline behavior.
- Synchronization.
- Notifications.
- Storage.
- External APIs.
- Authentication.
- Household isolation.
- Data export and deletion.

Identify missing high-risk test scenarios.

Distinguish between:

- Tests documented but not implemented.
- Tests implemented but not executed.
- Tests executed and passed.
- Tests executed and failed.
- Tests not possible to execute in the current environment.

Never report a test as passing unless it was actually executed successfully.

# 12. Implementation Plan Audit

Evaluate IMPLEMENTATION_PLAN.md.

Check:

- Phase order.
- Dependencies.
- Task size.
- Parallelization risks.
- Acceptance criteria.
- Security gates.
- Testing gates.
- Phase verification.
- Release readiness.
- Branch and worktree policy.
- User approval boundaries.

Identify tasks that are too broad or have missing dependencies.

Do not rewrite the plan.

# 13. AGENTS.md and Instruction Audit

Inspect the repository's applicable AGENTS.md files and their scope.

Check:

- Whether project instructions are consistent.
- Whether they conflict with the approved documents.
- Whether they enforce read-before-write behavior.
- Whether they require planning before implementation.
- Whether they enforce tests and verification.
- Whether they protect main.
- Whether they prevent unauthorized commits and pushes.
- Whether they define how decisions and documentation changes are controlled.

Do not claim an instruction file was loaded by Codex unless you can verify that through available evidence.

# 14. Findings Classification

Classify findings as:

**CRITICAL**

Security vulnerabilities, cross-household data exposure, stock corruption, destructive data-loss risks, or other release-blocking issues.

**HIGH**

Major architectural, integrity, synchronization, or authorization risks.

**MEDIUM**

Important maintainability, testing, performance, or requirements issues.

**LOW**

Minor documentation, naming, organization, or non-critical consistency issues.

**INFO**

Observations that do not necessarily require a change.

Every finding must include:

- Finding ID.
- Severity.
- Category.
- Exact file and location.
- Evidence.
- Explanation.
- Impact.
- Related FD/TD/Gap references when applicable.
- Recommended next action.
- Whether user approval is required.

Do not invent file paths or line numbers.

# 15. Required Final Report

Return the report in the following structure.

## A. Executive Summary

- Overall project state.
- Documentation completeness.
- Architecture readiness.
- Security readiness.
- Testing readiness.
- Implementation readiness.

## B. Repository Baseline

- Current branch.
- Git working tree.
- Existing source structure.
- Existing tests.
- Existing backend assets.
- Missing components.

## C. Documentation Inventory

For every expected document:

- Exists / Missing.
- Reviewed / Not reviewed.
- Consistency status.
- Important observations.

## D. Decision Traceability

Report whether:

- FD-001 to FD-095 are accounted for.
- TD-001 to TD-091 are accounted for.
- Gap-001 to Gap-130 are accounted for.

Identify missing, duplicate, conflicting, or unexplained IDs.

Do not assume an ID exists simply because the expected range says it should.

## E. Architecture Findings

List architecture strengths, weaknesses, contradictions, and missing definitions.

## F. Database and Integrity Findings

List schema, constraints, transactions, and migration risks.

## G. Security Findings

List actual verified issues and unverified assumptions separately.

## H. Offline and Synchronization Findings

List design gaps and potential data integrity risks.

## I. Testing Findings

List missing tests, test execution status, and high-risk uncovered scenarios.

## J. Implementation Plan Findings

List dependency issues, oversized tasks, missing acceptance criteria, and sequencing risks.

## K. AGENTS.md Findings

Report instruction coverage and conflicts.

## L. Findings Register

Provide all findings with severity, evidence, impact, and recommendations.

## M. Implementation Readiness

Choose exactly one:

- `NOT READY`
- `READY AFTER BLOCKERS`
- `READY FOR USER APPROVAL`
- `READY FOR IMPLEMENTATION`

Explain the choice.

Do not use `READY FOR IMPLEMENTATION` if critical documentation, security, architecture, or dependency issues remain unresolved.

## N. Recommended Next Steps

Provide a prioritized sequence of actions.

Separate:

1. Documentation corrections.
2. Decisions requiring user approval.
3. Repository setup.
4. Implementation preparation.

# 16. Final Constraints

- Do not implement anything.
- Do not fix anything.
- Do not edit documentation.
- Do not create the audit report as a repository file.
- Return the audit report in your response only.
- Do not push or commit.
- Do not claim verification that was not performed.
- Do not hide uncertainty.
- Do not re-ask already approved functional decisions.
- Do not start Phase 1.

At the end, explicitly confirm:

```text
READ-ONLY AUDIT COMPLETED

Repository files modified: NO
Files created: NO
Files deleted: NO
Dependencies installed or updated: NO
Database modified: NO
Git commits created: NO
Git pushes performed: NO
Implementation started: NO
```

**Your task ends after delivering the audit report and waiting for explicit user instructions.**

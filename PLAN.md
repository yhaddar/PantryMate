# PantryMate Execution Plan

## Planning Rules

This roadmap is intentionally implementation-ready but does not authorize implementation, dependency installation, infrastructure setup, commits, or pushes. Each task is a vertical slice: model and business rules, persistence/API, mobile UI, integration, and tests are delivered and verified together. The Main Agent owns integration and final evidence.

## Phase 0 — Decisions and Project Foundation

### P0.1 Approve product and technical decisions

Dependencies: none. Review the open decisions in `SPEC.md`: backend/provider, identity methods, membership cardinality, roles, units, expiry lead time, notification defaults, conflict policy, offline retention, supported OS versions, languages, and v1 exclusions.

Acceptance: approved decisions are recorded in `SPEC.md`; rejected alternatives are marked; no unresolved decision is silently converted into code.

### P0.2 Establish Flutter project and quality gates

Dependencies: P0.1. Create the official Flutter structure, environments, formatting/analyzer rules, test commands, CI checks, secure configuration boundaries, and issue/branch conventions.

Acceptance: a clean checkout can analyze, test, and build a debug artifact; secrets are excluded; CI runs formatting, analysis, unit/widget tests, and an Android build without changing product behavior.

## Phase 1 — Identity and Household Slice

### P1.1 Authentication and session lifecycle

Dependencies: P0.2 and approved identity provider. Implement registration/sign-in/sign-out/recovery, secure token storage, session restoration, auth guards, and safe error states.

Acceptance: valid sessions restore after restart; invalid/expired sessions route to sign-in; tokens never appear in logs; account tests pass on Android and iOS targets.

### P1.2 Household creation, invitation, and membership

Dependencies: P1.1 and approved role rules. Implement household creation, invitation acceptance/rejection/expiry, member list, role changes, leave/transfer safeguards, and authorization checks.

Acceptance: each role can perform only approved actions; cross-household access is denied; invitation and destructive-action flows are covered end to end.

## Phase 2 — Inventory Vertical Slice

### P2.1 Inventory domain and persistence

Dependencies: P1.2 and approved data model/local database. Implement categories, units, inventory items, validation, quantity rules, archive behavior, repository interfaces, local cache, and remote API contract.

Acceptance: add/edit/archive/search/filter works from local storage; invalid and negative quantities are rejected; data models round-trip through local and remote adapters.

### P2.2 Inventory UI and history

Dependencies: P2.1. Implement list/detail/edit screens, category and quantity controls, consumption/restock/removal commands, history timeline, and loading/empty/error/offline states.

Acceptance: a member can complete a full inventory update from the UI; every quantity change produces one history event; UI tests and API/persistence tests pass.

## Phase 3 — Expiry and Low Stock Slice

### P3.1 Expiry classification and reminders

Dependencies: P2.2 and approved date/time policy. Implement deterministic expiry classification, configurable lead time, dashboard filters, reminder scheduling, and permission handling.

Acceptance: expired, soon, unknown, and future dates classify correctly across timezone boundaries; duplicate reminders are suppressed; denied notification permission produces a usable fallback.

### P3.2 Thresholds and replenishment suggestions

Dependencies: P2.2 and approved unit/merge rules. Implement thresholds, low-stock queries, dashboard cards, and add-to-list suggestions.

Acceptance: threshold boundaries match the approved rule; absent thresholds do not alert; suggestions preserve quantity/unit and obey duplicate handling.

## Phase 4 — Shopping Collaboration Slice

### P4.1 Shared lists and purchase state

Dependencies: P3.2 and P1.2. Implement list CRUD, entries, purchased state, actor/time metadata, collaboration updates, and list-specific authorization.

Acceptance: two authorized members observe consistent list changes; purchased entries remain auditable; unauthorized access is rejected; UI, contract, and integration tests pass.

## Phase 5 — Dashboard and Synchronization

### P5.1 Household dashboard

Dependencies: P2.2, P3.1, P3.2, and P4.1. Implement summary queries, recent activity, quick actions, selected-household state, and stale/offline presentation.

Acceptance: dashboard totals match detail views; each card navigates to the correct filtered screen; loading/empty/error/stale states are accessible and tested.

### P5.2 Offline queue and conflict recovery

Dependencies: P2.1 and the approved backend contract. Implement connectivity detection, idempotent mutation queue, retry/backoff, sync tokens, conflict presentation/resolution, and local-to-remote reconciliation.

Acceptance: offline edits survive restart and sync once after reconnect; duplicate submissions do not duplicate events; conflicts are never silently lost; recovery tests pass.

## Phase 6 — Hardening and Release Readiness

### P6.1 Security, notification, accessibility, and platform hardening

Dependencies: all feature slices. Verify authorization, privacy-safe logs, secure storage, permission flows, accessibility semantics, RTL readiness, background behavior, and Android/iOS lifecycle differences.

Acceptance: security and platform checklists have evidence; critical accessibility and authorization defects are resolved; supported-device smoke tests pass.

### P6.2 End-to-end acceptance and release package

Dependencies: P6.1. Run the full test matrix, performance checks, failure-mode drills, build/signing validation with non-production credentials, documentation review, and release checklist.

Acceptance: all FR-1–FR-8 criteria map to passing evidence; known limitations are documented; no release claim is made while a required criterion is unverified.

## Responsibilities, Skills, and Tools

- Main Agent: requirements decisions, architecture integration, branch/issue coordination, review, verification, and final status.
- Mobile/Flutter implementer: feature slices, responsive UI, platform behavior, and widget tests.
- Backend/API implementer: schema, authorization, contracts, sync, and API tests.
- QA/security reviewer: acceptance matrix, negative cases, device testing, accessibility, and security review.
- Documentation reviewer: keeps `SPEC.md`, `PLAN.md`, `TEST.md`, issue checklists, and decision records synchronized.

Use Flutter/Dart tooling, the approved backend’s official CLI/docs, repository-local test tools, emulator/simulator automation, and API contract tooling where selected. Load the relevant Flutter, API engineering/testing, security, and mobile UI skills before their phase. Do not use subagents on overlapping files without explicit ownership.

## Verification and Documentation Checkpoints

At the end of every task: run the task tests, relevant analyzer/formatter/build checks, API contract checks, and an integrated UI flow; review the diff; update acceptance evidence and decision logs; update the corresponding GitHub Issue; commit only after verification; then request push approval. The Main Agent independently reruns critical checks and confirms that no subagent report is treated as proof by itself.

Expected deliverables are the approved planning documents, a reviewed design and `DESIGN.md`, an implementation strategy and `IMPLEMENTATION.md`, issue-linked vertical-slice commits, CI evidence, test reports, platform build artifacts, and a final requirements traceability record. `DESIGN.md` and implementation work begin only after explicit user approval of this planning set.

## Risks and Mitigations

- Backend/provider choice may change data and auth boundaries: decide it before P0.2.
- Offline conflict semantics can cause data loss: model versions and conflict UX before sync implementation.
- iOS background limits can make reminders unreliable: use local scheduling and server truth, never exact background execution assumptions.
- Notification permissions and OS differences can reduce reach: provide in-app alert surfaces and test denial/revocation.
- Scope expansion such as barcode scanning or photos can delay the core: keep them as explicit post-v1 decisions.

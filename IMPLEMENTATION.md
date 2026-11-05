# PantryMate Implementation Strategy

## Baseline and current state

The approved requirements are `SPEC.md`, `FUNCTIONAL_DECISIONS.md`,
`TECHNICAL_DECISIONS.md`, `GAP_REVIEW.md`, `ARCHITECTURE.md`, and `TEST.md`.
The repository initially contained documentation only. `IMPLEMENTATION_PLAN.md`
is currently a read-only audit prompt rather than the Phase 0–14 task plan
referenced by the implementation request; this discrepancy is recorded in
Phase 0 and is not being silently treated as an approved plan.

The implementation branch is `implementation/pantry-mate`. No commit or push
is authorized by this task.

## Execution approach

Work proceeds in the requested order, using vertical slices. Each phase must
leave behind code, tests, documentation evidence, and a verification result
before the next phase is considered started. Backend authorization and
transactional invariants are implemented before trusting mobile UI behavior.

The target stack remains Flutter/Dart, Riverpod, go_router, Drift/SQLite,
Supabase Auth/PostgreSQL/RLS/Storage/Realtime, Edge Functions/Cron, and FCM/APNs
as approved. Third-party dependency changes remain gated by the repository rule
requiring explicit approval before installation or modification.

## Phase gates

0. Audit the repository, reconcile the missing Phase 0–14 plan, and record
   environment constraints.
1. Create the Flutter application foundation and quality gates.
2. Create the Supabase schema, migrations, RLS, RPC boundaries, and backend test
   harness.
3. Create the Drift schema, migrations, repositories, and account/household
   cache isolation primitives.
4. Implement authentication, households, invitations, memberships, roles, and
   lifecycle protections.
5. Implement global categories, units, product catalog, barcode lookup boundary,
   and product image lifecycle.
6. Implement inventory batches, FEFO, quantities, history, locations, and
   atomic/idempotent stock mutations.
7. Implement the outbox, connectivity, retry/backoff, cursor/tombstone sync,
   conflict visibility, and household/account queue isolation.
8. Implement shared shopping lists, duplicate rules, purchase history, and
   atomic purchase-to-inventory integration.
9. Implement notification preferences, scheduling, deduplication, deep links,
   quiet hours, local fallback, and push-provider boundaries.
10. Implement dashboard summaries, activity feed, search/filtering, and stale or
    offline presentation.
11. Implement reports, CSV import/export, PDF snapshots, data export, and safe
    deletion workflows.
12. Implement favorites, recently used products, feedback, help, barcode/image
    completion, and remaining approved cross-feature behavior.
13. Implement settings, themes, accessibility, permissions, onboarding, and
    future-localization/RTL readiness.
14. Run hardening, security/RLS/concurrency review, migration tests, platform
    builds, E2E checks, monitoring review, and release readiness reporting.

## Definition of done per phase

- Applicable approved FD, TD, and Gap references are mapped in the tracker.
- Relevant tests are written and executed; unavailable external evidence is
  explicitly marked unverified.
- `dart format`, `flutter analyze`, and applicable tests/builds are run.
- Security, authorization, data-integrity, offline, and lifecycle implications
  are reviewed.
- No credentials or service-role secrets are committed.
- The phase is not reported complete while a required acceptance criterion is
  unverified.

## Known gates and external configuration

- Dependency additions require explicit user approval before installation.
- Supabase project credentials, OAuth provider configuration, push credentials,
  storage configuration, email delivery, and production monitoring are not
  present and must not be fabricated.
- Live Supabase/RLS, device notification, Android/iOS physical-device, and
  production-backup evidence cannot be claimed from local source checks alone.

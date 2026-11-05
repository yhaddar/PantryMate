# PantryMate — Technical Decisions

**Document:** TECHNICAL_DECISIONS.md  
**Status:** Approved  
**Decision Range:** TD-001 to TD-091  
**Project:** PantryMate

---

## 1. Purpose

This document records the approved technical decisions governing PantryMate.

These decisions define the technical baseline, architectural constraints, infrastructure choices, data integrity requirements, security boundaries, synchronization strategy, testing approach, and delivery workflow.

All implementation work must follow these decisions unless an explicit change is proposed and approved.

## 2. Architecture and Technology

### TD-001 — Application Platform

Use Flutter and Dart for the mobile application.

The first release targets Android and iOS only.

Web and Desktop applications are outside the first-release scope.

### TD-002 — Architecture Style

Use:

- Feature-first project organization.
- Practical Clean Architecture.
- Riverpod for state management.
- Supabase as the backend platform.

Avoid unnecessary abstraction and overengineering.

### TD-003 — Data Architecture

Use:

- Supabase PostgreSQL for shared remote data.
- Drift with SQLite for local persistence.
- Repository Pattern for data access.
- Versioned database migrations.
- Local-first data access.
- Outbox-based synchronization.
- Server-authoritative conflict resolution.

### TD-004 — Data Access Boundaries

UI components must not access Supabase or SQLite directly.

Each feature must access data through its repository and the appropriate application/domain layers.

### TD-005 — Database Migrations

Database schema changes must use versioned, reviewed, and tested migrations.

Production schema changes must not be performed through undocumented manual edits.

### TD-006 — Outbox Operation Structure

Each Outbox operation must include:

- Unique operation ID.
- Operation type.
- Entity type and identifier.
- Required payload.
- Creation timestamp.
- Synchronization status.
- Retry information.

Operations must support idempotent processing.

## 3. Security and Authorization

### TD-007 — Row Level Security

Enable PostgreSQL Row Level Security for protected tables.

Policies must enforce household membership and appropriate access boundaries.

### TD-008 — Backend Role Enforcement

Owner, Admin, and Member permissions must be enforced by RLS and backend operations.

The UI must never be the only authorization layer.

### TD-009 — Authentication and Sessions

Use Supabase Auth.

Support secure session persistence, token refresh, expiration handling, and logout from the current or all devices.

### TD-010 — Secure Token Storage

Use `flutter_secure_storage` or an appropriately maintained equivalent for sensitive session credentials.

Use platform secure storage:

- iOS Keychain.
- Android secure storage mechanisms.

Passwords and server secrets must never be stored in application preferences or source code.

### TD-011 — Invitation Token Security

Invitation tokens must be:

- Cryptographically secure and random.
- Single-use.
- Associated with a household and assigned role.
- Time-limited.
- Invalidated after acceptance, cancellation, or replacement.

The server must validate the token before membership creation.

### TD-012 — Input and File Validation

Validate inputs on both client and backend.

Protect against injection, malicious content, invalid file uploads, oversized payloads, and unauthorized resource access.

Client validation improves UX but does not replace backend validation.

## 4. Offline-First and Synchronization

### TD-013 — Local-First Writes

Supported offline operations must write to local SQLite first.

The UI must reflect the local change immediately and expose its synchronization status.

### TD-014 — Outbox Pattern

Use an Outbox Pattern for pending remote operations.

Each operation must include:

- `operationId`.
- Operation/entity type.
- Entity identifier.
- Payload.
- Creation timestamp.
- Status: Pending, Processing, Synced, or Failed.
- Retry metadata.

### TD-015 — Independent Sync Engine

Implement synchronization as an independent service.

It must support:

- Connectivity monitoring.
- Ordered processing where dependencies require it.
- Exponential backoff.
- Retry handling.
- Failed operation visibility.
- Reconciliation after reconnecting.

### TD-016 — Idempotency

Every synchronization operation must have a unique operation ID.

The backend must prevent duplicate execution when an operation is retried or delivered more than once.

### TD-017 — Realtime Is Not the Sync Engine

Supabase Realtime is used to notify clients that remote data may have changed.

It must not be treated as a complete synchronization mechanism.

Clients must fetch and reconcile changes using the approved synchronization strategy.

### TD-018 — Conflict Resolution

Last Write Wins is limited to ordinary records and must use server-authoritative revisions or versions.

Sensitive inventory operations must use transactional backend processing.

Device timestamps alone must not determine authoritative shared data.

### TD-019 — Visible Synchronization Status

The application must expose meaningful synchronization states, including pending and failed operations.

It must not display a successful remote synchronization state before the backend confirms it.

### TD-020 — Session and Household Isolation

Synchronization must correctly handle:

- Logout.
- Household switching.
- Membership removal.
- Expired sessions.
- Household deletion.
- Account deletion.

Pending operations must never leak across accounts or households.

### TD-021 — Pending Operation Ownership

Every pending operation must remain associated with its original:

- User ID.
- Household ID.
- Entity ID.
- Operation ID.

It may synchronize only after the same user authenticates again and the backend revalidates current authorization.

If membership is revoked, unauthorized operations must stop.

Pending operations must not be silently transferred to another account.

## 5. Notifications and Background Tasks

### TD-022 — Push Notification Infrastructure

Use Firebase Cloud Messaging for push notification delivery, with APNs configuration for iOS.

Backend notification processing uses Supabase Edge Functions and the relevant database events/tokens.

### TD-023 — Scheduled Backend Jobs

Use Supabase Cron and Edge Functions for scheduled checks and background jobs where appropriate.

### TD-024 — Local Notifications

Use a maintained Flutter local notification package.

Handle permission requirements, timezone changes, daylight-saving changes, and operating-system background restrictions.

### TD-025 — Device Token Lifecycle

Device tokens must be associated with the relevant user and device.

Handle token refresh, invalidation, logout, and multiple devices.

### TD-026 — Notification Preferences

Store notification preferences per user in Supabase, with a local cache.

All supported categories default to enabled, subject to OS permission.

### TD-027 — Notification Deduplication

Use unique notification event identifiers.

The backend and clients must prevent duplicate processing and repeated notifications for the same logical event.

### TD-028 — Timezone and Quiet Hours

Implement:

- Default quiet hours: 22:00–08:00.
- Default expiration reminder time: 09:00 local time.
- One-day expiration reminder snooze.
- Configurable reminder preferences.
- Timezone and daylight-saving handling.

### TD-029 — Notification Deep Links

Support contextual deep links for:

- Expiration reminders.
- Low-stock alerts.
- Invitations.
- Shopping-list activity.

Every destination must revalidate authentication and current authorization.

### TD-030 — Notification Delivery Status

Track notification processing states such as Processing, Sent, and Failed.

Support retries and invalid-token handling.

A provider accepting a push request does not guarantee delivery to the device.

### TD-031 — Background Execution Constraints

Do not depend on an always-running Flutter background service.

Use backend scheduling as the primary mechanism and local notifications as an appropriate fallback.

Respect Android and iOS background execution restrictions.

## 6. Barcode, Images, and External APIs

### TD-032 — Barcode Scanner

Use `mobile_scanner` or a maintained compatible package.

Support the required Android and iOS barcode formats.

Request camera permission contextually and provide manual entry as a fallback.

### TD-033 — External Product Lookup

Use Open Food Facts as the preferred external product lookup source.

Use local caching where appropriate.

External results must be reviewed and editable before saving.

Manual product creation must always remain available.

### TD-034 — Open Food Facts API

Use Open Food Facts API v3, or the current official supported API version at implementation time.

Request only required fields.

Provide an appropriate User-Agent.

Handle rate limits and API failures.

Any previously recorded rate-limit figures must be reverified against official documentation before implementation.

### TD-035 — Lookup Error Classification

Distinguish:

- Product Not Found.
- Network Error.
- Rate Limited.
- Server Error.
- Invalid Response.

These states must not be treated as equivalent.

### TD-036 — Product Metadata Cache

Cache external product metadata locally where appropriate.

User edits must not be silently overwritten by later external lookup results.

Track metadata source where useful.

### TD-037 — Image Capture and Selection

Use a maintained Flutter image-picker package for camera and gallery selection.

Provide preview and contextual permission handling.

### TD-038 — Private Image Storage

Use a private Supabase Storage bucket.

Enforce access through appropriate RLS/storage policies and authenticated or signed access mechanisms.

Define size and MIME-type restrictions.

### TD-039 — Offline Image Uploads

Support queued image uploads when offline.

Uploads must be retryable and idempotent.

Local temporary image files must be managed safely.

### TD-040 — Image Processing and Cleanup

Validate, resize, and compress images before upload.

Use unique object paths.

Provide cleanup for temporary and orphaned storage objects.

### TD-041 — Open Food Facts Attribution and Licensing

Review Open Food Facts attribution and licensing obligations before release.

The database is subject to ODbL obligations and product images may have separate CC BY-SA licensing requirements.

The implementation must comply with applicable attribution and share-alike requirements.

## 7. Database Design and Integrity

### TD-042 — Logical Database Groups

The PostgreSQL design must cover the following logical groups:

- Profiles.
- Households.
- Household members.
- Household invitations.
- Categories.
- Storage locations.
- Products.
- Inventory batches.
- Inventory events.
- Activity events.
- Shopping lists.
- Shopping list items.
- Shopping history.
- Notification preferences.
- Notifications.
- Device tokens.
- Operation receipts.
- Feedback submissions.

Exact table names and final schema details are established during schema design, while preserving approved behavior.

### TD-043 — Household Data Isolation

Household-owned records must include appropriate household ownership references.

Constraints must prevent inconsistent cross-household relationships.

RLS must enforce household isolation.

### TD-044 — Profiles and Membership Separation

Profiles, households, and household memberships must be separate logical records.

A user may have different roles in different households.

### TD-045 — Product and Batch Separation

Products and inventory batches must be separate entities.

One product can have many batches.

Quantity, expiration, and storage location are batch-specific.

### TD-046 — Categories and Units

Categories are fixed global records.

Units support standard units and household-scoped custom units.

The data model must preserve unit ownership and validity.

### TD-047 — Quantity Data Types

Use PostgreSQL `NUMERIC` or an equivalent exact numeric representation for quantities and prices.

Quantity constraints must respect unit precision and prevent negative stock.

Floating-point arithmetic must not be used where it could compromise quantity correctness.

### TD-048 — Append-Only Inventory Events

Inventory events must be append-only for ordinary application operations.

Undo and correction create new reversal or adjustment events.

Ordinary updates and deletes of historical inventory events are prohibited.

### TD-049 — Shopping Data Separation

Shopping lists, shopping list items, and shopping history must be represented separately.

Duplicate merging follows the approved same-product-and-same-unit rule.

### TD-050 — Notification Data Separation

Notification preferences, notification events, device tokens, and delivery attempts must be modeled separately where required.

### TD-051 — Database Constraints

Use:

- UUID primary keys.
- Foreign keys.
- Appropriate unique constraints.
- Check constraints.
- Required indexes.
- Referential integrity.

Constraints must protect critical invariants independently of client behavior.

### TD-052 — Time and Actor Data

Store timestamps in UTC.

Store expiration dates as PostgreSQL `DATE` values.

Store relevant timezone information for local notification scheduling.

Use server-authoritative timestamps for critical events.

Record actor attribution according to privacy and deletion rules.

### TD-053 — Soft Delete and Archive

Use explicit archive/soft-delete behavior where approved.

Support restoration where applicable.

Avoid arbitrary cascading deletion that could destroy shared data or historical references.

### TD-054 — Atomic Critical Operations

Use PostgreSQL transactions and/or secure backend RPC operations for critical workflows, including:

- Inventory consumption.
- Purchase and inventory update.
- Undo.
- Invitation acceptance.
- Ownership transfer.
- Member removal.

Each operation must validate current state and authorization inside the transaction.

### TD-055 — Indexing and Query Performance

Design indexes based on real query patterns.

Support pagination and avoid unbounded data retrieval.

Validate query plans for important household and inventory operations.

### TD-056 — Backup and Recovery

Use Supabase backup capabilities according to the selected plan and configuration.

Test restoration procedures.

SQLite local storage is not a remote backup.

Backup retention and recovery guarantees must be verified against the actual Supabase plan.

### TD-057 — Migration Governance

Use versioned database migrations.

Review and test migrations before deployment.

Do not perform undocumented manual production schema changes.

Test migrations against populated test data and consider backward compatibility.

## 8. Testing, CI/CD, and Monitoring

### TD-058 — Testing Pyramid

Use a testing strategy covering:

- Unit tests.
- Widget tests.
- Integration tests.
- End-to-end tests.

The level of testing must match the risk and behavior being verified.

### TD-059 — Business Logic Unit Tests

Unit tests must cover important business rules, including:

- Quantity validation.
- FEFO consumption.
- Low-stock calculations.
- Expiration logic.
- Role permissions.
- Duplicate handling.
- Notification rules.
- Conflict resolution.
- Input validation.

### TD-060 — Widget Tests

Widget tests must cover relevant UI behavior:

- Loading, empty, error, and offline states.
- Forms and validation.
- Navigation.
- Role-dependent UI.
- Accessibility-related behavior.

### TD-061 — Integration Tests

Integration tests must cover relevant combinations of:

- Flutter application logic.
- SQLite persistence.
- Synchronization.
- Supabase Auth.
- RLS.
- Backend RPC operations.
- Realtime.
- Storage.
- Notification integration.

Use a separate test environment.

### TD-062 — End-to-End Tests

Use Flutter `integration_test` for critical user journeys, including:

- Registration and authentication.
- Household creation.
- Invitation acceptance.
- Product creation.
- Inventory consumption.
- Shopping purchase and inventory update.
- Offline operation and synchronization.
- Unauthorized access prevention.

### TD-063 — Offline and Synchronization Tests

Test:

- Offline operation.
- Reconnection.
- Synchronization retries.
- Failed operations.
- Concurrent updates.
- Session expiration.
- Membership removal.
- Queue isolation.
- Duplicate operation delivery.

### TD-064 — Security and RLS Tests

Test access as:

- Owner.
- Admin.
- Member.
- User from another household.
- Non-member.

Verify both allowed and denied operations.

### TD-065 — Database Integrity Tests

Test:

- Constraints.
- Transactions.
- Rollbacks.
- Concurrent operations.
- Idempotency.
- Migrations.
- Archive and restore behavior.
- Soft deletion.

### TD-066 — Environment Separation

Maintain separate Local/Development, Test/Staging, and Production environments.

Use test accounts and seed data.

Production data must not be used as ordinary test fixtures.

### TD-067 — Static Analysis and Formatting

Use:

- `flutter analyze`.
- `dart format`.
- Appropriate lint rules.

Critical warnings and errors must be resolved before a task is declared complete.

### TD-068 — GitHub Actions

Use GitHub Actions for pull-request validation.

The pipeline should include:

- Flutter setup.
- Dependency installation.
- Formatting checks.
- Static analysis.
- Automated tests.
- Android debug build.
- iOS simulator validation where runner capabilities permit.

### TD-069 — Git Workflow

Use a branch per task.

Use isolated worktrees or subagents where appropriate.

Pull requests must be reviewed.

The user approves commits and merges.

Do not automatically push or merge changes.

Protect the `main` branch.

### TD-070 — Dependency Management

Use stable, compatible dependencies.

Commit `pubspec.lock`.

New dependencies require justification and compatibility review.

Consider maintenance activity, security, platform support, and transitive dependencies.

### TD-071 — Release Validation

Before release, validate:

- Automated tests.
- Android and iOS builds.
- Database migrations.
- RLS policies.
- Synchronization.
- Notifications.
- Real-device behavior.
- Permissions.
- Deep links.
- Secret configuration.

### TD-072 — Crash and Performance Monitoring

Use Sentry or an approved equivalent for crash reporting, runtime errors, API/sync failures, and performance monitoring.

Sensitive information must be redacted.

### TD-073 — Structured Logging

Use structured log levels:

- Debug.
- Info.
- Warning.
- Error.

Debug-level logging must be limited to development environments.

Production logs must be limited and privacy-aware.

### TD-074 — Performance Strategy

Use pagination, lazy loading, caching, optimized queries, and indexes.

Monitor performance and address measured bottlenecks.

### TD-075 — Application Version Compatibility

Define a minimum supported application version.

Handle database migrations and older supported clients safely.

Require mandatory updates only when necessary for security, compatibility, or critical correctness.

### TD-076 — Supabase Environment Separation

Use separate Supabase projects for Development, Staging, and Production.

Use environment-specific configuration and secrets.

Never share production credentials with development or test environments.

### TD-077 — Release and Migration Safety

Use versioning, migration review, regression testing, backup verification, and rollback planning.

Database migrations should remain backward-compatible where required by supported application versions.

## 9. Final Technical Gap Verification

### TD-078 — Atomic Inventory Concurrency

Concurrent inventory operations must be protected through PostgreSQL transactions and appropriate row locking or equivalent concurrency controls.

The operation must verify current quantity and atomically update stock and append its event.

Idempotency must prevent duplicate application.

LWW is not sufficient for stock mutations.

### TD-079 — Reliable Incremental Synchronization

Use a server-side change log, cursor, revision, or equivalent reliable mechanism for incremental synchronization.

Realtime is a notification/wakeup mechanism, not the authoritative change history.

Deletion and archive changes require tombstones or an equivalent mechanism so clients can reconcile removed records.

### TD-080 — Centralized Authorization

RLS and secure backend functions must enforce authorization.

Sensitive operations must validate current membership and role inside the transaction.

Never trust client-provided household IDs or role claims as authorization proof.

Any `SECURITY DEFINER` function requires careful review of ownership, search path, grants, and authorization checks.

### TD-081 — Account Deletion and Actor Attribution

Account deletion must remove personal profile data according to the approved policy while preserving required shared history.

Use a pseudonymous actor reference or nullable actor reference where appropriate.

The UI may display a neutral label such as "Former member" when the original identity is no longer available.

### TD-082 — Household Deletion and Recovery

Household deletion uses the approved 30-day soft-deletion period.

Ordinary operations must stop or be restricted during deletion.

Recovery must restore the household where valid.

The permanent deletion process must handle dependent records and historical references safely without arbitrary cascading deletion.

### TD-083 — Offline Queue Isolation

Pending operations remain tied to their original user and household.

They must not transfer to another account.

If membership is revoked, the queue must stop unauthorized synchronization.

After permanent account deletion, pending operations must not be synchronized.

The user must be warned that unsynchronized changes may be lost when deleting the account.

### TD-084 — Unit Model

Support standard global units and household-scoped custom units.

Each product has one base inventory unit.

All batches of that product use the same base unit.

Do not perform implicit unit conversions.

Historical events must preserve the unit used.

### TD-085 — Low-Stock Calculation

Low-stock evaluation uses the approved available-quantity model across active batches.

Expired batches remain visible but are excluded from available stock.

The implementation must distinguish total quantity from available quantity and apply the approved threshold behavior consistently.

### TD-086 — Atomic Invitation Acceptance

Invitation acceptance must be one atomic backend operation.

It validates token validity, expiration, usage, household status, and assigned role.

It creates the membership and invalidates the token within the same transaction.

### TD-087 — Push Notification Delivery Guarantees

Do not claim exactly-once push delivery.

Use at-least-once processing where appropriate, unique event keys, deduplication, and retries.

Provider acceptance is not proof of device delivery.

### TD-088 — Private Storage and Cleanup

Private storage access must be enforced through ownership-aware policies.

Object paths alone are not authorization.

Cleanup jobs must be safe, retryable, and idempotent.

### TD-089 — Secrets Management

The Supabase publishable/anon key may be included in the mobile application when RLS and backend authorization are correctly enforced.

Service-role keys, FCM server credentials, and private API secrets must remain server-side.

Use environment separation and never commit secrets to Git.

### TD-090 — External Product API Reliability

Open Food Facts is an optional lookup source.

Manual product creation must always remain available.

Implement caching, rate-limit handling, error classification, attribution, and licensing compliance.

External API failure must not block core inventory operations.

### TD-091 — Navigation Architecture

Use `go_router` for navigation, authentication redirects, protected routes, invitation deep links, and notification deep links.

Route guards improve navigation behavior but do not replace backend authorization.

---

## 10. Change Control

1. TD-001 through TD-091 are approved.
2. Implementation must follow these decisions.
3. No decision may be silently changed or removed.
4. Any proposed change must reference the affected TD identifier.
5. The proposal must explain its reason, impact, dependencies, and affected tests.
6. Explicit approval is required before changing the approved baseline.
7. Implementation-time verification must not be misrepresented as a new approved technical decision.

## 11. Relationship to Other Documents

- `SPEC.md`: Consolidated product requirements.
- `FUNCTIONAL_DECISIONS.md`: Approved functional decisions.
- `GAP_REVIEW.md`: Adopted functional gap resolutions.
- `ARCHITECTURE.md`: System architecture and component boundaries.
- `TEST.md`: Testing strategy.
- `IMPLEMENTATION_PLAN.md`: Implementation phases and task dependencies.
- `CODEX_READ_ONLY_AUDIT_PROMPT.md`: Read-only validation instructions.

**End of Technical Decisions**

# PantryMate — Functional Gap Review

**Document:** GAP_REVIEW.md  
**Status:** Adopted Resolutions  
**Project:** PantryMate  
**Resolution Range:** Gap-001 to Gap-130

---

## 1. Purpose

This document records the functional edge cases and gap resolutions adopted during the PantryMate requirements review.

It supplements:

- `SPEC.md`
- `FUNCTIONAL_DECISIONS.md`
- `TECHNICAL_DECISIONS.md`

These resolutions clarify expected behavior in exceptional situations, concurrent operations, offline scenarios, deletion workflows, and lifecycle transitions.

They do not authorize undocumented changes to the approved FD or TD decisions.

## 2. Adopted Gap Resolutions

### Gap-001 — Offline Changes During Account Deletion
Pending offline changes must not be silently synchronized after permanent account deletion. The user must be informed that unsynchronized changes may be lost.

### Gap-002 — Immutable History After Inventory Deletion
Archiving or removing inventory must not rewrite or erase existing inventory history. Historical events remain subject to the approved retention and deletion policies.

### Gap-003 — Household Deletion With Shared Records
Household deletion must account for dependent records and historical references. The recovery period must preserve sufficient data to restore the household.

### Gap-004 — Storage Location Deletion
A location cannot be deleted while active inventory batches reference it. Inventory must first be moved to a valid alternative location.

### Gap-005 — Low-Stock Notification State
Low-stock notifications are based on state transitions, not repeated checks. A notification is generated when stock enters low-stock status again after recovering.

### Gap-006 — Atomic Shopping Purchase
Marking an item as purchased and updating inventory must be handled as one atomic operation. Partial success must not leave inconsistent shopping and inventory records.

### Gap-007 — Product Image Lifecycle
Image selection, local caching, upload, replacement, deletion, and cleanup must be handled without leaving unauthorized or orphaned storage objects.

### Gap-008 — Shopping History Retention
Removing or archiving shopping list items must not silently erase shopping history required by the approved history rules.

### Gap-009 — Default Shopping Item Priority
A shopping item without an explicitly selected priority uses Normal priority.

### Gap-010 — Backup and Deletion
Local SQLite storage is not a remote backup. Account and household deletion must follow the approved remote data lifecycle and recovery rules.

### Gap-011 — Feedback Attachments
Feedback screenshots are optional. The application must not attach sensitive information automatically.

### Gap-012 — Log Privacy
Application logs and monitoring events must not expose passwords, authentication tokens, private credentials, or unnecessary personal data.

### Gap-013 — Timezone Changes and Notifications
Scheduled notifications must account for device timezone changes and daylight-saving transitions without changing date-only expiration values.

### Gap-014 — Barcode Uniqueness
Barcode-based duplicate detection must be handled consistently. A barcode conflict must be surfaced before saving a conflicting product.

### Gap-015 — Custom Unit Ownership
Custom units belong to their household. They must not be treated as globally available units or used implicitly across households.

### Gap-016 — Product Deletion and History
A product with dependent inventory batches or required historical references cannot be permanently deleted through an ordinary operation.

### Gap-017 — Realtime and Change History
Realtime notifications alone are insufficient for synchronization. Clients must reconcile changes using a reliable server-side change tracking mechanism.

### Gap-018 — Concurrent FEFO Consumption
Concurrent consumption operations must validate and update batch quantities transactionally. Two devices must not consume the same available quantity twice.

### Gap-019 — Invitation Resend and Cancellation
Resending or cancelling an invitation invalidates the previous token. Only the current valid token may be accepted.

### Gap-020 — Minimum Application Version
The application must handle unsupported or outdated client versions where compatibility or security requires it. Minimum supported versions must be explicitly configured.

### Gap-021 — Ownership Transfer
Ownership transfer must be atomic and must leave the household with exactly one valid Owner.

### Gap-022 — Member Removal
Member removal must immediately prevent further authorized household operations and stop unauthorized pending synchronization.

### Gap-023 — Role Changes
Role changes must be validated against the actor's current permissions and must take effect through backend authorization, not merely UI updates.

### Gap-024 — Invitation to Existing Members
An invitation must not create duplicate household membership when the invited account is already a member. The existing membership state must be handled explicitly.

### Gap-025 — Invitation Email Verification
Invitation acceptance must use the authenticated account and the valid invitation token. Email identity requirements must be enforced consistently with the configured authentication and invitation policy.

### Gap-026 — Last Active Household
Remembering the last active household must not bypass membership validation. If access is no longer valid, the application must select an accessible household or request an appropriate action.

### Gap-027 — Products Without Expiration Dates
A batch may have no expiration date. Such batches remain valid inventory and must not be treated as expired.

### Gap-028 — Batch Expiration Date Changes
Changing a batch expiration date must update future expiration scheduling while preserving the history of the change.

### Gap-029 — Undo Eligibility
Undo is limited to eligible operations within the approved time window. It must validate the current state and create a reversal event.

### Gap-030 — Repeated Shopping Purchase
Repeated requests to purchase the same shopping item must not apply the inventory increase more than once.

### Gap-031 — Offline Shopping Item Removal
An offline removal must be represented as a pending operation or tombstone so that synchronization does not accidentally restore the removed item.

### Gap-032 — Shopping List Archive
Archiving a list must preserve its records and history. Restoring it must not duplicate its items or purchase history.

### Gap-033 — Default Shopping List
The default shopping list must remain valid when lists are archived, restored, or deleted. Concurrent default-list changes must not produce inconsistent state.

### Gap-034 — Shopping Units
Shopping item units must be explicit. Different units must not be merged or converted implicitly.

### Gap-035 — Free-Text Shopping Items
Users may create shopping items without linking them to a catalog product. Such items must remain usable in shopping workflows.

### Gap-036 — Product Category Changes
Changing a product category updates its current catalog metadata. Historical events must retain their historical meaning and must not be silently rewritten.

### Gap-037 — Product Metadata and Batch Data
Product-level metadata must remain separate from batch-specific quantity, expiration, and location data.

### Gap-038 — Similar Product Names
Name similarity alone must not automatically merge products. The application should present potential duplicates for review.

### Gap-039 — Permanent Product Deletion
Permanent product deletion must be blocked while required dependent records or historical references exist. Any allowed permanent deletion must follow the approved deletion policy.

### Gap-040 — Quantity Precision
Quantity validation and arithmetic must respect the precision allowed by the selected unit. Invalid precision must be rejected.

### Gap-041 — Expiration Date Updates
Expiration date changes must be recorded and must trigger appropriate rescheduling of future reminders.

### Gap-042 — Multi-Device Notifications
Notification preferences and event deduplication must work across all registered devices belonging to the user.

### Gap-043 — Offline Notification Preferences
Offline preference changes must remain local and synchronize safely. A stale device must not silently overwrite newer server-authoritative preference values.

### Gap-044 — OS Notification Permission Denied
If operating-system notification permission is denied, the application must remain usable. It must explain the limitation and allow the user to enable permission later.

### Gap-045 — Notifications After Member Removal
A removed member must not continue receiving new household notifications requiring active membership. Existing notifications must be handled without exposing inaccessible household data.

### Gap-046 — Low Stock Across Multiple Batches
Low-stock calculation must consider the aggregate quantity across the relevant active batches rather than evaluating each batch independently.

### Gap-047 — Restocking
Restocking must update the relevant inventory quantities and produce the required history event. Low-stock notification state must be recalculated after the operation.

### Gap-048 — Dashboard Offline Counts
Dashboard values displayed offline must be identified as based on locally available data where synchronization may be pending.

### Gap-049 — Reports With Deleted Products
Reports must preserve required historical meaning even if a product is later archived or permanently removed under an approved deletion workflow.

### Gap-050 — CSV Duplicate Handling
CSV import must detect duplicate or conflicting records and report them before applying changes. It must not silently create unintended duplicates.

### Gap-051 — Interrupted CSV Import
An interrupted import must not leave an uncontrolled partially applied dataset. Import processing must have a defined failure and recovery strategy.

### Gap-052 — Invalid CSV Rows
Invalid rows must be reported with enough information for correction. The user must be able to review errors before applying valid data.

### Gap-053 — CSV Export While Offline
Export must clearly reflect the data available locally. It must not claim to contain remote changes that have not synchronized to the device.

### Gap-054 — PDF Report Consistency
A PDF report must use a consistent data snapshot for the report generation operation. It must not combine inconsistent values from different moments.

### Gap-055 — Archived Record Search
Archived records must follow explicit search visibility rules. They must not appear as active inventory unless restored.

### Gap-056 — Similar Name Search
Search must distinguish similar product names without treating them as identical products.

### Gap-057 — Accessibility
Forms, dialogs, controls, and status indicators must expose meaningful accessible labels and state information.

### Gap-058 — RTL and Future Localization
Although the first release is English-only, layout and text handling should not prevent future right-to-left localization.

### Gap-059 — Interrupted Onboarding
If onboarding is interrupted, the application must preserve completed valid steps and allow the user to resume without creating duplicate household or account records.

### Gap-060 — Multiple Household Switching
Switching households must clear or replace household-scoped UI state safely. Data from the previous household must not appear in the new household context.

### Gap-061 — Household Settings Offline
Offline household-setting changes must be restricted to supported operations and clearly marked as pending. Protected settings must still be authorized by the backend when synchronized.

### Gap-062 — Household Member Limits
Any member limits imposed by the selected backend/service plan must be verified before release. The application must handle a reached limit with a clear error rather than partial membership creation.

### Gap-063 — Household With No Active Members
The system must prevent or safely handle a household state with no valid Owner or authorized recovery path.

### Gap-064 — Storage Quota
Storage quota and upload limits must be verified against the selected Supabase plan and enforced with clear user feedback.

### Gap-065 — User Deletes an Image
Removing an image reference must not leave the application displaying a broken image. Remote cleanup must be safe and must not delete an object still referenced elsewhere.

### Gap-066 — Reinstall or Device Loss
Remote shared data must remain recoverable after reinstall or device loss, subject to authentication and backend retention. Local-only pending changes may not be recoverable.

### Gap-067 — Logout With Pending Changes
Before logout, the user must be informed when pending local changes may be affected. Pending data must not be transferred to another account.

### Gap-068 — Application Update With Pending Sync
Application updates must preserve compatible local pending operations. Incompatible operations must be handled explicitly rather than silently discarded or incorrectly migrated.

### Gap-069 — Incorrect Device Clock
Critical timestamps and ordering must use server-authoritative values. A device clock that is incorrect must not corrupt shared ordering or authorization.

### Gap-070 — Concurrent Product Metadata Changes
Concurrent edits to ordinary product metadata must use the approved revision/version conflict strategy. Sensitive inventory fields must not be resolved through ordinary LWW.

### Gap-071 — Storage Location Archive
Archiving a location must preserve history and prevent new assignment where applicable. Existing batches must be handled before permanent deletion.

### Gap-072 — Custom Unit Archive
A custom unit referenced by existing products or history must not be removed in a way that invalidates those records.

### Gap-073 — Notification Rescheduling
Changes to reminder preferences, expiration dates, quiet hours, or timezone must trigger appropriate notification rescheduling.

### Gap-074 — Deep Links to Deleted Records
A notification or invitation deep link may reference a record that is no longer available. The application must show a safe unavailable/expired state without exposing unauthorized data.

### Gap-075 — Profile Changes
Profile changes must not modify household membership, inventory ownership, or historical actor attribution unexpectedly.

### Gap-076 — Account Deletion Across Households
Account deletion must consider every household membership and the user's role in each household. Ownership-transfer requirements must be resolved before deletion where applicable.

### Gap-077 — Export Before Account Deletion
The account deletion workflow must provide the user with the approved data export opportunity and explain what happens to shared household data.

### Gap-078 — Feedback From Removed Members
Feedback submission must not grant a removed household member renewed access to household data. Feedback must be processed separately from household authorization.

### Gap-079 — Email Verification
Authentication and invitation flows must handle unverified email states according to the configured authentication policy.

### Gap-080 — Password Reset
Password reset must use the secure Supabase Auth flow. Reset links must be handled safely and must not expose credentials in application logs.

### Gap-081 — Account Linking
Linking authentication providers must not accidentally create duplicate user identities or merge accounts without explicit secure verification.

### Gap-082 — Session Expiration
An expired session must trigger reauthentication where necessary. Cached data may remain locally subject to the approved access and privacy rules.

### Gap-083 — Account Deletion Confirmation
Account deletion requires clear confirmation and an explanation of its consequences, including shared data, pending changes, and ownership constraints.

### Gap-084 — Household Recovery
During the approved recovery period, an authorized Owner must be able to cancel household deletion and restore normal operation where valid.

### Gap-085 — Unauthorized Cached Data
Cached household data must not become accessible to another signed-in account or a user whose membership has been revoked.

### Gap-086 — Feedback Screenshot Privacy
Before feedback screenshots are submitted, the user must be able to review the attachment. Sensitive information must not be included automatically.

### Gap-087 — Partial Operation Failures
Multi-step operations must have defined atomicity or compensation behavior. The UI must communicate whether an operation succeeded, failed, or remains pending.

### Gap-088 — Activity Feed Ordering and Privacy
Activity events must use authoritative timestamps and appropriate access rules. The feed must not expose information to unauthorized household users.

### Gap-089 — History Pagination
Large history datasets must be paginated. Pagination must preserve a stable and consistent ordering strategy.

### Gap-090 — Actor Anonymization
When an account is deleted, historical actor references must follow the approved pseudonymous or nullable attribution strategy.

### Gap-091 — Household Deletion and Invitations
Household deletion must invalidate or disable outstanding invitations so they cannot create membership in a deleted household.

### Gap-092 — Product and Batch Archive
Product archival and batch archival are distinct lifecycle operations. Their effects on visibility, consumption, restoration, and history must remain consistent.

### Gap-093 — Product Archive With Positive Stock
A product with positive inventory must not be archived in a way that makes stock inaccessible or causes inventory integrity problems. The approved lifecycle rules must be enforced.

### Gap-094 — No-Op Adjustment
An adjustment that does not change quantity must not create a misleading stock-change event. The application must handle no-op submissions explicitly.

### Gap-095 — Zero-Quantity Batch
A batch reaching zero quantity must follow the approved zero-quantity lifecycle behavior. It must not be treated as negative inventory or silently removed from required history.

### Gap-096 — Expired Batch Consumption
Expired batches remain visible. Their consumption or adjustment must follow the approved inventory policy and must not bypass history or quantity validation.

### Gap-097 — Unit Migration
Changing a product's base unit must not silently reinterpret existing quantities. Any required migration must be explicit, validated, and preserve historical units.

### Gap-098 — Expiration Notification for Zero-Quantity Batch
A zero-quantity batch must not continue generating irrelevant expiration notifications. Notification scheduling must consider the batch's current valid lifecycle state.

### Gap-099 — Household Timezone
Household-level scheduled behavior must use an explicitly defined timezone policy. Device-local display and household-level scheduling must not be confused.

### Gap-100 — Single Owner Invariant
Each active household must have exactly one valid Owner. Ownership transfer and deletion workflows must preserve this invariant.

### Gap-101 — Custom Unit Name Collision
Custom unit creation must detect conflicting names within the relevant household scope and handle duplicates consistently.

### Gap-102 — Import and Export Permissions
Import and export operations must enforce the relevant household role permissions and must not expose data beyond the user's authorization.

### Gap-103 — Duplicate Inventory Events
Repeated requests and synchronization retries must not create duplicate inventory events for the same logical operation. Use idempotency identifiers.

### Gap-104 — Search After Membership Removal
After membership is revoked, search must stop returning household records from both remote and locally cached results.

### Gap-105 — Offline Conflict Visibility
When synchronization detects a conflict, the application must not silently hide the outcome. It must expose an appropriate status and preserve data integrity.

### Gap-106 — Crash During Local Transaction
Local database operations must use transactions where multiple related changes are required. A crash must not leave partially written local state.

### Gap-107 — Permanent Deletion Phases
Permanent deletion of complex entities must follow a controlled lifecycle. Dependent records, storage objects, and historical references must be handled safely.

### Gap-108 — Account Deletion Versus Ownership Transfer
An Owner cannot bypass the ownership-transfer requirement through account deletion. The workflow must resolve household ownership first or follow an explicitly approved household deletion path.

### Gap-109 — Account Deletion Versus Household Deletion
Account deletion and household deletion are separate processes with separate authorization, recovery, and retention rules.

### Gap-110 — Historical Snapshot Completeness
Historical records and reports must retain the information necessary to explain past activity even when current product metadata changes.

### Gap-111 — Product Rename and Reports
Renaming a product changes its current catalog representation. Historical reporting must preserve enough context to interpret earlier activity accurately.

### Gap-112 — Household Switch and Stale Responses
Asynchronous responses from a previously active household must not overwrite the state of the newly selected household.

### Gap-113 — Concurrent Product Creation
Concurrent attempts to create equivalent products must be handled with database constraints and duplicate detection, avoiding uncontrolled duplicates.

### Gap-114 — Batch Transfer
Moving a batch between locations must be validated and recorded consistently. It must not create duplicate stock or lose the original quantity.

### Gap-115 — Low-Stock Threshold Changes
Changing a product's threshold must trigger recalculation of low-stock status and notification state without generating inappropriate repeated alerts.

### Gap-116 — Restore Product With Barcode Collision
Restoring an archived product must validate barcode uniqueness and resolve any collision before restoration.

### Gap-117 — Restore Location With Name Collision
Restoring an archived location must validate naming and uniqueness constraints within the household before restoration.

### Gap-118 — Default Shopping List Race
Concurrent changes to the default shopping list must preserve a valid default selection and prevent multiple conflicting defaults.

### Gap-119 — Restore Shopping Item After Purchase
Restoring or re-adding a shopping item after it has already been purchased must not duplicate the purchase or inventory update.

### Gap-120 — Expiration Date and Timezone
Expiration dates are date-only values. Timezone changes may affect reminder scheduling but must not shift the stored expiration date.

### Gap-121 — Offline Shopping Purchase
An offline purchase operation must be recorded locally and synchronized idempotently. It must not be applied twice after retries or reconnection.

### Gap-122 — Low-Stock State After Archive and Restore
Archiving or restoring inventory must trigger appropriate available-quantity and low-stock recalculation.

### Gap-123 — Notification After Undo
Undoing an inventory operation must recalculate relevant notification state and prevent stale notifications from being sent when no longer applicable.

### Gap-124 — Export During Household Deletion
Exports must respect household deletion status and authorization. An export must not bypass the deletion workflow or expose data after access is revoked.

### Gap-125 — Import During Household Deletion
Imports must be rejected or safely stopped when the household is in a deletion state. They must not create records in a household awaiting permanent deletion.

### Gap-126 — Notification and Invitation Secret Exposure
Notification payloads, deep links, logs, and client-visible data must not expose invitation secrets or sensitive authentication material.

### Gap-127 — Permanent Deletion and External Integrations
Permanent deletion must consider related external storage objects, notification tokens, and integration references. Cleanup must be safe and retryable.

### Gap-128 — Household Deletion and Offline Operations
Pending operations for a household awaiting deletion must not bypass its deletion state. Restoration or permanent deletion must reconcile those operations safely.

### Gap-129 — Historical Data and Account Privacy
Historical attribution must balance auditability and privacy. Account deletion must not expose deleted personal identity through retained shared history.

### Gap-130 — Deletion and Synchronization Finalization
Permanent deletion must coordinate remote records, local synchronization state, and dependent resources. Completion must not be reported until the required deletion workflow has reached its defined terminal state.

---

## 3. Review Boundaries

The adopted resolution range ends at Gap-130.

No Gap-131 or later identifier is part of this approved record.

This document records functional resolutions. It does not claim that the related implementation, database schema, backend functions, tests, or external services already exist.

## 4. Implementation Rules

1. Preserve the behavior defined by each adopted resolution.
2. Implement related safeguards at the correct layer: UI, local database, synchronization engine, backend, or PostgreSQL.
3. Do not rely on UI-only validation for security or data integrity.
4. Add tests for each applicable edge case.
5. If implementation reveals a contradiction, stop and report it.
6. Do not invent a new resolution ID or silently alter an adopted resolution.
7. Any change requires a documented proposal and explicit approval.

## 5. Relationship to Other Documents

- `SPEC.md`: Consolidated product requirements.
- `FUNCTIONAL_DECISIONS.md`: FD-001 to FD-095.
- `TECHNICAL_DECISIONS.md`: TD-001 to TD-091.
- `ARCHITECTURE.md`: System architecture.
- `TEST.md`: Testing strategy.
- `IMPLEMENTATION_PLAN.md`: Implementation phases and tasks.
- `CODEX_READ_ONLY_AUDIT_PROMPT.md`: Read-only audit instructions.

**End of Functional Gap Review**

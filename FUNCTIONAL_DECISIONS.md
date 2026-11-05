# PantryMate — Functional Decisions

**Document:** FUNCTIONAL_DECISIONS.md  
**Status:** Approved  
**Decision Range:** FD-001 to FD-095  
**Project:** PantryMate

---

## 1. Purpose

This document records the approved functional decisions governing PantryMate.

These decisions define expected product behavior. They are the functional source of truth for implementation.

Implementation must not silently reinterpret, weaken, or replace an approved decision.

If a requirement conflicts with another approved decision, the conflict must be reported rather than resolved through an undocumented assumption.

## 2. Approved Decisions

### FD-001 — Backend Platform
PantryMate uses Supabase as its backend platform, including PostgreSQL, Authentication, Row Level Security, Realtime, Storage, and backend functions where required.

### FD-002 — Multiple Households
A user may belong to multiple households and switch between them.

### FD-003 — Household Roles
Each household supports Owner, Admin, and Member roles. Permissions are defined independently for each household membership.

### FD-004 — Authentication Methods
The application supports email/password, Google, and Apple authentication.

### FD-005 — Inventory Permissions
Owner, Admin, and Member can add, edit, remove, and archive inventory records, subject to the approved inventory lifecycle and backend authorization rules.

### FD-006 — Expiration Reminder Default
The default expiration reminder is three days before the batch expiration date. Users can configure reminder preferences.

### FD-007 — Units
The application supports predefined standard units and household-scoped custom units.

### FD-008 — Categories
Product categories are predefined global categories. Households cannot create their own categories.

### FD-009 — Shopping List Duplicate Handling
Duplicate shopping items are merged only when they refer to the same product and the same unit. Their quantities are summed. Different units remain separate.

### FD-010 — Notification Defaults
All notification categories are enabled by default, subject to operating-system notification permission and user preferences.

### FD-011 — Offline Changes
Offline changes remain stored locally until synchronization succeeds. They do not expire after an arbitrary fixed period.

### FD-012 — Conflict Resolution
Ordinary record conflicts use Last Write Wins behavior, implemented with server-authoritative revision/version handling. Sensitive stock operations require stronger transactional handling.

### FD-013 — Date and Time Handling
Timestamps are stored in UTC and displayed in the device's local timezone. Expiration dates are date-only values.

### FD-014 — Initial Application Language
The first release is English-only. The architecture must remain suitable for future localization.

### FD-015 — Invitation Expiration
Household invitations expire after seven days.

### FD-016 — Owner Leaving a Household
An Owner must transfer ownership before leaving the household.

### FD-017 — Account Deletion and Shared Data
Account deletion removes personal account data according to the approved deletion workflow while preserving shared household data and required historical records for remaining members.

### FD-018 — Immutable Inventory History
Inventory history is immutable. Changes, corrections, undo operations, and deletions create new events instead of rewriting existing history.

### FD-019 — Barcode Scanning
Barcode scanning is included in the first release.

### FD-020 — Product Images
Users can capture product images using the camera or select them from the gallery.

### FD-021 — Storage Locations
Households have predefined storage locations and can create additional custom locations.

### FD-022 — Location Deletion
A storage location cannot be deleted while inventory batches remain assigned to it. Inventory must first be moved to another valid location.

### FD-023 — Quantity Precision
Quantity precision depends on the selected unit. Some units use whole quantities; others support decimal quantities.

### FD-024 — Low-Stock Notification Behavior
A low-stock notification is generated when a product enters low-stock status. No repeated notification is generated while it remains continuously in that state. A new notification can occur after stock recovers and later becomes low again.

### FD-025 — Household Deletion Recovery
Household deletion uses a 30-day recovery period before permanent deletion.

### FD-026 — Inventory Removal
Removing inventory from normal use means archiving it, not immediately destroying its history. Archived inventory can be restored according to lifecycle rules.

### FD-027 — Personal Notification Preferences
Users can independently enable or disable supported notification categories. Defaults are enabled, subject to OS permission.

### FD-028 — Purchased Items and Inventory
Confirming a shopping item as purchased can add the purchased quantity to inventory. The user can confirm or adjust quantity, unit, and storage location. The purchase must also be recorded in shopping history.

### FD-029 — Invitation Resending
Owner and Admin can resend invitations according to their invitation permissions. Resending renews the seven-day expiration period and invalidates the previous token.

### FD-030 — Barcode Lookup Review
Barcode lookup uses Open Food Facts as the preferred source. Returned information must be reviewable and editable before the product is saved.

### FD-031 — Barcode Lookup Failure
If the external lookup fails, the barcode remains available for manual entry. The application distinguishes network/API failures from a product-not-found result. Manual entry remains available.

### FD-032 — Product Image Storage
Product images use Supabase Storage and local caching. Offline image uploads are queued until connectivity is restored. Exact storage limits and compression parameters are implementation-time configuration details.

### FD-033 — Invitation Delivery
Invitations support email delivery and shareable links that users can send through available communication applications.

### FD-034 — Invitation Token
An invitation uses a secure, random, single-use token associated with a household, assigned role, and expiration. The token is invalidated after acceptance, cancellation, or replacement.

### FD-035 — Invitation Permissions
Owner can invite Admin or Member. Admin can invite Member only.

### FD-036 — Member Removal
Owner and Admin can remove Members. Only Owner can remove Admin. No household role can remove the Owner through ordinary member-removal operations.

### FD-037 — Role Assignment
Owner can assign Admin or Member roles. Admin can assign Member only.

### FD-038 — Leaving a Household
Admin and Member can leave a household. Owner must transfer ownership before leaving.

### FD-039 — Last Active Household
The application remembers the user's last active household and restores it when appropriate.

### FD-040 — Notification Channels
The application supports local notifications and push notifications, subject to device and platform capabilities.

### FD-041 — Expiration Notification Scheduling
Expiration notifications use a hybrid approach: backend scheduling is the primary mechanism, with local notifications as a fallback where appropriate.

### FD-042 — Default Low-Stock Threshold
The default low-stock threshold is one unit. The threshold can be customized per product.

### FD-043 — Expired Inventory Visibility
Expired products remain visible with an Expired status. They are not automatically removed from inventory.

### FD-044 — Multiple Inventory Batches
A product can have multiple inventory batches. Each batch has its own quantity, expiration date, and storage location.

### FD-045 — Consumption
Users can consume inventory through quantity adjustment or a dedicated Consume action. Both methods create inventory history events. Quantity cannot become negative.

### FD-046 — Undo
Eligible inventory operations can be undone within ten seconds. Undo creates a reversal event and does not delete the original history event.

### FD-047 — Shared Shopping Lists
All household members can view and edit shared shopping lists, subject to household membership and any applicable authorization restrictions.

### FD-048 — Multiple Shopping Lists
A household can have multiple shopping lists. Users with appropriate access can create, rename, archive, restore, and select a default list.

### FD-049 — Shopping List Item Fields
A shopping list item contains a name, quantity, and unit, with an optional note. Users can add, edit, remove, and mark items as purchased. Purchase attribution and time are recorded.

### FD-050 — Shopping List Archive and History
Shopping lists can be archived and restored. Shopping history is preserved. Permanent deletion follows the approved retention and lifecycle rules.

### FD-051 — Shopping Item Removal History
Removing an item from an active list preserves the relevant history, including who removed it and when.

### FD-052 — Shopping Item Priority
Shopping items can have Low, Normal, or High priority. Normal is the default.

### FD-053 — Shopping List Organization
Shopping lists support grouping by category, manual sorting, search, and filtering.

### FD-054 — Inventory Search and Filtering
Inventory supports search by product name and barcode. Filters include category, storage location, and expiration status. Sorting includes name, quantity, and expiration. Quick filters include expiring soon, expired, and low stock.

### FD-055 — Dashboard
The dashboard displays relevant summaries, including active inventory, low-stock products, expiring-soon and expired batches, shopping progress, and recent activity.

### FD-056 — Reports
Reports include consumption, waste/expired inventory, inventory changes, shopping history, and monthly summaries.

### FD-057 — Profile and Preferences
The profile area supports personal information, profile photo, account security, notification preferences, language settings when available, and theme selection.

### FD-058 — Theme Modes
The application supports System, Light, and Dark themes.

### FD-059 — UI States
The application must provide Loading, Empty, Error, Offline, Retry, and Success states where relevant.

### FD-060 — Accessibility
The application must support screen readers, dynamic text scaling, sufficient contrast, accessible labels, and appropriate touch-target sizes.

### FD-061 — Import and Export
The application supports CSV inventory import, CSV inventory export, shopping history export, and PDF summary reports. Imports must be validated and provide a preview of errors before applying changes.

### FD-062 — Shared Product Catalog
Each household has a shared product catalog. A product can have multiple inventory batches. Product-level edits apply to the shared product record. A product cannot be permanently deleted while dependent batches or required historical references exist.

### FD-063 — Global Categories
Categories are fixed and global. Households cannot create custom categories. Each product belongs to one category.

### FD-064 — Optional Notes
Optional notes are supported at Product, Inventory Batch, and Shopping List Item levels. Editing notes does not rewrite historical events.

### FD-065 — Personal Favorites
Users can maintain personal favorite products and quickly add them to a shopping list.

### FD-066 — Recently Used Products
Users can access personal recently used products and quickly add them to inventory or a shopping list.

### FD-067 — Duplicate Product Detection
Duplicate detection uses barcode first, then available name/brand matching. The application shows potential existing products but allows a new product when it is genuinely different.

### FD-068 — FEFO Consumption
The default consumption strategy is First Expired, First Out. Batches with the nearest expiration date are consumed first. Batches without expiration dates are ordered by oldest creation time. Users can manually select batches.

### FD-069 — Manual Adjustment Reasons
Manual inventory adjustments support Correction, Damaged, Lost, Found, and Other. The selected reason is recorded in the inventory event.

### FD-070 — Household-Wide Search
Search can cover authorized products, batches, and shopping lists in the active household. Results are grouped by record type. Unauthorized household data must never appear.

### FD-071 — Onboarding
Onboarding includes Welcome, Authentication, household creation or joining, notification preference configuration, and a brief inventory/shopping-list introduction.

### FD-072 — Dashboard Personalization
Users can hide and reorder dashboard widgets according to their preferences.

### FD-073 — Shared and Local Data
Supabase is the main shared data source. Local SQLite stores cached data and pending offline changes. The local database is not the only backup or source of truth.

### FD-074 — Session Security
The application supports secure session handling, token refresh and expiration, secure token storage, and logout from the current device or all devices. OAuth credentials and server secrets must not be embedded in the app.

### FD-075 — Overall Product Scope
PantryMate is a household inventory and shopping management platform. The first release includes the approved core capabilities documented in this specification and decision records.

### FD-076 — Household Activity Feed
The application provides a shared household activity feed covering relevant inventory, shopping-list, and membership actions. It records actor and time and supports appropriate filtering and privacy rules.

### FD-077 — Multi-Device Synchronization
A user's data synchronizes across multiple devices. Each device maintains its own local cache and exposes synchronization status.

### FD-078 — Offline-First User Experience
The application prioritizes local data access and supports approved offline operations. Pending and failed synchronization must be visible. The application must not falsely confirm remote synchronization.

### FD-079 — Household Settings
Household settings include name, photo, members, invitations, storage locations, and preferences. Protected settings follow Owner-only permissions where approved.

### FD-080 — Help and Feedback
The application provides in-app FAQ, problem reporting, and feedback submission. Users may optionally attach a screenshot. Sensitive data must not be attached automatically.

### FD-081 — Privacy and Legal Information
The application provides Privacy Policy, Terms, data export, and account deletion. It explains the implications of shared household data and avoids unnecessary permissions.

### FD-082 — Biometric App Lock
Optional biometric App Lock supports Face ID, Touch ID, and Android biometrics where available. A suitable fallback is provided. Biometric lock does not replace account authentication.

### FD-083 — Application Updates
Updates are managed through Google Play and Apple App Store. Database migrations and compatibility with older supported application versions must be considered. Minimum supported versions are established before release.

### FD-084 — Performance and Monitoring
The application uses pagination, lazy loading, image caching, optimized queries, and appropriate performance/error monitoring. Monitoring must respect privacy.

### FD-085 — Destructive Action Protection
Destructive actions require appropriate confirmation and an explanation of impact. Accidental household deletion must be prevented. Undo is provided where supported, and relevant actions are audited.

### FD-086 — Expiration Reminder Time
The default expiration reminder time is 09:00 in the device's local timezone. Users can configure the reminder time. The default lead time remains three days.

### FD-087 — Expiration Reminder Snooze
Users can snooze an expiration reminder for one day. Snoozing does not change the batch expiration date.

### FD-088 — Quiet Hours
Default quiet hours are 22:00–08:00. Users can configure or disable them. Non-urgent notifications are deferred where supported. Urgent notification behavior remains subject to platform and delivery constraints.

### FD-089 — Notification Deep Links
Notifications support contextual navigation:
- Expiration reminder → relevant product/batch.
- Low-stock alert → relevant product.
- Invitation → invitation details.
- Shopping activity → relevant shopping list.

The destination must be revalidated against authentication and current access permissions.

### FD-090 — Archived Inventory Retention
Archived inventory remains retained until explicit permanent deletion. It can be restored. There is no arbitrary automatic fixed retention period for archived inventory. Permanent deletion requires confirmation and must respect historical record integrity.

### FD-091 — Leaving a Household and Attribution
Leaving a household removes the user's access but preserves shared household data and required history. Historical attribution is preserved subject to account-deletion and privacy rules.

### FD-092 — Invitation Acceptance
Invitation acceptance requires an authenticated user and a valid, unexpired, unused token. Acceptance creates membership with the assigned role and invalidates the token.

### FD-093 — Contextual Permissions
Camera, gallery, and notification permissions are requested when the user invokes the relevant feature or enables the corresponding setting. The reason for each permission is explained.

### FD-094 — Permission Request Timing
The application must not request optional permissions immediately on first launch. Permissions are requested contextually and can be enabled later through settings where supported.

### FD-095 — Household Soft Deletion
Household deletion is a soft-deletion process initiated by the Owner. A 30-day recovery period is provided. The Owner can cancel deletion during that period. Permanent deletion occurs after the recovery period and must handle shared data and historical references safely.

---

## 3. Change Control

1. All decisions above are approved.
2. They must not be silently changed during implementation.
3. A proposed change must identify the affected FD identifier.
4. Its reason, impact, dependencies, and affected tests must be documented.
5. The change requires explicit approval before implementation.
6. If two decisions appear to conflict, report the conflict and request a documented resolution rather than inventing a new rule.

## 4. Relationship to Other Documents

- `SPEC.md` consolidates the product requirements.
- `TECHNICAL_DECISIONS.md` defines approved technical decisions.
- `GAP_REVIEW.md` records adopted functional gap resolutions.
- `ARCHITECTURE.md` describes system boundaries and component responsibilities.
- `TEST.md` defines verification expectations.
- `IMPLEMENTATION_PLAN.md` defines implementation phases and task sequencing.

**End of Functional Decisions**

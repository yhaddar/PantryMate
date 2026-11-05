# PantryMate — Software Requirements Specification

**Document:** SPEC.md  
**Project:** PantryMate  
**Status:** Approved Requirements Baseline  
**Platforms:** Android and iOS  
**Backend:** Supabase  
**Implementation Status:** Not started

---

## 1. Purpose

PantryMate is a household inventory and shopping management application.

Its purpose is to help individuals and households manage food products, inventory quantities, expiration dates, storage locations, shopping lists, and shared household activities.

The application must provide reliable shared data across multiple users and devices while remaining usable when the device is offline.

This document defines the consolidated requirements baseline. Detailed approved decisions are maintained in:

- `FUNCTIONAL_DECISIONS.md`
- `TECHNICAL_DECISIONS.md`
- `GAP_REVIEW.md`

These documents must be read together. This specification does not replace their detailed decision records.

## 2. Product Scope

### 2.1 In Scope

The first release includes:

1. Account registration and authentication.
2. Household creation, joining, switching, and management.
3. Household invitations and membership management.
4. Role-based permissions.
5. Product catalog management.
6. Inventory batch management.
7. Storage locations.
8. Expiration-date tracking.
9. Low-stock monitoring.
10. Barcode scanning and external product lookup.
11. Product images.
12. Shared shopping lists.
13. Shopping history.
14. Inventory activity and immutable history.
15. Offline-first operation and synchronization.
16. Local and push notifications.
17. Dashboard and reports.
18. CSV import/export and PDF reports.
19. User profile and preferences.
20. Data export, account deletion, and household deletion/recovery.
21. Accessibility, performance, privacy, and security requirements.

### 2.2 Out of Scope

The first release does not include:

- Web or Desktop applications.
- Automatic unit conversion between incompatible units.
- A public social network or public household directory.
- Unrestricted access to another household's data.
- An assumption that push notifications are guaranteed to reach a device.
- Automatic permanent deletion of archived inventory according to an arbitrary fixed retention period.

Any scope expansion requires an explicit change proposal.

## 3. Target Platforms

- Android
- iOS

The mobile application must adapt to supported screen sizes and platform capabilities.

Platform-specific permissions and background execution restrictions must be respected.

## 4. Users and Roles

### 4.1 Account

A user has one account and may belong to multiple households.

The user can switch between households and has a separate role in each household.

### 4.2 Household Roles

The application supports:

- **Owner**
- **Admin**
- **Member**

Each role has defined permissions for inventory, shopping lists, membership, invitations, and household settings.

Permissions must be enforced by the backend and database, not only by hiding UI controls.

The complete approved permission model is documented in `FUNCTIONAL_DECISIONS.md`.

## 5. Functional Requirements

### 5.1 Authentication and Profile

The application must support:

- Email/password authentication.
- Google authentication.
- Apple authentication.
- Secure session management.
- Password recovery.
- Profile name and photo management.
- Account security and logout.
- Personal notification preferences.
- Account data export and deletion.

Account deletion must respect shared household data and historical attribution requirements.

### 5.2 Household Management

Users must be able to:

- Create a household.
- Join through a valid invitation.
- Belong to multiple households.
- Switch active households.
- View household members and roles.
- Manage invitations according to permissions.
- Manage household settings according to ownership permissions.
- Leave a household where permitted.
- Transfer ownership before an Owner leaves.
- Request household deletion and recover it during the approved recovery period.

Household deletion follows the approved 30-day recovery process.

### 5.3 Invitations

Invitations must:

- Be associated with a household and assigned role.
- Use secure, single-use tokens.
- Expire after seven days.
- Support cancellation and resend.
- Require an authenticated user for acceptance.
- Be validated atomically before membership is created.
- Become invalid after acceptance, cancellation, or replacement through resend.

Invitation permissions depend on the inviter's role.

### 5.4 Product Catalog

Each household has a shared product catalog.

Products contain product-level information, including:

- Name.
- Category.
- Base inventory unit.
- Optional barcode.
- Optional brand.
- Optional description.
- Optional image.
- Optional notes.

The approved product model and required fields must follow the detailed decision records. Optional metadata must not be treated as mandatory.

A product can have multiple inventory batches.

Product-level information is distinct from batch-level information.

### 5.5 Inventory Batches

Each batch belongs to a product and contains its own:

- Quantity.
- Unit, consistent with the product's base inventory unit.
- Storage location.
- Optional expiration date.
- Creation and update information.
- Optional notes.

The application must support:

- Adding batches.
- Editing batch details.
- Consuming quantities.
- Manual quantity adjustments.
- Moving batches between storage locations.
- Archiving and restoring supported records.
- Viewing inventory history.

Quantity must never become negative.

Inventory changes must generate immutable events.

### 5.6 Units and Quantities

The application supports standard units and household-scoped custom units.

Each product has one base inventory unit. Its batches use that base unit.

Automatic conversion between different units is not assumed or performed.

Quantity precision must respect the unit's configured precision.

The detailed unit rules are defined in `TECHNICAL_DECISIONS.md`.

### 5.7 Storage Locations

Households have predefined storage locations and may create custom locations.

Users can move inventory between locations.

A location cannot be permanently deleted while dependent inventory remains assigned to it.

The application must preserve location-related history.

### 5.8 Expiration Tracking

The application must:

- Track batch expiration dates.
- Distinguish expired, expiring-soon, and non-expiring batches.
- Keep expired inventory visible.
- Notify users according to their preferences.
- Support configurable reminder timing.
- Use a default reminder three days before expiration.
- Use 09:00 local time as the default reminder time.
- Support one-day snoozing.
- Respect quiet hours and timezone changes.

Expiration dates are date-only values, not timestamps.

### 5.9 Low-Stock Monitoring

Each product can have a configurable low-stock threshold.

The default threshold is one unit.

Low-stock status is evaluated using the approved available-quantity rules.

The application must avoid repeated notifications while the product remains continuously in low-stock status.

A new notification may occur when stock recovers and later enters low-stock status again.

### 5.10 Barcode Scanning

The application must support barcode scanning on Android and iOS.

Open Food Facts is the preferred external product lookup source.

Users must be able to review and edit returned data before saving.

Manual product entry must remain available when:

- No product is found.
- The external API is unavailable.
- A request is rate-limited.
- Returned data is incomplete or invalid.

External API failure must not prevent inventory management.

### 5.11 Product Images

Users may select or capture product images.

The application must support:

- Image preview.
- Image validation.
- Compression and resizing.
- Private remote storage.
- Local caching.
- Offline upload queuing.
- Cleanup of orphaned or deleted image objects.

Camera and gallery permissions must be requested contextually.

### 5.12 Shopping Lists

Households can maintain multiple shared shopping lists.

Users with appropriate household access can:

- Create lists.
- Rename lists.
- Archive and restore lists.
- Select a default list.
- Add, edit, remove, and purchase items.
- Search and group items.
- Set item priority.
- Add optional notes.

Duplicate entries are merged only when they refer to the same product and unit. Quantities are summed.

Different units remain separate entries.

Free-text shopping items are supported.

### 5.13 Shopping and Inventory Integration

When a shopping item is marked as purchased:

- The user can confirm or adjust the purchased quantity.
- The user can select the applicable unit and storage location.
- The purchase is recorded in shopping history.
- Inventory is updated according to the approved purchase workflow.
- The operation must be atomic and idempotent.

A purchase must not be applied twice because of retries or repeated requests.

### 5.14 Inventory Consumption and Adjustments

Users can consume stock through quantity adjustment or a dedicated consumption action.

The default consumption strategy is FEFO (First Expired, First Out).

Users may manually select batches.

Manual adjustments must record a reason, such as:

- Correction.
- Damaged.
- Lost.
- Found.
- Other.

Undo is available only for eligible operations within the approved time window and must create a reversal event rather than deleting history.

### 5.15 History and Activity

The application maintains:

- Immutable inventory events.
- Shopping history.
- Household activity events.
- Membership and invitation activity where applicable.

History must preserve actor attribution and timestamps according to the approved privacy and account-deletion rules.

The UI must distinguish archived records from permanently deleted records.

### 5.16 Search and Filtering

Search must support the active household and authorized data only.

Inventory search includes product name and barcode.

Filters include category, location, expiration, and low-stock status.

Shopping lists and other supported records must provide appropriate search and filtering.

Archived records must follow the approved search visibility rules.

### 5.17 Dashboard and Reports

The dashboard includes relevant summaries such as:

- Active inventory.
- Low-stock products.
- Expiring-soon batches.
- Expired batches.
- Shopping progress.
- Recent household activity.

Users can personalize dashboard widget visibility and order.

Reports include consumption, waste, inventory changes, shopping history, and monthly summaries.

Reports must respect data access and historical snapshot rules.

### 5.18 Import and Export

The application supports:

- CSV inventory import.
- CSV inventory export.
- Shopping history export.
- PDF summary reports.

CSV import must validate data and provide a preview of errors before applying changes.

Import/export operations must respect permissions, offline limitations, and household lifecycle restrictions.

### 5.19 Notifications

The application supports local and push notifications for relevant categories, including:

- Expiration reminders.
- Low-stock alerts.
- Invitations.
- Shopping activity.
- Other approved household events.

Notification preferences are user-specific and enabled by default, subject to OS permission.

Notifications must support:

- Quiet hours.
- Snoozing where applicable.
- Deep links.
- Duplicate prevention.
- Delivery status and retry handling.

Push notification delivery is not guaranteed.

### 5.20 Offline Operation

The application must support local-first usage.

Users must be able to access cached household data and perform supported operations while offline.

Offline changes must be stored locally and queued for synchronization.

The UI must clearly distinguish:

- Local changes.
- Pending synchronization.
- Successful synchronization.
- Failed synchronization.

The application must not falsely report an offline change as remotely synchronized.

Operations belonging to a removed member or invalid session must not be synchronized without renewed authorization.

### 5.21 Settings and Onboarding

Onboarding includes:

- Welcome.
- Authentication.
- Household creation or joining.
- Notification preference configuration.
- Brief inventory and shopping-list introduction.

The application must provide:

- Profile settings.
- Household settings.
- Notification preferences.
- Theme selection.
- Account security settings.
- Help and feedback.
- Privacy policy and terms.
- Data export and account deletion.

Permissions must be requested only when the relevant feature is used.

### 5.22 Accessibility and UX

The application must provide:

- Screen-reader labels.
- Dynamic text scaling.
- Appropriate contrast.
- Accessible touch targets.
- Loading states.
- Empty states.
- Error states.
- Offline states.
- Retry actions.
- Success feedback.

The interface must remain usable when optional permissions are denied.

## 6. Non-Functional Requirements

### 6.1 Security

- Enforce household isolation.
- Enforce role-based access at backend/database level.
- Use PostgreSQL RLS for protected data.
- Validate sensitive operations server-side.
- Use secure session storage.
- Never embed service-role credentials or private server secrets in the mobile application.
- Protect file uploads and storage access.
- Avoid exposing sensitive data in logs or notifications.

### 6.2 Data Integrity

- Inventory quantities cannot become negative.
- Sensitive stock operations must be atomic.
- Inventory history is append-only.
- Critical operations must be idempotent.
- Database constraints must protect relationships and uniqueness.
- Migrations must be versioned and tested.

### 6.3 Reliability

- Offline operations must survive application restarts.
- Synchronization must support retries and duplicate prevention.
- Realtime events are not a replacement for synchronization.
- Failed operations must remain observable and recoverable where possible.
- Data deletion and recovery must follow explicit lifecycle rules.

### 6.4 Performance

The application must use:

- Pagination.
- Lazy loading.
- Image caching.
- Appropriate database indexes.
- Optimized queries.
- Efficient synchronization.
- Performance monitoring.

Exact numerical performance targets must be established and verified during implementation planning.

### 6.5 Compatibility

- Support Android and iOS.
- Define minimum supported OS versions before release.
- Maintain database migration compatibility.
- Handle application updates with pending local operations.
- Use store-managed application updates.

### 6.6 Observability

The system must support:

- Structured logging.
- Crash reporting.
- Runtime error monitoring.
- API and synchronization error monitoring.
- Performance monitoring.

Logs and monitoring events must not expose unnecessary personal or sensitive information.

## 7. Technical Architecture Constraints

The approved architecture uses:

- Flutter and Dart.
- Feature-first organization.
- Practical Clean Architecture.
- Riverpod.
- go_router.
- Drift and SQLite for local persistence.
- Supabase PostgreSQL for remote persistence.
- Repository Pattern.
- Outbox-based synchronization.
- Supabase Auth and RLS.
- Supabase Realtime for change notifications.
- Edge Functions and Cron for backend jobs.
- FCM and APNs for push notifications.

The local database is not a replacement for the remote source of truth or a backup service.

The backend remains authoritative for shared data, authorization, and sensitive operations.

Detailed architecture constraints are maintained in `TECHNICAL_DECISIONS.md` and `ARCHITECTURE.md`.

## 8. Data and Lifecycle Rules

The application must distinguish:

- Product catalog records.
- Inventory batches.
- Inventory events.
- Shopping list items.
- Shopping history.
- Household activity.
- Notifications and delivery attempts.
- User profiles and household memberships.

Archive, restore, soft deletion, permanent deletion, account deletion, and household deletion must follow their respective approved workflows.

Historical records must not be silently rewritten or deleted through ordinary application operations.

## 9. Testing Requirements

The application must include:

- Unit tests.
- Widget tests.
- Integration tests.
- End-to-end tests for critical journeys.
- Offline and synchronization tests.
- Concurrency and idempotency tests.
- RLS and authorization tests.
- Database constraint and migration tests.
- Accessibility checks.
- Static analysis and formatting checks.

The detailed testing strategy is defined in `TEST.md`.

## 10. Delivery and Development Rules

- Work must be divided into small implementation tasks.
- Each task must have dependencies and acceptance criteria.
- Each task must define relevant tests.
- Use isolated branches or worktrees where appropriate.
- Do not silently modify approved architecture or requirements.
- Do not automatically push or merge.
- The user reviews and approves commits and merges.
- Protect the `main` branch.
- Run required verification before declaring work complete.

## 11. Requirements Governance

The approved baseline consists of:

- Functional Decisions: FD-001 through FD-095.
- Technical Decisions: TD-001 through TD-091.
- Adopted Functional Gap Resolutions: Gap-001 through Gap-130.

No additional decision ID may be invented or presented as approved.

A change to an approved decision requires:

1. Identification of the affected decision.
2. Description of the proposed change.
3. Reason and impact analysis.
4. Identification of affected requirements and tests.
5. Explicit approval before implementation.

Unresolved implementation details must be documented as open items or implementation-time verification tasks.

## 12. Implementation Readiness

The existence of this specification does not prove that the repository, database, backend, application, or integrations have been implemented or tested.

Before implementation:

1. Complete the documentation set.
2. Perform a read-only documentation and repository audit.
3. Resolve contradictions and missing requirements.
4. Validate implementation-time external constraints.
5. Produce and approve the implementation plan.
6. Establish the testing and CI environment.

Implementation must not begin until these steps are completed and approved.

---

**End of Specification**

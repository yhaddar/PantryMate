# PantryMate

PantryMate is a Flutter mobile application for shared household food inventory.
It manages products, inventory batches, expiration dates, shopping lists,
reports, and offline changes that synchronize when a connection is available.
The first release targets Android and iOS.

## Status

The application is under active implementation on `implementation/pantry-mate`.
The Flutter project has local business-rule, widget, import, synchronization,
export, and image tests. Supabase schema, RLS policies, and RPC functions are
versioned in `supabase/migrations`.

This is not release-ready. Hosted Supabase/RLS, OAuth, push delivery,
physical-device behavior, end-to-end flows, and release signing require their
own test environments. [EXECUTION_TRACKER.md](EXECUTION_TRACKER.md) is the
authoritative evidence and blocker record.

## Implemented features

- Auth boundary, household selection/creation models, and role rules.
- Product catalog, duplicate detection, barcode lookup boundary, images,
  favorites, and recently used products.
- Local-first inventory batches, CSV preview/import, CSV export, PDF reports,
  and an outbox for pending changes.
- Shared-shopping repository boundary and atomic purchase RPC contract.
- Dashboard summaries, activity-feed boundary, notification preferences,
  themes, resumable onboarding, feedback, and biometric app lock.

## Architecture

```text
Flutter UI (Material 3 + Riverpod + go_router)
                 |
Feature repositories and domain rules
                 |
Local Drift/SQLite cache + Outbox <--> Supabase
                                  |- Auth
                                  |- PostgreSQL + RLS + RPC
                                  |- Storage
                                  `- Realtime / scheduled jobs
```

The project follows feature-first practical Clean Architecture. UI never reaches
Drift or Supabase directly; repositories isolate data access. Local changes use
an outbox with retries, idempotency identifiers, and visible pending/failed
states. RLS and RPC functions, not hidden controls, enforce authorization.

See [ARCHITECTURE.md](ARCHITECTURE.md),
[TECHNICAL_DECISIONS.md](TECHNICAL_DECISIONS.md), and
[FUNCTIONAL_DECISIONS.md](FUNCTIONAL_DECISIONS.md) for approved details.

## UI and colors

PantryMate uses Material 3 with pantry green `#2F6F4E` as its seed color.
It supports System, Light, and Dark modes, a mobile-first card dashboard, and
RTL-ready layout conventions. Connected screens provide loading, empty, error,
offline, and pending-sync states where applicable.

## Run locally

Prerequisites: Flutter `3.41.9`, Dart `3.11.5`, Docker Desktop, Supabase CLI,
Android SDK and/or Xcode.

```sh
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-publishable-or-anon-key
```

For a local Supabase stack:

```sh
supabase start
supabase status
supabase db reset
```

Use the URL and anon key shown by `supabase status` as the Dart defines.
`supabase db reset` recreates only the local database, applies every migration,
and loads `supabase/seed.sql`; never run it against production.

## Verification

```sh
dart format --output=show lib test
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --debug --no-codesign
```

## Guidance for agents and contributors

Read [AGENTS.md](AGENTS.md) first. Requirements, decisions, architecture, and
tests live in `SPEC.md`, `PLAN.md`, `TEST.md`, `IMPLEMENTATION.md`, and the
decision records. Work in vertical slices, preserve existing work, do not commit
credentials, and do not push without explicit approval.

# DOMIVIK — starter v0.1

Mobile-first Expo/React Native + TypeScript scaffold for iOS/Android. Visual palette: navy, black, neon lime. All nine approved functional modules are represented in navigation.

## Quick start
1. Install Node.js 20+ and run `npm install`.
2. Run `npx expo start` and open in Expo Go (if compatible with installed SDK) or build a development client.
3. Create a Supabase Free project and run `supabase/schema.sql` in its SQL Editor.
4. Copy `.env.example` to `.env` and fill with the **project URL and publishable/anon key only**. Never use a service-role secret in the mobile app.

## Current status — read carefully
- **Implemented:** branded navigation/dashboard, module routes, typed module catalog, database starter schema.
- **Not implemented:** login UI, secure session persistence, CRUD forms, photo/PDF upload, OCR, offline sync, notifications, loans calculations, family invitation flow, payments, subscription verification, analytics, tests, GDPR flows.
- The approved 3D logo is **not embedded as an asset** in this starter. A temporary text mark is shown. Add the approved exported app-icon artwork to `assets/` before release.
- **Security:** the SQL is an initial model, not production-ready. Do not enter real private financial or family documents until policies, storage rules, permissions, session persistence and audit tests are complete. In particular, member record updates require stricter column-specific policies/RPCs; do not enable shared editing yet.
- Supabase credentials in `.env` are intentionally not committed.
- Versions are starter targets; resolve compatibility with `npx expo install --fix` after install as needed.

## Roadmap
1. Auth and secure session storage; household creation and invitation acceptance.
2. Role-aware RLS, storage policies, audit logs, permission test suite.
3. Products, receipts, invoices, loans, vehicles, projects, calendar, family CRUD.
4. Photo/PDF scan, on-device OCR, configurable local notifications.
5. SQLite offline-first queue, conflict resolution, encrypted backup/export.
6. Subscription verification, family entitlements, privacy and legal compliance.
7. QA, store signing, beta and release.

## Architecture overview

FOSHA is a Flutter monorepo with three apps and one shared package.

- `apps/passenger`: passenger client
- `apps/driver`: driver client (background tracking + job flow)
- `apps/admin_web`: admin dashboard (Flutter Web)
- `packages/shared`: shared UI system + shared domain (pricing, cities, errors, widgets)

### App architecture (Clean Architecture)

Each app follows:

- `lib/src/presentation`: screens, widgets, router, Riverpod providers
- `lib/src/domain`: entities, value objects, repository interfaces, usecases
- `lib/src/data`: DTOs, mappers, Firebase/HTTP implementations

### Backend (Firebase)

- **Auth**: Phone Auth (passenger/driver), Email/Password for admin (optional) + `/admins/{uid}` gating
- **Firestore**: source of truth for users, drivers, trips, wallets, chat, SOS, config
- **Cloud Functions**: trip assignment, pricing finalization, wallet guard, payments adapters, FCM notifications
- **Storage**: driver documents, avatars

### City restriction (Upper Egypt only)

Trips must be intra-city only, restricted to:
- أسيوط
- سوهاج
- قنا

Enforced in:
- client validation (UX)
- Firestore rules (best-effort)
- Cloud Functions (authoritative)


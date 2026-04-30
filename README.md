# FOSHA (فسحة) Monorepo

Flutter monorepo containing:

- `apps/passenger`: Passenger App (فسحة للركاب)
- `apps/driver`: Driver App (فسحة للسواقين)
- `apps/admin_web`: Admin Dashboard (Flutter Web)
- `packages/shared`: Shared package (`fosha_shared`) for theme, widgets, models, and services

## Getting started

### Workspace bootstrap (Melos)

```bash
dart pub global run melos bootstrap
```

### Run an app

```bash
cd apps/passenger
flutter run
```

### Docs

- `docs/ARCHITECTURE.md`
- `docs/ENVIRONMENT.md`
- `docs/FIRESTORE_SCHEMA.md`

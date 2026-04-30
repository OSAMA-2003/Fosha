## Production hardening checklist (baseline)

### Firebase
- **Separate projects**: `fosha-dev` and `fosha-prod`
- **App Check**: enable for iOS/Android/Web (play integrity / device check / reCAPTCHA)
- **Functions**: set region, concurrency, and timeouts explicitly for critical endpoints
- **Emulators**: run in CI for rule/unit tests where possible

### Security
- Firestore rules follow least privilege (see `firebase/firestore.rules`)
- Storage rules: driver docs are private; admin review handled via server-side tooling
- Rate limiting: implement in Functions for payment endpoints + OTP workflows (abuse protection)

### Reliability
- Persist trip state in Firestore; restore on app relaunch
- Background driver tracking with watchdog + periodic reconciliation

### Observability
- Add Crash reporting (Crashlytics) + Analytics
- Add structured logs in Functions (`logger.info/error`)

### Release
- Android: signed builds + Play internal testing tracks
- iOS: TestFlight
- Web: deploy admin dashboard via Firebase Hosting or Vercel (if chosen)


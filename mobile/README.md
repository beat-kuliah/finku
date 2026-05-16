# FinKu Mobile

Flutter mobile app untuk FinKu dengan fokus MVP auth yang aman:
- Email/username + password login/register
- Google Sign-In
- Access token in-memory
- Refresh token disimpan di secure storage

## Requirements

- Flutter 3.41+
- Dart 3.11+
- Backend FinKu berjalan di lokal/remote

## Setup

1. Install dependency:

```bash
flutter pub get
```

2. Generate model code:

```bash
dart run build_runner build
```

3. Run app dengan env:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api --dart-define=GOOGLE_SERVER_CLIENT_ID=your-google-web-client-id.apps.googleusercontent.com
```

## API Base URL

`API_BASE_URL` dibaca dari compile-time env (`--dart-define`):

- Android emulator: `http://10.0.2.2:8080/api`
- iOS simulator: `http://localhost:8080/api`
- Device fisik: `http://<LAN_IP>:8080/api` (dev only)

Produksi wajib HTTPS.

## Security Notes

- Refresh token disimpan menggunakan `flutter_secure_storage`:
  - iOS: Keychain (`first_unlock_this_device`)
  - Android: storage terenkripsi bawaan plugin
- Access token tidak disimpan ke disk (hanya in-memory state).
- Refresh flow single-flight: saat 401, client melakukan satu kali refresh lalu retry request.
- Jika refresh gagal, session lokal langsung dihapus (force logout).
- Android cleartext traffic dinonaktifkan:
  - `android/app/src/main/res/xml/network_security_config.xml`
  - `android:usesCleartextTraffic="false"` di manifest
- Logging jaringan tidak mencetak request/response body di release build.

## Backend Contract (Mobile Auth)

Endpoint yang digunakan app:

- `POST /api/auth/mobile/register`
- `POST /api/auth/mobile/login`
- `POST /api/auth/mobile/oauth/google`
- `POST /api/auth/mobile/refresh`
- `POST /api/auth/mobile/logout`
- `GET /api/auth/me`

Semua endpoint mobile auth mengembalikan refresh token di JSON body (bukan cookie browser).

## Struktur Kode

Struktur utama:

- `lib/src/core/config`: env
- `lib/src/core/l10n`: locale persistence, JSON bundle loader, `context.l10n`
- `lib/src/core/network`: Dio + auth interceptor
- `lib/src/core/secure_storage`: token store
- `lib/src/core/router`: `go_router` guard auth
- `lib/src/features/auth`: data/domain/presentation auth MVP

## Internationalization (ID + EN)

UI copy lives in `assets/i18n/{id,en}/*.json`, mirrored from the web app (`frontend/src/i18n/locales`, excluding `landing.json`). Keys match the web namespaces (`auth`, `nav`, `dashboard`, etc.).

### Sync translations from web

From the repo root:

```bash
./scripts/sync-mobile-l10n.sh
```

Then run the app or tests so Flutter picks up asset changes.

### Locale behavior

- Storage key: `finku-locale` (`id` | `en`), same as web
- Default: saved value, else system language (`id*` → Indonesian, otherwise English), else `id`
- Dates: `format_dates.dart` only — do not call `DateFormat` with a hardcoded locale elsewhere

### Manual test: language picker

1. Run the app and sign in (or use an existing session).
2. Open **Profile** (More → Profile, or the profile tab).
3. Under **Language**, tap **English** — bottom nav labels should switch to English (e.g. Transactions, Wallets).
4. Confirm a snackbar shows the language-changed message.
5. Force-quit the app and reopen — language should still be English.
6. Switch back to **Indonesia** and spot-check Dashboard/Stats date formatting.

### Analyzer & tests

```bash
cd mobile && flutter analyze && flutter test
```

## Next Iterations

- Certificate pinning (`dio_certificate_pinning`)
- App lock biometrik (`local_auth`) + proteksi screenshot
- Push notifications
- Feature parity web (wallets, categories, transactions, budgets, goals, stats, profile)

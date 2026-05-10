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
- `lib/src/core/network`: Dio + auth interceptor
- `lib/src/core/secure_storage`: token store
- `lib/src/core/router`: `go_router` guard auth
- `lib/src/features/auth`: data/domain/presentation auth MVP

## Next Iterations

- Certificate pinning (`dio_certificate_pinning`)
- App lock biometrik (`local_auth`) + proteksi screenshot
- Push notifications
- Feature parity web (wallets, categories, transactions, budgets, goals, stats, profile)

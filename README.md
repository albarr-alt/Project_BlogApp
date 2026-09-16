# ATS_11 — Full Project

Folder ini menggabungkan backend dan aplikasi mobile jadi satu.

## Struktur
- `backend/` — Node.js + Express + Drizzle ORM (API server)
- `mobile/`  — Aplikasi Flutter (client)

## Menjalankan backend
```
cd backend
npm install
# lengkapi file .env (lihat .env yang kamu punya sebelumnya)
npm run dev   # atau sesuaikan dengan script di package.json
```

## Menjalankan mobile
```
cd mobile
flutter pub get
flutter run
```

Catatan: `node_modules` (backend) dan `build`/`.dart_tool` (mobile) sengaja tidak
disertakan karena otomatis dibuat ulang oleh `npm install` dan `flutter pub get`.
Kalau kamu punya file `.env` untuk backend, jangan lupa disalin manual ke folder `backend/`.

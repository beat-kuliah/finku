# FinKu — Frontend

Finansial manager kekinian buat Gen Z. Dibangun dengan React + Vite + Tailwind dengan vibe TikTok (vibrant, playful, gradient, bold).

## Stack

- React 18 + TypeScript
- Vite (dev server & bundler)
- Tailwind CSS 3 (design system + animations kustom)
- React Router v6 (routing)
- Framer Motion (animasi halus)
- Lucide React (ikon)
- Zustand (state management) — untuk nanti
- Recharts (chart) — untuk nanti

## Status

Phase 1 — UI Prototype. Saat ini sudah tersedia:

- [x] Landing page (hero, fitur, testimoni, CTA)
- [x] Login page
- [x] Register page
- [ ] Onboarding flow
- [ ] Dashboard
- [ ] Transactions, Budget, Stats, Goals, Profile

## Menjalankan

```bash
npm install
npm run dev
```

Buka `http://localhost:5173`.

## Halaman

| Route | Deskripsi |
|---|---|
| `/` | Landing page |
| `/login` | Login |
| `/register` | Register |

## Design System

- **Primary**: `electric-cyan` (`#00f0ff`)
- **Accent**: `electric-blue` (`#2563eb`), `deep-blue` (`#1d4ed8`), `sky` (`#38bdf8`)
- **Background**: `ink-900` dengan radial gradient blobs
- **Font**: Plus Jakarta Sans (heading), Inter (body)
- **Gradients**: `bg-gradient-tiktok`, `bg-gradient-neon`, `bg-gradient-cyber`, `bg-gradient-sunset`
- **Utility**: `.glass`, `.btn-primary`, `.card`, `.input`, `.chip`, `.text-gradient`

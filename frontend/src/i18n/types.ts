export type { AppLocale } from "@/lib/locale";

export const NAMESPACES = [
  "common",
  "auth",
  "landing",
  "nav",
  "dashboard",
  "stats",
  "transactions",
  "budget",
  "goals",
  "wallets",
  "profile",
] as const;

export type AppNamespace = (typeof NAMESPACES)[number];

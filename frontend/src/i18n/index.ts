import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import { applyDocumentLocale, getLocale, onLocaleChange } from "@/lib/locale";
import type { AppNamespace } from "./types";

import idCommon from "./locales/id/common.json";
import idAuth from "./locales/id/auth.json";
import idLanding from "./locales/id/landing.json";
import idNav from "./locales/id/nav.json";
import idDashboard from "./locales/id/dashboard.json";
import idStats from "./locales/id/stats.json";
import idTransactions from "./locales/id/transactions.json";
import idBudget from "./locales/id/budget.json";
import idGoals from "./locales/id/goals.json";
import idWallets from "./locales/id/wallets.json";
import idProfile from "./locales/id/profile.json";

import enCommon from "./locales/en/common.json";
import enAuth from "./locales/en/auth.json";
import enLanding from "./locales/en/landing.json";
import enNav from "./locales/en/nav.json";
import enDashboard from "./locales/en/dashboard.json";
import enStats from "./locales/en/stats.json";
import enTransactions from "./locales/en/transactions.json";
import enBudget from "./locales/en/budget.json";
import enGoals from "./locales/en/goals.json";
import enWallets from "./locales/en/wallets.json";
import enProfile from "./locales/en/profile.json";

const resources = {
  id: {
    common: idCommon,
    auth: idAuth,
    landing: idLanding,
    nav: idNav,
    dashboard: idDashboard,
    stats: idStats,
    transactions: idTransactions,
    budget: idBudget,
    goals: idGoals,
    wallets: idWallets,
    profile: idProfile,
  },
  en: {
    common: enCommon,
    auth: enAuth,
    landing: enLanding,
    nav: enNav,
    dashboard: enDashboard,
    stats: enStats,
    transactions: enTransactions,
    budget: enBudget,
    goals: enGoals,
    wallets: enWallets,
    profile: enProfile,
  },
} as const;

void i18n.use(initReactI18next).init({
  resources,
  lng: getLocale(),
  fallbackLng: "id",
  defaultNS: "common",
  ns: Object.keys(resources.id) as AppNamespace[],
  interpolation: { escapeValue: false },
});

applyDocumentLocale();

onLocaleChange(() => {
  void i18n.changeLanguage(getLocale());
  applyDocumentLocale();
});

export { onLocaleChange };
export default i18n;

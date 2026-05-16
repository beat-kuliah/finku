export const STORAGE_KEY = "finku-locale";

export type AppLocale = "id" | "en";

export const LOCALE_CHANGE_EVENT = "finku-locale-change";

const BCP47_TAGS: Record<AppLocale, string> = {
  id: "id-ID",
  en: "en-US",
};

function detectInitialLocale(): AppLocale {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved === "id" || saved === "en") {
      return saved;
    }
  } catch {
    // private browsing or blocked storage
  }

  if (typeof navigator !== "undefined") {
    if (navigator.language.toLowerCase().startsWith("id")) {
      return "id";
    }
    return "en";
  }

  return "id";
}

let currentLocale: AppLocale = detectInitialLocale();

if (typeof document !== "undefined") {
  document.documentElement.lang = currentLocale;
}

export function applyDocumentLocale(): void {
  if (typeof document !== "undefined") {
    document.documentElement.lang = getLocale();
  }
}

export function getLocale(): AppLocale {
  return currentLocale;
}

export function setLocale(locale: AppLocale): void {
  currentLocale = locale;

  try {
    localStorage.setItem(STORAGE_KEY, locale);
  } catch {
    // ignore
  }

  if (typeof document !== "undefined") {
    document.documentElement.lang = locale;
  }

  if (typeof window !== "undefined") {
    window.dispatchEvent(
      new CustomEvent(LOCALE_CHANGE_EVENT, { detail: { locale } }),
    );
  }
}

export function getBcp47Tag(): string {
  return BCP47_TAGS[currentLocale];
}

export function onLocaleChange(
  callback: (locale: AppLocale) => void,
): () => void {
  if (typeof window === "undefined") {
    return () => undefined;
  }

  const handler = (event: Event) => {
    const detail = (event as CustomEvent<{ locale: AppLocale }>).detail;
    callback(detail?.locale ?? getLocale());
  };

  window.addEventListener(LOCALE_CHANGE_EVENT, handler);
  return () => window.removeEventListener(LOCALE_CHANGE_EVENT, handler);
}

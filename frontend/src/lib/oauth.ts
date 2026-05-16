// Lightweight wrapper around Google Identity Services.
// The lib is loaded on demand from its CDN so we don't ship the SDK
// when the feature is disabled (no client ID).

import i18n from "@/i18n";

const t = (key: string, options?: Record<string, string>) =>
  i18n.t(key, { ns: "auth", ...options });

declare global {
  interface Window {
    google?: GoogleNamespace;
  }
}

type GoogleCredential = { credential: string };

type GoogleNamespace = {
  accounts: {
    id: {
      initialize: (cfg: {
        client_id: string;
        callback: (resp: GoogleCredential) => void;
        ux_mode?: "popup" | "redirect";
        auto_select?: boolean;
      }) => void;
      prompt: (
        listener?: (notification: {
          isNotDisplayed: () => boolean;
          isSkippedMoment: () => boolean;
          isDismissedMoment: () => boolean;
          getNotDisplayedReason: () => string;
          getDismissedReason: () => string;
        }) => void,
      ) => void;
      cancel: () => void;
    };
    oauth2: {
      initTokenClient: (cfg: {
        client_id: string;
        scope: string;
        callback: (resp: { access_token?: string; error?: string }) => void;
      }) => { requestAccessToken: () => void };
    };
  };
};

const GOOGLE_GIS_SRC = "https://accounts.google.com/gsi/client";

function loadScript(src: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const existing = document.querySelector(`script[src="${src}"]`) as
      | HTMLScriptElement
      | null;
    if (existing) {
      if (existing.dataset.loaded === "1") {
        resolve();
        return;
      }
      existing.addEventListener("load", () => resolve(), { once: true });
      existing.addEventListener(
        "error",
        () => reject(new Error(t("oauth.scriptFailed"))),
        { once: true },
      );
      return;
    }
    const s = document.createElement("script");
    s.src = src;
    s.async = true;
    s.defer = true;
    s.onload = () => {
      s.dataset.loaded = "1";
      resolve();
    };
    s.onerror = () => reject(new Error(t("oauth.scriptFailed")));
    document.head.appendChild(s);
  });
}

export const googleClientId = (import.meta.env.VITE_GOOGLE_CLIENT_ID ?? "") as string;

export const isGoogleEnabled = !!googleClientId;

let googleInitialized = false;
let googlePending: ((token: string) => void) | null = null;
let googleReject: ((err: Error) => void) | null = null;

async function ensureGoogle(): Promise<void> {
  if (!isGoogleEnabled) throw new Error(t("oauth.notConfigured"));
  if (window.google?.accounts?.id) {
    if (!googleInitialized) {
      window.google.accounts.id.initialize({
        client_id: googleClientId,
        callback: (resp) => {
          if (googlePending && resp.credential) {
            googlePending(resp.credential);
          } else if (googleReject) {
            googleReject(new Error(t("oauth.noCredential")));
          }
          googlePending = null;
          googleReject = null;
        },
      });
      googleInitialized = true;
    }
    return;
  }
  await loadScript(GOOGLE_GIS_SRC);
  if (!window.google?.accounts?.id) throw new Error(t("oauth.sdkLoadFailed"));
  window.google.accounts.id.initialize({
    client_id: googleClientId,
    callback: (resp) => {
      if (googlePending && resp.credential) {
        googlePending(resp.credential);
      } else if (googleReject) {
        googleReject(new Error(t("oauth.noCredential")));
      }
      googlePending = null;
      googleReject = null;
    },
  });
  googleInitialized = true;
}

/** Triggers the Google One Tap / GIS prompt; resolves with the ID token. */
export async function signInWithGoogle(): Promise<string> {
  await ensureGoogle();
  return new Promise<string>((resolve, reject) => {
    googlePending = resolve;
    googleReject = reject;
    window.google!.accounts.id.prompt((notification) => {
      if (
        notification.isNotDisplayed() ||
        notification.isSkippedMoment() ||
        notification.isDismissedMoment()
      ) {
        const reason =
          notification.getNotDisplayedReason() ??
          notification.getDismissedReason() ??
          t("oauth.cancelled");
        if (googleReject) {
          googleReject(
            new Error(t("oauth.failedWithReason", { reason })),
          );
        }
        googlePending = null;
        googleReject = null;
      }
    });
  });
}

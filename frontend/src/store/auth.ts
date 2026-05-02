import { create } from "zustand";
import { apiJson, apiUrl, bindOnRefreshed, bindTokenGetter } from "@/lib/api";

export type AuthUser = {
  id: string;
  email: string;
  name: string;
  username: string | null;
  hasPassword: boolean;
  providers: string[];
  monthlyIncome?: number | null;
  payday?: number | null;
  currency: string;
  createdAt: string;
  updatedAt: string;
};

export type AuthStatus = "idle" | "loading" | "ready" | "unauthenticated";

type UpdatePasswordInput = {
  currentPassword?: string;
  newPassword: string;
  confirmNewPassword: string;
};

type AuthState = {
  user: AuthUser | null;
  accessToken: string | null;
  status: AuthStatus;
  setAccessToken: (t: string | null) => void;
  bootstrap: () => Promise<void>;
  login: (identifier: string, password: string) => Promise<void>;
  loginWithGoogle: (idToken: string) => Promise<void>;
  register: (
    name: string,
    username: string,
    email: string,
    password: string,
  ) => Promise<void>;
  logout: () => Promise<void>;
  setUsername: (username: string) => Promise<AuthUser>;
  updatePassword: (input: UpdatePasswordInput) => Promise<AuthUser>;
  fetchUsernameSuggestion: () => Promise<string>;
  unlinkProvider: (provider: string) => Promise<AuthUser>;
  patchProfile: (body: {
    monthlyIncome?: number | null;
    payday?: number | null;
    currency?: string;
  }) => Promise<AuthUser>;
};

export class AuthApiError extends Error {
  status: number;
  code?: string;
  constructor(message: string, status: number, code?: string) {
    super(message);
    this.name = "AuthApiError";
    this.status = status;
    this.code = code;
  }
}

type ApiErrorBody = {
  error?: { code?: string; message?: string };
};

async function readError(res: Response, fallback: string): Promise<AuthApiError> {
  const body = (await res.json().catch(() => ({}))) as ApiErrorBody;
  return new AuthApiError(body.error?.message ?? fallback, res.status, body.error?.code);
}

export const useAuth = create<AuthState>((set, get) => ({
  user: null,
  accessToken: null,
  status: "idle",

  setAccessToken: (t) => set({ accessToken: t }),

  bootstrap: async () => {
    set({ status: "loading" });
    try {
      const res = await fetch(apiUrl("/auth/refresh"), {
        method: "POST",
        credentials: "include",
      });
      if (!res.ok) {
        set({ user: null, accessToken: null, status: "unauthenticated" });
        return;
      }
      const body = (await res.json()) as { accessToken?: string };
      if (!body.accessToken) {
        set({ user: null, accessToken: null, status: "unauthenticated" });
        return;
      }
      set({ accessToken: body.accessToken });
      const me = await fetch(apiUrl("/auth/me"), {
        headers: { Authorization: `Bearer ${body.accessToken}` },
        credentials: "include",
      });
      if (!me.ok) {
        set({ user: null, accessToken: null, status: "unauthenticated" });
        return;
      }
      const meData = (await me.json()) as { user: AuthUser };
      set({ user: meData.user, status: "ready" });
    } catch {
      set({ user: null, accessToken: null, status: "unauthenticated" });
    }
  },

  login: async (identifier, password) => {
    const res = await fetch(apiUrl("/auth/login"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ identifier, password }),
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Login gagal");
    const data = (await res.json()) as { accessToken?: string; user?: AuthUser };
    if (!data.accessToken || !data.user) {
      throw new AuthApiError("Invalid response", res.status);
    }
    set({ accessToken: data.accessToken, user: data.user, status: "ready" });
  },

  loginWithGoogle: async (idToken) => {
    const res = await fetch(apiUrl("/auth/oauth/google"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idToken }),
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Login Google gagal");
    const data = (await res.json()) as { accessToken?: string; user?: AuthUser };
    if (!data.accessToken || !data.user) {
      throw new AuthApiError("Invalid response", res.status);
    }
    set({ accessToken: data.accessToken, user: data.user, status: "ready" });
  },

  register: async (name, username, email, password) => {
    const res = await fetch(apiUrl("/auth/register"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, username, email, password }),
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Pendaftaran gagal");
    const data = (await res.json()) as { accessToken?: string; user?: AuthUser };
    if (!data.accessToken || !data.user) {
      throw new AuthApiError("Invalid response", res.status);
    }
    set({ accessToken: data.accessToken, user: data.user, status: "ready" });
  },

  logout: async () => {
    const t = get().accessToken;
    if (t) {
      try {
        await fetch(apiUrl("/auth/logout"), {
          method: "POST",
          headers: { Authorization: `Bearer ${t}` },
          credentials: "include",
        });
      } catch {
        /* ignore */
      }
    }
    set({ user: null, accessToken: null, status: "unauthenticated" });
  },

  setUsername: async (username) => {
    const t = get().accessToken;
    const res = await fetch(apiUrl("/auth/username"), {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        ...(t ? { Authorization: `Bearer ${t}` } : {}),
      },
      body: JSON.stringify({ username }),
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Gagal menyimpan username");
    const data = (await res.json()) as { user: AuthUser };
    set({ user: data.user });
    return data.user;
  },

  updatePassword: async (input) => {
    const t = get().accessToken;
    const res = await fetch(apiUrl("/auth/password"), {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        ...(t ? { Authorization: `Bearer ${t}` } : {}),
      },
      body: JSON.stringify(input),
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Gagal menyimpan password");
    const data = (await res.json()) as { user: AuthUser };
    set({ user: data.user });
    return data.user;
  },

  fetchUsernameSuggestion: async () => {
    const t = get().accessToken;
    const res = await fetch(apiUrl("/auth/username/suggest"), {
      headers: t ? { Authorization: `Bearer ${t}` } : {},
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Gagal mengambil saran username");
    const data = (await res.json()) as { suggestion: string };
    return data.suggestion;
  },

  unlinkProvider: async (provider) => {
    const t = get().accessToken;
    const res = await fetch(apiUrl(`/auth/identities/${encodeURIComponent(provider)}`), {
      method: "DELETE",
      headers: t ? { Authorization: `Bearer ${t}` } : {},
      credentials: "include",
    });
    if (!res.ok) throw await readError(res, "Gagal melepas akun");
    const data = (await res.json()) as { user: AuthUser };
    set({ user: data.user });
    return data.user;
  },

  patchProfile: async (body) => {
    const data = await apiJson<{ user: AuthUser }>(`/auth/profile`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    set({ user: data.user });
    return data.user;
  },
}));

bindTokenGetter(() => useAuth.getState().accessToken);
bindOnRefreshed((token) => useAuth.setState({ accessToken: token }));

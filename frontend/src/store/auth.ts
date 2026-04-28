import { create } from "zustand";
import { apiUrl, bindOnRefreshed, bindTokenGetter } from "@/lib/api";

export type AuthUser = {
  id: string;
  email: string;
  name: string;
  monthlyIncome?: number | null;
  payday?: number | null;
  currency: string;
  createdAt: string;
  updatedAt: string;
};

export type AuthStatus = "idle" | "loading" | "ready" | "unauthenticated";

type AuthState = {
  user: AuthUser | null;
  accessToken: string | null;
  status: AuthStatus;
  setAccessToken: (t: string | null) => void;
  bootstrap: () => Promise<void>;
  login: (email: string, password: string) => Promise<void>;
  register: (name: string, email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
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

  login: async (email, password) => {
    const res = await fetch(apiUrl("/auth/login"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
      credentials: "include",
    });
    const data = (await res.json().catch(() => ({}))) as {
      error?: { code?: string; message?: string };
      accessToken?: string;
      user?: AuthUser;
    };
    if (!res.ok) {
      const msg = data.error?.message ?? "Login failed";
      const code = data.error?.code;
      throw new AuthApiError(msg, res.status, code);
    }
    if (!data.accessToken || !data.user) {
      throw new AuthApiError("Invalid response", res.status);
    }
    set({ accessToken: data.accessToken, user: data.user, status: "ready" });
  },

  register: async (name, email, password) => {
    const res = await fetch(apiUrl("/auth/register"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, email, password }),
      credentials: "include",
    });
    const data = (await res.json().catch(() => ({}))) as {
      error?: { code?: string; message?: string };
      accessToken?: string;
      user?: AuthUser;
    };
    if (!res.ok) {
      const msg = data.error?.message ?? "Registration failed";
      const code = data.error?.code;
      throw new AuthApiError(msg, res.status, code);
    }
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
}));

bindTokenGetter(() => useAuth.getState().accessToken);
bindOnRefreshed((token) => useAuth.setState({ accessToken: token }));

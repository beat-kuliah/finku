/** API base path (Vite default: `/api` proxied to backend). */
export function apiUrl(path: string): string {
  const base = (import.meta.env.VITE_API_URL as string | undefined) ?? "/api";
  const p = path.startsWith("/") ? path : `/${path}`;
  if (base.endsWith("/")) return `${base.slice(0, -1)}${p}`;
  return `${base}${p}`;
}

let tokenGetter: () => string | null = () => null;

export function bindTokenGetter(fn: () => string | null): void {
  tokenGetter = fn;
}

let onRefreshed: (token: string) => void = () => {};

export function bindOnRefreshed(fn: (token: string) => void): void {
  onRefreshed = fn;
}

let refreshPromise: Promise<boolean> | null = null;

async function postRefresh(): Promise<boolean> {
  if (refreshPromise) return refreshPromise;
  refreshPromise = (async () => {
    try {
      const res = await fetch(apiUrl("/auth/refresh"), {
        method: "POST",
        credentials: "include",
      });
      if (!res.ok) return false;
      const data = (await res.json()) as { accessToken?: string };
      if (!data.accessToken) return false;
      onRefreshed(data.accessToken);
      return true;
    } catch {
      return false;
    } finally {
      refreshPromise = null;
    }
  })();
  return refreshPromise;
}

/**
 * Fetch against API with Bearer token and cookies. On 401 (except auth paths), tries refresh once then retries.
 */
export async function apiFetch(path: string, init: RequestInit = {}): Promise<Response> {
  const url = apiUrl(path);
  const headers = new Headers(init.headers);
  const t = tokenGetter();
  if (t) headers.set("Authorization", `Bearer ${t}`);

  const skipRefresh =
    path.includes("/auth/refresh") ||
    path.includes("/auth/login") ||
    path.includes("/auth/register") ||
    path.includes("/auth/oauth/google");

  const doFetch = () =>
    fetch(url, {
      ...init,
      headers,
      credentials: "include",
    });

  let res = await doFetch();
  if (res.status === 401 && !skipRefresh) {
    const ok = await postRefresh();
    if (ok) {
      const h2 = new Headers(init.headers);
      const t2 = tokenGetter();
      if (t2) h2.set("Authorization", `Bearer ${t2}`);
      res = await fetch(url, { ...init, headers: h2, credentials: "include" });
    }
  }
  return res;
}

export class ApiError extends Error {
  status: number;
  code?: string;
  constructor(message: string, status: number, code?: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
  }
}

type ApiErrBody = { error?: { code?: string; message?: string } };

export async function readApiError(res: Response): Promise<ApiError> {
  const body = (await res.json().catch(() => ({}))) as ApiErrBody;
  return new ApiError(body.error?.message ?? "Request failed", res.status, body.error?.code);
}

export async function apiJson<T>(path: string, init: RequestInit = {}): Promise<T> {
  const res = await apiFetch(path, init);
  if (!res.ok) throw await readApiError(res);
  return (await res.json()) as T;
}

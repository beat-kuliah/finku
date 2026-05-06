import { apiFetch, apiJson, readApiError } from "@/lib/api";

export type Budget = {
  id: string;
  categoryId: string;
  categoryName?: string;
  limitAmount: number;
  spent: number;
  periodAnchor: string;
  paused: boolean;
  pausedAt?: string;
};

export async function listBudgets(from?: string, to?: string) {
  const sp = new URLSearchParams();
  if (from) sp.set("from", from);
  if (to) sp.set("to", to);
  const q = sp.toString();
  return apiJson<{ budgets: Budget[] }>(`/budgets${q ? `?${q}` : ""}`);
}

export async function createBudget(body: {
  categoryId: string;
  period?: string;
  periodAnchor: string;
  limitAmount: number;
}) {
  return apiJson<{ budget: Budget }>(`/budgets`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateBudget(id: string, limitAmount: number) {
  return apiJson<{ budget: Budget }>(`/budgets/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ limitAmount }),
  });
}

export async function deleteBudget(id: string) {
  const res = await apiFetch(`/budgets/${id}`, { method: "DELETE" });
  if (!res.ok) throw await readApiError(res);
}

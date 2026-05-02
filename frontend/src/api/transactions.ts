import { apiFetch, apiJson, readApiError } from "@/lib/api";

export type Transaction = {
  id: string;
  userId: string;
  kind: "income" | "expense" | "transfer";
  walletId: string;
  destWalletId?: string;
  categoryId?: string;
  categoryName?: string;
  amount: number;
  occurredAt: string;
  description?: string;
  createdAt: string;
  updatedAt: string;
};

export type ListTxParams = {
  from?: string;
  to?: string;
  kind?: string;
  walletId?: string;
  categoryId?: string;
  q?: string;
};

export async function listTransactions(params?: ListTxParams) {
  const sp = new URLSearchParams();
  if (params?.from) sp.set("from", params.from);
  if (params?.to) sp.set("to", params.to);
  if (params?.kind) sp.set("kind", params.kind);
  if (params?.walletId) sp.set("walletId", params.walletId);
  if (params?.categoryId) sp.set("categoryId", params.categoryId);
  if (params?.q) sp.set("q", params.q);
  const q = sp.toString();
  return apiJson<{ transactions: Transaction[] }>(`/transactions${q ? `?${q}` : ""}`);
}

export async function createTransaction(body: {
  kind: string;
  walletId: string;
  destWalletId?: string;
  categoryId?: string;
  amount: number;
  occurredAt: string;
  description?: string;
}) {
  return apiJson<{ transaction: Transaction }>(`/transactions`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateTransaction(
  id: string,
  body: {
    kind: string;
    walletId: string;
    destWalletId?: string;
    categoryId?: string;
    amount: number;
    occurredAt: string;
    description?: string;
  },
) {
  return apiJson<{ transaction: Transaction }>(`/transactions/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function deleteTransaction(id: string) {
  const res = await apiFetch(`/transactions/${id}`, { method: "DELETE" });
  if (!res.ok) throw await readApiError(res);
}

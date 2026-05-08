import { apiFetch, apiJson, readApiError } from "@/lib/api";

export type WalletGroup = {
  id: string;
  userId: string;
  name: string;
  icon?: string;
  walletCount: number;
  totalBalance: number;
  createdAt: string;
  updatedAt: string;
};

export async function listWalletGroups() {
  return apiJson<{ groups: WalletGroup[] }>(`/wallet-groups`);
}

export async function createWalletGroup(body: { name: string; icon?: string }) {
  return apiJson<{ group: WalletGroup }>(`/wallet-groups`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateWalletGroup(id: string, body: { name: string; icon?: string }) {
  return apiJson<{ group: WalletGroup }>(`/wallet-groups/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function deleteWalletGroup(id: string) {
  const res = await apiFetch(`/wallet-groups/${id}`, { method: "DELETE" });
  if (!res.ok) throw await readApiError(res);
}

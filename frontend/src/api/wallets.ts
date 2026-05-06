import { apiJson } from "@/lib/api";

export type Wallet = {
  id: string;
  userId: string;
  name: string;
  walletType: string;
  icon?: string;
  balance: number;
  archivedAt?: string;
  createdAt: string;
  updatedAt: string;
};

export async function listWallets(archived = false) {
  const q = archived ? "?archived=1" : "";
  return apiJson<{ wallets: Wallet[] }>(`/wallets${q}`);
}

export async function createWallet(body: { name: string; walletType?: string; icon?: string }) {
  return apiJson<{ wallet: Wallet }>(`/wallets`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateWallet(id: string, body: { name: string; walletType?: string; icon?: string }) {
  return apiJson<{ wallet: Wallet }>(`/wallets/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function archiveWallet(id: string) {
  return apiJson<{ wallet: Wallet }>(`/wallets/${id}`, { method: "DELETE" });
}

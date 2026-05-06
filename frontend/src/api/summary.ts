import { apiJson } from "@/lib/api";

export type DashboardPayload = {
  totalBalance: number;
  periodIncome: number;
  periodExpense: number;
  periodFrom: string;
  periodTo: string;
  dailyTrend: Array<{ date: string; income: number; expense: number }>;
  categoryBreakdown: Array<{ categoryId: string; name: string; value: number; archived: boolean }>;
  budgets: Array<{
    id: string;
    categoryId: string;
    categoryName?: string;
    limitAmount: number;
    spent: number;
    periodAnchor: string;
    paused: boolean;
  }>;
  latestTransactions: Array<{
    id: string;
    kind: string;
    amount: number;
    occurredAt: string;
    description: string;
    category: string;
  }>;
};

export async function fetchDashboard(from?: string, to?: string) {
  const sp = new URLSearchParams();
  if (from) sp.set("from", from);
  if (to) sp.set("to", to);
  const q = sp.toString();
  return apiJson<DashboardPayload>(`/summary/dashboard${q ? `?${q}` : ""}`);
}

export type StatsPayload = {
  periodFrom: string;
  periodTo: string;
  totalIncome: number;
  totalExpense: number;
  categoryBreakdown: Array<{ name: string; value: number; archived: boolean }>;
  weeklyExpense: Array<{ week: string; total: number }>;
};

export async function fetchStats(from?: string, to?: string) {
  const sp = new URLSearchParams();
  if (from) sp.set("from", from);
  if (to) sp.set("to", to);
  const q = sp.toString();
  return apiJson<StatsPayload>(`/summary/stats${q ? `?${q}` : ""}`);
}

import { apiFetch, apiJson, readApiError } from "@/lib/api";

export type Goal = {
  id: string;
  userId: string;
  name: string;
  targetAmount: number;
  currentAmount: number;
  deadline?: string;
  progressPct?: number;
  createdAt: string;
  updatedAt: string;
};

export async function listGoals() {
  return apiJson<{ goals: Goal[] }>(`/goals`);
}

export async function createGoal(body: { name: string; targetAmount: number; deadline?: string }) {
  return apiJson<{ goal: Goal }>(`/goals`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateGoal(id: string, body: { name: string; targetAmount: number; deadline?: string }) {
  return apiJson<{ goal: Goal }>(`/goals/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function contributeGoal(id: string, amount: number) {
  return apiJson<{ goal: Goal }>(`/goals/${id}/contribute`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ amount }),
  });
}

export async function deleteGoal(id: string) {
  const res = await apiFetch(`/goals/${id}`, { method: "DELETE" });
  if (!res.ok) throw await readApiError(res);
}

import { apiJson } from "@/lib/api";

export type Preferences = {
  notifyBudgetWarning: boolean;
  notifyReminder: boolean;
  notifyWeeklyReport: boolean;
  theme: string;
  updatedAt?: string;
};

export async function getPreferences() {
  return apiJson<{ preferences: Preferences }>(`/preferences`);
}

export async function patchPreferences(body: Partial<Preferences>) {
  return apiJson<{ preferences: Preferences }>(`/preferences`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

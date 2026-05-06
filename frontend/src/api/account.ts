import { apiFetch, readApiError } from "@/lib/api";

export async function resetFinancialData() {
  const res = await apiFetch(`/account/reset-data`, { method: "POST" });
  if (!res.ok) throw await readApiError(res);
}

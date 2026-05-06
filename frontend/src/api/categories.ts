import { apiJson } from "@/lib/api";

export type Category = {
  id: string;
  userId: string;
  name: string;
  kind: "income" | "expense";
  icon?: string;
  archivedAt?: string;
  createdAt: string;
  updatedAt: string;
};

export async function listCategories(archived?: boolean) {
  let q = "";
  if (archived === true) q = "?archived=1";
  else if (archived === false) q = "?archived=0";
  return apiJson<{ categories: Category[] }>(`/categories${q}`);
}

export async function createCategory(body: { name: string; kind: string; icon?: string }) {
  return apiJson<{ category: Category }>(`/categories`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function updateCategory(id: string, body: { name: string; icon?: string }) {
  return apiJson<{ category: Category }>(`/categories/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

export async function archiveCategory(id: string) {
  return apiJson<{ category: Category }>(`/categories/${id}/archive`, { method: "POST" });
}

export async function unarchiveCategory(id: string) {
  return apiJson<{ category: Category }>(`/categories/${id}/unarchive`, { method: "POST" });
}

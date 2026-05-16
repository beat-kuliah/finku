import { getBcp47Tag } from "./locale";

export function formatIDR(amount: number, withPrefix = true): string {
  const value = Math.round(amount).toLocaleString(getBcp47Tag());
  return withPrefix ? `Rp ${value}` : value;
}

export function formatIDR(amount: number, withPrefix = true): string {
  const value = Math.round(amount).toLocaleString("id-ID");
  return withPrefix ? `Rp ${value}` : value;
}

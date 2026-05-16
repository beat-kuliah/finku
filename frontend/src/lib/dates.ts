import { getBcp47Tag } from "./locale";

function toDate(value: Date | string | number): Date {
  return value instanceof Date ? value : new Date(value);
}

export function formatDate(
  value: Date | string | number,
  options?: Intl.DateTimeFormatOptions,
): string {
  return toDate(value).toLocaleDateString(getBcp47Tag(), options);
}

export function formatWeekdayShort(value: Date | string | number): string {
  return toDate(value).toLocaleDateString(getBcp47Tag(), { weekday: "short" });
}

export function localeCompareName(a: string, b: string): number {
  return a.localeCompare(b, getBcp47Tag());
}

import { useEffect, useMemo, useState } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useTranslation } from "react-i18next";
import { ResponsiveContainer, PieChart, Pie, Cell, BarChart, Bar, XAxis, Tooltip } from "recharts";
import { toast } from "sonner";
import AppShell from "@/components/AppShell";
import { fetchStats, type StatsPayload } from "@/api/summary";
import { useDataVersion } from "@/store/dataVersion";
import { formatDate } from "@/lib/dates";
import { formatIDR } from "@/lib/format";

const COLORS = ["#00f0ff", "#2563eb", "#1d4ed8", "#38bdf8", "#7dd3fc", "#a5f3fc"];

function monthBounds(month: Date) {
  const from = new Date(month.getFullYear(), month.getMonth(), 1);
  const to = new Date(month.getFullYear(), month.getMonth() + 1, 0);
  const iso = (d: Date) => d.toISOString().slice(0, 10);
  return { from: iso(from), to: iso(to) };
}

export default function StatsPage() {
  const { t, i18n } = useTranslation("stats");
  const version = useDataVersion((s) => s.version);
  const [selectedMonth, setSelectedMonth] = useState(() => new Date());
  const [fetchState, setFetchState] = useState<{
    key: string;
    data: StatsPayload | null;
    err: string | null;
  }>({ key: "", data: null, err: null });

  const { from, to } = useMemo(() => monthBounds(selectedMonth), [selectedMonth]);
  const monthTitle = formatDate(selectedMonth, { month: "long", year: "numeric" });
  const requestKey = `${version}:${from}:${to}`;
  const loading = fetchState.key !== requestKey;
  const data = fetchState.key === requestKey ? fetchState.data : null;
  const err = fetchState.key === requestKey ? fetchState.err : null;

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      try {
        const d = await fetchStats(from, to);
        if (!cancelled) {
          setFetchState({ key: requestKey, data: d, err: null });
        }
      } catch (e) {
        if (!cancelled) {
          const msg = e instanceof Error ? e.message : t("loadFailed");
          setFetchState({ key: requestKey, data: null, err: msg });
          toast.error(msg);
        }
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [requestKey, from, to, t]);

  const pie = useMemo(() => {
    if (!data?.categoryBreakdown?.length) return [];
    const tot = data.categoryBreakdown.reduce((s, x) => s + x.value, 0) || 1;
    return data.categoryBreakdown.map((c, i) => ({
      name: c.name,
      value: Math.round((c.value / tot) * 100),
      raw: c.value,
      color: COLORS[i % COLORS.length],
    }));
  }, [data]);

  const weekly = useMemo(() => {
    if (!data?.weeklyExpense?.length) return [];
    const localeTag = i18n.language.startsWith("id") ? "id-ID" : "en-US";
    return data.weeklyExpense.map((w) => ({
      label: new Date(w.week + "T12:00:00").toLocaleDateString(localeTag, {
        day: "numeric",
        month: "short",
      }),
      total: w.total,
    }));
  }, [data, i18n.language]);

  const shiftMonth = (delta: number) => {
    setSelectedMonth((m) => new Date(m.getFullYear(), m.getMonth() + delta, 1));
  };

  return (
    <AppShell activeSection="stats" desktopTitle={t("title")} desktopSubtitle={t("subtitle")}>
      <div className="flex items-center justify-center gap-2 mb-4">
        <button
          type="button"
          className="btn-ghost !p-2 rounded-xl"
          aria-label={t("prevMonth")}
          onClick={() => shiftMonth(-1)}
        >
          <ChevronLeft className="w-5 h-5" />
        </button>
        <h2 className="font-display font-bold text-lg min-w-[10rem] text-center">{monthTitle}</h2>
        <button
          type="button"
          className="btn-ghost !p-2 rounded-xl"
          aria-label={t("nextMonth")}
          onClick={() => shiftMonth(1)}
        >
          <ChevronRight className="w-5 h-5" />
        </button>
      </div>

      {err && (
        <div className="rounded-2xl border border-amber-500/30 bg-amber-500/10 px-4 py-3 text-sm text-amber-100 mb-4">
          {err}
        </div>
      )}

      <section className="card !p-6">
        <p className="text-xs text-white/50 mb-2">
          {data?.periodFrom && data?.periodTo
            ? t("period", { from: data.periodFrom, to: data.periodTo })
            : null}
        </p>
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p className="text-xs text-white/60">{t("totalIncome")}</p>
            <p className="font-display text-2xl font-bold mt-1">
              {loading ? "…" : data ? formatIDR(data.totalIncome) : "—"}
            </p>
          </div>
          <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p className="text-xs text-white/60">{t("totalExpense")}</p>
            <p className="font-display text-2xl font-bold mt-1">
              {loading ? "…" : data ? formatIDR(data.totalExpense) : "—"}
            </p>
          </div>
          <div className="rounded-2xl border border-white/10 bg-white/5 p-4 sm:col-span-2 lg:col-span-1">
            <p className="text-xs text-white/60">{t("totalModifiedBalance")}</p>
            <p className="font-display text-2xl font-bold mt-1">
              {loading
                ? "…"
                : data?.totalModifiedBalance != null
                  ? formatIDR(data.totalModifiedBalance)
                  : "—"}
            </p>
            <p className="text-xs text-white/45 mt-2">{t("modifiedHint")}</p>
          </div>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl mb-4">{t("byCategory")}</h2>
          <div className="h-56">
            {loading ? (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">…</p>
            ) : pie.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={pie} dataKey="value" nameKey="name" innerRadius={50} outerRadius={80} paddingAngle={3}>
                    {pie.map((e) => (
                      <Cell key={e.name} fill={e.color} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(v: number) => [`${v}%`, ""]} />
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">{t("noData")}</p>
            )}
          </div>
        </div>
        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl mb-4">{t("weeklyExpense")}</h2>
          <div className="h-56">
            {loading ? (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">…</p>
            ) : weekly.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={weekly}>
                  <XAxis dataKey="label" stroke="#9fb5da" axisLine={false} tickLine={false} />
                  <Tooltip
                    formatter={(v: number) => [formatIDR(v), t("expense")]}
                    contentStyle={{
                      borderRadius: 12,
                      background: "rgba(11,18,32,0.95)",
                      border: "1px solid rgba(255,255,255,0.1)",
                    }}
                  />
                  <Bar dataKey="total" fill="#00f0ff" radius={[8, 8, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">{t("noData")}</p>
            )}
          </div>
        </div>
      </section>
    </AppShell>
  );
}

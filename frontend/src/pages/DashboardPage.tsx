import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import {
  ArrowUpRight,
  ArrowDownRight,
  Wallet,
  Flame,
  Sparkles,
} from "lucide-react";
import {
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
  XAxis,
  Tooltip,
} from "recharts";
import AppShell from "@/components/AppShell";
import { fetchDashboard, type DashboardPayload } from "@/api/summary";
import { useAuth } from "@/store/auth";
import { useDataVersion } from "@/store/dataVersion";
import { formatDate, formatWeekdayShort } from "@/lib/dates";
import { formatIDR } from "@/lib/format";

const COLORS = ["#00f0ff", "#2563eb", "#1d4ed8", "#38bdf8", "#7dd3fc", "#a5f3fc", "#bae6fd"];

export default function DashboardPage() {
  const { t, i18n } = useTranslation("dashboard");
  const user = useAuth((s) => s.user);
  const version = useDataVersion((s) => s.version);
  const [data, setData] = useState<DashboardPayload | null>(null);
  const [err, setErr] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      try {
        const d = await fetchDashboard();
        if (!cancelled) {
          setData(d);
          setErr(null);
        }
      } catch (e) {
        if (!cancelled) setErr(e instanceof Error ? e.message : t("loadFailed"));
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [version, t]);

  const trendData = useMemo(() => {
    if (!data?.dailyTrend?.length) return [];
    return data.dailyTrend.map((row) => ({
      day: formatWeekdayShort(row.date + "T12:00:00"),
      amount: row.expense,
    }));
  }, [data, i18n.language]);

  const categoryData = useMemo(() => {
    if (!data?.categoryBreakdown?.length) return [];
    const total = data.categoryBreakdown.reduce((s, c) => s + c.value, 0) || 1;
    return data.categoryBreakdown.map((c, i) => ({
      name: c.name,
      value: Math.round((c.value / total) * 100),
      raw: c.value,
      color: COLORS[i % COLORS.length],
    }));
  }, [data]);

  const budgets = data?.budgets ?? [];
  const latestTx = data?.latestTransactions ?? [];

  const subtitle = user?.username
    ? t("greetingUser", { username: user.username })
    : t("greetingName", { name: user?.name ?? "FinKu" });
  const today = formatDate(new Date(), {
    weekday: "long",
    day: "numeric",
    month: "short",
    year: "numeric",
  });

  const sisaBudget =
    data != null
      ? Math.max(
          0,
          budgets.reduce((s, b) => s + Math.max(0, b.limitAmount - b.spent), 0),
        )
      : 0;

  return (
    <AppShell activeSection="dashboard" desktopTitle={t("welcomeBack")} desktopSubtitle={subtitle}>
      {err && (
        <div className="rounded-2xl border border-amber-500/30 bg-amber-500/10 px-4 py-3 text-sm text-amber-100">
          {err}
        </div>
      )}
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">{t("totalBalance")}</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
              {data ? formatIDR(data.totalBalance) : "…"}
            </h1>
            <p className="text-sm text-white/80 mt-2">{today}</p>
            <Link to="/wallets" className="btn-ghost !px-0 text-sm mt-3 inline-flex">
              {t("walletDetails")}
            </Link>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <Flame className="w-3.5 h-3.5" />
            {t("monthSummary")}
          </div>
        </div>
        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-3 mt-5">
          <StatMini
            icon={<ArrowUpRight className="w-4 h-4" />}
            label={t("incomePeriod")}
            value={data ? formatIDR(data.periodIncome) : "…"}
          />
          <StatMini
            icon={<ArrowDownRight className="w-4 h-4" />}
            label={t("expensePeriod")}
            value={data ? formatIDR(data.periodExpense) : "…"}
          />
          <StatMini
            icon={<Sparkles className="w-4 h-4" />}
            label={t("modifiedPeriod")}
            value={data?.periodModifiedBalance != null ? formatIDR(data.periodModifiedBalance) : "…"}
          />
          <StatMini
            icon={<Wallet className="w-4 h-4" />}
            label={t("budgetRemaining")}
            value={data ? formatIDR(sisaBudget) : "…"}
          />
        </div>
      </section>

      <section className="grid lg:grid-cols-3 gap-5">
        <div className="card lg:col-span-2 !p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-display font-bold text-xl">{t("expenseTrend")}</h2>
            <span className="chip">{t("thisPeriod")}</span>
          </div>
          <div className="h-64">
            {trendData.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={trendData} margin={{ left: 0, right: 8, top: 10, bottom: 0 }}>
                  <defs>
                    <linearGradient id="areaGlow" x1="0" x2="0" y1="0" y2="1">
                      <stop offset="0%" stopColor="#00f0ff" stopOpacity={0.65} />
                      <stop offset="100%" stopColor="#00f0ff" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <XAxis axisLine={false} tickLine={false} dataKey="day" stroke="#9fb5da" />
                  <Tooltip
                    contentStyle={{
                      borderRadius: 16,
                      border: "1px solid rgba(255,255,255,0.1)",
                      background: "rgba(11, 18, 32, 0.9)",
                      color: "#e6f7ff",
                    }}
                    formatter={(value: number) => [formatIDR(value), t("expense")]}
                  />
                  <Area type="monotone" dataKey="amount" stroke="#00f0ff" strokeWidth={3} fill="url(#areaGlow)" />
                </AreaChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">{t("noExpenseData")}</p>
            )}
          </div>
        </div>

        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl">{t("categories")}</h2>
          <p className="text-white/60 text-sm mt-1">{t("categoryShare")}</p>
          <div className="h-48 mt-3">
            {categoryData.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={categoryData}
                    dataKey="value"
                    nameKey="name"
                    innerRadius={48}
                    outerRadius={72}
                    paddingAngle={4}
                  >
                    {categoryData.map((entry) => (
                      <Cell key={entry.name} fill={entry.color} />
                    ))}
                  </Pie>
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-white/50 text-sm text-center pt-16">{t("noCategoryData")}</p>
            )}
          </div>
          <div className="space-y-2 mt-2">
            {categoryData.map((item) => (
              <div key={item.name} className="flex items-center justify-between text-sm">
                <div className="flex items-center gap-2">
                  <span className="w-2.5 h-2.5 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-white/80">{item.name}</span>
                </div>
                <span className="text-white/60">{item.value}%</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6">
          <div className="flex items-center justify-between">
            <h2 className="font-display font-bold text-xl">{t("budgetTracker")}</h2>
            <Link to="/budget" className="btn-ghost !px-0 text-sm">
              {t("manage")}
            </Link>
          </div>
          <div className="space-y-4 mt-4">
            {budgets.length === 0 && <p className="text-white/50 text-sm">{t("noBudgets")}</p>}
            {budgets.map((item) => {
              const pct = item.limitAmount > 0 ? Math.min(100, Math.round((item.spent / item.limitAmount) * 100)) : 0;
              const over = item.spent > item.limitAmount;
              return (
                <div key={item.id} className="rounded-2xl border border-white/10 bg-white/5 p-4">
                  <div className="flex items-center justify-between gap-3 mb-2">
                    <span className="font-semibold text-sm truncate">
                      {item.categoryName ?? item.categoryId.slice(0, 8)}
                    </span>
                    <span className={`text-xs font-semibold ${over ? "text-red-400" : "text-neon-lime"}`}>{pct}%</span>
                  </div>
                  <div className="h-2 rounded-full bg-white/10 overflow-hidden">
                    <div
                      className={`h-full rounded-full ${over ? "bg-red-500" : "bg-gradient-neon"}`}
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <p className="text-xs text-white/60 mt-2">
                    {formatIDR(item.spent)} / {formatIDR(item.limitAmount)}
                    {item.paused ? t("paused") : ""}
                  </p>
                </div>
              );
            })}
          </div>
        </div>

        <div className="space-y-5">
          <div className="card !p-6">
            <div className="flex items-center justify-between mb-3">
              <h2 className="font-display font-bold text-xl">{t("latestTransactions")}</h2>
              <Link to="/transactions" className="btn-ghost !px-0 text-sm">
                {t("viewAll")}
              </Link>
            </div>
            <div className="space-y-2.5">
              {latestTx.length === 0 && <p className="text-white/50 text-sm">{t("noTransactions")}</p>}
              {latestTx.map((tx) => {
                const isIncome = tx.kind === "income";
                const isTransfer = tx.kind === "transfer";
                const label = tx.description || (isTransfer ? t("transfer") : tx.category || tx.kind);
                const kindLabel =
                  tx.kind === "income"
                    ? t("kindIncome")
                    : tx.kind === "expense"
                      ? t("kindExpense")
                      : tx.kind === "transfer"
                        ? t("kindTransfer")
                        : tx.kind;
                return (
                  <div key={tx.id} className="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 p-3">
                    <div className="w-10 h-10 rounded-xl bg-white/10 grid place-items-center text-lg">
                      {isTransfer ? "↔️" : isIncome ? "💰" : "📝"}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-medium truncate">{label}</p>
                      <p className="text-xs text-white/50">{kindLabel}</p>
                    </div>
                    <p className={`text-sm font-bold ${isIncome ? "text-neon-lime" : "text-white"}`}>
                      {isIncome ? "+" : isTransfer ? "" : "-"}
                      {formatIDR(tx.amount, false)}
                    </p>
                  </div>
                );
              })}
            </div>
          </div>

          <div className="card !p-6 bg-gradient-cyber">
            <div className="chip !bg-white/20 !border-white/30 !text-white mb-3 w-fit">
              <Sparkles className="w-3.5 h-3.5" /> {t("insightChip")}
            </div>
            <p className="font-semibold text-lg leading-relaxed text-white/90">{t("insightText")}</p>
          </div>
        </div>
      </section>
    </AppShell>
  );
}

function StatMini({ icon, label, value }: { icon: React.ReactNode; label: string; value: string }) {
  return (
    <div className="rounded-2xl bg-white/10 border border-white/20 p-3.5">
      <div className="flex items-center gap-2 text-white/80 text-xs uppercase tracking-wider font-semibold">
        {icon}
        {label}
      </div>
      <p className="font-bold mt-1.5">{value}</p>
    </div>
  );
}

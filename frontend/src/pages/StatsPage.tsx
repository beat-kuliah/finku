import { useEffect, useMemo, useState } from "react";
import { ResponsiveContainer, PieChart, Pie, Cell, BarChart, Bar, XAxis, Tooltip } from "recharts";
import AppShell from "@/components/AppShell";
import { fetchStats, type StatsPayload } from "@/api/summary";
import { useDataVersion } from "@/store/dataVersion";
import { formatIDR } from "@/lib/format";

const COLORS = ["#00f0ff", "#2563eb", "#1d4ed8", "#38bdf8", "#7dd3fc", "#a5f3fc"];

export default function StatsPage() {
  const version = useDataVersion((s) => s.version);
  const [data, setData] = useState<StatsPayload | null>(null);

  useEffect(() => {
    let c = false;
    void (async () => {
      try {
        const d = await fetchStats();
        if (!c) setData(d);
      } catch {
        if (!c) setData(null);
      }
    })();
    return () => {
      c = true;
    };
  }, [version]);

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
    return data.weeklyExpense.map((w) => ({
      label: new Date(w.week + "T12:00:00").toLocaleDateString("id-ID", { day: "numeric", month: "short" }),
      total: w.total,
    }));
  }, [data]);

  return (
    <AppShell activeSection="stats" desktopTitle="Stats" desktopSubtitle="Analitik pengeluaran">
      <section className="card !p-6">
        <p className="text-xs text-white/50 mb-2">
          Periode {data?.periodFrom} — {data?.periodTo}
        </p>
        <div className="grid sm:grid-cols-2 gap-4">
          <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p className="text-xs text-white/60">Total income</p>
            <p className="font-display text-2xl font-bold mt-1">{data ? formatIDR(data.totalIncome) : "—"}</p>
          </div>
          <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p className="text-xs text-white/60">Total expense</p>
            <p className="font-display text-2xl font-bold mt-1">{data ? formatIDR(data.totalExpense) : "—"}</p>
          </div>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl mb-4">Per kategori</h2>
          <div className="h-56">
            {pie.length > 0 ? (
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
              <p className="text-white/50 text-sm h-full flex items-center justify-center">Belum ada data.</p>
            )}
          </div>
        </div>
        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl mb-4">Per minggu (expense)</h2>
          <div className="h-56">
            {weekly.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={weekly}>
                  <XAxis dataKey="label" stroke="#9fb5da" axisLine={false} tickLine={false} />
                  <Tooltip
                    formatter={(v: number) => [formatIDR(v), "Expense"]}
                    contentStyle={{ borderRadius: 12, background: "rgba(11,18,32,0.95)", border: "1px solid rgba(255,255,255,0.1)" }}
                  />
                  <Bar dataKey="total" fill="#00f0ff" radius={[8, 8, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-white/50 text-sm h-full flex items-center justify-center">Belum ada data.</p>
            )}
          </div>
        </div>
      </section>
    </AppShell>
  );
}

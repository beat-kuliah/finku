import { Link } from "react-router-dom";
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

const trendData = [
  { day: "Sen", amount: 180000 },
  { day: "Sel", amount: 140000 },
  { day: "Rab", amount: 220000 },
  { day: "Kam", amount: 125000 },
  { day: "Jum", amount: 260000 },
  { day: "Sab", amount: 310000 },
  { day: "Min", amount: 170000 },
];

const categoryData = [
  { name: "Makan", value: 34, color: "#00f0ff" },
  { name: "Transport", value: 21, color: "#2563eb" },
  { name: "Shopping", value: 16, color: "#1d4ed8" },
  { name: "Hiburan", value: 14, color: "#38bdf8" },
  { name: "Lainnya", value: 15, color: "#7dd3fc" },
];

const budgets = [
  { emoji: "🍔", name: "Makan", spent: 820000, limit: 1200000 },
  { emoji: "🛵", name: "Transport", spent: 410000, limit: 600000 },
  { emoji: "🛍️", name: "Shopping", spent: 930000, limit: 800000 },
];

const latestTx = [
  { emoji: "☕", title: "Kopi Kenangan", category: "Jajan", amount: -38000 },
  { emoji: "💰", title: "Salary", category: "Income", amount: 5000000 },
  { emoji: "🍜", title: "Mie Gacoan", category: "Makan", amount: -47000 },
  { emoji: "🛵", title: "GoRide", category: "Transport", amount: -22000 },
];

export default function DashboardPage() {
  return (
    <AppShell
      activeSection="dashboard"
      desktopTitle="Welcome back!"
      desktopSubtitle="Halo, Kania 👋"
    >
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">
              Saldo bulan ini
            </p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
              Rp 3.240.500
            </h1>
            <p className="text-sm text-white/80 mt-2">Kamis, 23 Apr 2026</p>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <Flame className="w-3.5 h-3.5" />
            7 hari streak catat transaksi
          </div>
        </div>
        <div className="grid sm:grid-cols-3 gap-3 mt-5">
          <StatMini
            icon={<ArrowUpRight className="w-4 h-4" />}
            label="Income"
            value="Rp 5.000.000"
          />
          <StatMini
            icon={<ArrowDownRight className="w-4 h-4" />}
            label="Expense"
            value="Rp 1.759.500"
          />
          <StatMini
            icon={<Wallet className="w-4 h-4" />}
            label="Sisa budget"
            value="Rp 1.800.500"
          />
        </div>
      </section>

      <section className="grid lg:grid-cols-3 gap-5">
        <div className="card lg:col-span-2 !p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-display font-bold text-xl">Trend Pengeluaran</h2>
            <span className="chip">7 hari terakhir</span>
          </div>
          <div className="h-64">
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
                  formatter={(value: number) => [formatIDR(value), "Pengeluaran"]}
                />
                <Area
                  type="monotone"
                  dataKey="amount"
                  stroke="#00f0ff"
                  strokeWidth={3}
                  fill="url(#areaGlow)"
                />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl">Kategori</h2>
          <p className="text-white/60 text-sm mt-1">Porsi pengeluaran bulan ini</p>
          <div className="h-48 mt-3">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={categoryData} dataKey="value" innerRadius={48} outerRadius={72} paddingAngle={4}>
                  {categoryData.map((entry) => (
                    <Cell key={entry.name} fill={entry.color} />
                  ))}
                </Pie>
              </PieChart>
            </ResponsiveContainer>
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
            <h2 className="font-display font-bold text-xl">Budget Tracker</h2>
            <Link to="/budget" className="btn-ghost !px-0 text-sm">Kelola</Link>
          </div>
          <div className="space-y-4 mt-4">
            {budgets.map((item) => {
              const pct = Math.min(100, Math.round((item.spent / item.limit) * 100));
              const over = item.spent > item.limit;
              return (
                <div key={item.name} className="rounded-2xl border border-white/10 bg-white/5 p-4">
                  <div className="flex items-center justify-between gap-3 mb-2">
                    <div className="flex items-center gap-2">
                      <span className="text-lg">{item.emoji}</span>
                      <span className="font-semibold">{item.name}</span>
                    </div>
                    <span className={`text-xs font-semibold ${over ? "text-red-400" : "text-neon-lime"}`}>
                      {pct}%
                    </span>
                  </div>
                  <div className="h-2 rounded-full bg-white/10 overflow-hidden">
                    <div className={`h-full rounded-full ${over ? "bg-red-500" : "bg-gradient-neon"}`} style={{ width: `${pct}%` }} />
                  </div>
                  <p className="text-xs text-white/60 mt-2">
                    {formatIDR(item.spent)} / {formatIDR(item.limit)}
                  </p>
                </div>
              );
            })}
          </div>
        </div>

        <div className="space-y-5">
          <div className="card !p-6">
            <div className="flex items-center justify-between mb-3">
              <h2 className="font-display font-bold text-xl">Transaksi Terbaru</h2>
              <Link to="/transactions" className="btn-ghost !px-0 text-sm">Lihat semua</Link>
            </div>
            <div className="space-y-2.5">
              {latestTx.map((tx, idx) => (
                <div key={`${tx.title}-${idx}`} className="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 p-3">
                  <div className="w-10 h-10 rounded-xl bg-white/10 grid place-items-center text-lg">
                    {tx.emoji}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="font-medium truncate">{tx.title}</p>
                    <p className="text-xs text-white/50">{tx.category}</p>
                  </div>
                  <p className={`text-sm font-bold ${tx.amount > 0 ? "text-neon-lime" : "text-white"}`}>
                    {tx.amount > 0 ? "+" : "-"}
                    {formatIDR(Math.abs(tx.amount), false)}
                  </p>
                </div>
              ))}
            </div>
          </div>

          <div className="card !p-6 bg-gradient-cyber">
            <div className="chip !bg-white/20 !border-white/30 !text-white mb-3 w-fit">
              <Sparkles className="w-3.5 h-3.5" /> Insight hari ini
            </div>
            <p className="font-semibold text-lg leading-relaxed">
              Kamu spending <span className="font-extrabold">38%</span> lebih banyak di weekend.
              Kalau dipangkas 20%, goal laptop baru bisa lebih cepat <span className="font-extrabold">2 bulan</span>.
            </p>
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

function formatIDR(amount: number, withPrefix = true) {
  const value = amount.toLocaleString("id-ID");
  return withPrefix ? `Rp ${value}` : value;
}

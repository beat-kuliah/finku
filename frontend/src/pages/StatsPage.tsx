import {
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
  XAxis,
  Tooltip,
} from "recharts";
import AppShell from "@/components/AppShell";

const categoryData = [
  { name: "Makan", value: 34, color: "#00f0ff" },
  { name: "Transport", value: 21, color: "#2563eb" },
  { name: "Shopping", value: 16, color: "#1d4ed8" },
  { name: "Hiburan", value: 14, color: "#38bdf8" },
  { name: "Lainnya", value: 15, color: "#7dd3fc" },
];

const weeklyData = [
  { week: "W1", expense: 820000 },
  { week: "W2", expense: 630000 },
  { week: "W3", expense: 720000 },
  { week: "W4", expense: 880000 },
];

export default function StatsPage() {
  return (
    <AppShell activeSection="stats" desktopTitle="Spending analytics" desktopSubtitle="Insight finansial kamu">
      <section className="card !p-6">
        <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">Stats</p>
        <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">Analitik Pengeluaran</h1>
        <p className="text-white/60 mt-2">
          Lihat pola spending, kategori paling boros, dan progres penghematan.
        </p>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl">Distribusi kategori</h2>
          <div className="h-64 mt-2">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={categoryData} dataKey="value" innerRadius={55} outerRadius={88} paddingAngle={4}>
                  {categoryData.map((entry) => (
                    <Cell key={entry.name} fill={entry.color} />
                  ))}
                </Pie>
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="card !p-6">
          <h2 className="font-display font-bold text-xl">Pengeluaran per minggu</h2>
          <div className="h-64 mt-2">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={weeklyData}>
                <XAxis dataKey="week" axisLine={false} tickLine={false} stroke="#9fb5da" />
                <Tooltip
                  contentStyle={{
                    borderRadius: 14,
                    border: "1px solid rgba(255,255,255,0.1)",
                    background: "rgba(11, 18, 32, 0.9)",
                    color: "#e6f7ff",
                  }}
                  formatter={(value: number) => [`Rp ${value.toLocaleString("id-ID")}`, "Expense"]}
                />
                <Bar dataKey="expense" fill="#00f0ff" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>

      <section className="grid md:grid-cols-3 gap-5">
        <div className="card !p-5">
          <p className="text-white/60 text-sm">Top kategori</p>
          <p className="font-bold text-2xl mt-1">Makan 🍔</p>
          <p className="text-xs text-white/50 mt-1">34% dari total expense</p>
        </div>
        <div className="card !p-5">
          <p className="text-white/60 text-sm">Rata-rata harian</p>
          <p className="font-bold text-2xl mt-1">Rp 127.000</p>
          <p className="text-xs text-white/50 mt-1">Turun 6% dari bulan lalu</p>
        </div>
        <div className="card !p-5">
          <p className="text-white/60 text-sm">Insight</p>
          <p className="font-bold text-xl mt-1">Weekend lebih boros</p>
          <p className="text-xs text-white/50 mt-1">+38% dibanding weekdays</p>
        </div>
      </section>
    </AppShell>
  );
}

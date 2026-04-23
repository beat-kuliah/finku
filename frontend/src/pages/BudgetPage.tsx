import { Plus, AlertTriangle, CircleCheckBig } from "lucide-react";
import AppShell from "@/components/AppShell";

const budgetItems = [
  { emoji: "🍔", name: "Makan", spent: 820000, limit: 1200000 },
  { emoji: "🛵", name: "Transport", spent: 410000, limit: 600000 },
  { emoji: "🛍️", name: "Shopping", spent: 930000, limit: 800000 },
  { emoji: "🎮", name: "Hiburan", spent: 250000, limit: 400000 },
];

export default function BudgetPage() {
  const totalSpent = budgetItems.reduce((sum, item) => sum + item.spent, 0);
  const totalLimit = budgetItems.reduce((sum, item) => sum + item.limit, 0);
  const totalPct = Math.round((totalSpent / totalLimit) * 100);

  return (
    <AppShell activeSection="budget" desktopTitle="Budget planner" desktopSubtitle="Kontrol pengeluaran kamu">
      <section className="card !p-6 md:!p-7 bg-gradient-cyber">
        <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">Budget bulan ini</p>
        <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
          Rp {totalSpent.toLocaleString("id-ID")} / {totalLimit.toLocaleString("id-ID")}
        </h1>
        <div className="h-3 bg-white/20 rounded-full mt-4 overflow-hidden">
          <div className="h-full bg-white rounded-full" style={{ width: `${Math.min(100, totalPct)}%` }} />
        </div>
        <p className="text-sm text-white/80 mt-2">{totalPct}% terpakai</p>
      </section>

      <section className="card !p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-display font-bold text-2xl">Kategori Budget</h2>
          <button className="btn-primary !py-2.5 !px-4 text-sm">
            <Plus className="w-4 h-4" />
            Tambah Budget
          </button>
        </div>

        <div className="space-y-4">
          {budgetItems.map((item) => {
            const pct = Math.round((item.spent / item.limit) * 100);
            const over = item.spent > item.limit;

            return (
              <div key={item.name} className="rounded-2xl border border-white/10 bg-white/5 p-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="text-lg">{item.emoji}</span>
                    <span className="font-semibold">{item.name}</span>
                  </div>
                  <span className={`text-xs font-semibold ${over ? "text-red-300" : "text-neon-lime"}`}>
                    {pct}%
                  </span>
                </div>

                <div className="h-2 rounded-full bg-white/10 overflow-hidden">
                  <div className={`h-full rounded-full ${over ? "bg-red-500" : "bg-gradient-neon"}`} style={{ width: `${Math.min(100, pct)}%` }} />
                </div>

                <div className="flex items-center justify-between mt-3 text-xs">
                  <span className="text-white/60">
                    Rp {item.spent.toLocaleString("id-ID")} / Rp {item.limit.toLocaleString("id-ID")}
                  </span>
                  {over ? (
                    <span className="text-red-300 flex items-center gap-1">
                      <AlertTriangle className="w-3.5 h-3.5" /> Over budget
                    </span>
                  ) : (
                    <span className="text-neon-lime flex items-center gap-1">
                      <CircleCheckBig className="w-3.5 h-3.5" /> Aman
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </section>
    </AppShell>
  );
}

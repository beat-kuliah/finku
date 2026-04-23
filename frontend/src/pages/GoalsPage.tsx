import { Plus, Flag, CircleCheckBig } from "lucide-react";
import AppShell from "@/components/AppShell";

const goals = [
  { emoji: "💻", name: "MacBook Baru", current: 3500000, target: 12000000, deadline: "Des 2026" },
  { emoji: "✈️", name: "Liburan Bali", current: 2100000, target: 7000000, deadline: "Agu 2026" },
  { emoji: "🚨", name: "Dana Darurat", current: 8500000, target: 15000000, deadline: "Mar 2027" },
];

export default function GoalsPage() {
  return (
    <AppShell activeSection="goals" desktopTitle="Savings goals" desktopSubtitle="Target finansial kamu">
      <section className="card !p-6 md:!p-7 bg-gradient-cyber">
        <div className="flex flex-wrap justify-between gap-3 items-start">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">Goals</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">Target Nabung</h1>
            <p className="text-white/80 mt-2">Fokus ke target yang bikin kamu makin disiplin finansial.</p>
          </div>
          <button className="btn-primary !py-2.5 !px-4 text-sm">
            <Plus className="w-4 h-4" />
            Buat Goal
          </button>
        </div>
      </section>

      <section className="grid md:grid-cols-2 xl:grid-cols-3 gap-5">
        {goals.map((goal) => {
          const pct = Math.round((goal.current / goal.target) * 100);
          return (
            <div key={goal.name} className="card !p-5">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-2xl">{goal.emoji}</p>
                  <h2 className="font-display font-bold text-xl mt-2">{goal.name}</h2>
                </div>
                <span className="chip">{pct}%</span>
              </div>

              <p className="text-sm text-white/70 mt-4">
                Rp {goal.current.toLocaleString("id-ID")} / Rp {goal.target.toLocaleString("id-ID")}
              </p>
              <div className="h-2 rounded-full bg-white/10 overflow-hidden mt-2">
                <div className="h-full bg-gradient-neon rounded-full" style={{ width: `${Math.min(100, pct)}%` }} />
              </div>

              <div className="flex items-center justify-between mt-4 text-xs text-white/60">
                <span className="flex items-center gap-1">
                  <Flag className="w-3.5 h-3.5" /> Target {goal.deadline}
                </span>
                {pct >= 100 ? (
                  <span className="text-neon-lime flex items-center gap-1">
                    <CircleCheckBig className="w-3.5 h-3.5" /> Tercapai
                  </span>
                ) : (
                  <span>On progress</span>
                )}
              </div>
            </div>
          );
        })}
      </section>
    </AppShell>
  );
}

import { useCallback, useEffect, useState } from "react";
import AppShell from "@/components/AppShell";
import * as goalsApi from "@/api/goals";
import { useDataVersion } from "@/store/dataVersion";

const bumpData = () => useDataVersion.getState().bump();
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

export default function GoalsPage() {
  const version = useDataVersion((s) => s.version);
  const [goals, setGoals] = useState<goalsApi.Goal[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [name, setName] = useState("");
  const [target, setTarget] = useState("");
  const [deadline, setDeadline] = useState("");
  const [contrib, setContrib] = useState<Record<string, string>>({});

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const g = await goalsApi.listGoals();
      setGoals(g.goals);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Gagal memuat");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    const t = Number(String(target).replace(/\./g, ""));
    if (!name.trim() || !Number.isFinite(t) || t <= 0) {
      toast.error("Isi nama dan target valid.");
      return;
    }
    try {
      await goalsApi.createGoal({
        name: name.trim(),
        targetAmount: t,
        deadline: deadline || undefined,
      });
      toast.success("Goal dibuat.");
      setShowCreate(false);
      setName("");
      setTarget("");
      setDeadline("");
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Gagal");
    }
  };

  const handleContribute = async (id: string) => {
    const raw = contrib[id] ?? "";
    const amt = Number(String(raw).replace(/\./g, ""));
    if (!Number.isFinite(amt) || amt === 0) {
      toast.error("Isi jumlah tabungan (+ atau -).");
      return;
    }
    try {
      await goalsApi.contributeGoal(id, amt);
      toast.success("Progress diperbarui.");
      setContrib((s) => ({ ...s, [id]: "" }));
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Gagal");
    }
  };

  return (
    <AppShell activeSection="goals" desktopTitle="Goals" desktopSubtitle="Target tabungan">
      <section className="card !p-6 md:!p-7 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">Goals</p>
          <h1 className="font-display text-3xl font-extrabold mt-1">Target kamu</h1>
        </div>
        <button type="button" className="btn-primary !py-2.5 !px-4 text-sm" onClick={() => setShowCreate(true)}>
          Buat Goal
        </button>
      </section>

      {showCreate && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <form
            onSubmit={(e) => void handleCreate(e)}
            className="card !p-6 max-w-md w-full space-y-4 border border-white/15"
          >
            <h3 className="font-display font-bold text-lg">Goal baru</h3>
            <div>
              <label className="block text-xs text-white/60 mb-1">Nama</label>
              <input className="input" value={name} onChange={(e) => setName(e.target.value)} required />
            </div>
            <div>
              <label className="block text-xs text-white/60 mb-1">Target (IDR)</label>
              <input className="input" value={target} onChange={(e) => setTarget(e.target.value)} required />
            </div>
            <div>
              <label className="block text-xs text-white/60 mb-1">Deadline (opsional)</label>
              <input type="date" className="input" value={deadline} onChange={(e) => setDeadline(e.target.value)} />
            </div>
            <div className="flex gap-2 justify-end">
              <button type="button" className="btn-secondary" onClick={() => setShowCreate(false)}>
                Batal
              </button>
              <button type="submit" className="btn-primary">
                Simpan
              </button>
            </div>
          </form>
        </div>
      )}

      {loading && <p className="text-white/50 text-sm">Memuat…</p>}
      {!loading && goals.length === 0 && <p className="text-white/50 text-sm">Belum ada goal.</p>}

      <section className="grid md:grid-cols-2 gap-5">
        {goals.map((g) => {
          const pct = g.targetAmount > 0 ? Math.min(100, Math.round((g.currentAmount / g.targetAmount) * 100)) : 0;
          return (
            <div key={g.id} className="card !p-6 space-y-3">
              <div className="flex items-start justify-between gap-2">
                <div>
                  <h3 className="font-display font-bold text-xl">{g.name}</h3>
                  {g.deadline && <p className="text-xs text-white/50 mt-1">Deadline: {g.deadline}</p>}
                </div>
                <span className="text-neon-lime font-bold">{pct}%</span>
              </div>
              <div className="h-2 rounded-full bg-white/10 overflow-hidden">
                <div className="h-full rounded-full bg-gradient-neon" style={{ width: `${pct}%` }} />
              </div>
              <p className="text-sm text-white/70">
                {formatIDR(g.currentAmount)} / {formatIDR(g.targetAmount)}
              </p>
              <div className="flex gap-2 pt-2">
                <input
                  className="input flex-1 !py-2 text-sm"
                  placeholder="Tabung (+) / tarik (-)"
                  value={contrib[g.id] ?? ""}
                  onChange={(e) => setContrib((s) => ({ ...s, [g.id]: e.target.value }))}
                />
                <button
                  type="button"
                  className="btn-primary !py-2 !px-3 text-sm"
                  onClick={() => void handleContribute(g.id)}
                >
                  Update
                </button>
              </div>
            </div>
          );
        })}
      </section>
    </AppShell>
  );
}

import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Pencil, Trash2 } from "lucide-react";
import AppShell from "@/components/AppShell";
import * as goalsApi from "@/api/goals";
import { useDataVersion } from "@/store/dataVersion";
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

const bumpData = () => useDataVersion.getState().bump();

type EditorState = { mode: "create" } | { mode: "edit"; goalId: string };

export default function GoalsPage() {
  const { t } = useTranslation("goals");
  const version = useDataVersion((s) => s.version);
  const [goals, setGoals] = useState<goalsApi.Goal[]>([]);
  const [loading, setLoading] = useState(true);
  const [editor, setEditor] = useState<EditorState | null>(null);
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
      toast.error(e instanceof Error ? e.message : t("loadFailed"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const openCreate = () => {
    setName("");
    setTarget("");
    setDeadline("");
    setEditor({ mode: "create" });
  };

  const openEdit = (g: goalsApi.Goal) => {
    setName(g.name);
    setTarget(String(g.targetAmount));
    setDeadline(g.deadline ?? "");
    setEditor({ mode: "edit", goalId: g.id });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const targetAmount = Number(String(target).replace(/\./g, ""));
    if (!name.trim() || !Number.isFinite(targetAmount) || targetAmount <= 0) {
      toast.error(t("invalidForm"));
      return;
    }
    try {
      if (editor?.mode === "edit") {
        await goalsApi.updateGoal(editor.goalId, {
          name: name.trim(),
          targetAmount,
          deadline: deadline || undefined,
        });
        toast.success(t("updated"));
      } else {
        await goalsApi.createGoal({
          name: name.trim(),
          targetAmount,
          deadline: deadline || undefined,
        });
        toast.success(t("created"));
      }
      setEditor(null);
      setName("");
      setTarget("");
      setDeadline("");
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("failed"));
    }
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm(t("deleteConfirm"))) return;
    try {
      await goalsApi.deleteGoal(id);
      toast.success(t("deleted"));
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("failed"));
    }
  };

  const handleContribute = async (id: string) => {
    const raw = contrib[id] ?? "";
    const amt = Number(String(raw).replace(/\./g, ""));
    if (!Number.isFinite(amt) || amt === 0) {
      toast.error(t("contributeInvalid"));
      return;
    }
    try {
      await goalsApi.contributeGoal(id, amt);
      toast.success(t("progressUpdated"));
      setContrib((s) => ({ ...s, [id]: "" }));
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("failed"));
    }
  };

  return (
    <AppShell activeSection="goals" desktopTitle={t("title")} desktopSubtitle={t("subtitle")}>
      <section className="card !p-6 md:!p-7 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">{t("sectionLabel")}</p>
          <h1 className="font-display text-3xl font-extrabold mt-1">{t("heading")}</h1>
        </div>
        <button type="button" className="btn-primary !py-2.5 !px-4 text-sm" onClick={openCreate}>
          {t("createGoal")}
        </button>
      </section>

      {editor && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <form
            onSubmit={(e) => void handleSubmit(e)}
            className="card !p-6 max-w-md w-full space-y-4 border border-white/15"
          >
            <h3 className="font-display font-bold text-lg">
              {editor.mode === "edit" ? t("editGoal") : t("newGoal")}
            </h3>
            <div>
              <label className="block text-xs text-white/60 mb-1">{t("name")}</label>
              <input className="input" value={name} onChange={(e) => setName(e.target.value)} required />
            </div>
            <div>
              <label className="block text-xs text-white/60 mb-1">{t("target")}</label>
              <input className="input" value={target} onChange={(e) => setTarget(e.target.value)} required />
            </div>
            <div>
              <label className="block text-xs text-white/60 mb-1">{t("deadline")}</label>
              <input type="date" className="input" value={deadline} onChange={(e) => setDeadline(e.target.value)} />
            </div>
            <div className="flex gap-2 justify-end">
              <button type="button" className="btn-secondary" onClick={() => setEditor(null)}>
                {t("cancel")}
              </button>
              <button type="submit" className="btn-primary">
                {editor.mode === "edit" ? t("saveChanges") : t("save")}
              </button>
            </div>
          </form>
        </div>
      )}

      {loading && <p className="text-white/50 text-sm">{t("loading")}</p>}
      {!loading && goals.length === 0 && <p className="text-white/50 text-sm">{t("noGoals")}</p>}

      <section className="grid md:grid-cols-2 gap-5">
        {goals.map((g) => {
          const pct = g.targetAmount > 0 ? Math.min(100, Math.round((g.currentAmount / g.targetAmount) * 100)) : 0;
          return (
            <div key={g.id} className="card !p-6 space-y-3">
              <div className="flex items-start justify-between gap-2">
                <div>
                  <h3 className="font-display font-bold text-xl">{g.name}</h3>
                  {g.deadline && (
                    <p className="text-xs text-white/50 mt-1">{t("deadlineLabel", { date: g.deadline })}</p>
                  )}
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-neon-lime font-bold">{pct}%</span>
                  <button
                    type="button"
                    className="p-1.5 rounded-lg hover:bg-white/10 text-white/70"
                    aria-label={t("edit")}
                    onClick={() => openEdit(g)}
                  >
                    <Pencil className="w-4 h-4" />
                  </button>
                  <button
                    type="button"
                    className="p-1.5 rounded-lg hover:bg-white/10 text-red-300"
                    aria-label={t("delete")}
                    onClick={() => void handleDelete(g.id)}
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
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
                  placeholder={t("contributePlaceholder")}
                  value={contrib[g.id] ?? ""}
                  onChange={(e) => setContrib((s) => ({ ...s, [g.id]: e.target.value }))}
                />
                <button
                  type="button"
                  className="btn-primary !py-2 !px-3 text-sm"
                  onClick={() => void handleContribute(g.id)}
                >
                  {t("update")}
                </button>
              </div>
            </div>
          );
        })}
      </section>
    </AppShell>
  );
}

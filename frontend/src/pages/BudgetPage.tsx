import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import AppShell from "@/components/AppShell";
import * as budgetsApi from "@/api/budgets";
import * as catApi from "@/api/categories";
import { useDataVersion } from "@/store/dataVersion";

const bumpData = () => useDataVersion.getState().bump();
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

export default function BudgetPage() {
  const { t } = useTranslation("budget");
  const version = useDataVersion((s) => s.version);
  const [items, setItems] = useState<budgetsApi.Budget[]>([]);
  const [cats, setCats] = useState<catApi.Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAdd, setShowAdd] = useState(false);
  const [newCat, setNewCat] = useState("");
  const [newLimit, setNewLimit] = useState("");

  const monthStart = new Date();
  monthStart.setUTCDate(1);
  monthStart.setUTCHours(0, 0, 0, 0);
  const from = monthStart.toISOString().slice(0, 10);
  const to = new Date(monthStart.getFullYear(), monthStart.getMonth() + 1, 0).toISOString().slice(0, 10);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [b, c] = await Promise.all([budgetsApi.listBudgets(from, to), catApi.listCategories(false)]);
      setItems(b.budgets);
      setCats(c.categories.filter((x) => x.kind === "expense"));
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("loadFailed"));
    } finally {
      setLoading(false);
    }
  }, [from, to, t]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const totalLimit = items.reduce((s, b) => s + b.limitAmount, 0);
  const totalSpent = items.reduce((s, b) => s + b.spent, 0);
  const pct = totalLimit > 0 ? Math.min(100, Math.round((totalSpent / totalLimit) * 100)) : 0;

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    const lim = Number(String(newLimit).replace(/\./g, ""));
    if (!newCat || !Number.isFinite(lim) || lim <= 0) {
      toast.error(t("invalidForm"));
      return;
    }
    try {
      await budgetsApi.createBudget({
        categoryId: newCat,
        periodAnchor: from,
        limitAmount: lim,
      });
      toast.success(t("added"));
      setShowAdd(false);
      setNewLimit("");
      bumpData();
      void load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("failed"));
    }
  };

  return (
    <AppShell activeSection="budget" desktopTitle={t("title")} desktopSubtitle={t("subtitle")}>
      <section className="card !p-6 md:!p-7">
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">{t("sectionLabel")}</p>
            <h1 className="font-display text-3xl font-extrabold mt-1">{t("heading")}</h1>
          </div>
          <button type="button" className="btn-primary !py-2.5 !px-4 text-sm" onClick={() => setShowAdd(true)}>
            {t("addBudget")}
          </button>
        </div>
        <div className="mt-6">
          <div className="flex items-center justify-between text-sm text-white/70 mb-2">
            <span>{t("totalUsed")}</span>
            <span className="font-semibold text-white">
              {formatIDR(totalSpent)} / {formatIDR(totalLimit)}
            </span>
          </div>
          <div className="h-3 rounded-full bg-white/10 overflow-hidden">
            <div className="h-full rounded-full bg-gradient-neon transition-all" style={{ width: `${pct}%` }} />
          </div>
        </div>
      </section>

      {showAdd && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <form
            onSubmit={(e) => void handleAdd(e)}
            className="card !p-6 max-w-md w-full space-y-4 border border-white/15"
          >
            <h3 className="font-display font-bold text-lg">{t("newBudget")}</h3>
            <div>
              <label className="block text-xs text-white/60 mb-1">{t("category")}</label>
              <select className="input" value={newCat} onChange={(e) => setNewCat(e.target.value)} required>
                <option value="">{t("selectPlaceholder")}</option>
                {cats.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.icon ? `${c.icon} ` : ""}
                    {c.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs text-white/60 mb-1">{t("limit")}</label>
              <input className="input" value={newLimit} onChange={(e) => setNewLimit(e.target.value)} required />
            </div>
            <div className="flex gap-2 justify-end">
              <button type="button" className="btn-secondary" onClick={() => setShowAdd(false)}>
                {t("cancel")}
              </button>
              <button type="submit" className="btn-primary">
                {t("save")}
              </button>
            </div>
          </form>
        </div>
      )}

      <section className="space-y-4">
        {loading && <p className="text-white/50 text-sm">{t("loading")}</p>}
        {!loading && items.length === 0 && <p className="text-white/50 text-sm">{t("noBudgets")}</p>}
        {!loading &&
          items.map((item) => {
            const p = item.limitAmount > 0 ? Math.min(100, Math.round((item.spent / item.limitAmount) * 100)) : 0;
            const over = item.spent > item.limitAmount;
            return (
              <div key={item.id} className="card !p-5">
                <div className="flex items-center justify-between gap-3 mb-2">
                  <span className="font-semibold">{item.categoryName ?? item.categoryId}</span>
                  <span className={`text-xs font-semibold ${over ? "text-red-400" : "text-neon-lime"}`}>{p}%</span>
                </div>
                <div className="h-2 rounded-full bg-white/10 overflow-hidden">
                  <div
                    className={`h-full rounded-full ${over ? "bg-red-500" : "bg-gradient-neon"}`}
                    style={{ width: `${p}%` }}
                  />
                </div>
                <p className="text-xs text-white/60 mt-2">
                  {formatIDR(item.spent)} / {formatIDR(item.limitAmount)}
                  {item.paused ? t("pausedArchived") : ""}
                </p>
              </div>
            );
          })}
      </section>
    </AppShell>
  );
}

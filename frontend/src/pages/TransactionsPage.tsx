import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Search, Filter, ArrowDownRight, ArrowUpRight, Pencil, Trash2 } from "lucide-react";
import AppShell from "@/components/AppShell";
import EditTransactionModal from "@/components/EditTransactionModal";
import * as txApi from "@/api/transactions";
import * as walletsApi from "@/api/wallets";
import * as catApi from "@/api/categories";
import { useDataVersion } from "@/store/dataVersion";
import { formatDate } from "@/lib/dates";
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

const KIND_KEYS = ["income", "expense", "transfer", "modified"] as const;

const bumpData = () => useDataVersion.getState().bump();

export default function TransactionsPage() {
  const { t } = useTranslation("transactions");
  const version = useDataVersion((s) => s.version);
  const [items, setItems] = useState<txApi.Transaction[]>([]);
  const [wallets, setWallets] = useState<walletsApi.Wallet[]>([]);
  const [categories, setCategories] = useState<catApi.Category[]>([]);
  const [q, setQ] = useState("");
  const [kind, setKind] = useState<string>("");
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [walletFilter, setWalletFilter] = useState("");
  const [categoryFilter, setCategoryFilter] = useState("");
  const [loading, setLoading] = useState(true);
  const [totals, setTotals] = useState({ income: 0, expense: 0 });
  const [editTarget, setEditTarget] = useState<txApi.Transaction | null>(null);

  const walletMap = useMemo(() => {
    const m = new Map<string, string>();
    wallets.forEach((w) => m.set(w.id, w.name));
    return m;
  }, [wallets]);

  const kindLabel = (k: string) => {
    if (k === "income" || k === "expense" || k === "transfer" || k === "modified") {
      return t(k);
    }
    return k;
  };

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [tx, w, cats] = await Promise.all([
        txApi.listTransactions({
          q: q.trim() || undefined,
          kind: kind || undefined,
          from: from || undefined,
          to: to || undefined,
          walletId: walletFilter || undefined,
          categoryId: categoryFilter || undefined,
        }),
        walletsApi.listWallets(true),
        catApi.listCategories(),
      ]);
      setItems(tx.transactions);
      setWallets(w.wallets);
      setCategories(cats.categories);
      let inc = 0,
        exp = 0;
      tx.transactions.forEach((row) => {
        if (row.kind === "income") inc += row.amount;
        else if (row.kind === "expense") exp += row.amount;
      });
      setTotals({ income: inc, expense: exp });
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("loadFailed"));
    } finally {
      setLoading(false);
    }
  }, [q, kind, from, to, walletFilter, categoryFilter, t]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const clearFilters = () => {
    setKind("");
    setFrom("");
    setTo("");
    setWalletFilter("");
    setCategoryFilter("");
    setQ("");
  };

  const handleDelete = async (tx: txApi.Transaction) => {
    if (!window.confirm(t("deleteConfirm"))) return;
    try {
      await txApi.deleteTransaction(tx.id);
      toast.success(t("deleted"));
      bumpData();
      void load();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("loadFailed"));
    }
  };

  const exportCsv = () => {
    const rows = [
      ["occurredAt", "kind", "amount", "walletId", "destWalletId", "category", "description"].join(","),
      ...items.map((row) =>
        [
          row.occurredAt,
          row.kind,
          row.amount,
          row.walletId,
          row.destWalletId ?? "",
          (row.categoryName ?? "").replace(/,/g, " "),
          (row.description ?? "").replace(/,/g, " "),
        ].join(","),
      ),
    ].join("\n");
    const blob = new Blob([rows], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `finku-transactions-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    toast.success(t("csvDownloaded"));
  };

  return (
    <>
      <AppShell
        activeSection="transactions"
        desktopTitle={t("desktopTitle")}
        desktopSubtitle={t("subtitle")}
      >
        <section className="card !p-6 md:!p-7">
          <div className="flex flex-col md:flex-row md:items-center gap-3 md:justify-between">
            <div>
              <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">{t("sectionLabel")}</p>
              <h1 className="font-display text-3xl font-extrabold mt-1">{t("title")}</h1>
            </div>
            <div className="flex flex-wrap gap-2">
              <select
                className="input !py-2.5 !px-3 text-sm min-w-[140px]"
                value={kind}
                onChange={(e) => setKind(e.target.value)}
              >
                <option value="">{t("allKinds")}</option>
                {KIND_KEYS.map((k) => (
                  <option key={k} value={k}>
                    {t(k)}
                  </option>
                ))}
              </select>
              <button type="button" className="btn-secondary !py-2.5 !px-4 text-sm" onClick={() => void load()}>
                <Filter className="w-4 h-4" />
                {t("apply")}
              </button>
              <button type="button" className="btn-primary !py-2.5 !px-4 text-sm" onClick={exportCsv}>
                {t("exportCsv")}
              </button>
            </div>
          </div>

          <div className="mt-5 relative">
            <Search className="w-4 h-4 text-white/40 absolute left-4 top-1/2 -translate-y-1/2" />
            <input
              className="input !pl-11"
              placeholder={t("searchPlaceholder")}
              value={q}
              onChange={(e) => setQ(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && void load()}
            />
          </div>

          <div className="mt-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-2">
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("dateFrom")}</label>
              <input
                type="date"
                className="input !py-2.5 text-sm"
                value={from}
                onChange={(e) => setFrom(e.target.value)}
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("dateTo")}</label>
              <input
                type="date"
                className="input !py-2.5 text-sm"
                value={to}
                onChange={(e) => setTo(e.target.value)}
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("walletFilter")}</label>
              <select
                className="input !py-2.5 text-sm"
                value={walletFilter}
                onChange={(e) => setWalletFilter(e.target.value)}
              >
                <option value="">{t("allWallets")}</option>
                {wallets.map((w) => (
                  <option key={w.id} value={w.id}>
                    {w.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("categoryFilter")}</label>
              <select
                className="input !py-2.5 text-sm"
                value={categoryFilter}
                onChange={(e) => setCategoryFilter(e.target.value)}
              >
                <option value="">{t("allCategories")}</option>
                {categories.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.icon ? `${c.icon} ` : ""}
                    {c.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
          <div className="mt-3 flex justify-end">
            <button
              type="button"
              className="text-xs text-white/70 hover:underline"
              onClick={clearFilters}
            >
              {t("clearFilters")}
            </button>
          </div>
        </section>

        <section className="card !p-0 overflow-hidden">
          <div className="grid grid-cols-[80px_1fr_auto_auto] gap-3 px-5 py-3 text-xs uppercase tracking-wider text-white/50 border-b border-white/10">
            <span>{t("date")}</span>
            <span>{t("description")}</span>
            <span>{t("amount")}</span>
            <span aria-hidden="true"></span>
          </div>

          <div>
            {loading && <p className="px-5 py-8 text-white/50 text-sm">{t("loading")}</p>}
            {!loading && items.length === 0 && (
              <p className="px-5 py-8 text-white/50 text-sm">{t("noTransactions")}</p>
            )}
            {!loading &&
              items.map((tx) => {
                const isIncome = tx.kind === "income";
                const isModified = tx.kind === "modified";
                const modifiedUp = isModified && tx.isBalanceIncrease === true;
                const modifiedDown = isModified && tx.isBalanceIncrease === false;
                const title = tx.description || tx.categoryName || kindLabel(tx.kind);
                const wname = walletMap.get(tx.walletId) ?? t("walletFallback");
                const cat = tx.categoryName || kindLabel(tx.kind);
                const sign = isIncome || modifiedUp ? "+" : modifiedDown || tx.kind === "expense" ? "-" : "";
                return (
                  <div
                    key={tx.id}
                    className="grid grid-cols-[80px_1fr_auto_auto] gap-3 px-5 py-4 border-b border-white/5 items-center"
                  >
                    <p className="text-sm text-white/70">
                      {formatDate(tx.occurredAt + "T12:00:00", {
                        day: "numeric",
                        month: "short",
                      })}
                    </p>
                    <div className="min-w-0">
                      <p className="font-semibold truncate">{title}</p>
                      <p className="text-xs text-white/50">
                        {cat} · {wname}
                      </p>
                    </div>
                    <p
                      className={`text-sm font-bold ${
                        isIncome || modifiedUp ? "text-neon-lime" : modifiedDown ? "text-white" : "text-white"
                      }`}
                    >
                      {sign}
                      {formatIDR(tx.amount, false)}
                    </p>
                    <div className="flex items-center gap-1">
                      <button
                        type="button"
                        className="p-1.5 rounded-lg hover:bg-white/10 text-white/70"
                        aria-label={t("edit")}
                        title={t("edit")}
                        onClick={() => setEditTarget(tx)}
                      >
                        <Pencil className="w-4 h-4" />
                      </button>
                      <button
                        type="button"
                        className="p-1.5 rounded-lg hover:bg-white/10 text-rose-300"
                        aria-label={t("delete")}
                        title={t("delete")}
                        onClick={() => void handleDelete(tx)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                );
              })}
          </div>
        </section>

        <section className="grid md:grid-cols-2 gap-5">
          <div className="card !p-5">
            <div className="flex items-center gap-2 text-neon-lime">
              <ArrowUpRight className="w-4 h-4" />
              <span className="text-sm font-semibold">{t("totalIncome")}</span>
            </div>
            <p className="font-display text-3xl font-extrabold mt-2">{formatIDR(totals.income)}</p>
          </div>
          <div className="card !p-5">
            <div className="flex items-center gap-2 text-white/80">
              <ArrowDownRight className="w-4 h-4" />
              <span className="text-sm font-semibold">{t("totalExpense")}</span>
            </div>
            <p className="font-display text-3xl font-extrabold mt-2">{formatIDR(totals.expense)}</p>
          </div>
        </section>
      </AppShell>
      <EditTransactionModal
        transaction={editTarget}
        onClose={() => setEditTarget(null)}
        onSaved={() => {
          void load();
        }}
      />
    </>
  );
}

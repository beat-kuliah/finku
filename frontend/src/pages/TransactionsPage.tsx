import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Search, Filter, ArrowDownRight, ArrowUpRight } from "lucide-react";
import AppShell from "@/components/AppShell";
import * as txApi from "@/api/transactions";
import * as walletsApi from "@/api/wallets";
import { useDataVersion } from "@/store/dataVersion";
import { formatDate } from "@/lib/dates";
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

const KIND_KEYS = ["income", "expense", "transfer", "modified"] as const;

export default function TransactionsPage() {
  const { t } = useTranslation("transactions");
  const version = useDataVersion((s) => s.version);
  const [items, setItems] = useState<txApi.Transaction[]>([]);
  const [wallets, setWallets] = useState<walletsApi.Wallet[]>([]);
  const [q, setQ] = useState("");
  const [kind, setKind] = useState<string>("");
  const [loading, setLoading] = useState(true);
  const [totals, setTotals] = useState({ income: 0, expense: 0 });

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
      const [tx, w] = await Promise.all([
        txApi.listTransactions({
          q: q.trim() || undefined,
          kind: kind || undefined,
        }),
        walletsApi.listWallets(),
      ]);
      setItems(tx.transactions);
      setWallets(w.wallets);
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
  }, [q, kind, t]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

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
      </section>

      <section className="card !p-0 overflow-hidden">
        <div className="grid grid-cols-[80px_1fr_auto] px-5 py-3 text-xs uppercase tracking-wider text-white/50 border-b border-white/10">
          <span>{t("date")}</span>
          <span>{t("description")}</span>
          <span>{t("amount")}</span>
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
                  className="grid grid-cols-[80px_1fr_auto] px-5 py-4 border-b border-white/5 items-center"
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
  );
}

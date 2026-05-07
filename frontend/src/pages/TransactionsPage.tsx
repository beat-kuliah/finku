import { useCallback, useEffect, useMemo, useState } from "react";
import { Search, Filter, ArrowDownRight, ArrowUpRight } from "lucide-react";
import AppShell from "@/components/AppShell";
import * as txApi from "@/api/transactions";
import * as walletsApi from "@/api/wallets";
import { useDataVersion } from "@/store/dataVersion";
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

export default function TransactionsPage() {
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
      tx.transactions.forEach((t) => {
        if (t.kind === "income") inc += t.amount;
        else if (t.kind === "expense") exp += t.amount;
      });
      setTotals({ income: inc, expense: exp });
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Gagal memuat");
    } finally {
      setLoading(false);
    }
  }, [q, kind]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const exportCsv = () => {
    const rows = [
      ["occurredAt", "kind", "amount", "walletId", "destWalletId", "category", "description"].join(","),
      ...items.map((t) =>
        [
          t.occurredAt,
          t.kind,
          t.amount,
          t.walletId,
          t.destWalletId ?? "",
          (t.categoryName ?? "").replace(/,/g, " "),
          (t.description ?? "").replace(/,/g, " "),
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
    toast.success("CSV diunduh.");
  };

  return (
    <AppShell activeSection="transactions" desktopTitle="Transaction history" desktopSubtitle="Semua cash flow kamu">
      <section className="card !p-6 md:!p-7">
        <div className="flex flex-col md:flex-row md:items-center gap-3 md:justify-between">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">Transactions</p>
            <h1 className="font-display text-3xl font-extrabold mt-1">Riwayat Transaksi</h1>
          </div>
          <div className="flex flex-wrap gap-2">
            <select
              className="input !py-2.5 !px-3 text-sm min-w-[140px]"
              value={kind}
              onChange={(e) => setKind(e.target.value)}
            >
              <option value="">Semua jenis</option>
              <option value="income">Income</option>
              <option value="expense">Expense</option>
              <option value="transfer">Transfer</option>
            </select>
            <button type="button" className="btn-secondary !py-2.5 !px-4 text-sm" onClick={() => void load()}>
              <Filter className="w-4 h-4" />
              Terapkan
            </button>
            <button type="button" className="btn-primary !py-2.5 !px-4 text-sm" onClick={exportCsv}>
              Export CSV
            </button>
          </div>
        </div>

        <div className="mt-5 relative">
          <Search className="w-4 h-4 text-white/40 absolute left-4 top-1/2 -translate-y-1/2" />
          <input
            className="input !pl-11"
            placeholder="Cari transaksi (deskripsi)…"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && void load()}
          />
        </div>
      </section>

      <section className="card !p-0 overflow-hidden">
        <div className="grid grid-cols-[80px_1fr_auto] px-5 py-3 text-xs uppercase tracking-wider text-white/50 border-b border-white/10">
          <span>Tanggal</span>
          <span>Deskripsi</span>
          <span>Jumlah</span>
        </div>

        <div>
          {loading && <p className="px-5 py-8 text-white/50 text-sm">Memuat…</p>}
          {!loading && items.length === 0 && (
            <p className="px-5 py-8 text-white/50 text-sm">Belum ada transaksi.</p>
          )}
          {!loading &&
            items.map((tx) => {
              const isIncome = tx.kind === "income";
              const title = tx.description || tx.categoryName || tx.kind;
              const wname = walletMap.get(tx.walletId) ?? "Wallet";
              const cat = tx.categoryName || tx.kind;
              return (
                <div
                  key={tx.id}
                  className="grid grid-cols-[80px_1fr_auto] px-5 py-4 border-b border-white/5 items-center"
                >
                  <p className="text-sm text-white/70">
                    {new Date(tx.occurredAt + "T12:00:00").toLocaleDateString("id-ID", {
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
                  <p className={`text-sm font-bold ${isIncome ? "text-neon-lime" : "text-white"}`}>
                    {isIncome ? "+" : tx.kind === "transfer" ? "" : "-"}
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
            <span className="text-sm font-semibold">Total Income (daftar)</span>
          </div>
          <p className="font-display text-3xl font-extrabold mt-2">{formatIDR(totals.income)}</p>
        </div>
        <div className="card !p-5">
          <div className="flex items-center gap-2 text-white/80">
            <ArrowDownRight className="w-4 h-4" />
            <span className="text-sm font-semibold">Total Expense (daftar)</span>
          </div>
          <p className="font-display text-3xl font-extrabold mt-2">{formatIDR(totals.expense)}</p>
        </div>
      </section>
    </AppShell>
  );
}

import { useCallback, useEffect, useMemo, useState } from "react";
import { Wallet as WalletIcon } from "lucide-react";
import AppShell from "@/components/AppShell";
import * as walletsApi from "@/api/wallets";
import { useDataVersion } from "@/store/dataVersion";
import { formatIDR } from "@/lib/format";
import { toast } from "sonner";

const bumpData = () => useDataVersion.getState().bump();

type Tab = "active" | "archived";

export default function WalletsPage() {
  const version = useDataVersion((s) => s.version);
  const [tab, setTab] = useState<Tab>("active");
  const [activeWallets, setActiveWallets] = useState<walletsApi.Wallet[]>([]);
  const [allForArchived, setAllForArchived] = useState<walletsApi.Wallet[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState("");
  const [newType, setNewType] = useState("cash");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [a, all] = await Promise.all([walletsApi.listWallets(false), walletsApi.listWallets(true)]);
      setActiveWallets(a.wallets);
      setAllForArchived(all.wallets);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Gagal memuat");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load, version]);

  const archivedWallets = useMemo(
    () => allForArchived.filter((w) => w.archivedAt),
    [allForArchived],
  );

  const totalActiveBalance = useMemo(
    () => activeWallets.reduce((s, w) => s + w.balance, 0),
    [activeWallets],
  );

  const handleCreate = async () => {
    const n = newName.trim();
    if (!n) return;
    try {
      await walletsApi.createWallet({ name: n, walletType: newType });
      setNewName("");
      bumpData();
      toast.success("Dompet ditambahkan.");
      void load();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Gagal");
    }
  };

  const list = tab === "active" ? activeWallets : archivedWallets;

  return (
    <AppShell activeSection="wallets" desktopTitle="Wallets" desktopSubtitle="Dompet & saldo">
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">Total saldo (aktif)</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
              {loading ? "…" : formatIDR(totalActiveBalance)}
            </h1>
            <p className="text-sm text-white/80 mt-2">
              {activeWallets.length} dompet aktif
              {archivedWallets.length > 0 ? ` · ${archivedWallets.length} diarsipkan` : ""}
            </p>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <WalletIcon className="w-3.5 h-3.5" />
            Kelola dompet
          </div>
        </div>
      </section>

      <section className="card !p-6 space-y-4">
        <div className="flex gap-2">
          <button
            type="button"
            className={`btn-secondary !py-1.5 !px-3 text-xs ${tab === "active" ? "ring-1 ring-neon-cyan" : ""}`}
            onClick={() => setTab("active")}
          >
            Aktif
          </button>
          <button
            type="button"
            className={`btn-secondary !py-1.5 !px-3 text-xs ${tab === "archived" ? "ring-1 ring-neon-cyan" : ""}`}
            onClick={() => setTab("archived")}
          >
            Diarsipkan
          </button>
        </div>

        {tab === "active" && (
          <div className="flex flex-wrap gap-2 items-end">
            <input
              className="input flex-1 min-w-[160px]"
              placeholder="Nama dompet baru"
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
            />
            <select className="input !w-auto" value={newType} onChange={(e) => setNewType(e.target.value)}>
              <option value="cash">Cash</option>
              <option value="bank">Bank</option>
              <option value="ewallet">E-wallet</option>
            </select>
            <button type="button" className="btn-primary !py-2 !px-3 text-sm" onClick={() => void handleCreate()}>
              Tambah
            </button>
          </div>
        )}

        {loading && <p className="text-white/50 text-sm">Memuat…</p>}
        {!loading && list.length === 0 && (
          <p className="text-white/50 text-sm">{tab === "active" ? "Belum ada dompet aktif." : "Belum ada dompet diarsipkan."}</p>
        )}
        {!loading && (
          <ul className="space-y-2 text-sm">
            {list.map((w) => (
              <li
                key={w.id}
                className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-white/10 bg-white/5 px-3 py-2.5"
              >
                <div className="min-w-0">
                  <span className="font-medium">{w.name}</span>
                  <span className="text-white/50 text-xs ml-2">({w.walletType})</span>
                  <p className="text-white/70 font-semibold mt-0.5">{formatIDR(w.balance)}</p>
                </div>
                {tab === "active" && !w.archivedAt && (
                  <button
                    type="button"
                    className="text-xs text-amber-300 hover:underline shrink-0"
                    onClick={async () => {
                      if (!confirm(`Arsipkan dompet "${w.name}"?`)) return;
                      try {
                        await walletsApi.archiveWallet(w.id);
                        bumpData();
                        toast.success("Dompet diarsipkan.");
                        void load();
                      } catch (e) {
                        toast.error(e instanceof Error ? e.message : "Gagal");
                      }
                    }}
                  >
                    Arsipkan
                  </button>
                )}
                {tab === "archived" && w.archivedAt && (
                  <span className="text-xs text-white/40 shrink-0">Diarsipkan</span>
                )}
              </li>
            ))}
          </ul>
        )}
      </section>
    </AppShell>
  );
}

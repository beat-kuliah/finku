import { useEffect, useState } from "react";
import { X } from "lucide-react";
import { toast } from "sonner";
import * as walletsApi from "@/api/wallets";
import * as walletGroupsApi from "@/api/walletGroups";
import * as catApi from "@/api/categories";
import * as txApi from "@/api/transactions";
import { useDataVersion } from "@/store/dataVersion";
import { useUIStore } from "@/store/ui";

type Tab = "income" | "expense" | "transfer";

export default function AddTransactionModal() {
  const open = useUIStore((s) => s.addTransactionOpen);
  const setOpen = useUIStore((s) => s.setAddTransactionOpen);
  const bump = useDataVersion((s) => s.bump);

  const [tab, setTab] = useState<Tab>("expense");
  const [wallets, setWallets] = useState<walletsApi.Wallet[]>([]);
  const [groupNameById, setGroupNameById] = useState<Map<string, string>>(() => new Map());
  const [catsIncome, setCatsIncome] = useState<catApi.Category[]>([]);
  const [catsExpense, setCatsExpense] = useState<catApi.Category[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  const [amount, setAmount] = useState("");
  const [occurredAt, setOccurredAt] = useState(() => new Date().toISOString().slice(0, 10));
  const [description, setDescription] = useState("");
  const [walletId, setWalletId] = useState("");
  const [destWalletId, setDestWalletId] = useState("");
  const [categoryId, setCategoryId] = useState("");

  useEffect(() => {
    if (!open) return;
    const timer = window.setTimeout(() => {
      setLoading(true);
      void (async () => {
        try {
          const [w, gRes, catRes] = await Promise.all([
            walletsApi.listWallets(),
            walletGroupsApi.listWalletGroups(),
            catApi.listCategories(false),
          ]);
          setWallets(w.wallets);
          setGroupNameById(new Map(gRes.groups.map((g) => [g.id, g.name])));
          const income = catRes.categories.filter((c) => c.kind === "income");
          const expense = catRes.categories.filter((c) => c.kind === "expense");
          setCatsIncome(income);
          setCatsExpense(expense);
          if (w.wallets[0] && !walletId) setWalletId(w.wallets[0].id);
          if (tab !== "transfer") {
            const list = tab === "income" ? income : expense;
            const def = list.find((c) => c.name.toLowerCase().includes("lainnya")) ?? list[0];
            if (def) setCategoryId(def.id);
          }
        } catch (e) {
          toast.error(e instanceof Error ? e.message : "Gagal memuat data");
        } finally {
          setLoading(false);
        }
      })();
    }, 0);
    return () => window.clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reset form fields when opening
  }, [open]);

  useEffect(() => {
    if (!open) return;
    const timer = window.setTimeout(() => {
      const list = tab === "income" ? catsIncome : catsExpense;
      const def = list.find((c) => c.name.toLowerCase().includes("lainnya")) ?? list[0];
      if (tab !== "transfer" && def) setCategoryId(def.id);
    }, 0);
    return () => window.clearTimeout(timer);
  }, [tab, open, catsIncome, catsExpense]);

  if (!open) return null;

  const walletLabel = (w: walletsApi.Wallet) => {
    const bal = w.balance.toLocaleString("id-ID");
    const gid = w.groupId ?? undefined;
    const gname = gid ? groupNameById.get(gid) : undefined;
    if (gname) return `${gname} · ${w.name} (${bal})`;
    return `${w.name} (${bal})`;
  };

  const parseAmount = () => {
    const n = Number(String(amount).replace(/\./g, "").replace(/,/g, "."));
    return Number.isFinite(n) && n > 0 ? Math.round(n) : 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const amt = parseAmount();
    if (amt <= 0) {
      toast.error("Masukkan jumlah valid.");
      return;
    }
    if (!walletId) {
      toast.error("Pilih dompet.");
      return;
    }
    setSaving(true);
    try {
      if (tab === "transfer") {
        if (!destWalletId || destWalletId === walletId) {
          toast.error("Pilih dompet tujuan yang berbeda.");
          setSaving(false);
          return;
        }
        await txApi.createTransaction({
          kind: "transfer",
          walletId,
          destWalletId,
          amount: amt,
          occurredAt,
          description: description || undefined,
        });
      } else {
        if (!categoryId) {
          toast.error("Pilih kategori.");
          setSaving(false);
          return;
        }
        await txApi.createTransaction({
          kind: tab,
          walletId,
          categoryId,
          amount: amt,
          occurredAt,
          description: description || undefined,
        });
      }
      toast.success("Transaksi tersimpan.");
      bump();
      setOpen(false);
      setAmount("");
      setDescription("");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Gagal menyimpan");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-end md:items-center justify-center p-0 md:p-4">
      <button
        type="button"
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        aria-label="Tutup"
        onClick={() => setOpen(false)}
      />
      <div className="relative w-full max-w-lg rounded-t-3xl md:rounded-3xl border border-white/15 bg-ink-900/95 backdrop-blur-xl shadow-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
          <h2 className="font-display font-bold text-lg">Tambah transaksi</h2>
          <button type="button" onClick={() => setOpen(false)} className="p-2 rounded-xl hover:bg-white/10">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="flex gap-1 p-2 border-b border-white/10">
          {(["expense", "income", "transfer"] as const).map((k) => (
            <button
              key={k}
              type="button"
              onClick={() => setTab(k)}
              className={`flex-1 py-2.5 rounded-xl text-sm font-semibold capitalize transition-colors ${
                tab === k ? "bg-gradient-neon text-white shadow-neon" : "text-white/70 hover:bg-white/10"
              }`}
            >
              {k === "transfer" ? "Transfer" : k}
            </button>
          ))}
        </div>

        <form onSubmit={(e) => void handleSubmit(e)} className="p-5 space-y-4">
          {loading ? (
            <p className="text-white/60 text-sm">Memuat…</p>
          ) : (
            <>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">Jumlah (IDR)</label>
                <input
                  className="input"
                  inputMode="numeric"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  placeholder="50000"
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">Tanggal</label>
                <input
                  type="date"
                  className="input"
                  value={occurredAt}
                  onChange={(e) => setOccurredAt(e.target.value)}
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">Dompet</label>
                <select className="input" value={walletId} onChange={(e) => setWalletId(e.target.value)} required>
                  <option value="">— Pilih —</option>
                  {wallets.map((w) => (
                    <option key={w.id} value={w.id}>
                      {walletLabel(w)}
                    </option>
                  ))}
                </select>
              </div>
              {tab === "transfer" ? (
                <div>
                  <label className="block text-xs font-semibold text-white/60 mb-1.5">Dompet tujuan</label>
                  <select
                    className="input"
                    value={destWalletId}
                    onChange={(e) => setDestWalletId(e.target.value)}
                    required
                  >
                    <option value="">— Pilih —</option>
                    {wallets
                      .filter((w) => w.id !== walletId)
                      .map((w) => (
                        <option key={w.id} value={w.id}>
                          {walletLabel(w)}
                        </option>
                      ))}
                  </select>
                </div>
              ) : (
                <div>
                  <label className="block text-xs font-semibold text-white/60 mb-1.5">Kategori</label>
                  <select
                    className="input"
                    value={categoryId}
                    onChange={(e) => setCategoryId(e.target.value)}
                    required
                  >
                    {(tab === "income" ? catsIncome : catsExpense).map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.icon ? `${c.icon} ` : ""}
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>
              )}
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">Catatan (opsional)</label>
                <input className="input" value={description} onChange={(e) => setDescription(e.target.value)} />
              </div>
              <button type="submit" disabled={saving} className="btn-primary w-full !py-3 disabled:opacity-50">
                {saving ? "Menyimpan…" : "Simpan"}
              </button>
            </>
          )}
        </form>
      </div>
    </div>
  );
}

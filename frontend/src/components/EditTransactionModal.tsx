import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { X } from "lucide-react";
import { toast } from "sonner";
import * as walletsApi from "@/api/wallets";
import * as walletGroupsApi from "@/api/walletGroups";
import * as catApi from "@/api/categories";
import * as txApi from "@/api/transactions";
import { useDataVersion } from "@/store/dataVersion";
import { getBcp47Tag } from "@/lib/locale";

type Tab = "income" | "expense" | "transfer";

const TABS: Tab[] = ["expense", "income", "transfer"];

type Props = {
  transaction: txApi.Transaction | null;
  onClose: () => void;
  onSaved?: () => void;
};

export default function EditTransactionModal({ transaction, onClose, onSaved }: Props) {
  if (!transaction) return null;
  // "modified" (balance-adjustment) transactions require isBalanceIncrease which
  // the current update API does not expose; skip rendering for those.
  if (transaction.kind === "modified") return null;
  return (
    <EditTransactionForm
      key={transaction.id}
      transaction={transaction}
      onClose={onClose}
      onSaved={onSaved}
    />
  );
}

function EditTransactionForm({
  transaction,
  onClose,
  onSaved,
}: {
  transaction: txApi.Transaction;
  onClose: () => void;
  onSaved?: () => void;
}) {
  const { t } = useTranslation("transactions");
  const bump = useDataVersion((s) => s.bump);

  const initialTab: Tab =
    transaction.kind === "transfer" ? "transfer" : transaction.kind === "income" ? "income" : "expense";
  const [tab] = useState<Tab>(initialTab);
  const [wallets, setWallets] = useState<walletsApi.Wallet[]>([]);
  const [groupNameById, setGroupNameById] = useState<Map<string, string>>(() => new Map());
  const [catsIncome, setCatsIncome] = useState<catApi.Category[]>([]);
  const [catsExpense, setCatsExpense] = useState<catApi.Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [amount, setAmount] = useState(String(transaction.amount));
  const [occurredAt, setOccurredAt] = useState(transaction.occurredAt.slice(0, 10));
  const [description, setDescription] = useState(transaction.description ?? "");
  const [walletId, setWalletId] = useState(transaction.walletId);
  const [destWalletId, setDestWalletId] = useState(transaction.destWalletId ?? "");
  const [categoryId, setCategoryId] = useState(transaction.categoryId ?? "");

  useEffect(() => {
    let cancelled = false;
    const timer = window.setTimeout(() => {
      void (async () => {
        try {
          const [w, gRes, catRes] = await Promise.all([
            walletsApi.listWallets(),
            walletGroupsApi.listWalletGroups(),
            catApi.listCategories(false),
          ]);
          if (cancelled) return;
          setWallets(w.wallets);
          setGroupNameById(new Map(gRes.groups.map((g) => [g.id, g.name])));
          const income = catRes.categories.filter((c) => c.kind === "income");
          const expense = catRes.categories.filter((c) => c.kind === "expense");
          setCatsIncome(income);
          setCatsExpense(expense);
        } catch (e) {
          if (!cancelled) toast.error(e instanceof Error ? e.message : t("modal.loadFailed"));
        } finally {
          if (!cancelled) setLoading(false);
        }
      })();
    }, 0);
    return () => {
      cancelled = true;
      window.clearTimeout(timer);
    };
  }, [t]);

  const walletLabel = (w: walletsApi.Wallet) => {
    const bal = w.balance.toLocaleString(getBcp47Tag());
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
      toast.error(t("modal.invalidAmount"));
      return;
    }
    if (!walletId) {
      toast.error(t("modal.selectWallet"));
      return;
    }
    setSaving(true);
    try {
      if (tab === "transfer") {
        if (!destWalletId || destWalletId === walletId) {
          toast.error(t("modal.selectDestWallet"));
          setSaving(false);
          return;
        }
        await txApi.updateTransaction(transaction.id, {
          kind: "transfer",
          walletId,
          destWalletId,
          amount: amt,
          occurredAt,
          description: description || undefined,
        });
      } else {
        if (!categoryId) {
          toast.error(t("modal.selectCategory"));
          setSaving(false);
          return;
        }
        await txApi.updateTransaction(transaction.id, {
          kind: tab,
          walletId,
          categoryId,
          amount: amt,
          occurredAt,
          description: description || undefined,
        });
      }
      toast.success(t("modal.saved"));
      bump();
      onSaved?.();
      onClose();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("modal.saveFailed"));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-end md:items-center justify-center p-0 md:p-4">
      <button
        type="button"
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        aria-label={t("close")}
        onClick={onClose}
      />
      <div className="relative w-full max-w-lg rounded-t-3xl md:rounded-3xl border border-white/15 bg-ink-900/95 backdrop-blur-xl shadow-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
          <h2 className="font-display font-bold text-lg">{t("editTransaction")}</h2>
          <button type="button" onClick={onClose} className="p-2 rounded-xl hover:bg-white/10">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="flex gap-1 p-2 border-b border-white/10">
          {TABS.map((k) => (
            <button
              key={k}
              type="button"
              disabled
              aria-disabled
              className={`flex-1 py-2.5 rounded-xl text-sm font-semibold transition-colors cursor-not-allowed ${
                tab === k ? "bg-gradient-neon text-white shadow-neon" : "text-white/30"
              }`}
            >
              {t(k)}
            </button>
          ))}
        </div>

        <form onSubmit={(e) => void handleSubmit(e)} className="p-5 space-y-4">
          {loading ? (
            <p className="text-white/60 text-sm">{t("loading")}</p>
          ) : (
            <>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.amount")}</label>
                <input
                  className="input"
                  inputMode="numeric"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  placeholder={t("modal.amountPlaceholder")}
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.date")}</label>
                <input
                  type="date"
                  className="input"
                  value={occurredAt}
                  onChange={(e) => setOccurredAt(e.target.value)}
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.wallet")}</label>
                <select className="input" value={walletId} onChange={(e) => setWalletId(e.target.value)} required>
                  <option value="">{t("selectPlaceholder")}</option>
                  {wallets.map((w) => (
                    <option key={w.id} value={w.id}>
                      {walletLabel(w)}
                    </option>
                  ))}
                </select>
              </div>
              {tab === "transfer" ? (
                <div>
                  <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.destWallet")}</label>
                  <select
                    className="input"
                    value={destWalletId}
                    onChange={(e) => setDestWalletId(e.target.value)}
                    required
                  >
                    <option value="">{t("selectPlaceholder")}</option>
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
                  <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.category")}</label>
                  <select
                    className="input"
                    value={categoryId}
                    onChange={(e) => setCategoryId(e.target.value)}
                    required
                  >
                    <option value="">{t("selectPlaceholder")}</option>
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
                <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.note")}</label>
                <input className="input" value={description} onChange={(e) => setDescription(e.target.value)} />
              </div>
              <button type="submit" disabled={saving} className="btn-primary w-full !py-3 disabled:opacity-50">
                {saving ? t("saving") : t("save")}
              </button>
            </>
          )}
        </form>
      </div>
    </div>
  );
}

import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { X } from "lucide-react";
import { toast } from "sonner";
import * as walletsApi from "@/api/wallets";
import * as catApi from "@/api/categories";
import { useDataVersion } from "@/store/dataVersion";
import { formatIDR } from "@/lib/format";

type Props = {
  open: boolean;
  wallet: walletsApi.Wallet | null;
  onClose: () => void;
  onSaved?: () => void;
};

type RecordAs = "income" | "expense" | "modified";

function sanitizeBalanceInput(value: string): string {
  const trimmed = value.trim();
  if (!trimmed) return "";
  const negative = trimmed.startsWith("-");
  const digits = trimmed.replace(/\D/g, "");
  if (!digits) return negative ? "-" : "";
  return negative ? `-${digits}` : digits;
}

function parseBalanceInput(raw: string): number | null {
  const trimmed = raw.trim();
  if (!trimmed || trimmed === "-") return null;

  const negative = trimmed.startsWith("-");
  const digits = trimmed.replace(/\D/g, "");
  if (!digits) return null;

  const n = Number(negative ? `-${digits}` : digits);
  return Number.isFinite(n) ? n : null;
}

export default function AdjustWalletBalanceModal({ open, wallet, onClose, onSaved }: Props) {
  const { t } = useTranslation("wallets");
  const { t: tTx } = useTranslation("transactions");
  const bump = useDataVersion((s) => s.bump);
  const [step, setStep] = useState<1 | 2>(1);
  const [saving, setSaving] = useState(false);
  const [newBalanceRaw, setNewBalanceRaw] = useState("");
  const [occurredAt, setOccurredAt] = useState(() => new Date().toISOString().slice(0, 10));
  const [recordAs, setRecordAs] = useState<RecordAs>("modified");
  const [categoryId, setCategoryId] = useState("");
  const [catsIncome, setCatsIncome] = useState<catApi.Category[]>([]);
  const [catsExpense, setCatsExpense] = useState<catApi.Category[]>([]);

  useEffect(() => {
    if (!open || !wallet) return;
    setStep(1);
    setSaving(false);
    setNewBalanceRaw(String(Math.round(wallet.balance)));
    setOccurredAt(new Date().toISOString().slice(0, 10));
    setRecordAs("modified");
    setCategoryId("");
    void (async () => {
      try {
        const catRes = await catApi.listCategories(false);
        const income = catRes.categories.filter((c) => c.kind === "income");
        const expense = catRes.categories.filter((c) => c.kind === "expense");
        setCatsIncome(income);
        setCatsExpense(expense);
        const defInc = income.find((c) => c.name.toLowerCase().includes("lainnya")) ?? income[0];
        const defExp = expense.find((c) => c.name.toLowerCase().includes("lainnya")) ?? expense[0];
        if (defInc) setCategoryId(defInc.id);
        else if (defExp) setCategoryId(defExp.id);
      } catch {
        /* optional */
      }
    })();
  }, [open, wallet]);

  const newBalance = useMemo(() => parseBalanceInput(newBalanceRaw), [newBalanceRaw]);
  const delta = wallet && newBalance != null ? newBalance - wallet.balance : 0;

  const allowedRecordAs = useMemo((): RecordAs[] => {
    if (delta > 0) return ["income", "modified"];
    if (delta < 0) return ["expense", "modified"];
    return [];
  }, [delta]);

  useEffect(() => {
    if (!open || delta === 0) return;
    if (!allowedRecordAs.includes(recordAs)) {
      setRecordAs(allowedRecordAs[0] ?? "modified");
    }
  }, [open, delta, allowedRecordAs, recordAs]);

  useEffect(() => {
    if (!open || recordAs === "modified") return;
    const list = recordAs === "income" ? catsIncome : catsExpense;
    const def = list.find((c) => c.name.toLowerCase().includes("lainnya")) ?? list[0];
    if (def) setCategoryId(def.id);
  }, [open, recordAs, catsIncome, catsExpense]);

  if (!open || !wallet) return null;

  const handleStep1Next = (e: React.FormEvent) => {
    e.preventDefault();
    if (newBalance == null) {
      toast.error(t("modal.invalidBalance"));
      return;
    }
    if (delta === 0) {
      toast.message(t("modal.noChange"));
      onClose();
      return;
    }
    setStep(2);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (newBalance == null) {
      toast.error(t("modal.invalidBalance"));
      return;
    }
    if (delta === 0) {
      toast.message(t("modal.noChange"));
      onClose();
      return;
    }
    if (!recordAs) {
      toast.error(t("modal.selectRecordAs"));
      return;
    }
    if (recordAs !== "modified" && !categoryId) {
      toast.error(t("modal.selectCategory"));
      return;
    }

    setSaving(true);
    try {
      await walletsApi.adjustWalletBalance(wallet.id, {
        newBalance,
        recordAs,
        occurredAt,
        ...(recordAs !== "modified" ? { categoryId } : {}),
      });
      bump();
      toast.success(t("modal.adjusted"));
      onSaved?.();
      onClose();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("modal.adjustFailed"));
    } finally {
      setSaving(false);
    }
  };

  const categoryOptions = recordAs === "income" ? catsIncome : catsExpense;
  const deltaLabel =
    delta > 0
      ? t("modal.deltaIncrease", { amount: formatIDR(delta) })
      : t("modal.deltaDecrease", { amount: formatIDR(-delta) });

  return (
    <div className="fixed inset-0 z-[100] flex items-end md:items-center justify-center p-0 md:p-4">
      <button
        type="button"
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        aria-label={t("close")}
        onClick={onClose}
      />
      <AdjustPanel title={t("modal.adjustTitle")} onClose={onClose}>
        {step === 1 ? (
          <form onSubmit={handleStep1Next} className="p-5 space-y-4">
            <p className="text-sm text-white/60">
              {t("modal.currentBalance")}:{" "}
              <span className="text-white font-semibold">{formatIDR(wallet.balance)}</span>
            </p>
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.newBalance")}</label>
              <input
                className="input"
                inputMode="numeric"
                placeholder={t("modal.newBalancePlaceholder")}
                value={newBalanceRaw}
                onChange={(e) => setNewBalanceRaw(sanitizeBalanceInput(e.target.value))}
                autoFocus
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.date")}</label>
              <input
                type="date"
                className="input"
                value={occurredAt}
                onChange={(e) => setOccurredAt(e.target.value)}
              />
            </div>
            {delta !== 0 && newBalance != null && (
              <p className="text-sm text-neon-cyan font-medium">{deltaLabel}</p>
            )}
            <div className="flex gap-2 pt-2">
              <button type="button" className="btn-secondary flex-1" onClick={onClose}>
                {t("cancel")}
              </button>
              <button type="submit" className="btn-primary flex-1">
                {t("modal.next")}
              </button>
            </div>
          </form>
        ) : (
          <form onSubmit={(e) => void handleSubmit(e)} className="p-5 space-y-4">
            <p className="text-sm text-neon-cyan font-medium">{deltaLabel}</p>
            <fieldset className="space-y-2">
              <legend className="text-xs font-semibold text-white/60 mb-2">{t("modal.recordAs")}</legend>
              {allowedRecordAs.includes("income") && (
                <label className="flex items-start gap-2 text-sm cursor-pointer">
                  <input
                    type="radio"
                    name="recordAs"
                    checked={recordAs === "income"}
                    onChange={() => setRecordAs("income")}
                  />
                  <span>{t("modal.recordAsIncome")}</span>
                </label>
              )}
              {allowedRecordAs.includes("expense") && (
                <label className="flex items-start gap-2 text-sm cursor-pointer">
                  <input
                    type="radio"
                    name="recordAs"
                    checked={recordAs === "expense"}
                    onChange={() => setRecordAs("expense")}
                  />
                  <span>{t("modal.recordAsExpense")}</span>
                </label>
              )}
              {allowedRecordAs.includes("modified") && (
                <label className="flex items-start gap-2 text-sm cursor-pointer">
                  <input
                    type="radio"
                    name="recordAs"
                    checked={recordAs === "modified"}
                    onChange={() => setRecordAs("modified")}
                  />
                  <span>{t("modal.recordAsModified")}</span>
                </label>
              )}
            </fieldset>
            {recordAs !== "modified" && (
              <CategorySelect
                label={t("modal.category")}
                placeholder={tTx("selectPlaceholder")}
                value={categoryId}
                options={categoryOptions}
                onChange={setCategoryId}
              />
            )}
            <div className="flex gap-2 pt-2">
              <button type="button" className="btn-secondary flex-1" onClick={() => setStep(1)} disabled={saving}>
                {t("modal.back")}
              </button>
              <button type="submit" className="btn-primary flex-1 disabled:opacity-50" disabled={saving}>
                {saving ? t("saving") : t("modal.confirm")}
              </button>
            </div>
          </form>
        )}
      </AdjustPanel>
    </div>
  );
}

function AdjustPanel({
  title,
  onClose,
  children,
}: {
  title: string;
  onClose: () => void;
  children: React.ReactNode;
}) {
  return (
    <div className="relative w-full max-w-lg rounded-t-3xl md:rounded-3xl border border-white/15 bg-ink-900/95 backdrop-blur-xl shadow-2xl max-h-[90vh] overflow-y-auto">
      <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
        <h2 className="font-display font-bold text-lg">{title}</h2>
        <button type="button" onClick={onClose} className="p-2 rounded-xl hover:bg-white/10">
          <X className="w-5 h-5" />
        </button>
      </div>
      {children}
    </div>
  );
}

function CategorySelect({
  label,
  placeholder,
  value,
  options,
  onChange,
}: {
  label: string;
  placeholder: string;
  value: string;
  options: catApi.Category[];
  onChange: (id: string) => void;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-white/60 mb-1.5">{label}</label>
      <select className="input" value={value} onChange={(e) => onChange(e.target.value)}>
        <option value="">{placeholder}</option>
        {options.map((c) => (
          <option key={c.id} value={c.id}>
            {c.name}
          </option>
        ))}
      </select>
    </div>
  );
}

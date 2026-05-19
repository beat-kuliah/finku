import { useState } from "react";
import { useTranslation } from "react-i18next";
import { X } from "lucide-react";
import { toast } from "sonner";
import * as walletsApi from "@/api/wallets";
import * as walletGroupsApi from "@/api/walletGroups";
import { useDataVersion } from "@/store/dataVersion";

type Props = {
  open: boolean;
  onClose: () => void;
  groups: walletGroupsApi.WalletGroup[];
  onCreated?: () => void;
};

const GROUP_NONE = "";
const GROUP_NEW = "__new__";

export default function AddWalletModal({ open, onClose, groups, onCreated }: Props) {
  if (!open) return null;
  return <AddWalletForm groups={groups} onClose={onClose} onCreated={onCreated} />;
}

function AddWalletForm({
  groups,
  onClose,
  onCreated,
}: {
  groups: walletGroupsApi.WalletGroup[];
  onClose: () => void;
  onCreated?: () => void;
}) {
  const { t } = useTranslation("wallets");
  const bump = useDataVersion((s) => s.bump);
  const [saving, setSaving] = useState(false);
  const [name, setName] = useState("");
  const [walletType, setWalletType] = useState("cash");
  const [groupChoice, setGroupChoice] = useState(GROUP_NONE);
  const [newGroupName, setNewGroupName] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const walletName = name.trim();
    if (!walletName) {
      toast.error(t("modal.nameRequired"));
      return;
    }
    if (groupChoice === GROUP_NEW && !newGroupName.trim()) {
      toast.error(t("modal.newGroupRequired"));
      return;
    }

    setSaving(true);
    try {
      let groupId: string | null | undefined;
      if (groupChoice === GROUP_NEW) {
        const created = await walletGroupsApi.createWalletGroup({ name: newGroupName.trim() });
        groupId = created.group.id;
      } else if (groupChoice) {
        groupId = groupChoice;
      } else {
        groupId = undefined;
      }

      const body: Parameters<typeof walletsApi.createWallet>[0] = {
        name: walletName,
        walletType,
      };
      if (groupId !== undefined) body.groupId = groupId;

      await walletsApi.createWallet(body);
      bump();
      toast.success(t("modal.added"));
      onCreated?.();
      onClose();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : t("modal.addFailed"));
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
          <h2 className="font-display font-bold text-lg">{t("modal.addTitle")}</h2>
          <button type="button" onClick={onClose} className="p-2 rounded-xl hover:bg-white/10">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={(e) => void handleSubmit(e)} className="p-5 space-y-4">
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.name")}</label>
            <input
              className="input"
              placeholder={t("modal.namePlaceholder")}
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.type")}</label>
            <select className="input" value={walletType} onChange={(e) => setWalletType(e.target.value)}>
              <option value="cash">{t("modal.typeCash")}</option>
              <option value="bank">{t("modal.typeBank")}</option>
              <option value="ewallet">{t("modal.typeEwallet")}</option>
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.group")}</label>
            <select className="input" value={groupChoice} onChange={(e) => setGroupChoice(e.target.value)}>
              <option value={GROUP_NONE}>{t("modal.noGroup")}</option>
              {groups.map((g) => (
                <option key={g.id} value={g.id}>
                  {g.name}
                </option>
              ))}
              <option value={GROUP_NEW}>{t("modal.newGroup")}</option>
            </select>
          </div>
          {groupChoice === GROUP_NEW && (
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">{t("modal.newGroupName")}</label>
              <input
                className="input"
                placeholder={t("modal.newGroupPlaceholder")}
                value={newGroupName}
                onChange={(e) => setNewGroupName(e.target.value)}
              />
            </div>
          )}
          <button type="submit" disabled={saving} className="btn-primary w-full !py-3 disabled:opacity-50">
            {saving ? t("saving") : t("save")}
          </button>
        </form>
      </div>
    </div>
  );
}

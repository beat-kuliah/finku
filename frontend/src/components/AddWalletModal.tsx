import { useEffect, useState } from "react";
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
  const bump = useDataVersion((s) => s.bump);
  const [saving, setSaving] = useState(false);
  const [name, setName] = useState("");
  const [walletType, setWalletType] = useState("cash");
  const [groupChoice, setGroupChoice] = useState(GROUP_NONE);
  const [newGroupName, setNewGroupName] = useState("");

  useEffect(() => {
    if (!open) return;
    setSaving(false);
    setName("");
    setWalletType("cash");
    setGroupChoice(GROUP_NONE);
    setNewGroupName("");
  }, [open]);

  if (!open) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const walletName = name.trim();
    if (!walletName) {
      toast.error("Nama dompet wajib diisi.");
      return;
    }
    if (groupChoice === GROUP_NEW && !newGroupName.trim()) {
      toast.error("Isi nama grup baru atau pilih grup lain.");
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
      toast.success("Dompet ditambahkan.");
      onCreated?.();
      onClose();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Gagal menambah dompet");
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
        onClick={onClose}
      />
      <div className="relative w-full max-w-lg rounded-t-3xl md:rounded-3xl border border-white/15 bg-ink-900/95 backdrop-blur-xl shadow-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
          <h2 className="font-display font-bold text-lg">Tambah dompet</h2>
          <button type="button" onClick={onClose} className="p-2 rounded-xl hover:bg-white/10">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={(e) => void handleSubmit(e)} className="p-5 space-y-4">
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">Nama dompet</label>
            <input
              className="input"
              placeholder="Contoh: BCA, OVO, Dompet utama"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">Tipe</label>
            <select className="input" value={walletType} onChange={(e) => setWalletType(e.target.value)}>
              <option value="cash">Cash</option>
              <option value="bank">Bank</option>
              <option value="ewallet">E-wallet</option>
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/60 mb-1.5">Grup</label>
            <select className="input" value={groupChoice} onChange={(e) => setGroupChoice(e.target.value)}>
              <option value={GROUP_NONE}>— Tanpa grup —</option>
              {groups.map((g) => (
                <option key={g.id} value={g.id}>
                  {g.name}
                </option>
              ))}
              <option value={GROUP_NEW}>+ Buat grup baru</option>
            </select>
          </div>
          {groupChoice === GROUP_NEW && (
            <div>
              <label className="block text-xs font-semibold text-white/60 mb-1.5">Nama grup baru</label>
              <input
                className="input"
                placeholder="Contoh: Operasional, Pribadi"
                value={newGroupName}
                onChange={(e) => setNewGroupName(e.target.value)}
              />
            </div>
          )}
          <button type="submit" disabled={saving} className="btn-primary w-full !py-3 disabled:opacity-50">
            {saving ? "Menyimpan…" : "Simpan"}
          </button>
        </form>
      </div>
    </div>
  );
}

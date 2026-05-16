import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Wallet as WalletIcon } from "lucide-react";
import AppShell from "@/components/AppShell";
import AddWalletModal from "@/components/AddWalletModal";
import EditWalletModal from "@/components/EditWalletModal";
import * as walletsApi from "@/api/wallets";
import * as walletGroupsApi from "@/api/walletGroups";
import { useDataVersion } from "@/store/dataVersion";
import { localeCompareName } from "@/lib/dates";
import { getBcp47Tag } from "@/lib/locale";
import { toast } from "sonner";

const bumpData = () => useDataVersion.getState().bump();

function formatWalletBalance(amount: number): string {
  const value = Math.round(amount).toLocaleString(getBcp47Tag());
  return `Rp ${value}`;
}

type Tab = "active" | "archived";

export default function WalletsPage() {
  const { t } = useTranslation("wallets");
  const version = useDataVersion((s) => s.version);
  const [tab, setTab] = useState<Tab>("active");
  const [activeWallets, setActiveWallets] = useState<walletsApi.Wallet[]>([]);
  const [allForArchived, setAllForArchived] = useState<walletsApi.Wallet[]>([]);
  const [groups, setGroups] = useState<walletGroupsApi.WalletGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [addModalOpen, setAddModalOpen] = useState(false);
  const [editingWallet, setEditingWallet] = useState<walletsApi.Wallet | null>(null);
  const [editingGroupId, setEditingGroupId] = useState<string | null>(null);
  const [editingGroupName, setEditingGroupName] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [a, all, gRes] = await Promise.all([
        walletsApi.listWallets(false),
        walletsApi.listWallets(true),
        walletGroupsApi.listWalletGroups(),
      ]);
      setActiveWallets(a.wallets);
      setAllForArchived(all.wallets);
      setGroups(gRes.groups);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("loadFailed"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, [load, version]);

  const archivedWallets = useMemo(
    () => allForArchived.filter((w) => w.archivedAt),
    [allForArchived],
  );

  const totalActiveBalance = useMemo(
    () => activeWallets.reduce((s, w) => s + w.balance, 0),
    [activeWallets],
  );

  const sortedGroups = useMemo(
    () => [...groups].sort((a, b) => localeCompareName(a.name, b.name)),
    [groups],
  );

  const walletsByGroupId = useMemo(() => {
    const m = new Map<string, walletsApi.Wallet[]>();
    const none: walletsApi.Wallet[] = [];
    for (const w of activeWallets) {
      const gid = w.groupId ?? null;
      if (!gid) {
        none.push(w);
        continue;
      }
      const arr = m.get(gid) ?? [];
      arr.push(w);
      m.set(gid, arr);
    }
    return { map: m, ungrouped: none };
  }, [activeWallets]);

  const startRenameGroup = (g: walletGroupsApi.WalletGroup) => {
    setEditingGroupId(g.id);
    setEditingGroupName(g.name);
  };

  const cancelRenameGroup = () => {
    setEditingGroupId(null);
    setEditingGroupName("");
  };

  const saveRenameGroup = async (id: string) => {
    const name = editingGroupName.trim();
    if (!name) {
      toast.error(t("groupNameEmpty"));
      return;
    }
    try {
      await walletGroupsApi.updateWalletGroup(id, { name });
      bumpData();
      toast.success(t("groupUpdated"));
      cancelRenameGroup();
      void load();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("failed"));
    }
  };

  const handleDeleteGroup = async (g: walletGroupsApi.WalletGroup) => {
    if (!confirm(t("deleteGroupConfirm", { name: g.name }))) return;
    try {
      await walletGroupsApi.deleteWalletGroup(g.id);
      bumpData();
      toast.success(t("groupDeleted"));
      void load();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : t("failed"));
    }
  };

  const list = tab === "active" ? activeWallets : archivedWallets;

  const renderWalletRow = (w: walletsApi.Wallet, showArchive: boolean) => (
    <li
      key={w.id}
      className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-white/10 bg-white/5 px-3 py-2.5"
    >
      <div className="min-w-0">
        <span className="font-medium">{w.name}</span>
        <span className="text-white/50 text-xs ml-2">({w.walletType})</span>
        <p className="text-white/70 font-semibold mt-0.5">{formatWalletBalance(w.balance)}</p>
      </div>
      {showArchive && !w.archivedAt && (
        <div className="flex items-center gap-2 shrink-0">
          <button
            type="button"
            className="text-xs text-white/70 hover:underline"
            onClick={() => setEditingWallet(w)}
          >
            {t("edit")}
          </button>
          <button
            type="button"
            className="text-xs text-amber-300 hover:underline"
            onClick={async () => {
              if (!confirm(t("archiveConfirm", { name: w.name }))) return;
              try {
                await walletsApi.archiveWallet(w.id);
                bumpData();
                toast.success(t("archivedSuccess"));
                void load();
              } catch (e) {
                toast.error(e instanceof Error ? e.message : t("failed"));
              }
            }}
          >
            {t("archive")}
          </button>
        </div>
      )}
      {!showArchive && w.archivedAt && (
        <span className="text-xs text-white/40 shrink-0">{t("archivedLabel")}</span>
      )}
    </li>
  );

  return (
    <>
      <AppShell activeSection="wallets" desktopTitle={t("title")} desktopSubtitle={t("subtitle")}>
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">{t("totalBalance")}</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
              {loading ? "…" : formatWalletBalance(totalActiveBalance)}
            </h1>
            <p className="text-sm text-white/80 mt-2">
              {t("activeWallets", { count: activeWallets.length })}
              {archivedWallets.length > 0 ? t("archivedCount", { count: archivedWallets.length }) : ""}
            </p>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <WalletIcon className="w-3.5 h-3.5" />
            {t("manageWallets")}
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
            {t("active")}
          </button>
          <button
            type="button"
            className={`btn-secondary !py-1.5 !px-3 text-xs ${tab === "archived" ? "ring-1 ring-neon-cyan" : ""}`}
            onClick={() => setTab("archived")}
          >
            {t("archived")}
          </button>
        </div>

        {tab === "active" && (
          <div className="flex justify-end">
            <button type="button" className="btn-primary !py-2 !px-3 text-sm" onClick={() => setAddModalOpen(true)}>
              {t("addWallet")}
            </button>
          </div>
        )}

        {loading && <p className="text-white/50 text-sm">{t("loading")}</p>}
        {!loading && tab === "archived" && list.length === 0 && (
          <p className="text-white/50 text-sm">{t("noArchived")}</p>
        )}
        {!loading && tab === "active" && activeWallets.length === 0 && groups.length === 0 && (
          <p className="text-white/50 text-sm">{t("noActive")}</p>
        )}

        {!loading && tab === "active" && (
          <div className="space-y-6">
            {sortedGroups.map((g) => {
              const inGroup = walletsByGroupId.map.get(g.id) ?? [];
              const subtotal = inGroup.reduce((s, w) => s + w.balance, 0);
              return (
                <div key={g.id} className="space-y-2">
                  <div className="flex flex-wrap items-center justify-between gap-2 border-b border-white/10 pb-2">
                    <div className="min-w-0 flex-1">
                      {editingGroupId === g.id ? (
                        <div className="flex flex-wrap gap-2 items-center">
                          <input
                            className="input !py-1.5 text-sm flex-1 min-w-[140px]"
                            value={editingGroupName}
                            onChange={(e) => setEditingGroupName(e.target.value)}
                            autoFocus
                          />
                          <button
                            type="button"
                            className="btn-primary !py-1.5 !px-2 text-xs"
                            onClick={() => void saveRenameGroup(g.id)}
                          >
                            {t("save")}
                          </button>
                          <button type="button" className="btn-secondary !py-1.5 !px-2 text-xs" onClick={cancelRenameGroup}>
                            {t("cancel")}
                          </button>
                        </div>
                      ) : (
                        <div className="flex flex-wrap items-baseline gap-x-2 gap-y-1">
                          <h2 className="font-display font-bold text-base">{g.name}</h2>
                          <span className="text-neon-cyan font-semibold text-sm">{formatWalletBalance(subtotal)}</span>
                          <span className="text-white/45 text-xs">
                            {t("walletCount", { count: inGroup.length })}
                          </span>
                        </div>
                      )}
                    </div>
                    {editingGroupId !== g.id && (
                      <div className="flex gap-2 shrink-0">
                        <button
                          type="button"
                          className="text-xs text-white/70 hover:underline"
                          onClick={() => startRenameGroup(g)}
                        >
                          {t("rename")}
                        </button>
                        <button
                          type="button"
                          className="text-xs text-rose-300 hover:underline"
                          onClick={() => void handleDeleteGroup(g)}
                        >
                          {t("delete")}
                        </button>
                      </div>
                    )}
                  </div>
                  {inGroup.length === 0 ? (
                    <p className="text-white/40 text-xs pl-1">{t("noWalletsInGroup")}</p>
                  ) : (
                    <ul className="space-y-2 text-sm">{inGroup.map((w) => renderWalletRow(w, true))}</ul>
                  )}
                </div>
              );
            })}

            <div className="space-y-2">
              <div className="flex flex-wrap items-baseline justify-between gap-2 border-b border-white/10 pb-2">
                <h2 className="font-display font-bold text-base text-white/90">{t("ungrouped")}</h2>
                <div className="flex flex-wrap items-baseline gap-2">
                  <span className="text-neon-cyan font-semibold text-sm">
                    {formatWalletBalance(walletsByGroupId.ungrouped.reduce((s, w) => s + w.balance, 0))}
                  </span>
                  <span className="text-white/45 text-xs">
                    {t("walletCount", { count: walletsByGroupId.ungrouped.length })}
                  </span>
                </div>
              </div>
              {walletsByGroupId.ungrouped.length === 0 ? (
                <p className="text-white/40 text-xs pl-1">{t("noUngrouped")}</p>
              ) : (
                <ul className="space-y-2 text-sm">
                  {walletsByGroupId.ungrouped.map((w) => renderWalletRow(w, true))}
                </ul>
              )}
            </div>
          </div>
        )}

        {!loading && tab === "archived" && (
          <ul className="space-y-2 text-sm">
            {list.map((w) => renderWalletRow(w, false))}
          </ul>
        )}
      </section>
      </AppShell>
      <AddWalletModal
        open={addModalOpen}
        onClose={() => setAddModalOpen(false)}
        groups={sortedGroups}
        onCreated={() => {
          void load();
        }}
      />
      <EditWalletModal
        open={!!editingWallet}
        wallet={editingWallet}
        groups={sortedGroups}
        onClose={() => setEditingWallet(null)}
        onSaved={() => {
          void load();
        }}
      />
    </>
  );
}

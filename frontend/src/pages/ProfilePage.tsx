import { useEffect, useState } from "react";
import {
  Bell,
  Moon,
  Shield,
  Smartphone,
  Wallet,
  User,
  Save,
  Check,
  Lock,
  AtSign,
  Link as LinkIcon,
  Unlink,
  Sparkles,
  Eye,
  EyeOff,
} from "lucide-react";
import AppShell from "@/components/AppShell";
import { useTheme } from "@/lib/theme";
import { AuthApiError, useAuth } from "@/store/auth";
import { isGoogleEnabled, signInWithGoogle } from "@/lib/oauth";
import { toast } from "sonner";
import { ApiError } from "@/lib/api";
import * as prefApi from "@/api/preferences";
import * as catApi from "@/api/categories";
import * as accountApi from "@/api/account";

const PROVIDER_LABELS: Record<string, string> = {
  password: "Email & Password",
  google: "Google",
};

export default function ProfilePage() {
  const { isDarkMode, toggleDarkMode, setTheme } = useTheme();
  const user = useAuth((s) => s.user);
  const setUsername = useAuth((s) => s.setUsername);
  const updatePassword = useAuth((s) => s.updatePassword);
  const unlinkProvider = useAuth((s) => s.unlinkProvider);
  const loginWithGoogle = useAuth((s) => s.loginWithGoogle);
  const patchProfile = useAuth((s) => s.patchProfile);

  const [usernameDraft, setUsernameDraft] = useState(user?.username ?? "");
  const [usernameSaving, setUsernameSaving] = useState(false);

  const [pwForm, setPwForm] = useState({
    currentPassword: "",
    newPassword: "",
    confirmNewPassword: "",
  });
  const [showPw, setShowPw] = useState(false);
  const [pwSaving, setPwSaving] = useState(false);

  const [identityBusy, setIdentityBusy] = useState<string | null>(null);

  const [prefs, setPrefs] = useState({
    pushBudgetWarning: true,
    pushReminder: true,
    weeklyReport: false,
    biometric: false,
  });
  const [fin, setFin] = useState({
    monthlyIncome: "" as string,
    payday: "" as string,
    currency: "IDR",
  });
  const [prefsLoading, setPrefsLoading] = useState(false);
  const [saveBusy, setSaveBusy] = useState(false);
  const [catsActive, setCatsActive] = useState<catApi.Category[]>([]);
  const [catsArchived, setCatsArchived] = useState<catApi.Category[]>([]);
  const [catTab, setCatTab] = useState<"active" | "archived">("active");
  const [newCatName, setNewCatName] = useState("");
  const [newCatKind, setNewCatKind] = useState<"income" | "expense">("expense");

  useEffect(() => {
    const timer = window.setTimeout(() => {
      setUsernameDraft(user?.username ?? "");
    }, 0);
    return () => window.clearTimeout(timer);
  }, [user?.username]);

  useEffect(() => {
    if (!user) return;
    const timer = window.setTimeout(() => {
      setFin({
        monthlyIncome: user.monthlyIncome != null ? String(user.monthlyIncome) : "",
        payday: user.payday != null ? String(user.payday) : "",
        currency: user.currency || "IDR",
      });
    }, 0);
    return () => window.clearTimeout(timer);
  }, [user?.monthlyIncome, user?.payday, user?.currency, user]);

  useEffect(() => {
    if (!user) return;
    let c = false;
    void (async () => {
      setPrefsLoading(true);
      try {
        const [p, ca, cz] = await Promise.all([
          prefApi.getPreferences(),
          catApi.listCategories(false),
          catApi.listCategories(true),
        ]);
        if (c) return;
        setPrefs({
          pushBudgetWarning: p.preferences.notifyBudgetWarning,
          pushReminder: p.preferences.notifyReminder,
          weeklyReport: p.preferences.notifyWeeklyReport,
          biometric: window.localStorage.getItem("finku-biometric") === "1",
        });
        if (p.preferences.theme === "dark" || p.preferences.theme === "light") {
          setTheme(p.preferences.theme);
        }
        setCatsActive(ca.categories.filter((x) => !x.archivedAt));
        setCatsArchived(cz.categories.filter((x) => !!x.archivedAt));
      } catch {
        /* ignore */
      } finally {
        if (!c) setPrefsLoading(false);
      }
    })();
    return () => {
      c = true;
    };
  }, [user, setTheme]);

  if (!user) {
    return (
      <AppShell activeSection="profile" desktopTitle="Profile" desktopSubtitle="">
        <div className="card !p-8 text-center text-white/60">Memuat profil…</div>
      </AppShell>
    );
  }

  const providers = user.providers ?? [];
  const hasPassword = user.hasPassword;

  const handleSaveUsername = async () => {
    setUsernameSaving(true);
    try {
      await setUsername(usernameDraft.trim());
      toast.success("Username tersimpan.");
    } catch (err) {
      toast.error(err instanceof AuthApiError ? err.message : "Gagal menyimpan");
    } finally {
      setUsernameSaving(false);
    }
  };

  const handleSavePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (pwForm.newPassword.length < 8) {
      toast.error("Password baru minimal 8 karakter.");
      return;
    }
    if (pwForm.newPassword !== pwForm.confirmNewPassword) {
      toast.error("Konfirmasi password tidak cocok.");
      return;
    }
    setPwSaving(true);
    try {
      await updatePassword({
        currentPassword: hasPassword ? pwForm.currentPassword : undefined,
        newPassword: pwForm.newPassword,
        confirmNewPassword: pwForm.confirmNewPassword,
      });
      toast.success("Password berhasil disimpan.");
      setPwForm({ currentPassword: "", newPassword: "", confirmNewPassword: "" });
    } catch (err) {
      toast.error(err instanceof AuthApiError ? err.message : "Gagal menyimpan");
    } finally {
      setPwSaving(false);
    }
  };

  const handleUnlink = async (provider: string) => {
    if (!confirm(`Lepas akun ${PROVIDER_LABELS[provider] ?? provider}?`)) return;
    setIdentityBusy(provider);
    try {
      await unlinkProvider(provider);
      toast.success(
        `${PROVIDER_LABELS[provider] ?? provider} berhasil dilepas dari akun.`,
      );
    } catch (err) {
      toast.error(err instanceof AuthApiError ? err.message : "Gagal melepas akun");
    } finally {
      setIdentityBusy(null);
    }
  };

  const handleSaveAll = async () => {
    setSaveBusy(true);
    try {
      const mi = fin.monthlyIncome.trim() === "" ? null : Number(fin.monthlyIncome.replace(/\./g, ""));
      const pd = fin.payday.trim() === "" ? null : Number(fin.payday);
      await patchProfile({
        monthlyIncome: mi != null && Number.isFinite(mi) ? mi : null,
        payday: pd != null && Number.isFinite(pd) ? Math.round(pd) : null,
        currency: fin.currency.trim() || undefined,
      });
      await prefApi.patchPreferences({
        notifyBudgetWarning: prefs.pushBudgetWarning,
        notifyReminder: prefs.pushReminder,
        notifyWeeklyReport: prefs.weeklyReport,
        theme: isDarkMode ? "dark" : "light",
      });
      window.localStorage.setItem("finku-biometric", prefs.biometric ? "1" : "0");
      toast.success("Preferensi tersimpan.");
    } catch (err) {
      toast.error(
        err instanceof AuthApiError || err instanceof ApiError
          ? err.message
          : err instanceof Error
            ? err.message
            : "Gagal menyimpan",
      );
    } finally {
      setSaveBusy(false);
    }
  };

  const handleLinkGoogle = async () => {
    setIdentityBusy("google");
    try {
      const idToken = await signInWithGoogle();
      await loginWithGoogle(idToken);
      toast.success("Google berhasil dihubungkan.");
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Gagal hubungkan Google";
      toast.error(msg);
    } finally {
      setIdentityBusy(null);
    }
  };

  return (
    <AppShell
      activeSection="profile"
      desktopTitle="Profile & preferences"
      desktopSubtitle="Akun kamu"
      rightAction={
        <button
          type="button"
          disabled={saveBusy || prefsLoading}
          onClick={() => void handleSaveAll()}
          className="btn-primary !px-4 !py-2 text-sm disabled:opacity-50"
        >
          <Save className="w-4 h-4" />
          {saveBusy ? "Menyimpan…" : "Simpan"}
        </button>
      }
    >
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">Profile</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">
              Halo, {user.name}
            </h1>
            <p className="text-sm text-white/80 mt-2">
              Kelola profil, password, dan akun terhubung di sini.
            </p>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <Check className="w-3.5 h-3.5" />
            {user.username ? `@${user.username}` : "Belum ada username"}
          </div>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <User className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Profil</h2>
          </div>

          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Nama
            </label>
            <input className="input" value={user.name} readOnly disabled />
            <p className="text-[11px] text-white/40 mt-1">Nama belum bisa diubah dari sini.</p>
          </div>

          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Email
            </label>
            <input className="input" value={user.email} readOnly disabled />
          </div>

          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Username
            </label>
            <div className="relative">
              <AtSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
              <input
                className="input !pl-11"
                value={usernameDraft}
                maxLength={32}
                onChange={(e) => {
                  setUsernameDraft(e.target.value.replace(/\s/g, ""));
                }}
                placeholder="username_kamu"
                spellCheck={false}
              />
            </div>
            <button
              onClick={handleSaveUsername}
              disabled={
                usernameSaving ||
                usernameDraft.trim() === (user.username ?? "").trim() ||
                usernameDraft.trim().length < 3
              }
              className="btn-primary !px-3 !py-2 text-xs mt-3 disabled:opacity-60 disabled:cursor-not-allowed"
            >
              {usernameSaving ? (
                <>
                  <Sparkles className="w-3.5 h-3.5 animate-spin" /> Menyimpan...
                </>
              ) : (
                <>
                  <Save className="w-3.5 h-3.5" /> Simpan username
                </>
              )}
            </button>
          </div>
        </div>

        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Lock className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">
              {hasPassword ? "Ganti Password" : "Set Password"}
            </h2>
          </div>
          <p className="text-xs text-white/60">
            {hasPassword
              ? "Masukkan password lama untuk konfirmasi, lalu password baru."
              : "Akun kamu belum punya password (login via social). Set sekarang biar bisa login pakai email/username juga."}
          </p>

          <form onSubmit={handleSavePassword} className="space-y-3">
            {hasPassword && (
              <PasswordField
                label="Password lama"
                value={pwForm.currentPassword}
                show={showPw}
                onToggleShow={() => setShowPw((v) => !v)}
                onChange={(v) => setPwForm((s) => ({ ...s, currentPassword: v }))}
                placeholder="••••••••"
                autoComplete="current-password"
              />
            )}
            <PasswordField
              label="Password baru"
              value={pwForm.newPassword}
              show={showPw}
              onToggleShow={() => setShowPw((v) => !v)}
              onChange={(v) => setPwForm((s) => ({ ...s, newPassword: v }))}
              placeholder="Minimal 8 karakter"
              autoComplete="new-password"
            />
            <PasswordField
              label="Konfirmasi password baru"
              value={pwForm.confirmNewPassword}
              show={showPw}
              onToggleShow={() => setShowPw((v) => !v)}
              onChange={(v) => setPwForm((s) => ({ ...s, confirmNewPassword: v }))}
              placeholder="Ulangi password baru"
              autoComplete="new-password"
            />
            <button
              type="submit"
              disabled={pwSaving}
              className="btn-primary !px-3 !py-2 text-xs disabled:opacity-60 disabled:cursor-not-allowed"
            >
              {pwSaving ? (
                <>
                  <Sparkles className="w-3.5 h-3.5 animate-spin" /> Menyimpan...
                </>
              ) : (
                <>
                  <Save className="w-3.5 h-3.5" /> Simpan password
                </>
              )}
            </button>
          </form>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <LinkIcon className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Akun terhubung</h2>
          </div>
          <p className="text-xs text-white/60">
            Hubungkan akun supaya bisa login lewat berbagai cara.
          </p>

          <div className="space-y-2">
            <ProviderRow
              providerKey="password"
              connected={providers.includes("password")}
              busy={identityBusy === "password"}
              onUnlink={() => handleUnlink("password")}
            />
            {isGoogleEnabled && (
              <ProviderRow
                providerKey="google"
                connected={providers.includes("google")}
                busy={identityBusy === "google"}
                onLink={handleLinkGoogle}
                onUnlink={() => handleUnlink("google")}
              />
            )}
          </div>
        </div>

        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Wallet className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Preferensi Finansial</h2>
          </div>
          <p className="text-xs text-white/60">Disimpan lewat tombol Simpan di header.</p>
          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Pendapatan bulanan (IDR)
            </label>
            <input
              className="input"
              value={fin.monthlyIncome}
              onChange={(e) => setFin((s) => ({ ...s, monthlyIncome: e.target.value }))}
              placeholder="Opsional"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Payday (1–31)
            </label>
            <input
              className="input"
              value={fin.payday}
              onChange={(e) => setFin((s) => ({ ...s, payday: e.target.value }))}
              placeholder="Opsional"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">Currency</label>
            <input
              className="input"
              value={fin.currency}
              onChange={(e) => setFin((s) => ({ ...s, currency: e.target.value.toUpperCase().slice(0, 3) }))}
              maxLength={3}
            />
          </div>
        </div>
      </section>

      <section className="card !p-6 space-y-4">
        <h2 className="font-display font-bold text-xl">Kategori</h2>
        <div className="flex gap-2">
          <button
            type="button"
            className={`btn-secondary !py-1.5 !px-3 text-xs ${catTab === "active" ? "ring-1 ring-neon-cyan" : ""}`}
            onClick={() => setCatTab("active")}
          >
            Aktif
          </button>
          <button
            type="button"
            className={`btn-secondary !py-1.5 !px-3 text-xs ${catTab === "archived" ? "ring-1 ring-neon-cyan" : ""}`}
            onClick={() => setCatTab("archived")}
          >
            Diarsipkan
          </button>
        </div>
        <div className="flex flex-wrap gap-2 items-end">
          <input
            className="input flex-1 min-w-[140px]"
            placeholder="Nama kategori"
            value={newCatName}
            onChange={(e) => setNewCatName(e.target.value)}
          />
          <select
            className="input !w-auto"
            value={newCatKind}
            onChange={(e) => setNewCatKind(e.target.value as "income" | "expense")}
          >
            <option value="expense">Expense</option>
            <option value="income">Income</option>
          </select>
          <button
            type="button"
            className="btn-primary !py-2 !px-3 text-sm"
            onClick={async () => {
              const n = newCatName.trim();
              if (!n) return;
              try {
                await catApi.createCategory({ name: n, kind: newCatKind });
                setNewCatName("");
                const [ca, cz] = await Promise.all([catApi.listCategories(false), catApi.listCategories(true)]);
                setCatsActive(ca.categories.filter((x) => !x.archivedAt));
                setCatsArchived(cz.categories.filter((x) => !!x.archivedAt));
                toast.success("Kategori ditambahkan.");
              } catch (e) {
                toast.error(e instanceof Error ? e.message : "Gagal");
              }
            }}
          >
            Tambah
          </button>
        </div>
        <ul className="space-y-2 text-sm max-h-56 overflow-y-auto">
          {(catTab === "active" ? catsActive : catsArchived).map((c) => (
            <li key={c.id} className="flex items-center justify-between rounded-xl border border-white/10 bg-white/5 px-3 py-2">
              <span>
                {c.icon ? `${c.icon} ` : ""}
                {c.name} <span className="text-white/50">({c.kind})</span>
              </span>
              {catTab === "active" ? (
                <button
                  type="button"
                  className="text-xs text-amber-300 hover:underline"
                  onClick={async () => {
                    try {
                      await catApi.archiveCategory(c.id);
                      const [ca, cz] = await Promise.all([catApi.listCategories(false), catApi.listCategories(true)]);
                      setCatsActive(ca.categories.filter((x) => !x.archivedAt));
                      setCatsArchived(cz.categories.filter((x) => !!x.archivedAt));
                      toast.success("Kategori diarsipkan.");
                    } catch (e) {
                      toast.error(e instanceof Error ? e.message : "Gagal");
                    }
                  }}
                >
                  Arsipkan
                </button>
              ) : (
                <button
                  type="button"
                  className="text-xs text-neon-lime hover:underline"
                  onClick={async () => {
                    try {
                      await catApi.unarchiveCategory(c.id);
                      const [ca, cz] = await Promise.all([catApi.listCategories(false), catApi.listCategories(true)]);
                      setCatsActive(ca.categories.filter((x) => !x.archivedAt));
                      setCatsArchived(cz.categories.filter((x) => !!x.archivedAt));
                      toast.success("Kategori dipulihkan.");
                    } catch (e) {
                      toast.error(e instanceof Error ? e.message : "Gagal");
                    }
                  }}
                >
                  Batalkan arsip
                </button>
              )}
            </li>
          ))}
        </ul>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Bell className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Notifikasi</h2>
          </div>

          <SwitchRow
            title="Budget warning"
            desc="Kasih peringatan kalau spending hampir lewat limit."
            checked={prefs.pushBudgetWarning}
            onChange={(checked) => setPrefs((s) => ({ ...s, pushBudgetWarning: checked }))}
          />
          <SwitchRow
            title="Reminder catat transaksi"
            desc="Pengingat harian buat update pengeluaran kamu."
            checked={prefs.pushReminder}
            onChange={(checked) => setPrefs((s) => ({ ...s, pushReminder: checked }))}
          />
          <SwitchRow
            title="Weekly report"
            desc="Kirim rangkuman finansial tiap Minggu malam."
            checked={prefs.weeklyReport}
            onChange={(checked) => setPrefs((s) => ({ ...s, weeklyReport: checked }))}
          />
        </div>

        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Shield className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Keamanan & Tampilan</h2>
          </div>

          <SwitchRow
            title="Dark mode"
            desc="Gunakan tema gelap sebagai tampilan utama."
            checked={isDarkMode}
            onChange={toggleDarkMode}
            icon={<Moon className="w-4 h-4 text-white/60" />}
          />
          <SwitchRow
            title="Biometric lock"
            desc="Minta Face ID / Fingerprint saat buka app."
            checked={prefs.biometric}
            onChange={(checked) => setPrefs((s) => ({ ...s, biometric: checked }))}
            icon={<Smartphone className="w-4 h-4 text-white/60" />}
          />

          <div className="rounded-2xl border border-red-500/30 bg-red-500/10 p-4 mt-4">
            <p className="font-semibold text-red-300">Danger Zone</p>
            <p className="text-xs text-red-200/80 mt-1">
              Reset semua data transaksi dan budget (aksi permanen).
            </p>
            <button
              type="button"
              className="mt-3 px-3 py-2 rounded-xl text-sm font-semibold border border-red-400/40 text-red-200 hover:bg-red-500/20 transition-colors"
              onClick={async () => {
                if (!confirm("Hapus semua transaksi, budget, goals, kategori & dompet lalu buat ulang default?")) return;
                try {
                  await accountApi.resetFinancialData();
                  toast.success("Data finansial direset.");
                  const [ca, cz] = await Promise.all([
                    catApi.listCategories(false),
                    catApi.listCategories(true),
                  ]);
                  setCatsActive(ca.categories.filter((x) => !x.archivedAt));
                  setCatsArchived(cz.categories.filter((x) => !!x.archivedAt));
                } catch (e) {
                  toast.error(e instanceof Error ? e.message : "Gagal reset");
                }
              }}
            >
              Reset Data
            </button>
          </div>
        </div>
      </section>
    </AppShell>
  );
}

function PasswordField({
  label,
  value,
  onChange,
  show,
  onToggleShow,
  placeholder,
  autoComplete,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  show: boolean;
  onToggleShow: () => void;
  placeholder?: string;
  autoComplete?: string;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
        {label}
      </label>
      <div className="relative">
        <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
        <input
          type={show ? "text" : "password"}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          autoComplete={autoComplete}
          className="input !pl-11 !pr-12"
        />
        <button
          type="button"
          onClick={onToggleShow}
          className="absolute right-4 top-1/2 -translate-y-1/2 text-white/40 hover:text-white/80 transition-colors"
          aria-label="toggle password"
        >
          {show ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
        </button>
      </div>
    </div>
  );
}

function ProviderRow({
  providerKey,
  connected,
  busy,
  onLink,
  onUnlink,
}: {
  providerKey: string;
  connected: boolean;
  busy: boolean;
  onLink?: () => void;
  onUnlink: () => void;
}) {
  const label = PROVIDER_LABELS[providerKey] ?? providerKey;
  return (
    <div className="rounded-2xl border border-white/10 bg-white/5 p-4 flex items-center justify-between gap-3">
      <div>
        <p className="font-semibold">{label}</p>
        <p className="text-xs text-white/60">
          {connected ? "Tersambung" : "Belum terhubung"}
        </p>
      </div>
      {connected ? (
        <button
          onClick={onUnlink}
          disabled={busy}
          className="px-3 py-2 rounded-xl text-xs font-semibold border border-white/15 text-white/80 hover:bg-white/10 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
        >
          {busy ? (
            <Sparkles className="w-3.5 h-3.5 animate-spin" />
          ) : (
            <span className="inline-flex items-center gap-1.5">
              <Unlink className="w-3.5 h-3.5" /> Lepas
            </span>
          )}
        </button>
      ) : onLink ? (
        <button
          onClick={onLink}
          disabled={busy}
          className="btn-primary !px-3 !py-2 text-xs disabled:opacity-60 disabled:cursor-not-allowed"
        >
          {busy ? (
            <Sparkles className="w-3.5 h-3.5 animate-spin" />
          ) : (
            <span className="inline-flex items-center gap-1.5">
              <LinkIcon className="w-3.5 h-3.5" /> Hubungkan
            </span>
          )}
        </button>
      ) : null}
    </div>
  );
}

function SwitchRow({
  title,
  desc,
  checked,
  onChange,
  icon,
}: {
  title: string;
  desc: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
  icon?: React.ReactNode;
}) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/5 p-4 flex items-start justify-between gap-3">
      <div>
        <div className="flex items-center gap-2">
          {icon}
          <p className="font-semibold">{title}</p>
        </div>
        <p className="text-xs text-white/60 mt-1">{desc}</p>
      </div>
      <button
        onClick={() => onChange(!checked)}
        className={`w-12 h-7 rounded-full p-1 transition-colors ${checked ? "bg-gradient-neon" : "bg-white/15"}`}
      >
        <span
          className={`block w-5 h-5 rounded-full bg-white transition-transform ${checked ? "translate-x-5" : "translate-x-0"}`}
        />
      </button>
    </div>
  );
}

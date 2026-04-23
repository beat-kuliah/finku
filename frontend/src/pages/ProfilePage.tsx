import { useState } from "react";
import { Bell, Moon, Shield, Smartphone, Wallet, User, Save, Check } from "lucide-react";
import AppShell from "@/components/AppShell";
import { useTheme } from "@/lib/theme";

type FormState = {
  name: string;
  email: string;
  monthlyIncome: string;
  payday: string;
  currency: string;
};

export default function ProfilePage() {
  const { isDarkMode, toggleDarkMode } = useTheme();
  const [form, setForm] = useState<FormState>({
    name: "Kania Putri",
    email: "kania@email.com",
    monthlyIncome: "5000000",
    payday: "25",
    currency: "IDR",
  });

  const [prefs, setPrefs] = useState({
    pushBudgetWarning: true,
    pushReminder: true,
    weeklyReport: false,
    biometric: false,
  });

  const handleSave = () => {
    alert("Profile berhasil disimpan (mock) ✅");
  };

  return (
    <AppShell
      activeSection="profile"
      desktopTitle="Profile & preferences"
      desktopSubtitle="Akun kamu"
      rightAction={
        <button onClick={handleSave} className="btn-primary !px-4 !py-2 text-sm">
          <Save className="w-4 h-4" />
          Simpan
        </button>
      }
    >
      <section className="card !p-6 md:!p-7 bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/80 font-semibold">Profile</p>
            <h1 className="font-display text-3xl md:text-4xl font-extrabold mt-1">Akun & preferensi kamu</h1>
            <p className="text-sm text-white/80 mt-2">
              Kelola profil, preferensi finansial, notifikasi, dan keamanan dalam satu tempat.
            </p>
          </div>
          <div className="chip !bg-white/20 !border-white/30 !text-white">
            <Check className="w-3.5 h-3.5" />
            Auto-save off (manual)
          </div>
        </div>
      </section>

      <section className="grid lg:grid-cols-2 gap-5">
        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <User className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Profil</h2>
          </div>

          <Field label="Nama" value={form.name} onChange={(v) => setForm((s) => ({ ...s, name: v }))} />
          <Field label="Email" type="email" value={form.email} onChange={(v) => setForm((s) => ({ ...s, email: v }))} />
        </div>

        <div className="card !p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Wallet className="w-4 h-4 text-neon-pink" />
            <h2 className="font-display font-bold text-xl">Preferensi Finansial</h2>
          </div>

          <Field
            label="Income bulanan"
            value={form.monthlyIncome}
            onChange={(v) => setForm((s) => ({ ...s, monthlyIncome: v }))}
          />
          <Field
            label="Tanggal gajian"
            value={form.payday}
            onChange={(v) => setForm((s) => ({ ...s, payday: v }))}
          />

          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Mata uang
            </label>
            <select
              className="input"
              value={form.currency}
              onChange={(e) => setForm((s) => ({ ...s, currency: e.target.value }))}
            >
              <option value="IDR" className="bg-ink-800">IDR - Rupiah</option>
              <option value="USD" className="bg-ink-800">USD - Dollar</option>
              <option value="SGD" className="bg-ink-800">SGD - Singapore Dollar</option>
            </select>
          </div>
        </div>
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
            <button className="mt-3 px-3 py-2 rounded-xl text-sm font-semibold border border-red-400/40 text-red-200 hover:bg-red-500/20 transition-colors">
              Reset Data
            </button>
          </div>
        </div>
      </section>
    </AppShell>
  );
}

function Field({
  label,
  value,
  onChange,
  type = "text",
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  type?: string;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
        {label}
      </label>
      <input className="input" type={type} value={value} onChange={(e) => onChange(e.target.value)} />
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

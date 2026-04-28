import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AuthApiError, useAuth } from "@/store/auth";
import { motion } from "framer-motion";
import {
  Eye,
  EyeOff,
  Mail,
  Lock,
  User,
  ArrowRight,
  Sparkles,
  Check,
  Gift,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";

export default function RegisterPage() {
  const navigate = useNavigate();
  const register = useAuth((s) => s.register);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [agreed, setAgreed] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
  });

  const pwStrength = passwordStrength(form.password);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!agreed) {
      alert("Centang dulu syarat & kebijakan privasinya ya 😉");
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await register(form.name, form.email, form.password);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      if (err instanceof AuthApiError) {
        if (err.status === 409) {
          setError("Email ini sudah terdaftar. Coba login atau pakai email lain.");
        } else if (err.status === 429) {
          setError("Terlalu banyak percobaan. Coba lagi nanti.");
        } else {
          setError(err.message);
        }
      } else {
        setError("Gagal menghubungi server. Pastikan backend jalan.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="relative min-h-screen flex">
      <BlobBackground />

      {/* LEFT - Brand panel */}
      <aside className="hidden lg:flex flex-col justify-between w-[45%] xl:w-[50%] p-10 relative">
        <Logo size="md" />

        <div className="space-y-6 max-w-md">
          <div className="chip">
            <Gift className="w-3.5 h-3.5 text-neon-pink" />
            <span>Free forever — no credit card needed</span>
          </div>
          <h1 className="font-display font-extrabold text-5xl xl:text-6xl leading-[1.05] text-balance">
            Join <span className="text-gradient">10k+ Gen Z</span> yang udah
            glow up finansialnya
          </h1>

          <ul className="space-y-3 pt-4">
            {[
              "Catat pengeluaran 3 detik, gak ribet",
              "Insight finansial yang gak ngebosenin",
              "Streak & badge biar makin rajin nabung",
              "Aman, private, dan gratis selamanya",
            ].map((item) => (
              <li key={item} className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-lg bg-gradient-neon grid place-items-center flex-shrink-0 mt-0.5 shadow-neon">
                  <Check className="w-3.5 h-3.5 text-white" strokeWidth={3} />
                </div>
                <span className="text-white/80">{item}</span>
              </li>
            ))}
          </ul>

          <div className="card !p-4 flex items-center gap-3 mt-8">
            <div className="flex -space-x-2">
              {["🦄", "🌸", "🐸", "🔥", "💜"].map((e, i) => (
                <div
                  key={i}
                  className="w-8 h-8 rounded-full bg-gradient-to-br from-neon-purple to-neon-pink grid place-items-center text-sm ring-2 ring-ink-900"
                >
                  {e}
                </div>
              ))}
            </div>
            <div className="text-sm">
              <div className="font-semibold">+ 500 baru minggu ini</div>
              <div className="text-xs text-white/50">lagi rame nih 🔥</div>
            </div>
          </div>
        </div>

        <div className="text-xs text-white/40">
          © 2026 FinKu — made with 💙 for Gen Z
        </div>
      </aside>

      {/* RIGHT - Form panel */}
      <main className="flex-1 flex items-center justify-center p-5 md:p-10">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="w-full max-w-md"
        >
          <div className="lg:hidden mb-8 flex justify-center">
            <Logo size="lg" />
          </div>

          <div className="card !p-7 md:!p-9">
            <div className="mb-6">
              <h2 className="font-display font-extrabold text-3xl">
                Bikin akun baru 🚀
              </h2>
              <p className="text-sm text-white/60 mt-1">
                30 detik doang, gak pake ribet!
              </p>
            </div>

            <div className="grid grid-cols-2 gap-3 mb-5">
              <SocialButton provider="google" />
              <SocialButton provider="apple" />
            </div>

            <div className="divider-or mb-5">atau pake email</div>

            {error && (
              <div className="rounded-xl border border-red-500/40 bg-red-500/10 px-4 py-3 text-sm text-red-200">
                {error}
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <Field
                label="Nama kamu"
                icon={<User className="w-4 h-4" />}
                type="text"
                placeholder="Kania Putri"
                value={form.name}
                onChange={(v) => setForm((f) => ({ ...f, name: v }))}
                required
              />

              <Field
                label="Email"
                icon={<Mail className="w-4 h-4" />}
                type="email"
                placeholder="kamu@email.com"
                value={form.email}
                onChange={(v) => setForm((f) => ({ ...f, email: v }))}
                required
              />

              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  Password
                </label>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type={showPassword ? "text" : "password"}
                    required
                    minLength={8}
                    placeholder="Minimal 8 karakter"
                    value={form.password}
                    onChange={(e) =>
                      setForm((f) => ({ ...f, password: e.target.value }))
                    }
                    className="input !pl-11 !pr-12"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword((v) => !v)}
                    className="absolute right-4 top-1/2 -translate-y-1/2 text-white/40 hover:text-white/80 transition-colors"
                    aria-label="toggle password"
                  >
                    {showPassword ? (
                      <EyeOff className="w-4 h-4" />
                    ) : (
                      <Eye className="w-4 h-4" />
                    )}
                  </button>
                </div>
                {form.password && (
                  <div className="mt-2">
                    <div className="flex gap-1 h-1.5">
                      {[1, 2, 3, 4].map((lvl) => (
                        <div
                          key={lvl}
                          className={`flex-1 rounded-full transition-colors ${
                            lvl <= pwStrength.score
                              ? pwStrength.color
                              : "bg-white/10"
                          }`}
                        />
                      ))}
                    </div>
                    <div className="text-[11px] text-white/50 mt-1.5">
                      Kekuatan password:{" "}
                      <span className={pwStrength.textColor}>
                        {pwStrength.label}
                      </span>
                    </div>
                  </div>
                )}
              </div>

              <label className="flex items-start gap-2.5 cursor-pointer group select-none pt-1">
                <input
                  type="checkbox"
                  className="peer sr-only"
                  checked={agreed}
                  onChange={(e) => setAgreed(e.target.checked)}
                />
                <span className="w-5 h-5 rounded-lg border-2 border-white/20 grid place-items-center peer-checked:bg-gradient-neon peer-checked:border-transparent transition-all flex-shrink-0 mt-0.5">
                  <Check
                    className="w-3 h-3 text-white opacity-0 peer-checked:opacity-100"
                    strokeWidth={3}
                  />
                </span>
                <span className="text-sm text-white/70 group-hover:text-white transition-colors leading-relaxed">
                  Aku setuju sama{" "}
                  <a
                    href="#"
                    className="text-gradient-static font-semibold underline"
                  >
                    Syarat Layanan
                  </a>{" "}
                  dan{" "}
                  <a
                    href="#"
                    className="text-gradient-static font-semibold underline"
                  >
                    Kebijakan Privasi
                  </a>{" "}
                  FinKu
                </span>
              </label>

              <button
                type="submit"
                disabled={loading}
                className="btn-primary w-full !py-4 text-base disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <>
                    <Sparkles className="w-4 h-4 animate-spin" />
                    Bikin akunnya...
                  </>
                ) : (
                  <>
                    Mulai Cuan Sekarang
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </form>

            <p className="mt-6 text-center text-sm text-white/60">
              Udah punya akun?{" "}
              <Link
                to="/login"
                className="text-gradient-static font-bold hover:opacity-80"
              >
                Masuk di sini →
              </Link>
            </p>
          </div>
        </motion.div>
      </main>
    </div>
  );
}

function Field({
  label,
  icon,
  type,
  placeholder,
  value,
  onChange,
  required,
}: {
  label: string;
  icon: React.ReactNode;
  type: string;
  placeholder: string;
  value: string;
  onChange: (v: string) => void;
  required?: boolean;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
        {label}
      </label>
      <div className="relative">
        <div className="absolute left-4 top-1/2 -translate-y-1/2 text-white/40">
          {icon}
        </div>
        <input
          type={type}
          required={required}
          placeholder={placeholder}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="input !pl-11"
        />
      </div>
    </div>
  );
}

function passwordStrength(pw: string) {
  if (!pw) return { score: 0, label: "—", color: "bg-white/10", textColor: "text-white/50" };
  let score = 0;
  if (pw.length >= 8) score++;
  if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) score++;
  if (/\d/.test(pw)) score++;
  if (/[^A-Za-z0-9]/.test(pw)) score++;

  const map = [
    { label: "Lemah banget 💀", color: "bg-red-500", textColor: "text-red-400" },
    { label: "Lemah 😬", color: "bg-orange-500", textColor: "text-orange-400" },
    { label: "Lumayan 😐", color: "bg-yellow-500", textColor: "text-yellow-400" },
    { label: "Bagus 💪", color: "bg-neon-lime", textColor: "text-neon-lime" },
    { label: "Mantul! 🔥", color: "bg-gradient-neon", textColor: "text-neon-pink" },
  ];
  return { score, ...map[score] };
}

function SocialButton({ provider }: { provider: "google" | "apple" }) {
  const label = provider === "google" ? "Google" : "Apple";
  return (
    <button
      type="button"
      onClick={() => alert(`${label} sign-up (mock)`)}
      className="flex items-center justify-center gap-2.5 py-3 rounded-2xl bg-white/5 hover:bg-white/10 border border-white/10 transition-all active:scale-95 font-semibold text-sm"
    >
      {provider === "google" ? <GoogleIcon /> : <AppleIcon />}
      {label}
    </button>
  );
}

function GoogleIcon() {
  return (
    <svg viewBox="0 0 24 24" className="w-5 h-5">
      <path
        fill="#EA4335"
        d="M12 10.2v3.9h5.5c-.24 1.4-1.6 4.1-5.5 4.1a6.2 6.2 0 110-12.4 5.6 5.6 0 013.9 1.5l2.7-2.6A9.6 9.6 0 0012 2a10 10 0 100 20c5.8 0 9.6-4.1 9.6-9.8 0-.7-.1-1.2-.2-2H12z"
      />
    </svg>
  );
}

function AppleIcon() {
  return (
    <svg viewBox="0 0 24 24" className="w-5 h-5" fill="currentColor">
      <path d="M16.37 1.43c.05.13.07.33.05.6-.07 1-.5 1.95-1.27 2.87-.87 1.06-1.92 1.67-3.07 1.57a3.1 3.1 0 010-.6c.08-.8.45-1.63 1.1-2.5.33-.45.75-.82 1.27-1.12.5-.29 1-.45 1.47-.48.22-.01.38 0 .45.03v-.37zM20.7 17.13c-.4.93-.86 1.8-1.39 2.59-.73 1.08-1.32 1.83-1.77 2.24-.7.65-1.44.98-2.24 1a5.3 5.3 0 01-2.07-.5c-.67-.32-1.28-.5-1.84-.5-.58 0-1.2.18-1.9.5-.68.32-1.23.49-1.66.52-.77.03-1.53-.3-2.28-.99-.49-.45-1.11-1.23-1.85-2.33-.8-1.17-1.45-2.53-1.97-4.08C1.13 13.89.77 12.26.77 10.67c0-1.81.39-3.37 1.17-4.69a6.9 6.9 0 012.45-2.49c1.01-.59 2.1-.9 3.28-.92.55 0 1.27.2 2.16.58.88.38 1.45.58 1.7.58.17 0 .79-.23 1.86-.68 1-.42 1.86-.6 2.56-.54 1.9.15 3.33.9 4.28 2.25a5.85 5.85 0 00-2.52 5.09c.03 1.5.51 2.75 1.45 3.74.43.45.9.8 1.43 1.05-.12.33-.24.65-.37.96z" />
    </svg>
  );
}

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
  AtSign,
  ArrowRight,
  Sparkles,
  Check,
  Gift,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";
import { isGoogleEnabled, signInWithGoogle } from "@/lib/oauth";

const USERNAME_RE = /^[a-zA-Z0-9_]{3,32}$/;

export default function RegisterPage() {
  const navigate = useNavigate();
  const register = useAuth((s) => s.register);
  const loginWithGoogle = useAuth((s) => s.loginWithGoogle);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [oauthLoading, setOauthLoading] = useState<"google" | null>(null);
  const [agreed, setAgreed] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    name: "",
    username: "",
    email: "",
    password: "",
  });

  const pwStrength = passwordStrength(form.password);
  const usernameInvalid = form.username.length > 0 && !USERNAME_RE.test(form.username);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!agreed) {
      alert("Centang dulu syarat & kebijakan privasinya ya 😉");
      return;
    }
    if (!USERNAME_RE.test(form.username)) {
      setError("Username harus 3-32 karakter, hanya huruf, angka, dan underscore.");
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await register(form.name, form.username, form.email, form.password);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      if (err instanceof AuthApiError) {
        if (err.code === "USERNAME_TAKEN") {
          setError("Username sudah dipakai. Coba yang lain.");
        } else if (err.code === "EMAIL_TAKEN" || err.status === 409) {
          setError("Email atau username sudah terdaftar. Coba login atau pakai yang lain.");
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

  const handleGoogle = async () => {
    setError(null);
    setOauthLoading("google");
    try {
      const idToken = await signInWithGoogle();
      await loginWithGoogle(idToken);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Login Google gagal.";
      setError(msg);
    } finally {
      setOauthLoading(null);
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

            {isGoogleEnabled && (
              <>
                <div className="mb-5">
                  <SocialButton
                    loading={oauthLoading === "google"}
                    disabled={oauthLoading !== null}
                    onClick={handleGoogle}
                  />
                </div>

                <div className="divider-or mb-5">atau pake email</div>
              </>
            )}

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

              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  Username
                </label>
                <div className="relative">
                  <AtSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type="text"
                    required
                    minLength={3}
                    maxLength={32}
                    placeholder="kania_putri"
                    value={form.username}
                    onChange={(e) =>
                      setForm((f) => ({
                        ...f,
                        username: e.target.value.replace(/\s/g, ""),
                      }))
                    }
                    autoComplete="username"
                    spellCheck={false}
                    className="input !pl-11"
                  />
                </div>
                {usernameInvalid && (
                  <p className="text-[11px] text-red-300 mt-2">
                    3-32 karakter, hanya huruf, angka, dan underscore.
                  </p>
                )}
              </div>

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

function SocialButton({
  loading,
  disabled,
  onClick,
}: {
  loading?: boolean;
  disabled?: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled || loading}
      className="w-full flex items-center justify-center gap-2.5 py-3 rounded-2xl bg-white/5 hover:bg-white/10 border border-white/10 transition-all active:scale-95 font-semibold text-sm disabled:opacity-60 disabled:cursor-not-allowed"
    >
      {loading ? <Sparkles className="w-4 h-4 animate-spin" /> : <GoogleIcon />}
      Lanjut dengan Google
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

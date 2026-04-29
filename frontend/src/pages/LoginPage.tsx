import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AuthApiError, useAuth } from "@/store/auth";
import { motion } from "framer-motion";
import {
  Eye,
  EyeOff,
  Lock,
  ArrowRight,
  Sparkles,
  Flame,
  AtSign,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";
import { isGoogleEnabled, signInWithGoogle } from "@/lib/oauth";

export default function LoginPage() {
  const navigate = useNavigate();
  const login = useAuth((s) => s.login);
  const loginWithGoogle = useAuth((s) => s.loginWithGoogle);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [oauthLoading, setOauthLoading] = useState<"google" | null>(null);
  const [form, setForm] = useState({ identifier: "", password: "" });
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await login(form.identifier, form.password);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      if (err instanceof AuthApiError) {
        if (err.status === 429) {
          setError("Terlalu banyak percobaan. Coba lagi nanti.");
        } else if (err.status === 423) {
          setError("Akun terkunci sementara karena terlalu banyak gagal login. Coba lagi dalam 15 menit.");
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

      {/* LEFT - Brand panel (hidden on mobile) */}
      <aside className="hidden lg:flex flex-col justify-between w-[45%] xl:w-[50%] p-10 relative">
        <Logo size="md" />

        <div className="space-y-6 max-w-md">
          <div className="chip">
            <Flame className="w-3.5 h-3.5 text-neon-lime" />
            <span>Welcome back, bestie</span>
          </div>
          <h1 className="font-display font-extrabold text-5xl xl:text-6xl leading-[1.05] text-balance">
            Lanjutin <span className="text-gradient">glow up</span> finansial
            kamu
          </h1>
          <p className="text-white/60 text-lg">
            Saldo, budget, dan goals kamu udah nungguin. Login sekarang dan
            lanjutin streak nabung! 🔥
          </p>

          <div className="grid grid-cols-3 gap-3 mt-8">
            {[
              { e: "🔥", l: "7 day streak" },
              { e: "💎", l: "Premium vibes" },
              { e: "📊", l: "Smart insights" },
            ].map((i) => (
              <div key={i.l} className="card !p-4 text-center">
                <div className="text-2xl mb-1">{i.e}</div>
                <div className="text-xs text-white/70">{i.l}</div>
              </div>
            ))}
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
            <div className="flex items-center justify-between mb-6">
              <div>
                <h2 className="font-display font-extrabold text-3xl">
                  Masuk dulu yuk 👋
                </h2>
                <p className="text-sm text-white/60 mt-1">
                  Selamat datang balik, kangen kami gak?
                </p>
              </div>
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

                <div className="divider-or mb-5">atau</div>
              </>
            )}

            {error && (
              <div className="rounded-xl border border-red-500/40 bg-red-500/10 px-4 py-3 text-sm text-red-200">
                {error}
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  Email atau Username
                </label>
                <div className="relative">
                  <AtSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type="text"
                    required
                    autoComplete="username"
                    placeholder="kamu@email.com / username"
                    value={form.identifier}
                    onChange={(e) =>
                      setForm((f) => ({ ...f, identifier: e.target.value }))
                    }
                    className="input !pl-11"
                  />
                </div>
              </div>

              <div>
                <div className="flex items-center justify-between mb-2">
                  <label className="block text-xs font-semibold text-white/70 uppercase tracking-wider">
                    Password
                  </label>
                  <a
                    href="#"
                    className="text-xs text-neon-pink hover:text-neon-purple font-semibold transition-colors"
                  >
                    Lupa password?
                  </a>
                </div>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type={showPassword ? "text" : "password"}
                    required
                    placeholder="••••••••"
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
              </div>

              <label className="flex items-center gap-2.5 cursor-pointer group select-none">
                <input type="checkbox" className="peer sr-only" />
                <span className="w-5 h-5 rounded-lg border-2 border-white/20 grid place-items-center peer-checked:bg-gradient-neon peer-checked:border-transparent transition-all">
                  <svg
                    className="w-3 h-3 text-white opacity-0 peer-checked:opacity-100"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="3"
                  >
                    <path d="M5 13l4 4L19 7" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                </span>
                <span className="text-sm text-white/70 group-hover:text-white transition-colors">
                  Inget aku, jangan logout
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
                    Lagi masuk...
                  </>
                ) : (
                  <>
                    Masuk sekarang
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </form>

            <p className="mt-6 text-center text-sm text-white/60">
              Belum punya akun?{" "}
              <Link
                to="/register"
                className="text-gradient-static font-bold hover:opacity-80"
              >
                Daftar gratis →
              </Link>
            </p>
          </div>

          <p className="mt-5 text-center text-xs text-white/40 max-w-sm mx-auto">
            Dengan masuk, kamu setuju sama{" "}
            <a href="#" className="underline hover:text-white/70">
              Syarat
            </a>{" "}
            dan{" "}
            <a href="#" className="underline hover:text-white/70">
              Kebijakan Privasi
            </a>{" "}
            kami.
          </p>
        </motion.div>
      </main>
    </div>
  );
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

import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import {
  Eye,
  EyeOff,
  Mail,
  Lock,
  ArrowRight,
  Sparkles,
  Flame,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";

export default function LoginPage() {
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({ email: "", password: "" });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      alert("Login berhasil (mock). Dashboard coming soon! 🚀");
      navigate("/dashboard");
    }, 900);
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

            {/* Social login */}
            <div className="grid grid-cols-2 gap-3 mb-5">
              <SocialButton provider="google" />
              <SocialButton provider="apple" />
            </div>

            <div className="divider-or mb-5">atau</div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  Email
                </label>
                <div className="relative">
                  <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type="email"
                    required
                    placeholder="kamu@email.com"
                    value={form.email}
                    onChange={(e) =>
                      setForm((f) => ({ ...f, email: e.target.value }))
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

function SocialButton({ provider }: { provider: "google" | "apple" }) {
  const label = provider === "google" ? "Google" : "Apple";
  return (
    <button
      type="button"
      onClick={() => alert(`${label} sign-in (mock)`)}
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

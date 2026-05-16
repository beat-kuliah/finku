import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { motion } from "framer-motion";
import {
  ArrowRight,
  Sparkles,
  Wallet,
  Target,
  TrendingUp,
  Flame,
  Zap,
  Heart,
  Bell,
  ShieldCheck,
  Star,
  Play,
  type LucideIcon,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";
import { getBcp47Tag } from "@/lib/locale";

const FEATURE_KEYS = ["track", "budget", "insight", "streak", "notif", "secure"] as const;
const TESTIMONIAL_KEYS = ["kania", "raka", "sasha"] as const;

const featureMeta: Record<
  (typeof FEATURE_KEYS)[number],
  { icon: LucideIcon; gradient: string; emoji: string }
> = {
  track: { icon: Wallet, gradient: "from-neon-pink to-neon-purple", emoji: "💸" },
  budget: { icon: Target, gradient: "from-neon-purple to-neon-cyan", emoji: "🎯" },
  insight: { icon: TrendingUp, gradient: "from-neon-cyan to-neon-lime", emoji: "🧠" },
  streak: { icon: Flame, gradient: "from-neon-orange to-neon-pink", emoji: "🔥" },
  notif: { icon: Bell, gradient: "from-neon-lime to-neon-cyan", emoji: "🔔" },
  secure: { icon: ShieldCheck, gradient: "from-neon-purple to-neon-pink", emoji: "🔒" },
};

const statRows = [
  { valueKey: "valueUsers", labelKey: "users", g: "from-neon-pink to-neon-purple" },
  { valueKey: "valueTracked", labelKey: "tracked", g: "from-neon-purple to-neon-cyan" },
  { valueKey: "valueRating", labelKey: "rating", g: "from-neon-cyan to-neon-lime" },
  { valueKey: "valueUptime", labelKey: "uptime", g: "from-neon-orange to-neon-pink" },
] as const;

export default function LandingPage() {
  const { t } = useTranslation("landing");

  const features = FEATURE_KEYS.map((key) => ({
    key,
    ...featureMeta[key],
    title: t(`features.items.${key}.title`),
    desc: t(`features.items.${key}.desc`),
  }));

  const testimonials = TESTIMONIAL_KEYS.map((key) => ({
    key,
    emoji: t(`testimonials.items.${key}.emoji`),
    name: t(`testimonials.items.${key}.name`),
    role: t(`testimonials.items.${key}.role`),
    text: t(`testimonials.items.${key}.text`),
  }));

  return (
    <div className="relative min-h-screen overflow-x-hidden">
      <BlobBackground />

      <header className="sticky top-0 z-50 backdrop-blur-xl bg-ink-900/50 border-b border-white/5">
        <div className="max-w-6xl mx-auto px-5 h-16 flex items-center justify-between">
          <Logo />
          <nav className="hidden md:flex items-center gap-1">
            <a href="#fitur" className="btn-ghost">
              {t("nav.features")}
            </a>
            <a href="#testimoni" className="btn-ghost">
              {t("nav.testimonials")}
            </a>
            <a href="#harga" className="btn-ghost">
              {t("nav.pricing")}
            </a>
          </nav>
          <div className="flex items-center gap-2">
            <Link to="/login" className="btn-ghost hidden sm:inline-flex">
              {t("nav.login")}
            </Link>
            <Link to="/register" className="btn-primary !py-2 !px-4 text-sm">
              {t("nav.signup")}
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </header>

      <section className="relative">
        <div className="max-w-6xl mx-auto px-5 pt-16 pb-20 md:pt-24 md:pb-28">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="flex flex-col items-center text-center"
          >
            <div className="chip mb-6 animate-pulse-glow">
              <Sparkles className="w-3.5 h-3.5 text-neon-lime" />
              <span>{t("hero.chip")}</span>
            </div>

            <h1 className="font-display font-extrabold text-5xl sm:text-6xl md:text-7xl lg:text-8xl leading-[1.05] tracking-tight text-balance max-w-4xl">
              {t("hero.titleLine1")}{" "}
              <span className="text-gradient">{t("hero.titleHighlight1")}</span>,<br />
              {t("hero.titleLine2")}{" "}
              <span className="relative inline-block">
                <span className="text-gradient">{t("hero.titleHighlight2")}</span>
                <svg
                  className="absolute -bottom-2 left-0 w-full"
                  viewBox="0 0 200 12"
                  fill="none"
                >
                  <path
                    d="M2 8 Q50 2, 100 6 T198 4"
                    stroke="url(#grad)"
                    strokeWidth="3"
                    strokeLinecap="round"
                  />
                  <defs>
                    <linearGradient id="grad" x1="0" x2="1">
                      <stop offset="0%" stopColor="#00f0ff" />
                      <stop offset="100%" stopColor="#1d4ed8" />
                    </linearGradient>
                  </defs>
                </svg>
              </span>
            </h1>

            <p className="mt-7 text-lg md:text-xl text-white/70 max-w-2xl text-balance">
              {t("hero.subtitle")}{" "}
              <span className="text-white font-semibold">{t("hero.subtitleBold")}</span>.
            </p>

            <div className="mt-9 flex flex-col sm:flex-row items-center gap-3">
              <Link to="/register" className="btn-primary !px-7 !py-4 text-base">
                <Zap className="w-5 h-5" />
                {t("hero.ctaPrimary")}
              </Link>
              <Link to="/login" className="btn-secondary !px-7 !py-4 text-base">
                <Play className="w-4 h-4 fill-white" />
                {t("hero.ctaSecondary")}
              </Link>
            </div>

            <div className="mt-8 flex flex-wrap justify-center items-center gap-5 text-sm text-white/50">
              <div className="flex items-center gap-1.5">
                <div className="flex -space-x-2">
                  {["🦄", "🌸", "🐸", "🔥"].map((e, i) => (
                    <div
                      key={i}
                      className="w-7 h-7 rounded-full bg-gradient-to-br from-neon-purple to-neon-pink grid place-items-center text-sm ring-2 ring-ink-900"
                    >
                      {e}
                    </div>
                  ))}
                </div>
                <span className="ml-2">{t("hero.users")}</span>
              </div>
              <div className="flex items-center gap-1">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star
                    key={i}
                    className="w-4 h-4 fill-neon-lime text-neon-lime"
                  />
                ))}
                <span className="ml-1">{t("hero.rating")}</span>
              </div>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="relative mt-16 md:mt-20 flex justify-center"
          >
            <PhoneMockup />
          </motion.div>
        </div>
      </section>

      <section className="relative border-y border-white/5 bg-white/[0.02]">
        <div className="max-w-6xl mx-auto px-5 py-10 grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
          {statRows.map((s) => (
            <div key={s.labelKey}>
              <div
                className={`text-3xl md:text-4xl font-display font-extrabold bg-gradient-to-r ${s.g} bg-clip-text text-transparent`}
              >
                {t(`stats.${s.valueKey}`)}
              </div>
              <div className="text-sm text-white/60 mt-1">{t(`stats.${s.labelKey}`)}</div>
            </div>
          ))}
        </div>
      </section>

      <section id="fitur" className="relative">
        <div className="max-w-6xl mx-auto px-5 py-24">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="text-center max-w-2xl mx-auto mb-14"
          >
            <div className="chip mb-4">
              <Heart className="w-3.5 h-3.5 text-neon-pink" />
              <span>{t("features.chip")}</span>
            </div>
            <h2 className="font-display font-extrabold text-4xl md:text-5xl leading-tight text-balance">
              {t("features.title")}{" "}
              <span className="text-gradient">{t("features.titleHighlight")}</span>{" "}
              {t("features.titleSuffix")}
            </h2>
            <p className="mt-4 text-white/60">{t("features.subtitle")}</p>
          </motion.div>

          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {features.map((f, i) => (
              <motion.div
                key={f.key}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.08 }}
                className="card group hover:bg-white/10 transition-all duration-300 cursor-default"
              >
                <div
                  className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${f.gradient} grid place-items-center mb-4 shadow-neon group-hover:scale-110 group-hover:rotate-6 transition-transform duration-300`}
                >
                  <f.icon className="w-6 h-6 text-white" />
                </div>
                <div className="flex items-center gap-2 mb-1.5">
                  <h3 className="font-display font-bold text-xl">{f.title}</h3>
                  <span className="text-lg">{f.emoji}</span>
                </div>
                <p className="text-white/60 text-sm leading-relaxed">{f.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <section id="testimoni" className="relative">
        <div className="max-w-6xl mx-auto px-5 py-24">
          <div className="text-center mb-14">
            <div className="chip mb-4">
              <Star className="w-3.5 h-3.5 text-neon-lime fill-neon-lime" />
              <span>{t("testimonials.chip")}</span>
            </div>
            <h2 className="font-display font-extrabold text-4xl md:text-5xl leading-tight">
              {t("testimonials.title")}{" "}
              <span className="text-gradient">{t("testimonials.titleHighlight")}</span>
              {t("testimonials.titleSuffix")
                ? ` ${t("testimonials.titleSuffix")}`
                : ""}
            </h2>
          </div>

          <div className="grid md:grid-cols-3 gap-5">
            {testimonials.map((item, i) => (
              <motion.div
                key={item.key}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.1 }}
                className="card relative overflow-hidden"
              >
                <motion.div className="absolute -top-8 -right-8 text-8xl opacity-20">
                  {item.emoji}
                </motion.div>
                <div className="flex gap-1 mb-3">
                  {Array.from({ length: 5 }).map((_, j) => (
                    <Star
                      key={j}
                      className="w-4 h-4 fill-neon-lime text-neon-lime"
                    />
                  ))}
                </div>
                <p className="text-white/80 leading-relaxed mb-4">
                  &ldquo;{item.text}&rdquo;
                </p>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-gradient-neon grid place-items-center font-bold">
                    {item.name[0]}
                  </div>
                  <div>
                    <div className="font-semibold text-sm">{item.name}</div>
                    <div className="text-xs text-white/50">{item.role}</div>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <section id="harga" className="relative">
        <div className="max-w-6xl mx-auto px-5 py-24">
          <div className="relative overflow-hidden rounded-[2.5rem] p-10 md:p-16 text-center bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x shadow-neon">
            <div className="absolute inset-0 grid-bg opacity-30" />
            <div className="relative">
              <div className="chip !bg-black/30 !border-white/20 mb-5">
                <Flame className="w-3.5 h-3.5 text-neon-lime" />
                <span className="text-white">{t("cta.chip")}</span>
              </div>
              <h2 className="font-display font-extrabold text-4xl md:text-6xl leading-tight text-white">
                {t("cta.title")}
              </h2>
              <p className="mt-4 text-white/80 max-w-xl mx-auto">{t("cta.subtitle")}</p>
              <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-3">
                <Link
                  to="/register"
                  className="inline-flex items-center gap-2 px-7 py-4 rounded-2xl bg-white text-ink-900 font-bold hover:scale-105 active:scale-95 transition-transform shadow-xl"
                >
                  {t("cta.signup")}
                  <ArrowRight className="w-5 h-5" />
                </Link>
                <Link
                  to="/login"
                  className="inline-flex items-center gap-2 px-7 py-4 rounded-2xl bg-black/30 text-white font-semibold border border-white/30 hover:bg-black/40 backdrop-blur-sm"
                >
                  {t("cta.login")}
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>

      <footer className="border-t border-white/5">
        <div className="max-w-6xl mx-auto px-5 py-10 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <Logo size="sm" />
            <span className="text-xs text-white/40">{t("footer.copyright")}</span>
          </div>
          <div className="flex items-center gap-1 text-sm">
            <Link to="/login" className="btn-ghost text-xs">
              {t("footer.privacy")}
            </Link>
            <Link to="/login" className="btn-ghost text-xs">
              {t("footer.terms")}
            </Link>
            <a href="mailto:support@finku.app" className="btn-ghost text-xs">
              {t("footer.support")}
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

function PhoneMockup() {
  const { t } = useTranslation("landing");
  const fmtIdr = (n: number) => Math.round(Math.abs(n)).toLocaleString(getBcp47Tag());

  const mockTx = [
    { e: "🍔", key: "tx1" as const, amount: -45000, g: false },
    { e: "☕", key: "tx2" as const, amount: -52000, g: false },
    { e: "💰", key: "tx3" as const, amount: 5000000, g: true },
  ] as const;

  return (
    <div className="relative">
      <div className="absolute -inset-10 bg-gradient-tiktok blur-3xl opacity-30 rounded-full" />
      <div className="relative w-[300px] md:w-[340px] h-[620px] md:h-[700px] rounded-[3rem] bg-ink-800 border-[10px] border-ink-700 shadow-2xl shadow-neon-purple/30 overflow-hidden">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-28 h-6 bg-ink-900 rounded-b-2xl z-10" />

        <div className="w-full h-full p-5 pt-10 overflow-hidden relative bg-ink-900">
          <div className="flex items-center justify-between mb-5">
            <div>
              <div className="text-xs text-white/50">{t("mockup.greeting")}</div>
              <div className="text-sm font-semibold">{t("mockup.date")}</div>
            </div>
            <div className="w-9 h-9 rounded-full bg-gradient-neon grid place-items-center text-sm">
              🦄
            </div>
          </div>

          <div className="rounded-3xl bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x p-5 mb-4 shadow-neon">
            <div className="text-[11px] uppercase tracking-wider text-white/80 font-semibold">
              {t("mockup.balanceLabel")}
            </div>
            <div className="font-display font-extrabold text-3xl mt-1">
              Rp {fmtIdr(3240500)}
            </div>
            <div className="flex items-center gap-2 mt-3 text-xs">
              <div className="chip !bg-white/20 !border-white/30 !text-white">
                <TrendingUp className="w-3 h-3" /> +12%
              </div>
              <span className="text-white/80">{t("mockup.vsLastMonth")}</span>
            </div>
          </div>

          <div className="card !p-4 mb-4 flex items-center gap-4">
            <div className="relative w-16 h-16">
              <svg viewBox="0 0 36 36" className="w-full h-full -rotate-90">
                <circle
                  cx="18"
                  cy="18"
                  r="15.9"
                  fill="none"
                  stroke="rgba(255,255,255,0.1)"
                  strokeWidth="3"
                />
                <circle
                  cx="18"
                  cy="18"
                  r="15.9"
                  fill="none"
                  stroke="url(#ringgrad)"
                  strokeWidth="3"
                  strokeLinecap="round"
                  strokeDasharray="64 100"
                />
                <defs>
                  <linearGradient id="ringgrad">
                    <stop offset="0%" stopColor="#00f0ff" />
                    <stop offset="100%" stopColor="#1d4ed8" />
                  </linearGradient>
                </defs>
              </svg>
              <div className="absolute inset-0 grid place-items-center text-xs font-bold">
                64%
              </div>
            </div>
            <div className="flex-1">
              <div className="text-xs text-white/50">{t("mockup.budgetLabel")}</div>
              <div className="font-semibold">
                Rp {fmtIdr(3200000)} / {fmtIdr(5000000)}
              </div>
              <div className="text-xs text-neon-lime mt-0.5 flex items-center gap-1">
                <Sparkles className="w-3 h-3" /> {t("mockup.onTrack")}
              </div>
            </div>
          </div>

          <div className="text-xs uppercase tracking-wider text-white/50 font-semibold mb-2 px-1">
            {t("mockup.recentTx")}
          </div>
          <div className="space-y-2">
            {mockTx.map((tx) => (
              <div
                key={tx.key}
                className="flex items-center gap-3 p-2.5 rounded-2xl bg-white/5 border border-white/10"
              >
                <div className="w-9 h-9 rounded-xl bg-white/10 grid place-items-center text-lg">
                  {tx.e}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-medium truncate">
                    {t(`mockup.${tx.key}.name`)}
                  </div>
                  <div className="text-[11px] text-white/50">
                    {t(`mockup.${tx.key}.cat`)}
                  </div>
                </div>
                <div
                  className={`text-sm font-bold ${
                    tx.g ? "text-neon-lime" : "text-white"
                  }`}
                >
                  {tx.g ? `+Rp ${fmtIdr(tx.amount)}` : `-Rp ${fmtIdr(tx.amount)}`}
                </div>
              </div>
            ))}
          </div>

          <div className="absolute bottom-5 right-5 w-14 h-14 rounded-full bg-gradient-neon grid place-items-center shadow-neon animate-pulse-glow">
            <span className="text-2xl">+</span>
          </div>
        </div>
      </div>
    </div>
  );
}

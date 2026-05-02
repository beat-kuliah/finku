import { Link } from "react-router-dom";
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
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";

const features = [
  {
    icon: Wallet,
    title: "Catat duit 3 detik",
    desc: "Tap, ketik, selesai. Gak ribet, gak bikin ngantuk.",
    gradient: "from-neon-pink to-neon-purple",
    emoji: "💸",
  },
  {
    icon: Target,
    title: "Budget anti boncos",
    desc: "Kasih limit per kategori, auto-warn kalau mau over.",
    gradient: "from-neon-purple to-neon-cyan",
    emoji: "🎯",
  },
  {
    icon: TrendingUp,
    title: "Insight kayak AI",
    desc: "\"Kopi kamu bulan ini 450k — setara 1 AirPods 😱\"",
    gradient: "from-neon-cyan to-neon-lime",
    emoji: "🧠",
  },
  {
    icon: Flame,
    title: "Streak & badge",
    desc: "Makin rajin catat, makin banyak badge. FOMO-worthy!",
    gradient: "from-neon-orange to-neon-pink",
    emoji: "🔥",
  },
  {
    icon: Bell,
    title: "Notif smart",
    desc: "Ingetin bayar tagihan, reminder nabung, anti lupa.",
    gradient: "from-neon-lime to-neon-cyan",
    emoji: "🔔",
  },
  {
    icon: ShieldCheck,
    title: "Aman & private",
    desc: "Data dienkripsi. Cuma kamu yang bisa liat duit kamu.",
    gradient: "from-neon-purple to-neon-pink",
    emoji: "🔒",
  },
];

const testimonials = [
  {
    name: "Kania, 22",
    role: "Mahasiswi",
    text: "Akhirnya tau kenapa duit bulanan selalu habis sebelum akhir bulan 😭 sekarang bisa nabung buat konser!",
    emoji: "🎤",
  },
  {
    name: "Raka, 24",
    role: "First Jobber",
    text: "UI-nya estetik banget, gak berasa lagi ngatur duit. Kayak main game tapi duitnya beneran nambah.",
    emoji: "🎮",
  },
  {
    name: "Sasha, 20",
    role: "Content Creator",
    text: "Fitur insight-nya savage. Nunjukin kalau aku boros banget di ShopeeLive. Toxic tapi berguna 💀",
    emoji: "💅",
  },
];

export default function LandingPage() {
  return (
    <div className="relative min-h-screen overflow-x-hidden">
      <BlobBackground />

      {/* NAVBAR */}
      <header className="sticky top-0 z-50 backdrop-blur-xl bg-ink-900/50 border-b border-white/5">
        <div className="max-w-6xl mx-auto px-5 h-16 flex items-center justify-between">
          <Logo />
          <nav className="hidden md:flex items-center gap-1">
            <a href="#fitur" className="btn-ghost">Fitur</a>
            <a href="#testimoni" className="btn-ghost">Testimoni</a>
            <a href="#harga" className="btn-ghost">Harga</a>
          </nav>
          <div className="flex items-center gap-2">
            <Link to="/login" className="btn-ghost hidden sm:inline-flex">
              Masuk
            </Link>
            <Link to="/register" className="btn-primary !py-2 !px-4 text-sm">
              Mulai Gratis
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </header>

      {/* HERO */}
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
              <span>Baru launch — gratis selamanya buat early user!</span>
            </div>

            <h1 className="font-display font-extrabold text-5xl sm:text-6xl md:text-7xl lg:text-8xl leading-[1.05] tracking-tight text-balance max-w-4xl">
              Atur duit{" "}
              <span className="text-gradient">anti ribet</span>,<br />
              glow up finansial{" "}
              <span className="relative inline-block">
                <span className="text-gradient">auto.</span>
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
              FinKu bantu kamu track pengeluaran, atur budget, dan capai goals
              finansial — semuanya dalam satu app kekinian yang{" "}
              <span className="text-white font-semibold">super gampang</span>.
            </p>

            <div className="mt-9 flex flex-col sm:flex-row items-center gap-3">
              <Link to="/register" className="btn-primary !px-7 !py-4 text-base">
                <Zap className="w-5 h-5" />
                Mulai Gratis Sekarang
              </Link>
              <Link to="/login" className="btn-secondary !px-7 !py-4 text-base">
                <Play className="w-4 h-4 fill-white" />
                Liat Demo
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
                <span className="ml-2">10k+ Gen Z udah daftar</span>
              </div>
              <div className="flex items-center gap-1">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star
                    key={i}
                    className="w-4 h-4 fill-neon-lime text-neon-lime"
                  />
                ))}
                <span className="ml-1">4.9/5 rating</span>
              </div>
            </div>
          </motion.div>

          {/* PHONE MOCKUP */}
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

      {/* STATS */}
      <section className="relative border-y border-white/5 bg-white/[0.02]">
        <div className="max-w-6xl mx-auto px-5 py-10 grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
          {[
            { n: "10k+", l: "Gen Z user", g: "from-neon-pink to-neon-purple" },
            { n: "500M+", l: "duit tercatat", g: "from-neon-purple to-neon-cyan" },
            { n: "4.9★", l: "App rating", g: "from-neon-cyan to-neon-lime" },
            { n: "24/7", l: "Always on", g: "from-neon-orange to-neon-pink" },
          ].map((s) => (
            <div key={s.l}>
              <div
                className={`text-3xl md:text-4xl font-display font-extrabold bg-gradient-to-r ${s.g} bg-clip-text text-transparent`}
              >
                {s.n}
              </div>
              <div className="text-sm text-white/60 mt-1">{s.l}</div>
            </div>
          ))}
        </div>
      </section>

      {/* FEATURES */}
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
              <span>Kenapa pilih FinKu</span>
            </div>
            <h2 className="font-display font-extrabold text-4xl md:text-5xl leading-tight text-balance">
              Fitur yang bikin kamu{" "}
              <span className="text-gradient">ketagihan</span> nabung
            </h2>
            <p className="mt-4 text-white/60">
              Semua yang kamu butuhin buat jadi financially independent, dalam
              satu app yang asik dipake.
            </p>
          </motion.div>

          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {features.map((f, i) => (
              <motion.div
                key={f.title}
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
                <p className="text-white/60 text-sm leading-relaxed">
                  {f.desc}
                </p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* TESTIMONIALS */}
      <section id="testimoni" className="relative">
        <div className="max-w-6xl mx-auto px-5 py-24">
          <div className="text-center mb-14">
            <div className="chip mb-4">
              <Star className="w-3.5 h-3.5 text-neon-lime fill-neon-lime" />
              <span>Real talk</span>
            </div>
            <h2 className="font-display font-extrabold text-4xl md:text-5xl leading-tight">
              Kata mereka yang udah <span className="text-gradient">cuan</span>
            </h2>
          </div>

          <div className="grid md:grid-cols-3 gap-5">
            {testimonials.map((t, i) => (
              <motion.div
                key={t.name}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.1 }}
                className="card relative overflow-hidden"
              >
                <div className="absolute -top-8 -right-8 text-8xl opacity-20">
                  {t.emoji}
                </div>
                <div className="flex gap-1 mb-3">
                  {Array.from({ length: 5 }).map((_, j) => (
                    <Star
                      key={j}
                      className="w-4 h-4 fill-neon-lime text-neon-lime"
                    />
                  ))}
                </div>
                <p className="text-white/80 leading-relaxed mb-4">
                  "{t.text}"
                </p>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-gradient-neon grid place-items-center font-bold">
                    {t.name[0]}
                  </div>
                  <div>
                    <div className="font-semibold text-sm">{t.name}</div>
                    <div className="text-xs text-white/50">{t.role}</div>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section id="harga" className="relative">
        <div className="max-w-6xl mx-auto px-5 py-24">
          <div className="relative overflow-hidden rounded-[2.5rem] p-10 md:p-16 text-center bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x shadow-neon">
            <div className="absolute inset-0 grid-bg opacity-30" />
            <div className="relative">
              <div className="chip !bg-black/30 !border-white/20 mb-5">
                <Flame className="w-3.5 h-3.5 text-neon-lime" />
                <span className="text-white">Gratis selamanya</span>
              </div>
              <h2 className="font-display font-extrabold text-4xl md:text-6xl leading-tight text-white">
                Siap glow up <br className="md:hidden" />
                finansial kamu?
              </h2>
              <p className="mt-4 text-white/80 max-w-xl mx-auto">
                Daftar sekarang, mulai tracking dalam 30 detik. No credit card,
                no ribet, no drama.
              </p>
              <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-3">
                <Link
                  to="/register"
                  className="inline-flex items-center gap-2 px-7 py-4 rounded-2xl bg-white text-ink-900 font-bold hover:scale-105 active:scale-95 transition-transform shadow-xl"
                >
                  Buat Akun Gratis
                  <ArrowRight className="w-5 h-5" />
                </Link>
                <Link
                  to="/login"
                  className="inline-flex items-center gap-2 px-7 py-4 rounded-2xl bg-black/30 text-white font-semibold border border-white/30 hover:bg-black/40 backdrop-blur-sm"
                >
                  Udah punya akun? Masuk
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="border-t border-white/5">
        <div className="max-w-6xl mx-auto px-5 py-10 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <Logo size="sm" />
            <span className="text-xs text-white/40">
              © 2026 FinKu — made with 💙 for Gen Z
            </span>
          </div>
          <div className="flex items-center gap-1 text-sm">
            <Link to="/login" className="btn-ghost text-xs">
              Privacy
            </Link>
            <Link to="/login" className="btn-ghost text-xs">
              Terms
            </Link>
            <a href="mailto:support@finku.app" className="btn-ghost text-xs">
              Support
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

function PhoneMockup() {
  return (
    <div className="relative">
      <div className="absolute -inset-10 bg-gradient-tiktok blur-3xl opacity-30 rounded-full" />
      <div className="relative w-[300px] md:w-[340px] h-[620px] md:h-[700px] rounded-[3rem] bg-ink-800 border-[10px] border-ink-700 shadow-2xl shadow-neon-purple/30 overflow-hidden">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-28 h-6 bg-ink-900 rounded-b-2xl z-10" />

        <div className="w-full h-full p-5 pt-10 overflow-hidden relative bg-ink-900">
          {/* Mock header */}
          <div className="flex items-center justify-between mb-5">
            <div>
              <div className="text-xs text-white/50">Halo, Kania 👋</div>
              <div className="text-sm font-semibold">Kamis, 23 Apr</div>
            </div>
            <div className="w-9 h-9 rounded-full bg-gradient-neon grid place-items-center text-sm">
              🦄
            </div>
          </div>

          {/* Balance card */}
          <div className="rounded-3xl bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x p-5 mb-4 shadow-neon">
            <div className="text-[11px] uppercase tracking-wider text-white/80 font-semibold">
              Saldo bulan ini
            </div>
            <div className="font-display font-extrabold text-3xl mt-1">
              Rp 3.240.500
            </div>
            <div className="flex items-center gap-2 mt-3 text-xs">
              <div className="chip !bg-white/20 !border-white/30 !text-white">
                <TrendingUp className="w-3 h-3" /> +12%
              </div>
              <span className="text-white/80">vs bulan lalu</span>
            </div>
          </div>

          {/* Budget ring */}
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
              <div className="text-xs text-white/50">Budget bulan ini</div>
              <div className="font-semibold">Rp 3.2jt / 5jt</div>
              <div className="text-xs text-neon-lime mt-0.5 flex items-center gap-1">
                <Sparkles className="w-3 h-3" /> On track!
              </div>
            </div>
          </div>

          {/* Transactions */}
          <div className="text-xs uppercase tracking-wider text-white/50 font-semibold mb-2 px-1">
            Transaksi terbaru
          </div>
          <div className="space-y-2">
            {[
              { e: "🍔", n: "McD Delivery", a: "-45.000", c: "Makan" },
              { e: "☕", n: "Starbucks", a: "-52.000", c: "Jajan" },
              { e: "💰", n: "Gaji April", a: "+5.000.000", c: "Income", g: true },
            ].map((t, i) => (
              <div
                key={i}
                className="flex items-center gap-3 p-2.5 rounded-2xl bg-white/5 border border-white/10"
              >
                <div className="w-9 h-9 rounded-xl bg-white/10 grid place-items-center text-lg">
                  {t.e}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-medium truncate">{t.n}</div>
                  <div className="text-[11px] text-white/50">{t.c}</div>
                </div>
                <div
                  className={`text-sm font-bold ${
                    t.g ? "text-neon-lime" : "text-white"
                  }`}
                >
                  {t.a}
                </div>
              </div>
            ))}
          </div>

          {/* FAB */}
          <div className="absolute bottom-5 right-5 w-14 h-14 rounded-full bg-gradient-neon grid place-items-center shadow-neon animate-pulse-glow">
            <span className="text-2xl">+</span>
          </div>
        </div>
      </div>
    </div>
  );
}

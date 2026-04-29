import { useEffect, useRef, useState, type ReactNode } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import {
  Bell,
  Plus,
  House,
  ReceiptText,
  PiggyBank,
  ChartPie,
  Goal,
  User,
  LogOut,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";
import { useAuth } from "@/store/auth";
import { toast } from "sonner";

type ActiveSection =
  | "dashboard"
  | "transactions"
  | "stats"
  | "budget"
  | "goals"
  | "profile";

type AppShellProps = {
  activeSection: ActiveSection;
  desktopTitle: string;
  desktopSubtitle?: string;
  rightAction?: ReactNode;
  children: ReactNode;
};

const navItems: Array<{
  key: ActiveSection;
  label: string;
  to: string;
  icon: ReactNode;
}> = [
    { key: "dashboard", label: "Dashboard", to: "/dashboard", icon: <House className="w-4 h-4" /> },
    { key: "transactions", label: "Transactions", to: "/transactions", icon: <ReceiptText className="w-4 h-4" /> },
    { key: "stats", label: "Stats", to: "/stats", icon: <ChartPie className="w-4 h-4" /> },
    { key: "budget", label: "Budget", to: "/budget", icon: <PiggyBank className="w-4 h-4" /> },
    { key: "goals", label: "Goals", to: "/goals", icon: <Goal className="w-4 h-4" /> },
    { key: "profile", label: "Profile", to: "/profile", icon: <User className="w-4 h-4" /> },
  ];

export default function AppShell({
  activeSection,
  desktopTitle,
  desktopSubtitle,
  rightAction,
  children,
}: AppShellProps) {
  const navigate = useNavigate();
  const logout = useAuth((s) => s.logout);
  const mobileActive = activeSection === "stats" || activeSection === "goals" ? "dashboard" : activeSection;
  const [mobileSelected, setMobileSelected] = useState<ActiveSection>(mobileActive);
  const navTimeoutRef = useRef<number | null>(null);

  useEffect(() => {
    setMobileSelected(mobileActive);
  }, [mobileActive]);

  useEffect(() => {
    return () => {
      if (navTimeoutRef.current !== null) {
        window.clearTimeout(navTimeoutRef.current);
      }
    };
  }, []);

  const handleLogout = async () => {
    await logout();
    navigate("/login", { replace: true });
  };

  const handleMobileNav = (key: ActiveSection, to: string) => {
    if (mobileSelected === key && mobileActive === key) {
      return;
    }

    if (navTimeoutRef.current !== null) {
      window.clearTimeout(navTimeoutRef.current);
    }

    setMobileSelected(key);
    navTimeoutRef.current = window.setTimeout(() => {
      navigate(to);
    }, 170);
  };

  return (
    <div className="relative min-h-screen pb-24 md:pb-10">
      <BlobBackground />

      <div className="lg:grid lg:grid-cols-[260px_1fr]">
        <aside className="hidden lg:flex lg:flex-col lg:sticky lg:top-0 lg:h-screen border-r border-white/10 bg-ink-900/50 backdrop-blur-xl p-4">
          <div className="px-2 pt-2 pb-4 border-b border-white/10">
            <Logo asLink={false} />
          </div>

          <nav className="mt-4 space-y-1.5">
            {navItems.map((item) => (
              <SidebarNavItem
                key={item.key}
                icon={item.icon}
                label={item.label}
                to={item.to}
                active={activeSection === item.key}
              />
            ))}
          </nav>

          <div className="mt-auto space-y-1.5">
            <SidebarNavItem
              icon={<LogOut className="w-4 h-4" />}
              label="Logout"
              danger
              onClick={handleLogout}
            />
          </div>
        </aside>

        <div className="min-w-0">
          <header className="sticky top-0 z-40 backdrop-blur-xl bg-ink-900/60 border-b border-white/5">
            <div className="max-w-6xl mx-auto px-5 h-16 flex items-center justify-between lg:max-w-none lg:px-6">
              <div className="lg:hidden">
                <Logo />
              </div>
              <div className="hidden lg:block">
                <p className="text-sm text-white/60">{desktopSubtitle ?? "FinKu App"}</p>
                <p className="font-semibold">{desktopTitle}</p>
              </div>
              <div className="flex items-center gap-2">
                {rightAction ?? (
                  <>
                    <button className="w-10 h-10 rounded-xl bg-white/5 border border-white/10 grid place-items-center hover:bg-white/10 transition-colors">
                      <Bell className="w-4 h-4" />
                    </button>
                    <div className="w-10 h-10 rounded-full bg-gradient-neon grid place-items-center font-bold shadow-neon">
                      K
                    </div>
                  </>
                )}
              </div>
            </div>
          </header>

          <main className="max-w-6xl mx-auto px-5 py-6 md:py-8 space-y-5 lg:max-w-none lg:px-6">
            {children}
          </main>
        </div>
      </div>

      <button className="hidden md:grid fixed bottom-8 right-8 w-14 h-14 rounded-full bg-gradient-neon shadow-neon place-items-center animate-pulse-glow z-40">
        <Plus className="w-6 h-6" />
      </button>

      <nav className="fixed bottom-5 inset-x-0 md:hidden z-40 px-4">
        <div className="mx-auto max-w-md">
          <div className="h-[74px] rounded-[2rem] border border-white/20 bg-white/10 backdrop-blur-2xl shadow-[0_20px_40px_-18px_rgba(0,0,0,0.7)] px-2.5 flex items-center justify-between">
            <BottomNavItem
              icon={<House className="w-6 h-6" />}
              label="Home"
              active={mobileSelected === "dashboard"}
              onClick={() => handleMobileNav("dashboard", "/dashboard")}
            />
            <BottomNavItem
              icon={<ReceiptText className="w-6 h-6" />}
              label="Transactions"
              active={mobileSelected === "transactions"}
              onClick={() => handleMobileNav("transactions", "/transactions")}
            />
            <BottomNavCenter />
            <BottomNavItem
              icon={<PiggyBank className="w-6 h-6" />}
              label="Budget"
              active={mobileSelected === "budget"}
              onClick={() => handleMobileNav("budget", "/budget")}
            />
            <BottomNavItem
              icon={<User className="w-6 h-6" />}
              label="Profile"
              active={mobileSelected === "profile"}
              onClick={() => handleMobileNav("profile", "/profile")}
            />
          </div>
        </div>
      </nav>
    </div>
  );
}

function BottomNavItem({
  icon,
  label,
  active = false,
  onClick,
}: {
  icon: ReactNode;
  label: string;
  active?: boolean;
  onClick: () => void;
}) {
  const className = `h-14 rounded-[1.6rem] flex items-center justify-center gap-2.5 transition-all duration-200 ${active
      ? "px-6 bg-[#171a21] border border-white/10 text-white"
      : "w-12 text-white/80 hover:text-white"
    } relative overflow-hidden`;

  return (
    <button type="button" onClick={onClick} className={className}>
      {active && (
        <motion.span
          layoutId="mobile-dock-active-indicator"
          transition={{ type: "spring", stiffness: 420, damping: 34, mass: 0.7 }}
          className="absolute inset-0 rounded-[1.6rem] bg-[#171a21] border border-white/10"
        />
      )}
      <span className="relative z-10 flex items-center gap-2.5">
        {icon}
        {active && <span className="text-sm font-semibold">{label}</span>}
      </span>
    </button>
  );
}

function BottomNavCenter() {
  return (
    <button
      onClick={() => toast.info("Fitur tambah transaksi akan segera aktif ✨")}
      className="w-12 h-12 rounded-2xl grid place-items-center text-white/90 hover:text-white"
    >
      <Plus className="w-7 h-7" />
    </button>
  );
}

function SidebarNavItem({
  icon,
  label,
  active = false,
  danger = false,
  to,
  onClick,
}: {
  icon: ReactNode;
  label: string;
  active?: boolean;
  danger?: boolean;
  to?: string;
  onClick?: () => void | Promise<void>;
}) {
  const stateClass = danger
    ? "text-red-300 hover:text-red-200 hover:bg-red-500/10"
    : active
      ? "bg-gradient-neon text-white shadow-neon"
      : "text-white/70 hover:text-white hover:bg-white/10";

  const className = `w-full flex items-center gap-2.5 px-3 py-2.5 rounded-xl text-sm font-medium transition-colors ${stateClass}`;

  if (to) {
    return (
      <Link to={to} className={className}>
        {icon}
        <span>{label}</span>
      </Link>
    );
  }

  return (
    <button type="button" className={className} onClick={() => void onClick?.()}>
      {icon}
      <span>{label}</span>
    </button>
  );
}

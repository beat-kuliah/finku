import { useEffect, useRef, type ReactNode } from "react";
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
  Wallet,
  MoreHorizontal,
} from "lucide-react";
import Logo from "@/components/Logo";
import BlobBackground from "@/components/BlobBackground";
import AddTransactionModal from "@/components/AddTransactionModal";
import MoreSheet from "@/components/MoreSheet";
import { useAuth } from "@/store/auth";
import { useUIStore } from "@/store/ui";
import { toast } from "sonner";

type ActiveSection =
  | "dashboard"
  | "transactions"
  | "stats"
  | "budget"
  | "goals"
  | "wallets"
  | "profile";

type AppShellProps = {
  activeSection: ActiveSection;
  desktopTitle: string;
  desktopSubtitle?: string;
  rightAction?: ReactNode;
  children: ReactNode;
};

/** Routes opened from the mobile "More" sheet — bottom bar shows this slot as active with the child page name. */
const MORE_MOBILE_SECTIONS: readonly ActiveSection[] = ["stats", "goals", "profile"];

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
    { key: "wallets", label: "Wallets", to: "/wallets", icon: <Wallet className="w-4 h-4" /> },
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
  const user = useAuth((s) => s.user);
  const setAddTxOpen = useUIStore((s) => s.setAddTransactionOpen);
  const setMoreSheetOpen = useUIStore((s) => s.setMoreSheetOpen);
  const openAdd = () => setAddTxOpen(true);
  const initial =
    (user?.name?.trim()?.charAt(0) || user?.email?.charAt(0) || "?").toUpperCase();
  const mobileActive = activeSection;
  const navTimeoutRef = useRef<number | null>(null);

  const moreSlotActive = MORE_MOBILE_SECTIONS.includes(activeSection);
  const moreSlotLabel =
    activeSection === "stats"
      ? "Stats"
      : activeSection === "goals"
        ? "Goals"
        : activeSection === "profile"
          ? "Profile"
          : "More";
  /** Ikon slot More tetap ⋯ — affordance “menu”; nama halaman aktif cukup di label. */
  const moreSlotIcon = <MoreHorizontal className="w-5 h-5" />;

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
    if (mobileActive === key) {
      return;
    }

    if (navTimeoutRef.current !== null) {
      window.clearTimeout(navTimeoutRef.current);
    }

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
                    <button
                      type="button"
                      onClick={() => toast.message("Notifikasi: belum ada push — pengaturan ada di Profil.")}
                      className="w-10 h-10 rounded-xl bg-white/5 border border-white/10 grid place-items-center hover:bg-white/10 transition-colors"
                    >
                      <Bell className="w-4 h-4" />
                    </button>
                    <div className="w-10 h-10 rounded-full bg-gradient-neon grid place-items-center font-bold shadow-neon text-sm">
                      {initial}
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

      <button
        type="button"
        onClick={openAdd}
        className="grid fixed bottom-28 right-5 md:bottom-8 md:right-8 w-14 h-14 rounded-full bg-gradient-neon shadow-neon place-items-center animate-pulse-glow z-50"
        aria-label="Tambah transaksi"
      >
        <Plus className="w-6 h-6" />
      </button>

      <nav className="fixed bottom-5 inset-x-0 md:hidden z-40 px-4">
        <div className="mx-auto max-w-md">
          <div className="min-h-[78px] py-1 rounded-[2rem] border border-white/20 bg-white/10 backdrop-blur-2xl shadow-[0_20px_40px_-18px_rgba(0,0,0,0.7)] px-1.5 flex items-stretch justify-between gap-0.5">
            <BottomNavItem
              icon={<House className="w-5 h-5" />}
              label="Home"
              active={mobileActive === "dashboard"}
              onClick={() => handleMobileNav("dashboard", "/dashboard")}
            />
            <BottomNavItem
              icon={<ReceiptText className="w-5 h-5" />}
              label="Transactions"
              active={mobileActive === "transactions"}
              onClick={() => handleMobileNav("transactions", "/transactions")}
            />
            <BottomNavItem
              icon={<Wallet className="w-5 h-5" />}
              label="Wallets"
              active={mobileActive === "wallets"}
              onClick={() => handleMobileNav("wallets", "/wallets")}
            />
            <BottomNavItem
              icon={<PiggyBank className="w-5 h-5" />}
              label="Budget"
              active={mobileActive === "budget"}
              onClick={() => handleMobileNav("budget", "/budget")}
            />
            <BottomNavItem
              icon={moreSlotIcon}
              label={moreSlotLabel}
              active={moreSlotActive}
              ariaLabel={moreSlotActive ? `${moreSlotLabel}, buka menu lainnya` : "Lainnya"}
              onClick={() => setMoreSheetOpen(true)}
            />
          </div>
        </div>
      </nav>

      <AddTransactionModal />
      <MoreSheet />
    </div>
  );
}

function BottomNavItem({
  icon,
  label,
  active = false,
  ariaLabel,
  onClick,
}: {
  icon: ReactNode;
  label: string;
  active?: boolean;
  ariaLabel?: string;
  onClick: () => void;
}) {
  const className = `min-h-[62px] rounded-[1.35rem] flex items-center justify-center transition-all duration-200 min-w-0 flex-1 ${active
      ? "px-1.5 py-1 bg-[#171a21] border border-white/10 text-white"
      : "px-1 text-white/80 hover:text-white"
    } relative overflow-hidden`;

  return (
    <button type="button" onClick={onClick} className={className} aria-label={ariaLabel ?? label}>
      {active && (
        <motion.span
          layoutId="mobile-dock-active-indicator"
          transition={{ type: "spring", stiffness: 420, damping: 34, mass: 0.7 }}
          className="absolute inset-0 rounded-[1.6rem] bg-[#171a21] border border-white/10"
        />
      )}
      <span
        className={`relative z-10 flex max-w-full items-center justify-center gap-1 ${active ? "flex-col gap-0.5 px-0.5" : ""}`}
      >
        {icon}
        {active && (
          <span className="text-[9px] font-semibold leading-[1.15] text-center whitespace-normal break-words hyphens-none">
            {label}
          </span>
        )}
      </span>
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

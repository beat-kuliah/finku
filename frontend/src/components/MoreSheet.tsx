import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { ChartPie, Goal, LogOut, User, X } from "lucide-react";
import { useAuth } from "@/store/auth";
import { useUIStore } from "@/store/ui";

const rowKeys = [
  { labelKey: "stats" as const, to: "/stats", icon: ChartPie },
  { labelKey: "goals" as const, to: "/goals", icon: Goal },
  { labelKey: "profile" as const, to: "/profile", icon: User },
];

export default function MoreSheet() {
  const { t } = useTranslation("nav");
  const { t: tCommon } = useTranslation("common");
  const open = useUIStore((s) => s.moreSheetOpen);
  const setOpen = useUIStore((s) => s.setMoreSheetOpen);
  const navigate = useNavigate();
  const logout = useAuth((s) => s.logout);

  if (!open) return null;

  const go = (to: string) => {
    setOpen(false);
    navigate(to);
  };

  const handleLogout = async () => {
    setOpen(false);
    await logout();
    navigate("/login", { replace: true });
  };

  return (
    <div className="fixed inset-0 z-[90] md:hidden flex items-end justify-center">
      <button
        type="button"
        aria-label={tCommon("close")}
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={() => setOpen(false)}
      />
      <div className="relative w-full max-w-lg rounded-t-3xl border border-white/15 bg-ink-900/95 backdrop-blur-xl shadow-2xl max-h-[85vh] overflow-hidden animate-slide-up">
        <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
          <h2 className="font-display font-bold text-lg">{t("moreSheetTitle")}</h2>
          <button
            type="button"
            onClick={() => setOpen(false)}
            className="p-2 rounded-xl hover:bg-white/10"
            aria-label={tCommon("close")}
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        <nav className="p-3 pb-6 space-y-1">
          {rowKeys.map(({ labelKey, to, icon: Icon }) => (
            <button
              key={to}
              type="button"
              onClick={() => go(to)}
              className="w-full flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-4 py-3.5 text-left hover:bg-white/10 transition-colors"
            >
              <Icon className="w-5 h-5 text-white/80 shrink-0" />
              <span className="font-semibold">{t(labelKey)}</span>
            </button>
          ))}
          <div className="pt-2 mt-2 border-t border-white/10">
            <button
              type="button"
              onClick={() => void handleLogout()}
              className="w-full flex items-center gap-3 rounded-2xl px-4 py-3.5 text-left text-red-300 hover:text-red-200 hover:bg-red-500/10 transition-colors"
            >
              <LogOut className="w-5 h-5 shrink-0" />
              <span className="font-semibold">{t("logout")}</span>
            </button>
          </div>
        </nav>
      </div>
    </div>
  );
}

import { useEffect, type ReactNode } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { useAuth } from "@/store/auth";
import SetUsernameModal from "@/components/SetUsernameModal";

export default function ProtectedRoute({ children }: { children: ReactNode }) {
  const { t } = useTranslation("common");
  const status = useAuth((s) => s.status);
  const user = useAuth((s) => s.user);
  const bootstrap = useAuth((s) => s.bootstrap);
  const location = useLocation();

  useEffect(() => {
    if (status === "idle") {
      void bootstrap();
    }
  }, [status, bootstrap]);

  if (status === "idle" || status === "loading") {
    return (
      <div className="min-h-screen flex items-center justify-center text-white/70 text-sm">
        {t("loading")}
      </div>
    );
  }

  if (status === "unauthenticated") {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />;
  }

  const needsUsername = !!user && (!user.username || user.username.trim() === "");

  return (
    <>
      {children}
      {needsUsername && <SetUsernameModal />}
    </>
  );
}

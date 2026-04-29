import { Routes, Route, Navigate } from "react-router-dom";
import { Toaster } from "sonner";
import { useTheme } from "@/lib/theme";
import ProtectedRoute from "@/components/ProtectedRoute";
import LandingPage from "./pages/LandingPage";
import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import DashboardPage from "./pages/DashboardPage";
import ProfilePage from "./pages/ProfilePage";
import TransactionsPage from "./pages/TransactionsPage";
import BudgetPage from "./pages/BudgetPage";
import StatsPage from "./pages/StatsPage";
import GoalsPage from "./pages/GoalsPage";

export default function App() {
  const { isDarkMode } = useTheme();
  return (
    <>
      <Toaster
        theme={isDarkMode ? "dark" : "light"}
        position="top-center"
        richColors
      />
      <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />
      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <DashboardPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/transactions"
        element={
          <ProtectedRoute>
            <TransactionsPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/budget"
        element={
          <ProtectedRoute>
            <BudgetPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/stats"
        element={
          <ProtectedRoute>
            <StatsPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/goals"
        element={
          <ProtectedRoute>
            <GoalsPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/profile"
        element={
          <ProtectedRoute>
            <ProfilePage />
          </ProtectedRoute>
        }
      />
      <Route path="/settings" element={<Navigate to="/profile" replace />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
    </>
  );
}

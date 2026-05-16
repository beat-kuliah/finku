import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
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
import { toast } from "sonner";

const USERNAME_RE = /^[a-zA-Z0-9_]{3,32}$/;

export default function RegisterPage() {
  const { t } = useTranslation("auth");
  const navigate = useNavigate();
  const register = useAuth((s) => s.register);
  const loginWithGoogle = useAuth((s) => s.loginWithGoogle);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [oauthLoading, setOauthLoading] = useState<"google" | null>(null);
  const [agreed, setAgreed] = useState(false);
  const [form, setForm] = useState({
    name: "",
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
  });

  const pwStrength = passwordStrength(form.password, t);
  const usernameInvalid = form.username.length > 0 && !USERNAME_RE.test(form.username);
  const passwordsMatch =
    form.confirmPassword.length === 0 || form.password === form.confirmPassword;

  const benefits = [
    t("registerPage.benefit1"),
    t("registerPage.benefit2"),
    t("registerPage.benefit3"),
    t("registerPage.benefit4"),
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!agreed) {
      toast.error(t("register.acceptTerms"));
      return;
    }
    if (!USERNAME_RE.test(form.username)) {
      toast.error(t("register.usernameInvalid"));
      return;
    }
    if (!passwordsMatch) {
      toast.error(t("register.passwordMismatch"));
      return;
    }
    setLoading(true);
    try {
      await register(form.name, form.username, form.email, form.password);
      toast.success(t("register.success"));
      navigate("/dashboard", { replace: true });
    } catch (err) {
      if (err instanceof AuthApiError) {
        if (err.code === "USERNAME_TAKEN") {
          toast.error(t("register.usernameTaken"));
        } else if (err.code === "EMAIL_TAKEN" || err.status === 409) {
          toast.error(t("register.emailTaken"));
        } else if (err.status === 429) {
          toast.error(t("register.tooManyAttempts"));
        } else {
          toast.error(t("register.failed"));
        }
      } else {
        toast.error(t("register.serverError"));
      }
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async () => {
    setOauthLoading("google");
    try {
      const idToken = await signInWithGoogle();
      await loginWithGoogle(idToken);
      toast.success(t("register.googleSuccess"));
      navigate("/dashboard", { replace: true });
    } catch {
      toast.error(t("register.googleFailed"));
    } finally {
      setOauthLoading(null);
    }
  };

  return (
    <div className="relative min-h-screen flex">
      <BlobBackground />

      <aside className="hidden lg:flex flex-col justify-between w-[45%] xl:w-[50%] p-10 relative">
        <Logo size="md" />

        <div className="space-y-6 max-w-md">
          <div className="chip">
            <Gift className="w-3.5 h-3.5 text-neon-pink" />
            <span>{t("registerPage.brandChip")}</span>
          </div>
          <h1 className="font-display font-extrabold text-5xl xl:text-6xl leading-[1.05] text-balance">
            {t("registerPage.brandTitlePrefix")}{" "}
            <span className="text-gradient">{t("registerPage.brandTitleHighlight")}</span>{" "}
            {t("registerPage.brandTitleSuffix")}
          </h1>

          <ul className="space-y-3 pt-4">
            {benefits.map((item) => (
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
              <div className="font-semibold">{t("registerPage.socialProofTitle")}</div>
              <div className="text-xs text-white/50">{t("registerPage.socialProofSubtitle")}</div>
            </div>
          </div>
        </div>

        <div className="text-xs text-white/40">{t("registerPage.copyright")}</div>
      </aside>

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
              <h2 className="font-display font-extrabold text-3xl">{t("registerPage.title")}</h2>
              <p className="text-sm text-white/60 mt-1">{t("registerPage.subtitle")}</p>
            </div>

            {isGoogleEnabled && (
              <>
                <div className="mb-5">
                  <SocialButton
                    label={t("registerPage.googleButton")}
                    loading={oauthLoading === "google"}
                    disabled={oauthLoading !== null}
                    onClick={handleGoogle}
                  />
                </div>

                <div className="divider-or mb-5">{t("registerPage.dividerOr")}</div>
              </>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <Field
                label={t("registerPage.nameLabel")}
                icon={<User className="w-4 h-4" />}
                type="text"
                placeholder={t("registerPage.namePlaceholder")}
                value={form.name}
                onChange={(v) => setForm((f) => ({ ...f, name: v }))}
                required
              />

              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  {t("registerPage.usernameLabel")}
                </label>
                <div className="relative">
                  <AtSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type="text"
                    required
                    minLength={3}
                    maxLength={32}
                    placeholder={t("registerPage.usernamePlaceholder")}
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
                  <p className="text-[11px] text-red-300 mt-2">{t("registerPage.usernameHint")}</p>
                )}
              </div>

              <Field
                label={t("registerPage.emailLabel")}
                icon={<Mail className="w-4 h-4" />}
                type="email"
                placeholder={t("registerPage.emailPlaceholder")}
                value={form.email}
                onChange={(v) => setForm((f) => ({ ...f, email: v }))}
                required
              />

              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  {t("registerPage.passwordLabel")}
                </label>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type={showPassword ? "text" : "password"}
                    required
                    minLength={8}
                    placeholder={t("registerPage.passwordPlaceholder")}
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
                    aria-label={t("registerPage.togglePassword")}
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
                      {t("registerPage.passwordStrength")}{" "}
                      <span className={pwStrength.textColor}>{pwStrength.label}</span>
                    </div>
                  </div>
                )}
              </div>

              <div>
                <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
                  {t("registerPage.confirmPasswordLabel")}
                </label>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
                  <input
                    type="password"
                    required
                    minLength={8}
                    placeholder={t("registerPage.confirmPasswordPlaceholder")}
                    value={form.confirmPassword}
                    onChange={(e) =>
                      setForm((f) => ({
                        ...f,
                        confirmPassword: e.target.value,
                      }))
                    }
                    className="input !pl-11"
                  />
                </div>
                {form.confirmPassword.length > 0 && !passwordsMatch && (
                  <p className="text-[11px] text-red-300 mt-2">
                    {t("registerPage.confirmPasswordMismatch")}
                  </p>
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
                  {t("registerPage.termsPrefix")}{" "}
                  <a
                    href="#"
                    className="text-gradient-static font-semibold underline"
                  >
                    {t("registerPage.terms")}
                  </a>{" "}
                  {t("registerPage.termsAnd")}{" "}
                  <a
                    href="#"
                    className="text-gradient-static font-semibold underline"
                  >
                    {t("registerPage.privacy")}
                  </a>
                  {t("registerPage.termsSuffix") ? ` ${t("registerPage.termsSuffix")}` : ""}
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
                    {t("registerPage.submitting")}
                  </>
                ) : (
                  <>
                    {t("registerPage.submit")}
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </form>

            <p className="mt-6 text-center text-sm text-white/60">
              {t("registerPage.hasAccount")}{" "}
              <Link
                to="/login"
                className="text-gradient-static font-bold hover:opacity-80"
              >
                {t("registerPage.loginLink")}
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

type TFn = (key: string) => string;

function passwordStrength(pw: string, t: TFn) {
  if (!pw) {
    return {
      score: 0,
      label: t("registerPage.passwordStrengthEmpty"),
      color: "bg-white/10",
      textColor: "text-white/50",
    };
  }
  let score = 0;
  if (pw.length >= 8) score++;
  if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) score++;
  if (/\d/.test(pw)) score++;
  if (/[^A-Za-z0-9]/.test(pw)) score++;

  const map = [
    {
      label: t("registerPage.passwordWeak1"),
      color: "bg-red-500",
      textColor: "text-red-400",
    },
    {
      label: t("registerPage.passwordWeak2"),
      color: "bg-orange-500",
      textColor: "text-orange-400",
    },
    {
      label: t("registerPage.passwordFair"),
      color: "bg-yellow-500",
      textColor: "text-yellow-400",
    },
    {
      label: t("registerPage.passwordGood"),
      color: "bg-neon-lime",
      textColor: "text-neon-lime",
    },
    {
      label: t("registerPage.passwordStrong"),
      color: "bg-gradient-neon",
      textColor: "text-neon-pink",
    },
  ];
  return { score, ...map[score] };
}

function SocialButton({
  label,
  loading,
  disabled,
  onClick,
}: {
  label: string;
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

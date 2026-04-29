import { useEffect, useRef, useState } from "react";
import { AtSign, Sparkles, ArrowRight } from "lucide-react";
import { AuthApiError, useAuth } from "@/store/auth";

const USERNAME_RE = /^[a-zA-Z0-9_]{3,32}$/;

function clientValidate(username: string): string | null {
  const u = username.trim();
  if (u.length === 0) return "Username wajib diisi.";
  if (u.length < 3) return "Minimal 3 karakter.";
  if (u.length > 32) return "Maksimal 32 karakter.";
  if (!USERNAME_RE.test(u)) return "Hanya huruf, angka, dan underscore.";
  return null;
}

export default function SetUsernameModal() {
  const setUsername = useAuth((s) => s.setUsername);
  const fetchSuggestion = useAuth((s) => s.fetchUsernameSuggestion);

  const [value, setValue] = useState("");
  const [suggestion, setSuggestion] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loadedSuggestion, setLoadedSuggestion] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      try {
        const s = await fetchSuggestion();
        if (cancelled) return;
        setSuggestion(s);
        setValue((prev) => (prev === "" ? s : prev));
      } catch {
        // Ignore — user can type their own.
      } finally {
        if (!cancelled) setLoadedSuggestion(true);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [fetchSuggestion]);

  useEffect(() => {
    inputRef.current?.focus();
  }, [loadedSuggestion]);

  const clientErr = clientValidate(value);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (clientErr) {
      setError(clientErr);
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await setUsername(value.trim());
    } catch (err) {
      if (err instanceof AuthApiError) {
        setError(err.message);
      } else {
        setError("Gagal menghubungi server.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-5 bg-black/70 backdrop-blur-sm">
      <div className="card !p-7 md:!p-9 w-full max-w-md">
        <div className="mb-5">
          <div className="chip mb-3">
            <Sparkles className="w-3.5 h-3.5 text-neon-pink" />
            <span>Selesaikan profil dulu yuk</span>
          </div>
          <h2 className="font-display font-extrabold text-2xl">
            Pilih username kamu
          </h2>
          <p className="text-sm text-white/60 mt-1">
            Username dipakai buat login dan biar temen bisa nemuin kamu. 3-32
            karakter, huruf/angka/underscore.
          </p>
        </div>

        {error && (
          <div className="rounded-xl border border-red-500/40 bg-red-500/10 px-4 py-3 text-sm text-red-200 mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-semibold text-white/70 mb-2 uppercase tracking-wider">
              Username
            </label>
            <div className="relative">
              <AtSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40" />
              <input
                ref={inputRef}
                type="text"
                required
                placeholder={loadedSuggestion ? "username" : "lagi nyari ide..."}
                value={value}
                onChange={(e) => setValue(e.target.value)}
                className="input !pl-11"
                maxLength={32}
                autoComplete="off"
                spellCheck={false}
              />
            </div>
            {suggestion && value !== suggestion && (
              <button
                type="button"
                onClick={() => setValue(suggestion)}
                className="mt-2 text-xs text-neon-pink hover:text-neon-purple font-semibold transition-colors"
              >
                Pakai saran: <span className="underline">{suggestion}</span>
              </button>
            )}
            {value && clientErr && (
              <p className="text-[11px] text-red-300 mt-2">{clientErr}</p>
            )}
          </div>

          <button
            type="submit"
            disabled={loading || !!clientErr}
            className="btn-primary w-full !py-4 text-base disabled:opacity-60 disabled:cursor-not-allowed"
          >
            {loading ? (
              <>
                <Sparkles className="w-4 h-4 animate-spin" />
                Menyimpan...
              </>
            ) : (
              <>
                Simpan & lanjut
                <ArrowRight className="w-4 h-4" />
              </>
            )}
          </button>
        </form>
      </div>
    </div>
  );
}

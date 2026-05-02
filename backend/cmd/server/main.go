package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"finku/backend/internal/account"
	"finku/backend/internal/auth"
	"finku/backend/internal/budget"
	"finku/backend/internal/cache"
	"finku/backend/internal/category"
	"finku/backend/internal/config"
	"finku/backend/internal/db"
	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/goal"
	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"
	"finku/backend/internal/preferences"
	"finku/backend/internal/summary"
	"finku/backend/internal/token"
	"finku/backend/internal/transaction"
	"finku/backend/internal/wallet"

	"github.com/go-chi/chi/v5"
	chimw "github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		slog.Error("config", "err", err)
		os.Exit(1)
	}
	slog.SetDefault(slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelInfo})))

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	pool, err := db.NewPool(ctx, cfg)
	if err != nil {
		slog.Error("postgres", "err", err)
		os.Exit(1)
	}
	defer pool.Close()

	rdb, err := cache.New(ctx, cfg)
	if err != nil {
		slog.Error("redis", "err", err)
		os.Exit(1)
	}
	defer rdb.Close()

	q := sqlc.New(pool)
	access := token.NewAccessIssuer(cfg.JWTSecret, cfg.AccessTokenTTL)

	var googleVerif auth.GoogleVerifier
	if cfg.GoogleClientID != "" {
		googleVerif = auth.NewGoogleIDTokenVerifier(cfg.GoogleClientID)
	}

	svc := auth.NewService(cfg, q, rdb, access, googleVerif)
	h := auth.NewHandler(cfg, svc)
	authMw := middleware.NewAuth(access, rdb)
	rateMw := middleware.NewRateLimiter(rdb)

	walletSvc := wallet.NewService(q)
	walletH := wallet.NewHandler(walletSvc)
	catSvc := category.NewService(q)
	catH := category.NewHandler(catSvc)
	txSvc := transaction.NewService(q)
	txH := transaction.NewHandler(txSvc)
	budSvc := budget.NewService(q)
	budH := budget.NewHandler(budSvc)
	goalSvc := goal.NewService(q)
	goalH := goal.NewHandler(goalSvc)
	sumSvc := summary.NewService(q)
	sumH := summary.NewHandler(sumSvc)
	prefSvc := preferences.NewService(q)
	prefH := preferences.NewHandler(prefSvc)
	acctH := account.NewHandler(q)

	r := chi.NewRouter()
	r.Use(chimw.RequestID, chimw.RealIP, chimw.Recoverer)
	r.Use(middleware.SecurityHeaders(cfg.IsProduction()))
	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
			start := time.Now()
			ww := chimw.NewWrapResponseWriter(w, req.ProtoMajor)
			next.ServeHTTP(ww, req)
			slog.Info("http",
				"method", req.Method,
				"path", req.URL.Path,
				"status", ww.Status(),
				"dur_ms", time.Since(start).Milliseconds(),
			)
		})
	})
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   cfg.CORSOrigins,
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-Request-ID"},
		AllowCredentials: true,
		MaxAge:           300,
	}))
	r.Use(rateMw.LimitGlobal)

	r.Get("/api/health", func(w http.ResponseWriter, _ *http.Request) {
		httpx.JSON(w, http.StatusOK, map[string]string{"status": "ok"})
	})

	r.Route("/api/auth", func(r chi.Router) {
		r.With(rateMw.Limit).Post("/register", h.Register)
		r.With(rateMw.Limit).Post("/login", h.Login)
		r.With(rateMw.Limit).Post("/oauth/google", h.OAuthGoogle)
		r.Post("/refresh", h.Refresh)
		r.Group(func(r chi.Router) {
			r.Use(authMw.Require)
			r.Get("/me", h.Me)
			r.Patch("/profile", h.PatchProfile)
			r.With(rateMw.Limit).Patch("/password", h.UpdatePassword)
			r.With(rateMw.Limit).Patch("/username", h.UpdateUsername)
			r.Get("/username/suggest", h.SuggestUsername)
			r.Get("/identities", h.ListIdentities)
			r.Delete("/identities/{provider}", h.UnlinkIdentity)
			r.Post("/logout", h.Logout)
		})
	})

	r.Route("/api", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(authMw.Require)
			r.Get("/wallets", walletH.List)
			r.Post("/wallets", walletH.Create)
			r.Patch("/wallets/{id}", walletH.Update)
			r.Delete("/wallets/{id}", walletH.Archive)

			r.Get("/categories", catH.List)
			r.Post("/categories", catH.Create)
			r.Patch("/categories/{id}", catH.Update)
			r.Post("/categories/{id}/archive", catH.Archive)
			r.Post("/categories/{id}/unarchive", catH.Unarchive)

			r.Get("/transactions", txH.List)
			r.Post("/transactions", txH.Create)
			r.Patch("/transactions/{id}", txH.Update)
			r.Delete("/transactions/{id}", txH.Delete)

			r.Get("/budgets", budH.List)
			r.Post("/budgets", budH.Create)
			r.Patch("/budgets/{id}", budH.Update)
			r.Delete("/budgets/{id}", budH.Delete)

			r.Get("/goals", goalH.List)
			r.Post("/goals", goalH.Create)
			r.Patch("/goals/{id}", goalH.Update)
			r.Post("/goals/{id}/contribute", goalH.Contribute)
			r.Delete("/goals/{id}", goalH.Delete)

			r.Get("/summary/dashboard", sumH.Dashboard)
			r.Get("/summary/stats", sumH.Stats)

			r.Get("/preferences", prefH.Get)
			r.Patch("/preferences", prefH.Patch)

			r.Post("/account/reset-data", acctH.ResetData)
		})
	})

	srv := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           r,
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       120 * time.Second,
	}

	go func() {
		slog.Info("listening", "addr", srv.Addr, "env", cfg.AppEnv, "cors_origins", cfg.CORSOrigins)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			slog.Error("server", "err", err)
			os.Exit(1)
		}
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig
	shutdownCtx, shutCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutCancel()
	_ = srv.Shutdown(shutdownCtx)
	slog.Info("shutdown complete")
}

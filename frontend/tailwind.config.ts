import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
        display: ["'Plus Jakarta Sans'", "Inter", "sans-serif"],
      },
      colors: {
        brand: {
          50: "#e6fcff",
          100: "#ccf9ff",
          200: "#99f3ff",
          300: "#66edff",
          400: "#33e7ff",
          500: "#00f0ff",
          600: "#00c8d6",
          700: "#0092a0",
          800: "#006f79",
          900: "#004951",
        },
        neon: {
          pink: "#00f0ff",
          purple: "#2563eb",
          cyan: "#1d4ed8",
          lime: "#38bdf8",
          orange: "#7dd3fc",
        },
        ink: {
          50: "#f5f8ff",
          100: "#e8eefb",
          200: "#c9d7f2",
          300: "#9fb5da",
          400: "#7d97bf",
          500: "#5b749d",
          600: "#3f5880",
          700: "#273c5f",
          800: "#111c33",
          900: "#0b1220",
        },
      },
      backgroundImage: {
        "gradient-tiktok":
          "linear-gradient(135deg, #00f0ff 0%, #2563eb 50%, #1d4ed8 100%)",
        "gradient-neon":
          "linear-gradient(135deg, #00f0ff 0%, #2563eb 100%)",
        "gradient-cyber":
          "linear-gradient(135deg, #00f0ff 0%, #1d4ed8 100%)",
        "gradient-sunset":
          "linear-gradient(135deg, #7dd3fc 0%, #2563eb 100%)",
        "gradient-lime":
          "linear-gradient(135deg, #38bdf8 0%, #00f0ff 100%)",
      },
      boxShadow: {
        neon: "0 10px 40px -10px rgba(0, 240, 255, 0.45)",
        "neon-pink": "0 10px 40px -10px rgba(0, 240, 255, 0.45)",
        "neon-cyan": "0 10px 40px -10px rgba(29, 78, 216, 0.5)",
        glow: "0 0 40px rgba(0, 240, 255, 0.28)",
      },
      animation: {
        "gradient-x": "gradient-x 8s ease infinite",
        float: "float 6s ease-in-out infinite",
        "float-slow": "float 10s ease-in-out infinite",
        "pulse-glow": "pulse-glow 2s ease-in-out infinite",
        "slide-up": "slide-up 0.5s ease-out",
        "fade-in": "fade-in 0.6s ease-out",
        "spin-slow": "spin 20s linear infinite",
        "bounce-slow": "bounce 3s infinite",
        wiggle: "wiggle 0.6s ease-in-out",
        shimmer: "shimmer 2s linear infinite",
      },
      keyframes: {
        "gradient-x": {
          "0%, 100%": { "background-position": "0% 50%" },
          "50%": { "background-position": "100% 50%" },
        },
        float: {
          "0%, 100%": { transform: "translateY(0)" },
          "50%": { transform: "translateY(-20px)" },
        },
        "pulse-glow": {
          "0%, 100%": { "box-shadow": "0 0 20px rgba(0, 240, 255, 0.4)" },
          "50%": { "box-shadow": "0 0 40px rgba(0, 240, 255, 0.75)" },
        },
        "slide-up": {
          "0%": { transform: "translateY(20px)", opacity: "0" },
          "100%": { transform: "translateY(0)", opacity: "1" },
        },
        "fade-in": {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        wiggle: {
          "0%, 100%": { transform: "rotate(-3deg)" },
          "50%": { transform: "rotate(3deg)" },
        },
        shimmer: {
          "0%": { "background-position": "-200% 0" },
          "100%": { "background-position": "200% 0" },
        },
      },
      backdropBlur: {
        xs: "2px",
      },
    },
  },
  plugins: [],
} satisfies Config;

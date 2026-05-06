import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig(({ command }) => {
  const isProdBuild = command === "build";
  return {
    plugins: [react()],
    resolve: {
      alias: {
        "@": path.resolve(__dirname, "./src"),
      },
    },
    // Strip console / debugger calls from the production bundle so leftover
    // logs cannot leak request payloads, tokens, or internals into a user's
    // DevTools. NOT a security boundary (users can still inspect Network),
    // just hygiene to avoid accidental disclosure.
    esbuild: isProdBuild
      ? { drop: ["console", "debugger"], legalComments: "none" }
      : undefined,
    build: {
      sourcemap: false,
      target: "es2020",
    },
    server: {
      port: 5173,
      host: true,
      // Tailscale MagicDNS / other tunnels send Host: *.ts.net
      allowedHosts: [".tailfc34e1.ts.net", "fransiskus-fds.tailfc34e1.ts.net", "*.beatfraps.com"],
      proxy: {
        "/api": {
          target: "http://localhost:8080",
          changeOrigin: true,
        },
      },
    },
  };
});

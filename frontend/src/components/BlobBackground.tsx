export default function BlobBackground() {
  return (
    <div
      className="pointer-events-none absolute inset-0 overflow-hidden -z-10"
      aria-hidden
    >
      <div className="absolute -top-32 -left-24 w-[420px] h-[420px] bg-neon-pink/30 rounded-full blur-[120px] animate-float" />
      <div className="absolute top-1/3 -right-24 w-[520px] h-[520px] bg-neon-purple/30 rounded-full blur-[140px] animate-float-slow" />
      <div className="absolute -bottom-32 left-1/4 w-[460px] h-[460px] bg-neon-cyan/25 rounded-full blur-[140px] animate-float" />
    </div>
  );
}

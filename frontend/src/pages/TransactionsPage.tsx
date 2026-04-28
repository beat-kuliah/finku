import { Search, Filter, ArrowDownRight, ArrowUpRight } from "lucide-react";
import AppShell from "@/components/AppShell";

const transactions = [
  { date: "23 Apr", title: "Kopi Kenangan", category: "Jajan", amount: -38000, wallet: "BCA" },
  { date: "23 Apr", title: "Gaji April", category: "Income", amount: 5000000, wallet: "BCA" },
  { date: "22 Apr", title: "Mie Gacoan", category: "Makan", amount: -47000, wallet: "GoPay" },
  { date: "22 Apr", title: "GoRide", category: "Transport", amount: -22000, wallet: "GoPay" },
  { date: "21 Apr", title: "Steam Wallet", category: "Hiburan", amount: -120000, wallet: "BCA" },
  { date: "20 Apr", title: "Topup e-Wallet", category: "Transfer", amount: -250000, wallet: "BCA" },
];

export default function TransactionsPage() {
  return (
    <AppShell
      activeSection="transactions"
      desktopTitle="Transaction history"
      desktopSubtitle="Semua cash flow kamu"
    >
      <section className="card !p-6 md:!p-7">
        <div className="flex flex-col md:flex-row md:items-center gap-3 md:justify-between">
          <div>
            <p className="text-xs uppercase tracking-wider text-white/60 font-semibold">Transactions</p>
            <h1 className="font-display text-3xl font-extrabold mt-1">Riwayat Transaksi</h1>
          </div>
          <div className="flex gap-2">
            <button className="btn-secondary !py-2.5 !px-4 text-sm">
              <Filter className="w-4 h-4" />
              Filter
            </button>
            <button className="btn-primary !py-2.5 !px-4 text-sm">Export CSV</button>
          </div>
        </div>

        <div className="mt-5 relative">
          <Search className="w-4 h-4 text-white/40 absolute left-4 top-1/2 -translate-y-1/2" />
          <input className="input !pl-11" placeholder="Cari transaksi..." />
        </div>
      </section>

      <section className="card !p-0 overflow-hidden">
        <div className="grid grid-cols-[80px_1fr_auto] px-5 py-3 text-xs uppercase tracking-wider text-white/50 border-b border-white/10">
          <span>Tanggal</span>
          <span>Deskripsi</span>
          <span>Jumlah</span>
        </div>

        <div>
          {transactions.map((tx, idx) => {
            const isIncome = tx.amount > 0;
            return (
              <div
                key={`${tx.title}-${idx}`}
                className="grid grid-cols-[80px_1fr_auto] px-5 py-4 border-b border-white/5 items-center"
              >
                <p className="text-sm text-white/70">{tx.date}</p>
                <div className="min-w-0">
                  <p className="font-semibold truncate">{tx.title}</p>
                  <p className="text-xs text-white/50">{tx.category} · {tx.wallet}</p>
                </div>
                <p className={`text-sm font-bold ${isIncome ? "text-neon-lime" : "text-white"}`}>
                  {isIncome ? "+" : "-"}Rp {Math.abs(tx.amount).toLocaleString("id-ID")}
                </p>
              </div>
            );
          })}
        </div>
      </section>

      <section className="grid md:grid-cols-2 gap-5">
        <div className="card !p-5">
          <div className="flex items-center gap-2 text-neon-lime">
            <ArrowUpRight className="w-4 h-4" />
            <span className="text-sm font-semibold">Total Income</span>
          </div>
          <p className="font-display text-3xl font-extrabold mt-2">Rp 5.000.000</p>
        </div>
        <div className="card !p-5">
          <div className="flex items-center gap-2 text-white/80">
            <ArrowDownRight className="w-4 h-4" />
            <span className="text-sm font-semibold">Total Expense</span>
          </div>
          <p className="font-display text-3xl font-extrabold mt-2">Rp 477.000</p>
        </div>
      </section>
    </AppShell>
  );
}

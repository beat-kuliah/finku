import { create } from "zustand";

/** Bump after mutating wallets/transactions/budgets/goals to refetch dashboard lists. */
export const useDataVersion = create<{ version: number; bump: () => void }>((set, get) => ({
  version: 0,
  bump: () => set({ version: get().version + 1 }),
}));

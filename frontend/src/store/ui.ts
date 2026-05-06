import { create } from "zustand";

type UIState = {
  addTransactionOpen: boolean;
  setAddTransactionOpen: (open: boolean) => void;
  moreSheetOpen: boolean;
  setMoreSheetOpen: (open: boolean) => void;
};

export const useUIStore = create<UIState>((set) => ({
  addTransactionOpen: false,
  setAddTransactionOpen: (open) => set({ addTransactionOpen: open }),
  moreSheetOpen: false,
  setMoreSheetOpen: (open) => set({ moreSheetOpen: open }),
}));

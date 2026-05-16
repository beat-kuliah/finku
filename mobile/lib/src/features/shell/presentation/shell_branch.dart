/// Branches inside the shell — order MUST match `StatefulShellRoute.indexedStack`.
enum ShellBranch {
  dashboard,
  transactions,
  wallets,
  budget,
  stats,
  goals,
  profile;

  /// Routing index matches the declaration order (built-in `Enum.index`).
  int get branchIndex => index;

  static ShellBranch fromIndex(int index) {
    if (index < 0 || index >= ShellBranch.values.length) {
      return ShellBranch.dashboard;
    }
    return ShellBranch.values[index];
  }
}

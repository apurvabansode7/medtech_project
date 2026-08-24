abstract class WalletEvent {}

class LoadWalletTransactions extends WalletEvent {
  final int page;
  final int limit;

  LoadWalletTransactions({
    this.page = 1,
    this.limit = 10,
  });
}

class RefreshWalletTransactions extends WalletEvent {}

class LoadMoreWalletTransactions extends WalletEvent {}
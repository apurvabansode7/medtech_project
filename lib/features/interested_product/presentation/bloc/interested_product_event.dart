abstract class InterestedProductEvent {}

class LoadInterestedProducts
    extends InterestedProductEvent {
  final bool refresh;

  LoadInterestedProducts({
    this.refresh = false,
  });
}

class LoadMoreInterestedProducts
    extends InterestedProductEvent {}
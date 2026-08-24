abstract class ShowcaseProductEvent {
  const ShowcaseProductEvent();
}

class LoadShowcaseProducts extends ShowcaseProductEvent {
  final bool refresh;

  const LoadShowcaseProducts({
    this.refresh = false,
  });
}

class LoadMoreShowcaseProducts extends ShowcaseProductEvent {
  const LoadMoreShowcaseProducts();
}
class RefreshShowcaseProducts extends ShowcaseProductEvent {
  const RefreshShowcaseProducts();
}
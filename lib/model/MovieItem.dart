class MovieItem {
  final int index;
  final Uri? uri;
  // let image: UIImage?

  MovieItem({required this.index, this.uri});

  bool get canFetchImage {
    // image == nil && url != nil
    return false;
  }
}

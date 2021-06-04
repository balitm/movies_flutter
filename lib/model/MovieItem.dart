class MovieItem {
  int index = 0;
  // let url: URL?
  // let image: UIImage?

  bool get canFetchImage {
    // image == nil && url != nil
    return false;
  }
}

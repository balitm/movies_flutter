// enum HTTPError: Error {
//     case status(code: Int)
//     case invalidResponse
// }

import 'MovieItem.dart';

class NowPlaying {
  int page;
  List<MovieItem> results;

  NowPlaying({
    required this.page,
    required this.results,
  });
  factory NowPlaying.empty() {
    return NowPlaying(page: 0, results: []);
  }
}

import 'dart:async';

import 'package:collection/collection.dart';

import 'package:movies/model/API.dart';
import 'package:movies/model/MovieItem.dart';
import 'package:movies/model/HTTPSession.dart';
import 'package:movies/model/data_source/data_source.dart' as DS;

class MoviesCollectionViewModel {
  Future<Configuration> _configuration;
  StreamController<NowPlaying> _streamController;

  MoviesCollectionViewModel()
      : _configuration = API.configuration(),
        _streamController = StreamController.broadcast();

  Stream<NowPlaying> get nowPlaying => _streamController.stream;

  start(int page, int width) {
    _configuration
        .then((config) => _fetchPlayingPosters(
              page,
              width,
              config,
            ))
        .then((value) => _streamController.add(value));
  }

  downloadImage({required MovieItem item}) {}

  // ---- privates ----

  static Future<NowPlaying> _fetchPlayingPosters(
    int page,
    int width,
    Configuration config,
  ) async {
    return API.nowPlaying(page: page).then((np) {
      if (np.results.isEmpty) return NowPlaying.empty();

      final uris = _convertToUris(config, width, np);
      return NowPlaying(
        page: np.page,
        results: uris
            .asMap()
            .map((key, value) =>
                MapEntry(key, MovieItem(index: key, uri: value)))
            .values
            .toList(),
      );
    }).catchError((error) {
      print(error.toString());
      return NowPlaying.empty();
    });
  }

  static List<Uri?> _convertToUris(
      Configuration config, int width, DS.NowPlaying nowPlaying) {
    if (config.baseUrl.isEmpty) {
      return [null];
    }
    final baseUrl = config.baseUrl;
    final index = _index(width, config);
    final size = config.posterSizes[index];
    final uris = nowPlaying.results.map((mr) {
      final path = mr.posterPath;
      if (path == null) return null;
      final idx = baseUrl.indexOf('://');
      if (idx == -1) return null;
      final scheme = baseUrl.substring(0, idx);
      final hostIdx = baseUrl.indexOf('/', idx + 3);
      final host = baseUrl.substring(idx + 3, hostIdx);
      final dp = baseUrl.substring(hostIdx + 1);
      final uri = Uri(
        scheme: scheme,
        host: host,
        path: dp + size + path,
      );
      return uri;
    }).toList();

    return uris;
  }

  static int _index(int width, Configuration cofig) {
    final widhts = cofig.posterSizes
        .map((e) {
          try {
            return int.parse(e.substring(1));
          } catch (_) {
            return null;
          }
        })
        .whereNotNull()
        .toList();

    var idx = widhts.indexWhere((e) => e >= width);
    if (idx == -1) idx = cofig.posterSizes.length - 2;
    return idx;
  }
}

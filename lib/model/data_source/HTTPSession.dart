part of 'package:movies/model/data_source/data_source.dart';

abstract class FromJSON {
  FromJSON.fromJson(Map<String, dynamic> json);
}

class _Images {
  final String baseUrl;
  final List<String> posterSizes;

  _Images({
    required this.baseUrl,
    required this.posterSizes,
  });

  static _Images fromJson(Map<String, dynamic> json) {
    List<dynamic> posterSizes = json['poster_sizes'];
    return _Images(
      baseUrl: json['base_url'],
      posterSizes: posterSizes.cast<String>(),
    );
  }
}

class Configuration implements FromJSON {
  final String baseUrl;
  final List<String> posterSizes;

  Configuration({
    required this.baseUrl,
    required this.posterSizes,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) {
    final images = _Images.fromJson(json['images']);
    final result = Configuration(
      baseUrl: images.baseUrl,
      posterSizes: images.posterSizes,
    );
    print('received config: $result');
    return result;
  }

  factory Configuration.empty() {
    return Configuration(baseUrl: "", posterSizes: []);
  }
}

class _MovieListResult {
  final String? posterPath;

  _MovieListResult({required this.posterPath});

  factory _MovieListResult.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'];
    return _MovieListResult(posterPath: posterPath);
  }
}

class NowPlaying implements FromJSON {
  final int page;
  final List<_MovieListResult> results;

  NowPlaying({
    required this.page,
    required this.results,
  });

  factory NowPlaying.fromJson(Map<String, dynamic> json) {
    final int page = json['page'];
    final List<dynamic> rawPaths = json['results'];
    final results = rawPaths.map((e) => _MovieListResult.fromJson(e)).toList();
    final result = NowPlaying(
      page: page,
      results: results,
    );
    print('received now playing: $result');
    return result;
  }
}

/// Add factory functions for every Type and every constructor you want to make available to `make`
final _factories = <Type, Function>{
  Configuration: (Map<String, dynamic> json) => Configuration.fromJson(json),
  NowPlaying: (Map<String, dynamic> json) => NowPlaying.fromJson(json),
};

T makeEntity<T extends FromJSON>(Map<String, dynamic> json) {
  return _factories[T]!(json);
}

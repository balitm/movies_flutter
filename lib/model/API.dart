import 'dart:convert';

import 'package:movies/model/data_source/data_source.dart' as DS;
import 'package:http/http.dart' as http;

typedef Configuration = DS.Configuration;

final _kTokenKey = "01c2282c845056a58215f4bd57f65352";
final _kBaseUrlString = "api.themoviedb.org";
final _kPathPrefix = "3/";

class API {
  static Future<DS.Configuration> configuration() async {
    final uri = API._createURL("configuration");
    return _fetch(uri);
  }

  static Future<DS.NowPlaying> nowPlaying({required int page}) {
    final uri = API._createURL("movie/now_playing", {
      'language': 'en-US',
      'page': '$page',
    });
    return _fetch(uri);
  }

  static Future<T> _fetch<T extends DS.FromJSON>(Uri uri) async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return DS.makeEntity<T>(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch $uri');
    }
  }

  static Uri _createURL(String function, [Map<String, dynamic>? parameters]) {
    // Assembling the url.
    final path = _kPathPrefix + function;
    final Map<String, dynamic> params = {'api_key': _kTokenKey};
    if (parameters != null) {
      params.addAll(parameters);
    }
    // request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    return Uri.https(_kBaseUrlString, path, params);
  }
}

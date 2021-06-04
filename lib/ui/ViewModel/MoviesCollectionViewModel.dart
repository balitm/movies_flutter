import 'package:movies/model/API.dart';

class MoviesCollectionViewModel {
  Future<Configuration> _configuration;

  MoviesCollectionViewModel() : _configuration = API.configuration();
}

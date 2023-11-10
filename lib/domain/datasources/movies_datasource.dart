import 'package:cinemapedia/domain/entities/movie.dart';


// Clase que definira el origen de los datos
abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
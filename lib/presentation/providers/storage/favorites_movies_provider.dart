import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  
  StorageMoviesNotifier({
    required this.localStorageRepository
  }): super({});

  Future<void> loadNextPage() async {
    final movies = await localStorageRepository.loadMovie(offset: page * 10, limit: 20);
    page++;

    final tempMovieMap = <int, Movie>{};
    for(final movie in movies) {
      tempMovieMap[movie.id] = movie;
    }

    state = {...state, ...tempMovieMap};
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if(isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    }else{
      state = {...state, movie.id: movie};
    }
  }
}
part of 'movie_bloc.dart';

sealed class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

final class MovieInitial extends MovieState {
  const MovieInitial();
}

final class MovieOnLoading extends MovieState {
  const MovieOnLoading();
}

final class MovieLoadSuccess extends MovieState {
  final List<MovieData> popularMovies, nowPlayingMovies, topRatedMovies;
  const MovieLoadSuccess({
    required this.popularMovies,
    required this.nowPlayingMovies,
    required this.topRatedMovies,
  });
}

final class MovieLoadMoreSuccess extends MovieState {
  final List<MovieData> movies;
  const MovieLoadMoreSuccess({
    required this.movies,
  });
}

final class MovieSearchSuccess extends MovieState {
  final List<MovieData> searchResults;
  const MovieSearchSuccess({
    required this.searchResults,
  });
}

final class DetailLoadSuccess extends MovieState {
  final ResponseDetailMovie movieDetail;
  final List<MovieData> relatedMovies;
  const DetailLoadSuccess({
    required this.movieDetail,
    required this.relatedMovies,
  });
}

final class MovieNoInternet extends MovieState {
  const MovieNoInternet();
}

final class MovieOnError extends MovieState {
  final String message;
  const MovieOnError(this.message);
}

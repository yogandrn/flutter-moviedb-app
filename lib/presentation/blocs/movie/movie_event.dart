part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialMovies extends MovieEvent {
  const LoadInitialMovies();
}

class LoadMoreMovies extends MovieEvent {
  final String categoryType;
  const LoadMoreMovies(this.categoryType);
}

class SearchMovies extends MovieEvent {
  final String query;
  const SearchMovies(this.query);
}

class LoadDetailMovie extends MovieEvent {
  final int movieID;
  const LoadDetailMovie(this.movieID);
}

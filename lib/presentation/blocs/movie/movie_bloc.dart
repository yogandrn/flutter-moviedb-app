import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utilites/helper.dart';
import '../../../core/utilites/validator.dart';
import '../../../data/models/response_detail_movie.dart';
import '../../../data/models/response_list_movies.dart';
import '../../../data/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(const MovieInitial()) {
    const movieRepository = MovieRepository();

    on<LoadInitialMovies>((event, emit) async {
      try {
        emit(const MovieOnLoading());

        // validasi koneksi internet
        final isOnline = await Validator.isConnectedToInternet();
        if (!isOnline) {
          emit(const MovieNoInternet());
          return;
        }

        // init variables
        ResponseListMovies? responsePopularMovies,
            responseNowPlayingMovies,
            responseTopRatedMovies;

        // send api asynchronous
        await Future.wait([
          movieRepository
              .getNowPlayingMovies()
              .then((value) => responseNowPlayingMovies = value),
          movieRepository
              .getPopularMovies()
              .then((value) => responsePopularMovies = value),
          movieRepository
              .getTopRatedMovies()
              .then((value) => responseTopRatedMovies = value),
        ]);

        if (responseNowPlayingMovies != null &&
            responsePopularMovies != null &&
            responseTopRatedMovies != null) {
          responseTopRatedMovies!.results
              .sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
          emit(
            (responseNowPlayingMovies!.statusCode == 200
                ? MovieLoadSuccess(
                    popularMovies:
                        Helper.shuffleArray(responsePopularMovies!.results),
                    nowPlayingMovies:
                        Helper.shuffleArray(responseNowPlayingMovies!.results),
                    topRatedMovies: responseTopRatedMovies!.results,
                  )
                : MovieOnError("${responseNowPlayingMovies?.statusMessage}")),
          );
        } else {
          emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
        }
      } catch (e) {
        log("Error on LoadInitialMovies event on MovieBloc : $e");
        emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
      }
    });

    on<LoadDetailMovie>((event, emit) async {
      try {
        emit(const MovieOnLoading());

        // validasi koneksi internet
        final isOnline = await Validator.isConnectedToInternet();
        if (!isOnline) {
          emit(const MovieNoInternet());
          return;
        }

        // init variables
        ResponseDetailMovie? responseDetailMovie;
        ResponseListMovies? responseRelatedMovies;

        // send api request asynchronous
        await Future.wait([
          movieRepository
              .getDetailMovie(event.movieID)
              .then((value) => responseDetailMovie = value),
          movieRepository
              .getRecommendationMovies(event.movieID)
              .then((value) => responseRelatedMovies = value),
        ]);

        if (responseRelatedMovies != null && responseDetailMovie != null) {
          emit(
            (responseDetailMovie!.statusCode == 200)
                ? DetailLoadSuccess(
                    movieDetail: responseDetailMovie!,
                    relatedMovies: responseRelatedMovies!.results)
                : MovieOnError("${responseDetailMovie?.statusMessage}"),
          );
        } else {
          emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
        }
      } catch (e) {
        log("Error on LoadDetailMovie event on MovieBloc : $e");
        emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
      }
    });

    on<SearchMovies>((event, emit) async {
      try {
        emit(const MovieOnLoading());

        // validasi koneksi internet
        final isOnline = await Validator.isConnectedToInternet();
        if (!isOnline) {
          emit(const MovieNoInternet());
          return;
        }

        // send api request
        final result = await movieRepository.searchMovies(event.query);

        if (result != null) {
          emit(
            ((result.statusCode == 200)
                ? MovieSearchSuccess(
                    searchResults: result.results,
                  )
                : MovieOnError(result.statusMessage)),
          );
        } else {
          emit(const MovieOnError('Terjadi kesalahan saat mencari data film!'));
        }
      } catch (e) {
        log("Error on LoadDetailMovie event on MovieBloc : $e");
        emit(const MovieOnError('Terjadi kesalahan saat mencari data film!'));
      }
    });

    on<LoadMoreMovies>((event, emit) async {
      try {
        emit(const MovieOnLoading());

        // validasi koneksi internet
        final isOnline = await Validator.isConnectedToInternet();
        if (!isOnline) {
          emit(const MovieNoInternet());
          return;
        }

        ResponseListMovies? result;
        // send api request
        switch (event.categoryType.toUpperCase()) {
          case "POPULAR":
            result = await movieRepository.getPopularMovies();
            break;
          case "TOP RATED":
            result = await movieRepository.getTopRatedMovies();
            break;
          case "NOW PLAYING":
            result = await movieRepository.getNowPlayingMovies();
            break;
          default:
            result = await movieRepository.getPopularMovies();
        }

        if (result != null) {
          emit(
            ((result.statusCode == 200)
                ? MovieLoadMoreSuccess(
                    movies: result.results,
                  )
                : MovieOnError(result.statusMessage)),
          );
        } else {
          emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
        }
      } catch (e) {
        log("Error on LoadMoreMovies event on MovieBloc : $e");
        emit(const MovieOnError('Terjadi kesalahan saat memuat data film!'));
      }
    });
  }
}

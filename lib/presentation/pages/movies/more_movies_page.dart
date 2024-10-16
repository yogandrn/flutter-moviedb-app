import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/response_list_movies.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../pages/errors/custom_error_screen.dart';
import '../../pages/errors/custom_no_internet_screen.dart';
import '../../pages/movies/detail_movie_page.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';
import '../../widgets/custom_fluttertoast.dart';
import '../../widgets/grid_item_movie.dart';

class MoreMoviesPage extends StatefulWidget {
  final String category;
  const MoreMoviesPage({super.key, required this.category});

  @override
  State<MoreMoviesPage> createState() => _MoreMoviesPageState();
}

class _MoreMoviesPageState extends State<MoreMoviesPage> {
  final movieBloc = MovieBloc();
  final fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
    movieBloc.close();
  }

  Future<void> initializeData() async {
    movieBloc.add(LoadMoreMovies(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => movieBloc,
      child: Scaffold(
        backgroundColor: primary,
        appBar: _buildAppBar(),
        body: BlocConsumer<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial || state is MovieOnLoading) {
              return _buildOnLoadingScreen();
            }
            if (state is MovieNoInternet) {
              return const NoInternetWidget();
            }
            if (state is MovieOnError) {
              return OnErrorWidget(message: state.message);
            }

            if (state is MovieLoadMoreSuccess) {
              return _buildMovieGrid(state.movies);
            }
            return Container();
          },
          listener: (context, state) {
            if (state is MovieOnError) {
              fToast.showToast(
                child: CustomFlutterToast(message: state.message),
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(milliseconds: 2400),
              );
            }
            if (state is MovieNoInternet) {
              fToast.showToast(
                child: const CustomFlutterToast(
                    message: "Koneksi internet perangkat terputus!"),
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(milliseconds: 2400),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMovieGrid(List<MovieData> movies) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 12),
      itemCount: movies.length,
      itemBuilder: (context, index) => GridItemMovie(
        movie: movies[index],
        onTap: () {
          final heroKey = movies[index].uniqueKey;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailPage(
                      movieID: movies[index].id,
                      imageUrl: "${movies[index].posterPath}",
                      heroTag: heroKey,
                    )),
          );
        },
      ),
    );
  }

  Widget _buildOnLoadingScreen() {
    final dummyData = List.generate(
        4,
        (index) => MovieData(
              id: index + 101,
              video: true,
              voteAverage: 10,
              voteCount: 1000,
              title: 'Default Movie Title OnLoading',
              originalTitle: 'Default Original Movie Title On Loading',
              releaseDate: '2020-01-01',
            ));
    return Skeletonizer(child: _buildMovieGrid(dummyData));
  }

  AppBar _buildAppBar() {
    var title = '';
    switch (widget.category.toUpperCase()) {
      case "POPULAR":
        title = "Populer";
        break;
      case "TOP RATED":
        title = "Rating Tertinggi";
        break;
      case "NOW PLAYING":
        title = "Sedang Tayang";
        break;
      default:
        title = 'Populer';
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: const BackButton(color: white),
      title: Text(
        title,
        style: poppins600.copyWith(fontSize: 16),
      ),
      centerTitle: true,
    );
  }
}

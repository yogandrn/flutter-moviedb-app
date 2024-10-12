import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/utilites/helper.dart';
import '../../../data/models/response_detail_movie.dart';
import '../../../data/models/response_list_movies.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../pages/errors/custom_error_screen.dart';
import '../../pages/errors/custom_no_internet_screen.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';
import '../../widgets/custom_fluttertoast.dart';
import '../../widgets/list_item_movie_horizontal.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieID;
  final String imageUrl, heroTag;
  const MovieDetailPage(
      {super.key,
      required this.movieID,
      required this.imageUrl,
      required this.heroTag});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final movieBloc = MovieBloc();
  final fToast = FToast();
  bool isWatchList = true;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    movieBloc.close();
  }

  Future<void> fetchData() async {
    movieBloc.add(LoadDetailMovie(widget.movieID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => movieBloc,
      child: Scaffold(
        backgroundColor: primary,
        body: BlocConsumer<MovieBloc, MovieState>(builder: (context, state) {
          if (state is DetailLoadSuccess) {
            return _buildMovieDetailBody(
              movie: state.movieDetail,
              relatedMovies: state.relatedMovies,
            );
          }
          if (state is MovieInitial || state is MovieOnLoading) {
            return _buildOnLoading();
          }

          if (state is MovieOnError) {
            return OnErrorWidget(message: state.message);
          }

          if (state is MovieNoInternet) {
            return const NoInternetWidget();
          }

          return Container();
        }, listener: (context, state) {
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
        }),
      ),
    );
  }

  Widget _buildMovieDetailBody(
      {required ResponseDetailMovie movie,
      required List<MovieData> relatedMovies}) {
    return Stack(
      children: [
        Positioned(
          top: -135,
          left: 0,
          right: 0,
          child: Hero(
            tag: widget.heroTag,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: double.maxFinite,
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          top: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildBackButton(), _buildWatchListButton()],
          ),
        ),
        _buildSlidingPanel(
          movie,
          relatedMovies: relatedMovies,
        ),
      ],
    );
  }

  Widget _buildSlidingPanel(ResponseDetailMovie detailMovie,
      {required List<MovieData> relatedMovies}) {
    final size = MediaQuery.sizeOf(context);
    return SlidingUpPanel(
      color: primary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      minHeight: size.height * 0.54,
      maxHeight: size.height * 0.92,
      parallaxEnabled: true,
      header: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            width: 56,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white,
            ),
          ),
        ),
      ),
      panel: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${detailMovie.title} (${detailMovie.releaseDate})",
              style: poppins600.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              detailMovie.genres.map((genre) => genre.name).join(', '),
              style: poppins500.copyWith(fontSize: 13.6),
            ),
            Text(
              Helper.convertDuration(detailMovie.runtime ?? 0),
              style: poppins500.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingBarIndicator(
                  rating: detailMovie.voteAverage / 2,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: accentColor,
                  ),
                  unratedColor: white.withOpacity(0.25),
                  itemCount: 5, // 5 bintang
                  itemSize: 24, // Ukuran bintang
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 6),
                Text(
                  detailMovie.voteAverage.toStringAsFixed(1),
                  style: poppins400.copyWith(fontSize: 13.6),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${detailMovie.voteCount})",
                  style: poppins400.copyWith(fontSize: 13.6),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Ringkasan",
              style: poppins600.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detailMovie.overview,
              style: poppins400.copyWith(fontSize: 13.5),
            ),
            const SizedBox(height: 20),
            _buildRelatedMoviesList(relatedMovies),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedMoviesList(List<MovieData> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rekomendasi",
          style: poppins600.copyWith(fontSize: 16),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 240,
          child: movies.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  itemCount: movies.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      ListItemMovieHorizontal(movie: movies[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildOnLoading() {
    final dummyData = ResponseDetailMovie(
      genres: [],
      id: 99999,
      originalTitle: "Default Original Title Lorem ipsum dolor sit amet",
      overview:
          "Default Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et",
      releaseDate: "2020",
      title: "Default Original Title Lorem ipsum dolor sit amet",
      voteAverage: 10,
      voteCount: 99,
      success: true,
      statusCode: 200,
      statusMessage: "Success",
    );
    return Stack(
      children: [
        Positioned(
          top: -135,
          left: 0,
          right: 0,
          child: Hero(
            tag: widget.heroTag,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: double.maxFinite,
            ),
          ),
        ),
        Positioned(left: 20, top: 48, child: _buildBackButton()),
        Skeletonizer(
          enabled: true,
          child: _buildSlidingPanel(dummyData, relatedMovies: []),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildWatchListButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isWatchList = !isWatchList;
        });
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isWatchList ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isWatchList ? null : Border.all(color: white, width: 1.2),
        ),
        child: Icon(
          isWatchList
              ? Icons.bookmark_added_outlined
              : Icons.bookmark_add_rounded,
          color: isWatchList ? black : white,
          size: 28,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ditonton/presentation/pages/errors/custom_no_internet_screen.dart';
import 'package:ditonton/presentation/pages/movies/detail_movie_page.dart';
import 'package:ditonton/presentation/widgets/list_item_carousel_image.dart';
import 'package:ditonton/presentation/widgets/list_item_movie_vertical.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'errors/custom_error_screen.dart';
import 'movies/more_movies_page.dart';
import '../../data/models/response_list_movies.dart';
import '../blocs/movie/movie_bloc.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';
import '../widgets/custom_fluttertoast.dart';
import '../widgets/list_item_movie_horizontal.dart';
import 'movies/search_movie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final movieBloc = MovieBloc();
  final fToast = FToast();

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
    movieBloc.add(const LoadInitialMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => movieBloc,
          child: BlocConsumer<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieInitial || state is MovieOnLoading) {
                return _onLoadingScreen();
              }
              if (state is MovieOnError) {
                return OnErrorWidget(
                  message: state.message,
                );
              }
              if (state is MovieNoInternet) {
                return const NoInternetWidget();
              }
              if (state is MovieLoadSuccess) {
                return _buildOnLoadedScreen(
                  nowPlayingMovies: state.nowPlayingMovies,
                  popularMovies: state.popularMovies,
                  topRatedMovies: state.topRatedMovies,
                );
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
      ),
    );
  }

  Widget _buildOnLoadedScreen({
    required List<MovieData> nowPlayingMovies,
    required List<MovieData> popularMovies,
    required List<MovieData> topRatedMovies,
  }) {
    return RefreshIndicator(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildSearchBar(initialData: popularMovies),
            const SizedBox(height: 20),
            _buildCarouselSlider(
                title: "Sedang Tayang",
                movies: nowPlayingMovies,
                onTapViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MoreMoviesPage(category: "NOW PLAYING")),
                  );
                }),
            const SizedBox(height: 16),
            _buildHorizontalMovieList(
              title: 'Populer',
              movies: popularMovies,
              onTapViewAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MoreMoviesPage(category: "POPULAR")),
              ),
            ),
            const SizedBox(height: 16),
            topRatedMovies.isEmpty
                ? const SizedBox.shrink()
                : _buildVerticalMovieList(
                    title: 'Rating Tertinggi',
                    movies: topRatedMovies,
                    onTapViewAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MoreMoviesPage(category: "TOP RATED")),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(
      {required String title,
      required List<MovieData> movies,
      required Function() onTapViewAll,
      bool isLoading = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: poppins600.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: onTapViewAll,
                child: Text(
                  'Lihat semua',
                  style: poppins500.copyWith(fontSize: 13.5),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: !isLoading,
            autoPlayInterval: const Duration(milliseconds: 5400),
            autoPlayAnimationDuration: const Duration(milliseconds: 640),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
          ),
          items: movies.map((movie) {
            return CarouselImageItem(movie: movie);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHorizontalMovieList({
    required String title,
    required List<MovieData> movies,
    required Function() onTapViewAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: poppins600.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: onTapViewAll,
                child: Text(
                  'Lihat semua',
                  style: poppins500.copyWith(fontSize: 13.5),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 240,
          child: movies.isEmpty
              ? const Center(
                  child: Text(
                    'No Movies',
                    style: poppins500,
                  ),
                )
              : ListView.builder(
                  itemCount: movies.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => (index > 0)
                      ? ListItemMovieHorizontal(movie: movies[index - 1])
                      : const SizedBox(width: 12),
                ),
        ),
      ],
    );
  }

  Widget _buildVerticalMovieList({
    required String title,
    required List<MovieData> movies,
    required Function() onTapViewAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: poppins600.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: onTapViewAll,
                child: Text(
                  'Lihat semua',
                  style: poppins500.copyWith(fontSize: 13.5),
                ),
              )
            ],
          ),
        ),
        ListView.builder(
            itemCount: movies.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final heroTag = movies[index].uniqueKey;
              return ListItemMovieVertical(
                movie: movies[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                        movieID: movies[index].id,
                        imageUrl: "${movies[index].posterPath}",
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                heroKey: heroTag,
              );
            }),
      ],
    );
  }

  Widget _onLoadingScreen() {
    final dummyData = List.generate(
        3,
        (index) => MovieData(
              id: index,
              video: true,
              voteAverage: 10,
              voteCount: 1000,
              title: 'Default Movie Title OnLoading',
              originalTitle: 'Default Original Movie Title On Loading',
              releaseDate: '2020-01-01',
            ));
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 40),
          _buildSearchBar(initialData: []),
          const SizedBox(height: 20),
          _buildCarouselSlider(
            title: "Now Playing",
            movies: dummyData,
            onTapViewAll: () {},
            isLoading: true,
          ),
          const SizedBox(height: 16),
          _buildHorizontalMovieList(
            title: "OnLoading",
            movies: dummyData,
            onTapViewAll: () {},
          ),
          const SizedBox(height: 16),
          _buildVerticalMovieList(
            movies: dummyData,
            title: "OnLoading",
            onTapViewAll: () {},
          ),
        ]),
      ),
    );
  }

  Widget _buildSearchBar({required List<MovieData> initialData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Skeleton.ignore(
        child: TextFormField(
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            filled: true,
            hintText: "Cari film",
            fillColor: white.withOpacity(0.08),
            hintStyle: poppins400.copyWith(fontSize: 13.5),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white.withOpacity(0.6), width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: white, width: 1.8),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: errorColor, width: 1),
              borderRadius: BorderRadius.circular(9),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: white,
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchMoviePage(
                        initialData: initialData,
                      ))),
          readOnly: true,
        ),
      ),
    );
  }
}

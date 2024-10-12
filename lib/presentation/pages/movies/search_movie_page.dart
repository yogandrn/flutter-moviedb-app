import 'package:ditonton/presentation/pages/errors/custom_no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/models/response_list_movies.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../pages/errors/custom_not_found_screen.dart';
import '../../widgets/custom_fluttertoast.dart';
import '../../widgets/list_item_movie_vertical.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';
import 'detail_movie_page.dart';

class SearchMoviePage extends StatefulWidget {
  final List<MovieData> initialData;
  const SearchMoviePage({super.key, required this.initialData});

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  final movieBloc = MovieBloc();
  final TextEditingController searchController = TextEditingController();
  final fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    movieBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => movieBloc,
      child: Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          child: BlocConsumer<MovieBloc, MovieState>(builder: (context, state) {
            if (state is MovieInitial) {
              return _buildInitialScreen();
            }
            if (state is MovieOnLoading) {
              return _buildOnLoadingScreen();
            }
            if (state is MovieSearchSuccess) {
              return _buildSearchResultScreen(
                  searchResults: state.searchResults);
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
      ),
    );
  }

  Widget _buildInitialScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildSearchBar(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Popular",
            style: poppins600.copyWith(fontSize: 16),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.initialData.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final heroTag = UniqueKey().toString();
                return ListItemMovieVertical(
                  movie: widget.initialData[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movieID: widget.initialData[index].id,
                          imageUrl: "${widget.initialData[index].posterPath}",
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  },
                  heroKey: heroTag,
                );
              }),
        ),
      ],
    );
  }

  Widget _buildSearchResultScreen({required List<MovieData> searchResults}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildSearchBar(),
        const SizedBox(height: 20),
        Expanded(
          child: searchResults.isEmpty
              ? const NotFoundWidget(
                  message: "Data tidak ditemukan.\nCobalah kata kunci lainnya.",
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final heroTag = UniqueKey().toString();
                    return ListItemMovieVertical(
                      movie: searchResults[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              movieID: searchResults[index].id,
                              imageUrl: "${searchResults[index].posterPath}",
                              heroTag: heroTag,
                            ),
                          ),
                        );
                      },
                      heroKey: heroTag,
                    );
                  }),
        ),
      ],
    );
  }

  Widget _buildOnLoadingScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildSearchBar(),
        const SizedBox(height: 20),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: white,
                ),
                SizedBox(height: 8),
                Text(
                  'Sedang mencari...',
                  style: poppins500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        controller: searchController,
        textInputAction: TextInputAction.search,
        style: poppins400.copyWith(fontSize: 14),
        autofocus: true,
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
        onFieldSubmitted: (value) {
          if (searchController.text.isNotEmpty) {
            movieBloc.add(SearchMovies(searchController.text));
          }
        },
        onChanged: (value) {
          if (searchController.text.isNotEmpty) {
            movieBloc.add(SearchMovies(searchController.text));
          }
          // if (value.length >= 3) {
          //   jobBloc.add(JobSearhing(value));
          // }
          // if (value.isEmpty) {
          //   jobBloc.add(const JobDefaultSearch());
          // }
          // if (value.isEmpty) {
          //   contactBloc.add(
          //     ContactSearch(
          //         listContacts: contactsList, keyword: keywordController.text),
          //   );
          // }
          // jobBloc.add(JobSearhing(value));
        },
      ),
    );
  }
}

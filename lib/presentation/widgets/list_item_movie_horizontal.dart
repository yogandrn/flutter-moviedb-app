import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/configs/constanta_asset.dart';
import '../../data/models/response_list_movies.dart';
import '../pages/movies/detail_movie_page.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';

class ListItemMovieHorizontal extends StatelessWidget {
  final MovieData movie;

  const ListItemMovieHorizontal({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey().toString();
    return GestureDetector(
      onTap: () {
        log("Movie ID : ${movie.id}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(
              movieID: movie.id,
              imageUrl: "${movie.posterPath}",
              heroTag: heroTag,
            ),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          width: 128,
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
              color: greyLight,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: greyLight.withOpacity(0.16),
                  offset: const Offset(0, 6),
                  blurRadius: 9,
                  spreadRadius: 1,
                ),
              ]),
          child: Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: movie.posterPath != null
                      ? CachedNetworkImage(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                          imageUrl: "${movie.posterPath}",
                          progressIndicatorBuilder: (context, url, progress) =>
                              Skeletonizer(
                                  enabled: true,
                                  child: Image.asset(
                                    AssetConst.invalidImage,
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    fit: BoxFit.cover,
                                  )),
                          errorWidget: (context, url, error) => Center(
                            child: Image.asset(
                              AssetConst.invalidImage,
                              width: 64,
                            ),
                          ),
                        )
                      : Skeletonizer(
                          child: Image.asset(
                            AssetConst.invalidImage,
                            width: double.maxFinite,
                            height: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(9)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        black.withOpacity(0.9),
                        black.withOpacity(0.75),
                        black.withOpacity(0.48),
                        black.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "${movie.title} (${movie.releaseDate})",
                        maxLines: 4,
                        style: poppins600.copyWith(fontSize: 13.5),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

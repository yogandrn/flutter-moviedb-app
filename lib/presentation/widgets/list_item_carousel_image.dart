import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/movies/detail_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/configs/constanta_asset.dart';
import '../../data/models/response_list_movies.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';

class CarouselImageItem extends StatelessWidget {
  final MovieData movie;
  const CarouselImageItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final heroKey = UniqueKey().toString();
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieDetailPage(
                movieID: movie.id,
                imageUrl: "${movie.posterPath}",
                heroTag: heroKey)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 150,
        margin: const EdgeInsets.fromLTRB(6, 8, 6, 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: greyLight,
            boxShadow: [
              BoxShadow(
                color: greyLight.withOpacity(0.18),
                offset: const Offset(2, 8),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ]),
        child: Stack(
          children: [
            Positioned(
              child: Hero(
                tag: heroKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: movie.backdropPath != null
                      ? CachedNetworkImage(
                          imageUrl: "${movie.backdropPath}",
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Skeletonizer(
                            enabled: true,
                            child: Image.asset(
                              AssetConst.invalidImage,
                              width: double.maxFinite,
                              height: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Image.asset(
                              AssetConst.invalidImage,
                              height: 84,
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
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(9)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      black.withOpacity(0.9),
                      black.withOpacity(0.75),
                      black.withOpacity(0.64),
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
    );
  }
}

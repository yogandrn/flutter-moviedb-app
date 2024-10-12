import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/configs/constanta_asset.dart';
import '../../data/models/response_list_movies.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';

class ListItemMovieVertical extends StatelessWidget {
  final MovieData movie;
  final Function() onTap;
  final String heroKey;
  const ListItemMovieVertical(
      {super.key,
      required this.movie,
      required this.onTap,
      required this.heroKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: greyLight,
                ),
                width: 72,
                height: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
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
                              width: 40,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${movie.title}",
                    maxLines: 2,
                    style: poppins600.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: movie.voteAverage / 2,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: accentColor,
                        ),
                        unratedColor: white.withOpacity(0.25),
                        itemCount: 5, // 5 bintang
                        itemSize: 20, // Ukuran bintang
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: poppins400.copyWith(fontSize: 13.6),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "(${movie.voteCount})",
                        style: poppins400.copyWith(fontSize: 13.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${movie.releaseDate}",
                    style: poppins500.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

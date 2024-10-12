import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/configs/constanta_asset.dart';
import '../../data/models/response_list_movies.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';

class GridItemMovie extends StatelessWidget {
  final MovieData movie;
  final Function() onTap;
  const GridItemMovie({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: greyLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 500,
                height: 500,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: movie.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: "${movie.posterPath}",
                          fit: BoxFit.cover,
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
                              width: 84,
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${movie.title}",
                      maxLines: 2,
                      style: poppins600.copyWith(fontSize: 13.6, height: 1.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${movie.releaseDate}",
                      style: poppins400.copyWith(fontSize: 13.6, height: 1.35),
                    ),
                    const SizedBox(height: 3),
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
                          itemSize: 15, // Ukuran bintang
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: poppins400.copyWith(fontSize: 13, height: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

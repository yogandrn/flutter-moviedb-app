import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/configs/constanta_asset.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';

class NotFoundWidget extends StatelessWidget {
  final String message;
  final double fontSize;
  final String lottieAsset;
  const NotFoundWidget({
    super.key,
    this.message = "Data tidak ditemukan!",
    this.fontSize = 15.6,
    this.lottieAsset = AssetConst.noDataAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Oops!',
              style: poppins600.copyWith(fontSize: 18, color: errorColor),
            ),
            Lottie.asset(
              lottieAsset,
              width: size.height / 3.2,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              maxLines: 5,
              textAlign: TextAlign.center,
              style: poppins500.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

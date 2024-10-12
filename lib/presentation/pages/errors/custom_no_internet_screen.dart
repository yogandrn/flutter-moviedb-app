import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/configs/constanta_asset.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Oops!',
            style: poppins600.copyWith(fontSize: 18, color: errorColor),
          ),
          Text(
            'Tidak ada koneksi internet',
            style: poppins500.copyWith(fontSize: 15),
          ),
          Lottie.asset(
            AssetConst.noInternetAnimation,
            height: size.height / 3.2,
          ),
        ],
      ),
    );
  }
}

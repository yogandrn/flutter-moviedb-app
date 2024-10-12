import 'package:flutter/material.dart';

import '../themes/colors.dart';
import '../themes/textstyles.dart';

class CustomFlutterToast extends StatelessWidget {
  final String message;
  const CustomFlutterToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: white.withOpacity(0.28),
      ),
      child: Text(
        message,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: poppins400.copyWith(
          color: white,
          fontSize: 14.5,
          height: 1.25,
        ),
      ),
    );
  }
}

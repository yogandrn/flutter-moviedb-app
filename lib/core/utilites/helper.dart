import 'dart:math';

final class Helper {
  static List<T> shuffleArray<T>(List<T> array) {
    final newArray = [...array];
    newArray.shuffle(Random());
    return newArray;
  }

  static String convertDuration(num duration) {
    final hours = (duration / 60).floor();
    final minutes = duration % 60;

    return '${hours}h ${minutes}m';
  }
}

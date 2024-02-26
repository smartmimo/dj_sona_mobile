import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageUtils {
  static Future<PaletteGenerator> getDominantColorsFromImageUrl(String imageUrl) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl)).buffer.asUint8List();
    final Completer<Image> completer = Completer();
    decodeImageFromList(bytes, (Image img) {
      completer.complete(img);
    });
    Image image = await completer.future;
    return PaletteGenerator.fromImage(image);
  }

  static Color getAverageColorFromList(List<Color> colors) {
    int r = 0, g = 0, b = 0;

    for (int i = 0; i < colors.length; i++) {
      r += colors[i].red;
      g += colors[i].green;
      b += colors[i].blue;
    }

    r = r ~/ colors.length;
    g = g ~/ colors.length;
    b = b ~/ colors.length;

    return Color.fromRGBO(r, g, b, 1);
  }

  static Color darkenColor(Color color, [double factor = 0.1]) {
    assert(factor >= 0 && factor <= 1);
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
    );
  }

// Function to make a color lighter
  static Color lightenColor(Color color, [double factor = 0.1]) {
    assert(factor >= 0 && factor <= 1);
    return Color.fromARGB(
      color.alpha,
      color.red + ((255 - color.red) * factor).round(),
      color.green + ((255 - color.green) * factor).round(),
      color.blue + ((255 - color.blue) * factor).round(),
    );
  }
}

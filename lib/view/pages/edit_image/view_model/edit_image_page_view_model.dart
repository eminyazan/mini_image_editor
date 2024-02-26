import 'dart:developer';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:mini_image_editor/core/controllers/dependency_injection/service_locator.dart';
import 'package:path_provider/path_provider.dart';

class EditImagePageViewModel {
  final _defaultColorMatrix = <double>[
    1, 0, 0, 0, 0, // R
    0, 1, 0, 0, 0, // G
    0, 0, 1, 0, 0, // B
    0, 0, 0, 1, 0, // A
  ];

  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(_defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(_defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  Future<bool> saveImage({
    required img.Image image,
    required double brightness,
    required double saturation,
    required double contrast,
  }) async {
    try {
      image = img.adjustColor(
        image,
        brightness: brightness,
        saturation: saturation,
        contrast: contrast,
      );
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File output = File('${appDocDir.path}/mini_image_editor-${DateTime.now().toIso8601String()}.png');
      await output.writeAsBytes(img.encodeJpg(image));
      if (output.existsSync()) {
        await appLocalDatabase.saveImagePath(output.path);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error while saving image', error: e);
      return false;
    }
  }
}

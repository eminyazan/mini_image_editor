import 'dart:io';

import 'package:mini_image_editor/core/controllers/dependency_injection/service_locator.dart';
import 'package:mini_image_editor/core/utils/tools/image_picker/image_picker.dart';

class HomePageViewModel {
  final AppImagePicker _appImagePicker = AppImagePicker();

  List<String>? getSavedImagesPaths() => appLocalDatabase.getSavedImagesPaths();

  Future<File?> takePhotoFromCamera() async => await _appImagePicker.takePhotoFromCamera();

  Future<File?> pickImageFromGallery() async => await _appImagePicker.pickImageFromGallery();
}

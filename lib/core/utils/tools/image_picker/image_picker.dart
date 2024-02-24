import 'dart:io';

import 'package:image_picker/image_picker.dart';

//Base class for abstraction
abstract class ImagePickerBase {
  Future<File?> pickImageFromGallery();

  Future<File?> takePhotoFromCamera();
}

//Our service class we will use it for image picking operations
class AppImagePicker extends ImagePickerBase {
  final ImagePickerBase _imagePickerProvider = _ImagePickerProvider();

  @override
  Future<File?> pickImageFromGallery() async => await _imagePickerProvider.pickImageFromGallery();

  @override
  Future<File?> takePhotoFromCamera() async => await _imagePickerProvider.takePhotoFromCamera();
}

//Our provider class capsule it with ImagePickerBase so it became package independent
class _ImagePickerProvider implements ImagePickerBase {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImageFromGallery() async => await _imagePicker.pickImage(source: ImageSource.gallery).then(
        (value) => value != null ? File(value.path) : null,
      );

  @override
  Future<File?> takePhotoFromCamera() async => await _imagePicker.pickImage(source: ImageSource.camera).then(
        (value) => value != null ? File(value.path) : null,
      );
}

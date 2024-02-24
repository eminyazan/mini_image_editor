import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:mini_image_editor/core/utils/extensions/bottom_sheet_extension/bottom_sheet_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/size/size_extension.dart';
import 'package:mini_image_editor/view/components/page/screenshot_disabled/screenshot_disabled_page.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';
import 'package:mini_image_editor/view/constants/app_colors/app_colors.dart';

enum AppFilter { grayscale, sepia, monochrome, none }

class EditImagePage extends StatefulWidget {
  final File image;

  const EditImagePage({super.key, required this.image});

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  final _editedImageNotifier = ValueNotifier<img.Image?>(null);

  final _satNotifier = ValueNotifier<double>(1);
  final _brightNotifier = ValueNotifier<double>(0);
  final _conNotifier = ValueNotifier<double>(1);

  Future<void> _applyFilter(AppFilter filter) async {
    switch (filter) {
      case AppFilter.grayscale:
        _editedImageNotifier.value = img.grayscale(_editedImageNotifier.value!);
        break;
      case AppFilter.monochrome:
        _editedImageNotifier.value = img.monochrome(_editedImageNotifier.value!);
        break;
      case AppFilter.sepia:
        _editedImageNotifier.value = img.sepia(_editedImageNotifier.value!);
        break;
      default:
        _reset();
        break;
    }
    _editedImageNotifier.notifyListeners();
  }

  Future<void> _loadImage() async {
    ByteData data = await widget.image.readAsBytes().then((value) => ByteData.sublistView(Uint8List.fromList(value)));
    final List<int> bytes = data.buffer.asUint8List();
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    _editedImageNotifier.value = img.copyResize(image, width: image.width, height: image.height);
  }

  _reset() async {
    await _loadImage();
    _satNotifier.value = 1;
    _brightNotifier.value = 0;
    _conNotifier.value = 1;
  }

  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShotDisabledPage(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: _navBar(),
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildImage(),
              Container(
                color: Colors.white38,
                height: context.getHeight * 0.4,
                width: context.getWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildSlider(min: 0, max: 2, notifier: _satNotifier, icon: Icons.brush, name: 'Saturation'),
                    _buildSlider(min: -1, max: 1, notifier: _brightNotifier, icon: Icons.brightness_4, name: 'Brightness'),
                    _buildSlider(min: 0, max: 2, notifier: _conNotifier, icon: Icons.color_lens, name: 'Contrast'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const AppTextWidget(
        text: "Edit Image",
        style: TextStyle(color: Colors.black54),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings_backup_restore),
          onPressed: () => _reset(),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () async {
            //TODO save here
          },
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ValueListenableBuilder<img.Image?>(
        valueListenable: _editedImageNotifier,
        builder: (context, image, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: image != null
                ? Image.memory(Uint8List.fromList(img.encodePng(image)))
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }

  Widget _navBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.flip,
            color: Colors.white,
          ),
          label: 'Filters',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_left,
            color: Colors.white,
          ),
          label: 'Rotate Left',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_right,
            color: Colors.white,
          ),
          label: 'Rotate Right',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            _openFilters();
            break;
          case 1:
            rotate(true);
            break;
          case 2:
            rotate(false);
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: AppColors.kcLightModeMainSecondary,
      unselectedItemColor: AppColors.kcLightModeMainSecondary,
    );
  }

  void _openFilters() {
    context.showBottomSheet(
      title: 'Choose Filter',
      height: context.getHeight * .37,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterItem('Grayscale', AppFilter.grayscale),
          _filterItem('Sepia', AppFilter.sepia),
          _filterItem('Monochrome', AppFilter.monochrome),
          _filterItem('Remove filters', AppFilter.none),
        ],
      ),
    );
  }

  Widget _filterItem(String name, AppFilter filter) {
    return GestureDetector(
      onTap: () async {
        //Closes dialog
        context.pop();
        _applyFilter(filter);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8),
        child: AppTextWidget(text: name, fontSize: 17),
      ),
    );
  }

  void rotate(bool left) {
    double angle = left ? -90.0 : 90.0;
    int targetWidth = _editedImageNotifier.value!.height;
    int targetHeight = _editedImageNotifier.value!.width;
    _editedImageNotifier.value = img.copyRotate(_editedImageNotifier.value!, angle: angle);
    _editedImageNotifier.value = img.copyResize(_editedImageNotifier.value!, width: targetHeight, height: targetWidth);
  }

  Widget _buildSlider({
    required double min,
    required double max,
    required ValueNotifier<double> notifier,
    required IconData icon,
    required String name,
  }) {
    return ValueListenableBuilder<double>(
        valueListenable: notifier,
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: AppColors.kcLightModeMainSecondary,
                    ),
                    AppTextWidget(
                      text: name,
                      style: const TextStyle(color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(
                  width: context.getWidth * 0.5,
                  child: Slider(
                    onChanged: (double value) {
                      notifier.value = value;
                    },
                    onChangeEnd: (double value) => _adjustColor(),
                    divisions: 50,
                    value: notifier.value,
                    min: min,
                    max: max,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: context.getWidth * 0.08),
                  child: AppTextWidget(text: value.toStringAsFixed(2)),
                ),
              ],
            ),
          );
        });
  }

  _adjustColor() {
    //TODO make here
  }
}

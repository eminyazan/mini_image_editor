import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/utils/extensions/bottom_sheet_extension/bottom_sheet_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/tools/image_picker/image_picker.dart';
import 'package:mini_image_editor/view/components/alert/app_alert_dialog.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';
import 'package:mini_image_editor/view/pages/edit_image/edit_image_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppImagePicker _appImagePicker = AppImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTextWidget(text: 'Mini Image Editor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppTextWidget(
              text: 'Click button and choose image from gallery or camera',
              maxLine: 2,
              centerText: true,
            ),
            const SizedBox(height: 20),
            IconButton(onPressed: () => _openBottomSheet(), icon: const Icon(Icons.upload_file, size: 37))
          ],
        ),
      ),
    );
  }

  _openBottomSheet() async {
    await context.showBottomSheet(
      title: 'Choose Image',
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.camera_alt,
            ),
            title: const AppTextWidget(
              text: 'Take from camera',
            ),
            onTap: () async {
              await _appImagePicker.takePhotoFromCamera().then((res) {
                if (res != null) {
                  //Closes dialog
                  context.pop();
                  context.push(EditImagePage(image: res));
                } else {
                  AppAlert.show(description: 'Error while taking photo');
                }
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const AppTextWidget(
              text: 'Pick from gallery',
            ),
            onTap: () async {
              await _appImagePicker.pickImageFromGallery().then((res) {
                if (res != null) {
                  //Closes dialog
                  context.pop();
                  context.push(EditImagePage(image: res));
                } else {
                  AppAlert.show(description: 'Error while picking image');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/utils/extensions/bottom_sheet_extension/bottom_sheet_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/size/size_extension.dart';
import 'package:mini_image_editor/view/components/alert/app_alert_dialog.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';
import 'package:mini_image_editor/view/pages/edit_image/edit_image_page.dart';
import 'package:mini_image_editor/view/pages/home/view_model/home_page_view_model.dart';
import 'package:mini_image_editor/view/pages/previous_edits/previous_edits_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homePageViewModel = HomePageViewModel();
  List<String>? _previousRecords;

  _checkPreviousEdits() async {
    _previousRecords = _homePageViewModel.getSavedImagesPaths();
    setState(() {});
  }

  @override
  void initState() {
    _checkPreviousEdits();
    super.initState();
  }

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
            IconButton(onPressed: () => _openBottomSheet(), icon: const Icon(Icons.upload_file, size: 37)),
            if (_previousRecords != null && _previousRecords!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: context.getHeight * .05),
                  const AppTextWidget(
                    text: 'Click button look previous edits',
                    maxLine: 2,
                    centerText: true,
                  ),
                  IconButton(
                    onPressed: () async {
                      await context.push(PreviousEditsPage(paths: _previousRecords!)).then((_) {
                        _checkPreviousEdits();
                      });
                    },
                    icon: const Icon(Icons.history, size: 37),
                  )
                ],
              )
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
              await _homePageViewModel.takePhotoFromCamera().then((res) {
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
              await _homePageViewModel.pickImageFromGallery().then((res) {
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

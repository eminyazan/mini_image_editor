import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/size/size_extension.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';

extension BottomSheetExtension on BuildContext {
  Future<void> showBottomSheet({double? height, required String title, required Widget child}) async {
    await showModalBottomSheet(
        context: this,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) {
          return Container(
            height: height ?? getHeight * .3,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _title(title),
                child,
              ],
            ),
          );
        });
  }

  _title(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => pop(),
                child: const Icon(
                  Icons.close,
                  color: Colors.black26,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: AppTextWidget(
                  text: title,
                  textColor: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.black26,
        ),
      ],
    );
  }
}

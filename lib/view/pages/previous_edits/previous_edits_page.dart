import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/size/size_extension.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';

class PreviousEditsPage extends StatelessWidget {
  final List<String> paths;

  const PreviousEditsPage({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTextWidget(text: 'Previous Edits'),
      ),
      body: ListView.builder(
        itemCount: paths.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.push(_FullImageView(path: paths[index])),
          child: ListTile(
            leading: SizedBox(
              height: context.getHeight * .1,
              width: context.getWidth * .1,
              child: Image.file(
                File(paths[index]),
              ),
            ),
            subtitle: AppTextWidget(
              text: paths[index],
              fontSize: 11,
              maxLine: 3,
            ),
          ),
        ),
      ),
    );
  }
}

class _FullImageView extends StatelessWidget {
  final String path;

  const _FullImageView({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        panEnabled: false,
        //Zoom levels
        minScale: 0.5,
        maxScale: 2.5,
        child: Image.file(
          File(path),
          height: context.getHeight,
          width: context.getWidth,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/controllers/dependency_injection/service_locator.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/core/utils/extensions/size/size_extension.dart';
import 'package:mini_image_editor/view/components/text/app_text_widget.dart';
import 'package:mini_image_editor/view/pages/edit_image/edit_image_page.dart';

class PreviousEditsPage extends StatefulWidget {
  final List<String> paths;

  const PreviousEditsPage({super.key, required this.paths});

  @override
  State<PreviousEditsPage> createState() => _PreviousEditsPageState();
}

class _PreviousEditsPageState extends State<PreviousEditsPage> {
  List<String> _pathsChangeable = [];

  _reloadPath() {
    var res = appLocalDatabase.getSavedImagesPaths();
    if (res != null && res.isNotEmpty) {
      _pathsChangeable.clear();
      _pathsChangeable = res;
      setState(() {});
    }else{
      context.pop();
    }
  }

  @override
  void initState() {
    _pathsChangeable.addAll(widget.paths);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTextWidget(text: 'Previous Edits'),
      ),
      body: ListView.builder(
        key: const ValueKey('listKey'),
        itemCount: _pathsChangeable.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.push(_FullImageView(path: _pathsChangeable[index])),
          onLongPress: () async {
            await appLocalDatabase.deleteFromLocale(index).then((_) => _reloadPath());
          },
          child: ListTile(
            leading: SizedBox(
              height: context.getHeight * .1,
              width: context.getWidth * .1,
              child: Image.file(
                File(_pathsChangeable[index]),
              ),
            ),
            subtitle: AppTextWidget(
              text: _pathsChangeable[index],
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_sharp, color: Colors.white),
        onPressed: () => context.push(
          EditImagePage(
            image: File(path),
          ),
        ),
      ),
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

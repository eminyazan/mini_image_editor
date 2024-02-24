import 'package:flutter/cupertino.dart';
import 'package:mini_image_editor/main.dart';


extension NavigationExtension on BuildContext {
  void pushAndRemove(Widget page) {
    navigatorKey.currentState!.pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => page), (route) => false);
  }

  void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  Future<T?> push<T extends Object?>(Widget page) async {
    return navigatorKey.currentState!.push(
      CupertinoPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

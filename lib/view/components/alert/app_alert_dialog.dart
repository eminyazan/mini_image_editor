import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_image_editor/core/utils/extensions/navigation_extension/navigation_extension.dart';
import 'package:mini_image_editor/main.dart';
import 'package:mini_image_editor/view/constants/app_colors/app_colors.dart';

enum AlertType { success, error, warning }

class AppAlert {
  static Future<dynamic> show({
    required String description,
    String? title,
    String? cancelText,
    String? mainText,
    VoidCallback? cancelPressed,
    VoidCallback? mainPressed,
    AlertType alertType = AlertType.error,
    bool dismissible = true,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        barrierDismissible: dismissible,
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: dismissible,
            child: CupertinoAlertDialog(
              title: Text(
                title ?? 'Warning',
                style: TextStyle(
                  color: alertType == AlertType.error
                      ? CupertinoColors.destructiveRed
                      : alertType == AlertType.success
                          ? CupertinoColors.activeGreen
                          : CupertinoColors.activeOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(description, style: const TextStyle(fontSize: 15)),
              actions: <Widget>[
                if (cancelText != null)
                  CupertinoDialogAction(
                    isDefaultAction: false,
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontSize: 15, color: CupertinoColors.destructiveRed),
                    ),
                    onPressed: () {
                      if (cancelPressed != null) {
                        cancelPressed();
                      } else {
                        context.pop();
                      }
                    },
                  ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    mainText ?? 'OK',
                    style: const TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  onPressed: () {
                    if (mainPressed != null) {
                      mainPressed();
                    } else {
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        barrierDismissible: dismissible,
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: dismissible,
            child: AlertDialog(
              title: Text(
                title ?? 'Warning',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                if (cancelText != null)
                  TextButton(
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontSize: 15, color: AppColors.kcLightModeMainSecondary),
                    ),
                    onPressed: () {
                      if (cancelPressed != null) {
                        cancelPressed();
                      } else {
                        context.pop();
                      }
                    },
                  ),
                TextButton(
                  child: Text(
                    mainText ?? 'OK',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.kcLightModeMainSecondary,
                    ),
                  ),
                  onPressed: () {
                    if (mainPressed != null) {
                      mainPressed();
                    } else {
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<dynamic> withChild({
    required Widget child,
    List<Widget>? actions,
    Widget? title,
    Color titleColor = Colors.black,
    bool dismissible = true,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        barrierDismissible: dismissible,
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: dismissible,
            child: CupertinoAlertDialog(
              title: title,
              content: child,
              actions: actions ?? <Widget>[],
            ),
          );
        },
      );
    } else {
      return showDialog(
        barrierDismissible: dismissible,
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: dismissible,
            child: AlertDialog(
              title: title,
              content: child,
              actions: actions,
            ),
          );
        },
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class ScreenShotDisabledPage extends StatefulWidget {
  final Widget child;

  const ScreenShotDisabledPage({super.key, required this.child});

  @override
  State<ScreenShotDisabledPage> createState() => _ScreenShotDisabledPageState();
}

class _ScreenShotDisabledPageState extends State<ScreenShotDisabledPage> {
  _disableScreenShot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  _enableScreenShots() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    if (Platform.isAndroid) _enableScreenShots();
    super.dispose();
  }

  @override
  void initState() {
    //It works only on Android iOS side implemented on AppDelegate
    if (Platform.isAndroid) _disableScreenShot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

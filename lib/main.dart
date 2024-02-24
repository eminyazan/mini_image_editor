import 'package:flutter/material.dart';
import 'package:mini_image_editor/view/constants/app_colors/app_colors.dart';
import 'package:mini_image_editor/view/pages/home/home_page.dart';

//navigator state for navigation and alert operations
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


//TODO add pop scope to editing page ask for discard edit


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Image Editor',
      navigatorKey: navigatorKey,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kcLightModeMainPrimary)),
      home: const HomePage(),
    );
  }
}

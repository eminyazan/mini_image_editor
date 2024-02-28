import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_image_editor/core/model/app_consts/app_consts.dart';

import '../../local_database_controller.dart';

class HiveProvider extends LocalDatabaseController {
  late Box<String> _records;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _records = await Hive.openBox<String>(AppConsts.recordBox);
  }

  @override
  Future<void> saveImagePath(String path) async {
    await _records.add(path);
  }

  @override
  List<String>? getSavedImagesPaths() => _records.values.toList();

  @override
  Future<void> deleteFromLocale(int index) async => await _records.deleteAt(index);
}

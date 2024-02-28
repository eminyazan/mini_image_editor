import 'local_database_controller.dart';

class LocalDatabase implements LocalDatabaseController {
  late LocalDatabaseController localDatabaseProvider;

  static final LocalDatabase _instance = LocalDatabase._internal();

  LocalDatabase._internal();

  factory LocalDatabase({required LocalDatabaseController localDatabaseProvider}) {
    _instance.localDatabaseProvider = localDatabaseProvider;
    return _instance;
  }

  @override
  Future<void> initialize() async {
    await localDatabaseProvider.initialize();
  }

  @override
  Future<void> saveImagePath(String path) async => await localDatabaseProvider.saveImagePath(path);

  @override
  List<String>? getSavedImagesPaths() => localDatabaseProvider.getSavedImagesPaths();

  @override
  Future<void> deleteFromLocale(int index) async => await localDatabaseProvider.deleteFromLocale(index);
}

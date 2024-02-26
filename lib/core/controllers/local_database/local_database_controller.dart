abstract class LocalDatabaseController {
  Future<void> initialize();

  Future<void> saveImagePath(String path);

  List<String>? getSavedImagesPaths();
}

import 'package:get_it/get_it.dart';

import '../local_database/local_database.dart';
import '../local_database/provider/hive/hive_provider.dart';

final _serviceLocator = GetIt.instance;

final appLocalDatabase = _serviceLocator.get<LocalDatabase>();

void setupLocators() {
  //LocalDatabase class singleton
  _serviceLocator.registerLazySingleton(
    () => LocalDatabase(
      localDatabaseProvider: HiveProvider(),
    ),
  );
}

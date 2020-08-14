import 'package:cubaopenplay/src/blocs/blocs.dart';
import 'package:cubaopenplay/src/repositories/apps_hash_repository.dart';
import 'package:cubaopenplay/src/repositories/apps_repository.dart';
import 'package:get_it/get_it.dart';

void setupDependencies() {
  // Repositories
  GetIt.I.registerLazySingleton<IAppsHashRepository>(
    () => AppsHashRepository(),
  );
  GetIt.I.registerLazySingleton<IAppsRepository>(
    () => AppsRepository(GetIt.I.get<IAppsHashRepository>()),
  );
  // Blocs
  GetIt.I.registerLazySingleton<IAppsBloc>(
    () => AppsBloc(GetIt.I.get<IAppsRepository>()),
  );
}

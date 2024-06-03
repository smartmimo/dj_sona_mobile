import 'package:djsona_mobile/services/downloader_api_provider.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/api/api_service.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  serviceLocator.allowReassignment = true;

  /**
   * UTILS
  **/
  serviceLocator.registerSingleton<LocalStorageManager>(
    await LocalStorageManager.create(),
  );

  serviceLocator.registerSingleton<ApiService>(ApiService()..init());
  serviceLocator.registerSingleton<AppStateCubit>(AppStateCubit(serviceLocator.get<LocalStorageManager>())..init());

  /**
   * PROVIDERS
  **/
  serviceLocator.registerSingleton<SearchApiProvider>(
    SearchApiProvider(serviceLocator.get<ApiService>()),
  );
  serviceLocator.registerSingleton<DownloaderApiProvider>(
    DownloaderApiProvider(
      serviceLocator.get<ApiService>(),
      serviceLocator.get<LocalStorageManager>(),
    ),
  );
}

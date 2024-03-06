import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/api/api_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupDependencies() {
  serviceLocator.allowReassignment = true;
  serviceLocator.registerSingleton<ApiService>(ApiService()..init());
  serviceLocator.registerSingleton<AppStateCubit>(AppStateCubit()..init());

  /**
   * PROVIDERS
  **/
  serviceLocator.registerSingleton<SearchApiProvider>(
    SearchApiProvider(serviceLocator.get<ApiService>()),
  );
}

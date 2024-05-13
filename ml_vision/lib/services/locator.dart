import 'package:get_it/get_it.dart';
import 'ml_service.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<MLService>(() => MLService());
}

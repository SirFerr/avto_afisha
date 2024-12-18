import 'package:get_it/get_it.dart';

import 'feature/screens/auth/auth_notifier.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Регистрация AuthNotifier как singleton
  locator.registerLazySingleton<AuthNotifier>(() => AuthNotifier());
}

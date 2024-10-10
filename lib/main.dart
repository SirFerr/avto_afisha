import 'package:avto_afisha/routes/router.dart';
import 'package:avto_afisha/theme/theme.dart';
import 'package:flutter/material.dart';
import 'feature/locator.dart';

void main() {
  setupLocator(); // Настраиваем GetIt
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {

    final appRouter = AppRouter();
    return MaterialApp.router(
      title: 'AvtoAfisha',
      theme: theme,
      routerConfig: appRouter.router,
    );
  }
}




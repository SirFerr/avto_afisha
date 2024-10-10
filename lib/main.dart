import 'package:avto_afisha/routes/router.dart';
import 'package:avto_afisha/theme/theme.dart';
import 'package:avto_afisha/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feature/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return  MaterialApp.router(
          title: 'AvtoAfisha',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: appRouter.router,
        );
      },
    );
  }
}

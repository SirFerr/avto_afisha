import 'package:avto_afisha/locator.dart';
import 'package:avto_afisha/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'feature/screens/auth/auth_notifier.dart';
import 'routes/router.dart';

void main() {
  setupLocator();
  final router = AppRouter().router;
  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<AuthNotifier>()),
      ],
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Your App',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: state.themeMode,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}

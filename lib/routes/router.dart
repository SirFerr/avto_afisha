import 'package:avto_afisha/feature/screens/export_screens.dart';
import 'package:avto_afisha/feature/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter get router => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Text('/'),
          ),
          GoRoute(
            path: '/auth',
            builder: (context, state) => AuthScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => MainScreen(),
          ),
          GoRoute(
            path: '/event',
            builder: (context, state) => EventScreen(),
          ),
          GoRoute(
            path: '/purchase',
            builder: (context, state) => const Text('/purchase'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const Text('/favorites'),
          ),
          GoRoute(
            path: '/purchasedTickets',
            builder: (context, state) => const Text('/purchasedTickets'),
          ),
          GoRoute(
            path: '/tickets',
            builder: (context, state) => const Text('/tickets'),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const Text('/about'),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Text('/settings'),
          ),
        ],
        redirect: (context, state) {
          // Если текущий путь корневой, то перенаправляем на /auth
          if (state.location == '/') {
            return '/auth';
          }
          // В остальных случаях возвращаем null, чтобы не было редиректа
          return null;
        },
      );
}

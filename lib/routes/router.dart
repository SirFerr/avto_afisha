import 'package:avto_afisha/feature/screens/export_screens.dart';
import 'package:avto_afisha/feature/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../feature/screens/auth/auth_notifier.dart';
import '../locator.dart';

class AppRouter {
  final AuthNotifier authNotifier = locator<AuthNotifier>();


  GoRouter get router => GoRouter(
        refreshListenable: authNotifier,

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
            path: '/main',
            builder: (context, state) => MainScreen(),
          ),
          GoRoute(
            path: '/event/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EventScreen(
                id: id,
              );
            },
          ),
          GoRoute(
            path: '/purchase',
            builder: (context, state) {
              final purchaseData = state.extra as Map<String, dynamic>;
              return PurchaseScreen(
                eventName: purchaseData['eventName'],
                date: purchaseData['date'],
                location: purchaseData['location'],
                price: purchaseData['price'],
              );
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => FavoritesScreen(),
          ),
          GoRoute(
            path: '/purchasedTickets',
            builder: (context, state) => PurchasedTicketsScreen(),
          ),
          GoRoute(
            path: '/ticket',
            builder: (context, state) {
              // Получаем данные из state.extra и проверяем наличие данных о билете
              if (state.extra is Map<String, dynamic>) {
                final ticketData = state.extra as Map<String, dynamic>;
                return TicketScreen(
                  eventName: ticketData['eventName'] ?? 'No Event Name',
                  date: ticketData['date'] ?? DateTime.now(),
                  location: ticketData['location'] ?? 'No Location',
                  price: ticketData['price'] ?? 0.0,
                );
              }

              // Если данные не были переданы, показываем сообщение об ошибке
              return const Scaffold(
                body: Center(child: Text('Invalid ticket data')),
              );
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => AboutAppScreen(),
          ),
        ],
        redirect: (context, state) async {

          final isAuthenticated = authNotifier.isAuthenticated;

          // Если пользователь не авторизован, перенаправляем на /auth
          if (!isAuthenticated && state.location != '/auth') {
            return '/auth';
          }

          // Если пользователь авторизован, но находится на /auth, перенаправляем на /main
          if (isAuthenticated && state.location == '/auth') {
            return '/main';
          }

          return null; // Не перенаправлять
        },
      );
}

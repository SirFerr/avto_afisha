import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Экран профиля'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileOption(
            context,
            label: 'Избранные мероприятия',
            onTap: () {
              // Логика перехода на экран избранных мероприятий
              context.go('/favorites');
            },
          ),
          _buildProfileOption(
            context,
            label: 'Купленные билеты',
            onTap: () {
              // Логика перехода на экран купленных билетов
              context.go('/tickets');
            },
          ),
          _buildProfileOption(
            context,
            label: 'Экран О приложении',
            onTap: () {
              // Логика перехода на экран "О приложении"
              context.go('/about');
            },
          ),
          _buildProfileOption(
            context,
            label: 'Экран настроек',
            onTap: () {
              // Логика перехода на экран настроек
              context.go('/settings');
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Логика выхода из аккаунта
              context.go('/logout');
            },
            child: const Text(
              'Выйти из аккаунта',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: const Icon(Icons.description),
      title: Text(label),
      onTap: onTap,
    );
  }
}

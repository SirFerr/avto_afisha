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
              context.push('/favorites');
            },
          ),
          _buildProfileOption(
            context,
            label: 'Купленные билеты',
            onTap: () {
              // Логика перехода на экран купленных билетов
              context.push('/purchasedTickets');
            },
          ),
          _buildProfileOption(
            context,
            label: '"О приложении"',
            onTap: () {
              // Логика перехода на экран "О приложении"
              context.push('/about');
            },
          ),
          _buildProfileOption(
            context,
            label: 'Настройки',
            onTap: () {
              // Логика перехода на экран настроек
              context.push('/settings');
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Логика выхода из аккаунта
              context.push('/logout');
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

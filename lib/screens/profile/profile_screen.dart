import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../history/history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final isBoss = user.role == UserRole.boss;
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(user.displayName),
            subtitle: Text('${user.email} - ${isBoss ? 'Boss' : 'Employé'}'),
            trailing: FilledButton.tonal(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (_) => false,
                );
              },
              child: const Text('Déconnexion'),
            ),
          ),
        ),
        const Expanded(child: HistoryScreen()),
      ],
    );
  }
}

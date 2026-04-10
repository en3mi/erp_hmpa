import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../purchases/purchase_list_screen.dart';
import '../sales/sale_list_screen.dart';
import '../validations/validations_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().currentUser?.role;
    final isBoss = role == UserRole.boss;
    final pages = [
      const DashboardScreen(),
      const PurchaseListScreen(),
      const SaleListScreen(),
      if (isBoss) const ValidationsScreen(),
      const ProfileScreen(),
    ];
    final labels = [
      'Dashboard',
      'Achats',
      'Ventes',
      if (isBoss) 'Validations',
      'Profil',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(labels[index])),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (v) => setState(() => index = v),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Achats'),
          const BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Ventes'),
          if (isBoss)
            const BottomNavigationBarItem(
              icon: Icon(Icons.verified),
              label: 'Validations',
            ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/erp_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/common/splash_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ErpHmpaApp());
}

class ErpHmpaApp extends StatelessWidget {
  const ErpHmpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ErpProvider()..init()),
      ],
      child: MaterialApp(
        title: 'ERP HMPA - Gestion Comptable',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1E3A5F),
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        ),
        home: const SplashScreen(),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  AppUser? currentUser;

  bool login(String email, String password) {
    final user = _authService.login(email, password);
    if (user == null) return false;
    currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}

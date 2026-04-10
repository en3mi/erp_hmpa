import '../core/enums.dart';
import '../models/user.dart';

class AuthService {
  static const _users = <Map<String, String>>[
    {
      'email': 'admin@hmpa.com',
      'password': 'admin123',
      'name': 'Boss HMPA',
      'role': 'boss',
    },
    {
      'email': 'employe@hmpa.com',
      'password': 'employe123',
      'name': 'Employé HMPA',
      'role': 'employee',
    },
  ];

  AppUser? login(String email, String password) {
    final user = _users.cast<Map<String, String>?>().firstWhere(
      (u) => u?['email'] == email.trim(),
      orElse: () => null,
    );
    if (user == null || user['password'] != password) return null;
    return AppUser(
      id: user['email']!,
      email: user['email']!,
      displayName: user['name']!,
      role: user['role'] == 'boss' ? UserRole.boss : UserRole.employee,
    );
  }
}

import 'package:farafinah_insta/models/user.dart';

class AuthService {
  // Static list of mock users for login simulation
  static final List<User> _users = [
    User(username: 'muser1', password: 'mpassword1'),
    User(username: 'muser2', password: 'mpassword2'),
    User(username: 'muser3', password: 'mpassword3', isBlocked: true),
  ];

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();

  // Current logged in user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Login method that simulates authentication
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user in the mock users list
    final user = _users.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''),
    );

    // Check if user exists
    if (user.username.isEmpty) {
      return {
        'success': false,
        'message': 'Informations de connexion invalides',
      };
    }

    // Check if user is blocked
    if (user.isBlocked) {
      return {
        'success': false,
        'message': 'Ce compte a été bloqué.',
      };
    }

    // Set current user and return success
    _currentUser = user;
    return {
      'success': true,
      'user': user,
    };
  }

  // Logout method
  Future<void> logout() async {
    _currentUser = null;
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
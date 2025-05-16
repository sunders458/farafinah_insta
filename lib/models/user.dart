class User {
  final String username;
  final String password;
  final bool isBlocked;

  User({
    required this.username,
    required this.password,
    this.isBlocked = false,
  });
}
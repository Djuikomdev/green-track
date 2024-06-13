class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      phone: data['phone'],
      role: data['role'],
    );
  }
}
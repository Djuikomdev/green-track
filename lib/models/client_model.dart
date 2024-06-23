class Client {
  final String id;
  final String username;
  final String email;
  final String city;
  final String quarter;
  final String phone;
  final String date;
  final String role;

  Client( {
    required this.id,
    required this.city,
    required this.quarter,
    required this.username,
    required this.email,
    required this.phone,
    required this.date,
    required this.role,
  });

  factory Client.fromMap(Map<String, dynamic> data) {
    return Client(
      id: data['id'],
      city: data['city'],
      quarter: data['quarter'],
      username: data['username'],
      email: data['email'],
      phone: data['phone'],
      role: data['role'],
      date: data['date'],
    );
  }
}
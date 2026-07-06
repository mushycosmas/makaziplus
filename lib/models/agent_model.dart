// lib/models/agent.dart
class Agent {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String createdAt;
  final int propertyCount;

  Agent({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.propertyCount,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      createdAt: json['createdAt'] ?? '',
      propertyCount: json['_count']?['properties'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'createdAt': createdAt,
      'propertyCount': propertyCount,
    };
  }
}
class Category {
  final int id;
  final String name;
  final String? icon;
  final DateTime? createdAt;
  final int totalProperties;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.createdAt,
    required this.totalProperties,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      // 🔥 IMPORTANT PART
      totalProperties: (json['properties'] as List<dynamic>?)
              ?.length ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt?.toIso8601String(),
      'totalProperties': totalProperties,
    };
  }
}
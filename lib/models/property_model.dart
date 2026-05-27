class Property {
  final int id;
  final String title;
  final String description;
  final double price;
  final String type;
  final String status;

  final int userId;
  final int categoryId;
  final int wardId;

  final String wardName;
  final String categoryName;

  final List<String> images;
  final List<Amenity> amenities;

  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.status,
    required this.userId,
    required this.categoryId,
    required this.wardId,
    required this.wardName,
    required this.categoryName,
    required this.images,
    required this.amenities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      status: json['status'] ?? '',

      userId: json['userId'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      wardId: json['wardId'] ?? 0,

      wardName: json['ward']?['name'] ?? '',
      categoryName: json['category']?['name'] ?? '',

      // ✅ FIXED IMAGES
      images: (json['images'] as List?)
              ?.map((img) => img['url'].toString())
              .toList() ??
          [],

      // ✅ FIXED AMENITIES
      amenities: (json['amenities'] as List?)
              ?.map((e) => Amenity.fromJson(e['amenity']))
              .toList() ??
          [],

      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }
}

class Amenity {
  final int id;
  final String name;
  final String icon;

  Amenity({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
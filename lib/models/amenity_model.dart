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
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class PropertyAmenity {
  final int id;
  final int propertyId;
  final int amenityId;
  final Amenity amenity;

  PropertyAmenity({
    required this.id,
    required this.propertyId,
    required this.amenityId,
    required this.amenity,
  });

  factory PropertyAmenity.fromJson(Map<String, dynamic> json) {
    return PropertyAmenity(
      id: json['id'],
      propertyId: json['propertyId'],
      amenityId: json['amenityId'],
      amenity: Amenity.fromJson(json['amenity']),
    );
  }
}
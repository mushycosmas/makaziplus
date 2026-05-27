class Property {
  final int id;
  final String title;
  final String description;
  final int price;
  final String type;
  final String status;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.status,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'status': status,
    };
  }
}
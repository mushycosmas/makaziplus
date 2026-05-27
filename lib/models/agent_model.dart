class Agent {
  final int id;
  final String name;
  final String properties;
  final String rating;
  final String? image;

  Agent({
    required this.id,
    required this.name,
    required this.properties,
    required this.rating,
    this.image,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'] ?? '',
      properties: json['properties'] ?? '0 Properties',
      rating: json['rating']?.toString() ?? '0.0',
      image: json['image'],
    );
  }
}
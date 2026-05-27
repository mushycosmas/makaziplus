class District {
  final int id;
  final String name;
  final int regionId;

  District({
    required this.id,
    required this.name,
    required this.regionId,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      regionId: json['regionId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'regionId': regionId,
    };
  }
}
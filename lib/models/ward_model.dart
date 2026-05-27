class Ward {
  final int id;
  final String name;

  Ward({
    required this.id,
    required this.name,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'],
      name: json['name'],
    );
  }
}
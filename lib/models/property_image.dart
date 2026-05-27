class PropertyImage {
  final int id;
  final String url;

  PropertyImage({
    required this.id,
    required this.url,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'],
      url: json['url'],
    );
  }
}
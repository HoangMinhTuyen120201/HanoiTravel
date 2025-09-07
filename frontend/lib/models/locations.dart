class Location {
  final String id;
  final String name;
  final String nameEn;
  final String image;
  final String description;
  final String descriptionEn;
  final String address;
  final List<String> tags;
  final String createdAt;
  final bool isFeatured;

  Location({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.image,
    required this.description,
    required this.descriptionEn,
    required this.address,
    required this.tags,
    required this.createdAt,
    required this.isFeatured,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      address: json['address'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'nameEn': nameEn,
      'image': image,
      'description': description,
      'descriptionEn': descriptionEn,
      'address': address,
      'tags': tags,
      'createdAt': createdAt,
      'isFeatured': isFeatured,
    };
  }
}

class Product {
  final int? id;
  final String name;
  final double price;
  final String category;
  final String imagePath;
  final bool favorite;
  final String createdAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imagePath = '',
    this.favorite = false,
    this.createdAt = '',
  });

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    String? imagePath,
    bool? favorite,
    String? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'favorite': favorite ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      category: map['category'],
      imagePath: map['imagePath'] ?? '',
      favorite: (map['favorite'] ?? 0) == 1,
      createdAt: map['createdAt'] ?? '',
    );
  }
}

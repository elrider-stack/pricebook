class Product {
  final int? id;
  final String name;
  final double price;
  final String category;
  final String createdAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final int discount;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.discount,
    required this.stock,
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['product_name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      discount: json['discount_rate'],
      stock: json['stock_quantity'],
    );
  }
}

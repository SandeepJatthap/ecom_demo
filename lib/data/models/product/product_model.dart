import '../../../domain/entities/product/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.rating,
    required super.price,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        rating: json["rating"] != null ? Rating.fromJson(json["rating"]) : null,
        price: json["price"]?.toDouble(),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "rating": rating?.toJson(),
        "price": price,
        "category": category,
      };

  factory ProductModel.fromEntity(Product entity) => ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      rating: entity.rating,
      price: entity.price,
      category: entity.category,
      image: entity.image);
}

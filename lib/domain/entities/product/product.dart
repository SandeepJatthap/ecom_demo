import 'package:equatable/equatable.dart';

class Product extends Equatable {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
  });

  @override
  List<Object?> get props => [id];
}

class Rating {
  Rating({
    double? rate,
    int? count,
  }) {
    _rate = rate;
    _count = count;
  }

  Rating.fromJson(dynamic json) {
    _rate = json['rate']?.toDouble();
    _count = json['count'];
  }

  double? _rate;
  int? _count;

  double? get rate => _rate;

  int? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rate'] = _rate;
    map['count'] = _count;
    return map;
  }
}

import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0) String? id;
  @HiveField(1) String? name;
  @HiveField(2) String? description;
  @HiveField(3) double? price;
  @HiveField(4) int? stock;
  @HiveField(5) String? category;
  @HiveField(6) String? brand;
  @HiveField(7) bool? isDiscounted;
  @HiveField(8) String? image;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.brand,
    this.isDiscounted,
    this.image
  });
}
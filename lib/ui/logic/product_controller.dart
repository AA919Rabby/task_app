import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../data/models/product_model.dart';


class ProductController extends GetxController {
  var productList = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocalProducts();
  }

  void fetchLocalProducts() {
    var box = Hive.box<ProductModel>('productsBox');
    productList.value = box.values.toList();
  }
}
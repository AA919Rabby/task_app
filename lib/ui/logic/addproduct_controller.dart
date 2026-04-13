import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/ui/logic/product_controller.dart';
import '../../data/models/product_model.dart';

class AddProductController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  // Form Field Controllers
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();
  final discountController = TextEditingController();
  final weightController = TextEditingController();
  final dimensionsController = TextEditingController();

  // Dropdown States
  var selectedCategory = "".obs;
  var selectedStock = "".obs;
  var selectedTag = "".obs;
  var selectedStatus = "".obs;
  var selectedColor = "".obs;
  var selectedImage = Rxn<File>();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void addProduct() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 3));

      String imagePath = selectedImage.value?.path ?? "";

      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        description: descController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        stock: selectedStock.value == "In Stock" ? 10 : 0,
        category: selectedCategory.value,
        brand: brandController.text,
        image: imagePath,
      );

      var box = Hive.box<ProductModel>('productsBox');
      await box.add(newProduct);

      // Refresh list in HomeView
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().fetchLocalProducts();
      }

      isLoading.value = false;
      Get.back();

      Get.snackbar(
          "Success",
          "Product added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}
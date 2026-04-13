import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/core/sizes.dart';
import '../../data/models/product_model.dart';
import '../logic/product_controller.dart';

class EditproductController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  ProductModel? editingProduct;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();
  final discountController = TextEditingController();
  final weightController = TextEditingController();
  final dimensionsController = TextEditingController();

  // Dropdown Selections
  var selectedCategory = Rxn<String>();
  var selectedStoke = Rxn<String>();
  var selectedTag = Rxn<String>();
  var selectedStatus = Rxn<String>();
  var selectedColor = Rxn<String>();
  var selectedBrand = Rxn<String>();

  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      editingProduct = Get.arguments as ProductModel;

      nameController.text = editingProduct!.name ?? '';
      descController.text = editingProduct!.description ?? '';
      priceController.text = editingProduct!.price?.toString() ?? '';

      selectedBrand.value = editingProduct!.brand;

      String? cat = editingProduct!.category;
      selectedCategory.value = (cat != null && cat.trim().isNotEmpty) ? cat : null;

      if (editingProduct!.stock != null) {
        selectedStoke.value = editingProduct!.stock! > 0 ? "In Stock" : "Out of Stock";
      } else {
        selectedStoke.value = null;
      }

      if (editingProduct!.image != null && editingProduct!.image!.isNotEmpty) {
        selectedImage.value = File(editingProduct!.image!);
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void updateProduct() async {
    if (formKey.currentState!.validate() && editingProduct != null) {
      isLoading.value = true;

      Get.dialog(
        Center(child: SpinKitFadingCircle(color: AllThemes.blueColor, size: 10.w)),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(seconds: 3));

      // Update fields
      editingProduct!.name = nameController.text;
      editingProduct!.description = descController.text;
      editingProduct!.price = double.tryParse(priceController.text) ?? 0.0;
      editingProduct!.category = selectedCategory.value;

      // Save from the dropdown variable
      editingProduct!.brand = selectedBrand.value;

      editingProduct!.stock = selectedStoke.value == "In Stock" ? 10 : 0;

      if (selectedImage.value != null) {
        editingProduct!.image = selectedImage.value!.path;
      }

      await editingProduct!.save();

      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().fetchLocalProducts();
      }

      if (Get.isDialogOpen == true) Get.back();
      isLoading.value = false;
      Get.back();

      Get.snackbar("Success", "Product updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
  }
}
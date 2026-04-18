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

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await ProductServices().getProducts(token ?? "");
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) productList.value = body['data'];
    } catch (e) {
      Get.snackbar('Error', 'Network Error');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addProduct() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final Map<String, dynamic> productMap = {
        "name": pNameClt.text.trim(),
        "description": pDescClt.text.trim(),
        "price": double.parse(pPriceClt.text.trim()),
        "stock": int.parse(pStockClt.text.trim()),
        "category": pCatClt.text.trim(),
        "colors": pColorClt.text.split(',').map((e) => e.trim()).toList(),
        "isActive": true,
      };

      var response = await http.post(
        Uri.parse("${BaseUrl.baseUrl}/products"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(productMap),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Product added successfully');
        fetchProducts();
        Get.back();
      } else {
        var body = jsonDecode(response.body);
        Get.snackbar('Error', body['message'] ?? 'Server Error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ensure Price and Stock are valid numbers');
    } finally {
      isLoading.value = false;
    }
  }
}

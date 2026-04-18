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
  Future<void> editProduct(String id) async {
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

      var response = await http.put(
        Uri.parse("${BaseUrl.baseUrl}/products/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(productMap),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Product updated');
        fetchProducts();
        Get.back();
      } else {
        var body = jsonDecode(response.body);
        Get.snackbar('Error', body['message'] ?? 'Server Error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await ProductServices().deleteProduct(token!, id);
      if (response.statusCode == 200) {
        fetchProducts();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete Failed');
    } finally {
      isLoading.value = false;
    }
  }
}

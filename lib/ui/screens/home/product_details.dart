import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/core/sizes.dart';
import '../../../data/models/product_model.dart';
import '../../logic/product_controller.dart';
import 'edit_product.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});
  void _deleteProductFromHive(ProductModel product) async {
    try {
      // Deletes the object from the Hive box
      await product.delete();

      // Refresh the product list in the background controller
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().fetchLocalProducts();
      }

      Get.back(); // Return to previous screen
      Get.snackbar(
        "Deleted",
        "Product removed successfully",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not delete: $e", backgroundColor: Colors.red);
    }
  }

  // Confirmation Dialog to prevent accidental taps
  void _showDeleteDialog(BuildContext context, ProductModel product) {
    Get.defaultDialog(
      title: "Delete Product",
      middleText: "Are you sure you want to delete ${product.name}?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Close dialog
        _deleteProductFromHive(product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    // Proper casting from arguments
    final ProductModel product = Get.arguments as ProductModel;

    bool inStock = (product.stock ?? 0) > 0;

    return Scaffold(
      backgroundColor: AllThemes.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularIcon(Icons.arrow_back, () => Get.back()),
                  Text(
                    "Product Detail",
                    style: GoogleFonts.inter(
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Updated Trash Icon with Delete Logic
                  _buildCircularIcon(
                    Icons.delete_outline,
                        () => _showDeleteDialog(context, product),
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.w),
                        child: _buildImage(product.image),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Name & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name ?? "Product",
                            style: GoogleFonts.inter(
                              fontSize: 2.8.h,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                          style: GoogleFonts.inter(
                            fontSize: 2.6.h,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Stock
                    Row(
                      children: [
                        Icon(
                          inStock ? Icons.check : Icons.close,
                          color: inStock ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          inStock ? "In Stock" : "Out of Stock",
                          style: GoogleFonts.inter(
                            color: inStock ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Category + Brand
                    Text(
                      "${product.category ?? ''} ${product.brand ?? ''}",
                      style: GoogleFonts.inter(
                        fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Discount status
                    Text(
                      product.isDiscounted == true
                          ? "Discount Available"
                          : "No Discount",
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 1.8.h,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Description
                    Text(
                      "Description",
                      style: GoogleFonts.inter(
                        fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      product.description ?? "No description",
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 1.8.h,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Edit Button
            Padding(
              padding: EdgeInsets.all(5.w),
              child: SizedBox(
                width: double.infinity,
                height: 7.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllThemes.blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => EditProduct(), arguments: product);
                  },
                  child: Text(
                    "Edit Product",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 2.2.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon, VoidCallback onTap,
      {Color color = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

   _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image, size: 50);
    }
    // Network Image
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    // Local Hive/Picker File
    return Image.file(File(path), fit: BoxFit.cover);
  }
}
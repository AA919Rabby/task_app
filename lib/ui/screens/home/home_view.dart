import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/ui/screens/home/product_details.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/sizes.dart';
import '../../logic/product_controller.dart';
import 'package:get/get.dart';
import '../../logic/profile_controller.dart';
import 'add_product.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final productController = Get.put(ProductController());
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);

    return Scaffold(
      backgroundColor: AllThemes.blueColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 12.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 7.w,
                      backgroundColor: AllThemes.whiteColor,
                      backgroundImage: profileController.selectedImage.value.isNotEmpty
                          ? FileImage(File(profileController.selectedImage.value))
                          : const AssetImage('assets/images/user_placeholder.png') as ImageProvider,
                    );
                  }),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hi, Wade Warren!",
                          style: GoogleFonts.inter(
                            color: AllThemes.whiteColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AllThemes.whiteColor, size: 4.w),
                            SizedBox(width: 1.w),
                            Text(
                              "Golder Avenue, Abuja",
                              style: GoogleFonts.inter(
                                color: AllThemes.whiteColor,
                                fontSize: 2.2.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AllThemes.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.w),
                    topRight: Radius.circular(8.w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Services",
                          style: GoogleFonts.inter(
                            color: AllThemes.blackColor,
                            fontSize: 2.8.h,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Filter row
                      Row(
                        children: [
                          _buildFilterTab("Ongoing", true),
                          SizedBox(width: 3.w),
                          _buildFilterTab("Upcoming", false),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Products grid with Refresh and Shimmer
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            productController.isLoading.value = true;
                             productController.fetchLocalProducts();
                            await Future.delayed(const Duration(seconds: 3));
                            productController.isLoading.value = false;
                          },
                          color: AllThemes.blueColor,
                          child: Obx(() {
                            // Show Shimmer Effect during loading
                            if (productController.isLoading.value) {
                              return _buildShimmerGrid();
                            }

                            if (productController.productList.isEmpty) {
                              return ListView(
                                children: [
                                  SizedBox(height: 20.h),
                                  Center(
                                    child: Text("No products available.",
                                        style: GoogleFonts.inter(color: AllThemes.greyColor)),
                                  ),
                                ],
                              );
                            }

                            return GridView.builder(
                              padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.w,
                                mainAxisSpacing: 2.h,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: productController.productList.length,
                              itemBuilder: (context, index) {
                                final product = productController.productList[index];
                                return _buildProductCard(product);
                              },
                            );
                          }),
                        ),
                      ),

                      CustomButton(
                        onTap: () => Get.to(() => AddProduct()),
                        color: AllThemes.blueColor,
                        label: 'Create Product',
                        labelColor: AllThemes.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.w),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterTab(String label, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isActive ? AllThemes.blueColor : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isActive ? AllThemes.whiteColor : Colors.grey,
          fontSize: 2.h,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

   _buildProductCard(var product) {
    bool inStock = (product.stock ?? 0) > 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () => Get.to(() => const ProductDetails(),
                arguments: product,
                duration: const Duration(milliseconds: 500),
                transition: Transition.fade,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.w),
                      child: _buildProductImage(product.image),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        (product.category ?? "Electronics").toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AllThemes.blueColor),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AllThemes.blueColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    product.name ?? 'Unnamed Product',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.check, size: 14, color: inStock ? Colors.green : Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        inStock ? 'In Stock' : 'Out of Stock',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: inStock ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Details',
                        style: GoogleFonts.inter(fontSize: 11, color: AllThemes.blueColor, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Edit', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(color: Colors.grey.shade200, child: const Icon(Icons.image_outlined, color: Colors.grey));
    }

    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
      }
      return const Icon(Icons.broken_image);
    }
  }
}
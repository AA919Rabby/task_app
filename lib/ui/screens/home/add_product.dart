import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/addproduct_controller.dart';

class AddProduct extends StatelessWidget {
  AddProduct({super.key});

  final controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      backgroundColor: AllThemes.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AllThemes.noColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 2),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: AllThemes.whiteColor,
                border: Border.all(color: AllThemes.greyColor.withOpacity(0.1), width: 1.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, size: 2.7.h),
            ),
          ),
        ),
        centerTitle: true,
        title: Text('Add Product', style: GoogleFonts.inter(fontSize: 2.8.h, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection(),
              SizedBox(height: 1.h),

              _buildLabel("Product Name"),
              _buildTextField(controller.nameController, "Type product name"),

              _buildLabel("Select Category"),
              _buildDropdown("Select Categories", ["Electronics", "Fashion", "Grocery"], controller.selectedCategory),

              _buildLabel("Description"),
              _buildTextField(controller.descController, "Type Description", maxLines: 4),

              _buildLabel("Price"),
              _buildTextField(controller.priceController, "Type Price", keyboardType: TextInputType.number),

              _buildLabel("Stock"),
              _buildDropdown("Select Stock Status", ["In Stock", "Out of Stock"], controller.selectedStock),

              SizedBox(height: 4.h),

              SizedBox(
                width: double.infinity,
                height: 7.h,
                child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF246BFD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: controller.isLoading.value ? null : () => controller.addProduct(),
                  child: controller.isLoading.value
                      ? Center(
                    child: SpinKitFadingCircle(
                      color: AllThemes.blueColor,
                      size: 8.w,
                    ),
                  )
                      : Text(
                      "Submit",
                      style: GoogleFonts.inter(
                          fontSize: 2.2.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      )
                  ),
                )),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Obx(() => controller.selectedImage.value == null
              ? Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400, size: 8.h)
              : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(controller.selectedImage.value!, height: 12.h, width: 12.h, fit: BoxFit.cover),
          )),
          SizedBox(height: 1.h),
          Text('Upload photo', style: GoogleFonts.inter(fontSize: 2.2.h, fontWeight: FontWeight.w700)),
          SizedBox(height: 1.h),
          OutlinedButton(
            onPressed: () => controller.pickImage(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Choose a file", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: GoogleFonts.inter(fontSize: 2.h, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value == null || value.isEmpty ? "Required field" : null,
    );
  }

  Widget _buildDropdown(String hint, List<String> items, RxString selectedValue) {
    return Obx(() => DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      hint: Text(hint),
      value: selectedValue.value.isEmpty ? null : selectedValue.value,
      items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (val) => selectedValue.value = val!,
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
    ));
  }
}
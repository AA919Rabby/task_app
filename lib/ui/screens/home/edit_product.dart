import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/editproduct_controller.dart';

class EditProduct extends StatelessWidget {
  EditProduct({super.key});

  final controller = Get.put(EditproductController());

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
                child: Icon(Icons.arrow_back, size: 2.7.h)),
          ),
        ),
        centerTitle: true,
        title: Text('Edit Product',
          style: GoogleFonts.inter(fontSize: 2.8.h, fontWeight: FontWeight.w700, color: AllThemes.blackColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection(),
              SizedBox(height: 3.h),

              _buildLabel("Product Name"),
              _buildTextField(controller.nameController, "Type product name"),

              _buildLabel("Select Category"),
              _buildDropdown("Select Categories", ["Electronics", "Fashion", "Health"],
                  controller.selectedCategory),

              _buildLabel("Description"),
              _buildTextField(controller.descController, "Type Description", maxLines: 4),

              _buildLabel("Price"),
              _buildTextField(controller.priceController, "Type Price", keyboardType: TextInputType.number),

              SizedBox(height: 4.h),

              SizedBox(
                width: double.infinity,
                height: 7.h,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.updateProduct(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF246BFD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value
                      ? SpinKitFadingCircle(
                    color: AllThemes.blueColor,
                    size: 4.h,
                  )
                      : Text("Submit", style: GoogleFonts.inter(color: Colors.white,
                      fontWeight: FontWeight.bold, fontSize: 2.2.h)),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Obx(() => controller.selectedImage.value == null
              ? Icon(Icons.add_photo_alternate_outlined, size: 8.h, color: Colors.grey)
              : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(controller.selectedImage.value!, height: 10.h, width: 10.h, fit: BoxFit.cover),
          ),
          ),
          SizedBox(height: 1.h),
          Text('Upload photo', style: GoogleFonts.inter(fontSize: 2.2.h, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.5.h),
          Text('Upload the front side of your document\nSupports: JPG, PNG, PDF',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 1.6.h, color: Colors.grey),
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: () => controller.pickImage(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: const BorderSide(color: Colors.black54),
            ),
            child: const Text("Choose a file", style: TextStyle(color: Colors.black87)),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 15.0),
      child: Text(text, style: GoogleFonts.inter(fontSize: 2.h, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {int maxLines = 1,
    TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
    );
  }

  Widget _buildDropdown(String hint, List<String> items, Rxn<String> selectedValue) {
    return Obx(() => DropdownButtonFormField<String>(
      value: selectedValue.value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400)),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
      onChanged: (newValue) => selectedValue.value = newValue,
      validator: (value) => value == null ? "Selection required" : null,
    ));
  }
}
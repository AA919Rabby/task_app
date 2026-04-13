import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/ui/screens/home/home_view.dart';
import '../../core/all_themes.dart';
import '../../data/services/auth_services.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  final List<dynamic> languages = [
    {'name': 'English (US)', 'flag': 'assets/country/us.jpg'},
    {'name': 'Indonesia', 'flag': 'assets/country/indonesia.jpg'},
    {'name': 'Afghanistan', 'flag': 'assets/country/afghanistan.jpg'},
    {'name': 'Algeria', 'flag': 'assets/country/algeria.jpg'},
    {'name': 'Malaysia', 'flag': 'assets/country/malaysia.jpg'},
    {'name': 'Arabic', 'flag': 'assets/country/arabic.jpg'},
  ].obs;

  var selectedIndex = 0.obs;

  void changeSelection(int index) {
    selectedIndex.value = index;
  }

  var selectedImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedProfileData(); // Automatically load saved image when screen opens
  }

  // Load the image path we saved in AuthServices
  void loadSavedProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImage = prefs.getString('profile_image');
    if (savedImage != null && savedImage.isNotEmpty) {
      selectedImage.value = savedImage;
    }
  }

  pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (image != null) {
      selectedImage.value = image.path;
      Get.back();
    }
  }

  final setProfileAbout = TextEditingController();
  final dateOfBirth = TextEditingController();
  final setProfileGlobalKey = GlobalKey<FormState>();
  var selectedGender = 'Male'.obs;

  void updateGender(String val) {
    selectedGender.value = val;
  }

  saveProfile() async {
    try {
      if (selectedImage.value.isEmpty) {
        Get.snackbar("Error", "Please select a profile picture",
            backgroundColor: AllThemes.redColor,
            colorText: AllThemes.whiteColor);
        return false;
      }

      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('token') ?? '';

      if (userToken.isEmpty) {
        Get.snackbar("Auth Error", "Token is missing! Please login again.",
            backgroundColor: AllThemes.redColor, colorText: Colors.white);
        isLoading.value = false;
        return false;
      }

      final response = await AuthServices().completeProfile(
        about: setProfileAbout.text,
        dob: dateOfBirth.text,
        gender: selectedGender.value,
        imagePath: selectedImage.value,
        token: userToken,
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        return true;
      } else {
        Get.snackbar("Error", result['message'] ?? "Server Error",
            backgroundColor: AllThemes.redColor,
            colorText: AllThemes.whiteColor);
        return false;
      }
    } catch (e) {
      print("Catch Error: $e");
      Get.snackbar("Error", "Check your internet or server connection",
          backgroundColor: AllThemes.redColor,
          colorText: AllThemes.whiteColor);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
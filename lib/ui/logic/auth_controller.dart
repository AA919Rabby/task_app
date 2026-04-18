import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_x/data/services/auth_services.dart';
import 'package:the_x/ui/home/home_view.dart';
import 'package:the_x/ui/auth/login.dart';
import 'package:the_x/ui/auth/update_profile.dart';
import '../../ui/auth/forgetpass.dart';
import '../../ui/auth/registerverify_otp.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  // Global Image picker & validator function (5MB Limit)
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      if (file.lengthSync() > 5 * 1024 * 1024) {
        Get.snackbar("Error", "Image must be less than 5 MB");
        return null;
      }
      return file;
    }
    return null;
  }

  // Login
  final loginEmailClt = TextEditingController();
  final loginPasswordClt = TextEditingController();

  loginUser() async {
    isLoading.value = true;
    try {
      final response = await AuthServices().loginUser(loginEmailClt.text.trim(), loginPasswordClt.text.trim());
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save Token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['data']['token']);
        Get.snackbar('Success', body['message'] ?? 'Login Successful');
        Get.offAll(() => const HomeView());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Login Failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //Register
  final registerEmailClt = TextEditingController();
  final registerUsernameClt = TextEditingController();
  final registerPasswordClt = TextEditingController();

  registerUser() async {
    isLoading.value = true;
    try {
      final response = await AuthServices().registerUser(
        registerUsernameClt.text.trim(),
        registerEmailClt.text.trim(),
        registerPasswordClt.text.trim(),
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP sent to email');
        Get.to(() => const RegisterverifyOtp());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Registration Failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // REgister verify otp

  final regOtpClt = TextEditingController();

  verifyRegisterOtp() async {
    isLoading.value = true;
    try {
      final response = await AuthServices().verifyOtp(
          registerEmailClt.text.trim(),
          int.parse(regOtpClt.text.trim())
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['data']['token']);
        Get.snackbar('Success', 'OTP Verified. Complete Profile now.');
        Get.offAll(() => const UpdateProfile());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Complete profile
   final profileCountryClt = TextEditingController();
  final profileAboutClt = TextEditingController();
  var profileImage = Rxn<File>();

  completeProfile() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await AuthServices().completeProfile(
        token!,
        profileCountryClt.text.trim(),
        profileAboutClt.text.trim(),
        profileImage.value,
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Profile Updated!');
        Get.offAll(() => Login());
      } else {
        print(response.statusCode);
        Get.snackbar('Error', body['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //Forget pass
  final forgotEmailClt = TextEditingController();
  final forgotOtpClt = TextEditingController();
  final newPasswordClt = TextEditingController();

  sendForgotPasswordCode() async {
    isLoading.value = true;
    try {
      final response = await AuthServices().forgotPassword(forgotEmailClt.text.trim());
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Code sent to email');
        Get.to(() =>  ForgetpassverifyOtp());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Failed to send code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  verifyForgotOtp() async {
    if (forgotOtpClt.text.trim().isEmpty || int.tryParse(forgotOtpClt.text.trim()) == null) {
      Get.snackbar('Error', 'Please enter a valid OTP');
      return;
    }
    try {
      isLoading.value = true;
      final response = await AuthServices().verifyOtp(
          forgotEmailClt.text.trim(),
          int.parse(forgotOtpClt.text.trim())
      );
      final body = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('temp_token', body['data']['token']);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Verified. Enter new password.');
        Get.to(() =>  NewPassword());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Invalid Code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  resetPassword() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('temp_token');

      if (token == null) {
        Get.snackbar('Error', 'Session expired.Please verify OTP again.');
        return;
      }
      final response = await AuthServices().resetPassword(
          forgotEmailClt.text.trim(),
          newPasswordClt.text.trim(),
          token
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Password changed successfully');
        Get.offAll(() => Login());
      } else {
        Get.snackbar('Error', body['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

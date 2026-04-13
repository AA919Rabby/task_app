import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/data/services/auth_services.dart';
import 'package:task/ui/screens/auth/verify_view.dart';
import 'package:task/ui/screens/home/home_view.dart';
import '../screens/auth/signin.dart';
import '../screens/profile/enable_location.dart';



class AuthController extends GetxController {
  // For signin
  final signInEmailClt = TextEditingController();
  final signInPasswordClt = TextEditingController();
  final signInGlobalKey = GlobalKey<FormState>();

  // For signup
  final signUpEmailClt = TextEditingController();
  final signUpFullNameClt = TextEditingController();
  final signUpPasswordClt = TextEditingController();
  final signUpGlobalKey = GlobalKey<FormState>();

  // For Verify OTP
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();

  // UI States
  var isObscure = true.obs;
  var isSignUpObscure = true.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;

  var passwordStrength = 0.obs;
  var strengthText = "".obs;
  var strengthColor = Colors.transparent.obs;
  var isRequirementMet = false.obs;

  void toggleVisibility() => isObscure.value = !isObscure.value;
  void toggleSignUpVisibility() => isSignUpObscure.value = !isSignUpObscure.value;

  void validatePassword(String value) {
    bool has8Chars = value.length >= 8;
    bool hasLetters = value.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumbers = value.contains(RegExp(r'[0-9]'));

    isRequirementMet.value = has8Chars && hasLetters && hasNumbers;

    if (value.isEmpty) {
      passwordStrength.value = 0;
      strengthText.value = "";
      strengthColor.value = Colors.transparent;
    } else if (!isRequirementMet.value) {
      passwordStrength.value = 1;
      strengthText.value = "Weak";
      strengthColor.value = AllThemes.redColor;
    } else {
      passwordStrength.value = 4;
      strengthText.value = "Strong";
      strengthColor.value = AllThemes.blueColor;
    }
  }

  // Safe Token Extractor
  String _extractToken(Map<String, dynamic> data) {
    if (data['token'] != null) return data['token'];
    if (data['accessToken'] != null) return data['accessToken'];
    if (data['data'] != null && data['data'] is Map) {
      if (data['data']['token'] != null) return data['data']['token'];
      if (data['data']['accessToken'] != null) return data['data']['accessToken'];
    }
    return '';
  }

  // login function
  signInUser() async {
    try {
      isLoading.value = true;
      final response = await AuthServices().signIn(
          signInEmailClt.text.trim(), signInPasswordClt.text.trim());

      if (response.statusCode == 200 || response.statusCode == 201) {

        print(response.statusCode);
        var result = jsonDecode(response.body);
        String token = _extractToken(result);

        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
        }

        Get.offAll(() => HomeView(),
            duration: Duration(milliseconds: 800),
            transition: Transition.circularReveal,
            curve: Curves.easeInOut);
      } else {
        var errorData = jsonDecode(response.body);
        print('$errorData');
        print(response.statusCode);
        Get.snackbar("Signin Failed", "Please try again later",
            colorText: AllThemes.whiteColor,
            backgroundColor: AllThemes.redColor,
            duration: Duration(seconds: 2));
      }
      signInEmailClt.clear();
      signInPasswordClt.clear();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AllThemes.whiteColor,
          backgroundColor: AllThemes.redColor,
          duration: Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  //Register function
  SignUpUser() async {
    try {
      isLoading.value = true;
      final response = await AuthServices().signUp(
          signUpFullNameClt.text.trim(),
          signUpEmailClt.text.trim(),
          signUpPasswordClt.text.trim());

      if (response.statusCode == 200 || response.statusCode == 201) {
        startTimer();
        Get.off(() => VerifyView(),
            duration: Duration(milliseconds: 500), transition: Transition.fade);
      } else {
        var errorData = jsonDecode(response.body);
        String serverError = errorData['message'] ?? "Something went wrong";
        Get.snackbar("Signup Failed", serverError,
            colorText: AllThemes.whiteColor,
            backgroundColor: AllThemes.redColor,
            duration: Duration(seconds: 4));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AllThemes.whiteColor,
          backgroundColor: AllThemes.redColor,
          duration: Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Timer? _timer;
  var secondsRemaining = 60.obs;
  var canResend = false.obs;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  String get timerText => "00:${secondsRemaining.value.toString().padLeft(2, '0')}";

  // Resend OTP API
  resendOTP() async {
    isLoading.value = true;
    clearOtpFields();
    final response = await AuthServices().resendVerifyOtp(signUpEmailClt.text);
    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      startTimer();
      Get.snackbar("Success", "OTP Resent!",
          colorText: AllThemes.whiteColor,
          backgroundColor: AllThemes.greenColor);
    }
  }

  // Verify OTP API
  Future<void> verifyOTP({required VoidCallback onSuccess}) async {
    String otp = otp1.text + otp2.text + otp3.text + otp4.text;
    if (otp.length < 4) return;

    try {
      isLoading.value = true;
      final response = await AuthServices().verifyOtp(signUpEmailClt.text, otp);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var result = jsonDecode(response.body);
        String token = _extractToken(result);

        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
        }

        onSuccess();
        Get.offAll(()=>EnableLocation(),duration: Duration(milliseconds: 500),
          transition: Transition.fade,curve: Curves.easeIn,);
        signUpEmailClt.clear();
        signUpFullNameClt.clear();
        signUpPasswordClt.clear();
      } else {
        clearOtpFields();
        var errorData = jsonDecode(response.body);
        String serverError = errorData['message'] ?? "Invalid OTP";
        Get.snackbar("Error", serverError,
            backgroundColor: AllThemes.redColor, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: AllThemes.redColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void clearOtpFields() {
    otp1.clear();
    otp2.clear();
    otp3.clear();
    otp4.clear();
  }
}
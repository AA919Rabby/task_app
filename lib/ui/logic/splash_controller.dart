import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/ui/screens/home/home_view.dart';
import 'package:task/ui/screens/splash/onboarding_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    checkUser();
    super.onInit();
  }

  Future<void> checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    await Future.delayed(const Duration(seconds: 4));

    if (token != null && token.isNotEmpty) {
      // User is logged in
      Get.offAll(() => HomeView(),
          duration: const Duration(milliseconds: 1000),
          transition: Transition.circularReveal,
          curve: Curves.bounceInOut);
    } else {
      // New user or logged out
      Get.offAll(() => OnboardingView(),
          duration: const Duration(milliseconds: 1000),
          transition: Transition.circularReveal,
          curve: Curves.bounceInOut);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnboardingController extends GetxController {

  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<dynamic> onboardingData = [
    {
      "images": "assets/intro/onboard1.jpg",
      "title": "Best online courses\nin the world",
      "subtitle": "Now you can learn anywhere, anytime, even if there is no internet access!",
      "button": "Next",
    },
    {
      "images": "assets/intro/onboard2.jpg",
      "title": "Explore your new skill\ntoday",
      "subtitle": "Our platform is designed to help you explore new skills. Let's learn & grow with Eduline!",
      "button": "Get Started",
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }


}

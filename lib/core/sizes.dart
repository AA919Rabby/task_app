import 'package:flutter/material.dart';


extension ResponsiveSize on num {
  // Returns a percentage of the screen height
  double get h => Sizes.screenHeight * (this / 100);

  // Returns a percentage of the screen width
  double get w => Sizes.screenWidth * (this / 100);
}

class Sizes {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

}
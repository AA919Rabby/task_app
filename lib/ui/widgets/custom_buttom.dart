import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/core/sizes.dart';


class CustomButton extends StatelessWidget {
  String label;
  Color color;
  Color ?labelColor;
  VoidCallback? onTap;
  VoidCallback? onPressed;
  CustomButton({
    required this.color,
    required this.label,
    this.onTap,
    this.onPressed,
    this.labelColor,

  });

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return InkWell(
      onTap: onPressed ?? onTap,
      child: Container(
        height: 6.7.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AllThemes.blueColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,style: GoogleFonts.inter(
            color: labelColor,
            fontSize: 2.1.h,
            fontWeight: FontWeight.w700,
          ),
          ),
        ),
      ),
    );
  }
}
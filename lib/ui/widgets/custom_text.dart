import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/core/all_themes.dart';
import '../../core/sizes.dart';


class CustomText extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLInes;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomText({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.readOnly,
    this.onTap,
    this.maxLines,
    this.minLInes,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      minLines: minLInes ?? 1,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.inter(
        color: AllThemes.blackColor,
        fontSize: 2.2.h,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: GoogleFonts.inter(
          color: AllThemes.greyColor,
          fontSize: 1.8.h,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.3.h),
          borderSide: BorderSide(color: AllThemes.greyColor.withOpacity(0.3)),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.3.h),
          borderSide: BorderSide(color: AllThemes.greyColor.withOpacity(0.3)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.3.h),
          borderSide: BorderSide(color: AllThemes.blueColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.3.h),
          borderSide: BorderSide(color: AllThemes.redColor, width: 1.5),
        ),
      ),
    );
  }

}
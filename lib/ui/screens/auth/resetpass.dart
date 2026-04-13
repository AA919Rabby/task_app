import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/forgetpass_controller.dart';
import '../../widgets/custom_auth.dart';
import '../../widgets/custom_buttom.dart';


class Resetpass extends StatelessWidget {
  Resetpass({super.key});
  final forgetpassController = Get.put(ForgetpassController());
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AllThemes.whiteColor,
      appBar: AppBar(
        backgroundColor: AllThemes.noColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w, top: 1.h),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
                padding: EdgeInsets.only(left: 2.w),
                decoration: BoxDecoration(
                  color: AllThemes.whiteColor,
                  border: Border.all(
                    color: AllThemes.greyColor.withOpacity(0.1),
                    width: 1.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios, size: 2.5.h)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: forgetpassController.resetPassGlobalKey,
            child: Column(
              children: [
                SizedBox(height: 2.h),
                Text(
                  "Reset Password",
                  style: GoogleFonts.inter(
                    fontSize: 3.5.h,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  "Your password must be at least 8 characters\nlong and include a combination of letters,\nnumbers",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 1.8.h,
                    color: AllThemes.greyColor,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "New Password",
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),
                // New Password field
                Obx(() => CustomAuth(
                  validator: (value) {
                    if (value!.isEmpty) return "Required";
                    if (value.length < 8) return "Password must be at least 8 characters";
                    return null;
                  },
                  controller: forgetpassController.resetPassClt,
                  hintText: "••••••••",
                  obscureText: forgetpassController.isObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      forgetpassController.isObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 2.5.h,
                      color: AllThemes.greyColor,
                    ),
                    onPressed: () => forgetpassController.toggleObscure(),
                  ),
                )),
                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm New Password",
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),
                // Confirm Password field
                Obx(() => CustomAuth(
                  validator: (value) {
                    if (value!.isEmpty) return "Required";
                    if (value.length < 8) return "Password must be at least 8 characters";
                    if (value != forgetpassController.resetPassClt.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  controller: forgetpassController.confirmResetPassClt,
                  hintText: "••••••••",
                  obscureText: forgetpassController.isConfirmObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      forgetpassController.isConfirmObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 2.5.h,
                      color: AllThemes.greyColor,
                    ),
                    onPressed: () => forgetpassController.toggleConfirmObscure(),
                  ),
                )),
                SizedBox(height: 6.h),
                // Submit Button
                Obx(() => forgetpassController.isLoading.value
                    ? Center(
                  child: SpinKitFadingCircle(
                    color: AllThemes.blueColor,
                    size: 10.w,
                  ),
                )
                    : CustomButton(
                  onTap: () {
                    if (forgetpassController.resetPassGlobalKey.currentState!.validate()) {
                      forgetpassController.resetPassword();
                    }
                  },
                  color: AllThemes.blueColor,
                  label: "Submit",
                  labelColor: AllThemes.whiteColor,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
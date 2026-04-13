import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/auth_controller.dart';
import '../profile/enable_location.dart';


class VerifyView extends StatelessWidget {
  VerifyView({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AllThemes.whiteColor,
      appBar: AppBar(
        backgroundColor: AllThemes.noColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 2),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: AllThemes.whiteColor,
                  border: Border.all(
                    color: AllThemes.greyColor.withOpacity(0.1),
                    width: 1.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios, size: 2.7.h)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 3.h),
            Text(
              "Verify Code",
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AllThemes.blackColor,
              ),
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 2.h,
                    color: AllThemes.greyColor,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: "Please enter the code we just sent to\nemail "),
                    TextSpan(
                      text: authController.signUpEmailClt.text.isNotEmpty
                          ? authController.signUpEmailClt.text
                          : "your email",
                      style: TextStyle(
                        color: AllThemes.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                otpBox(context, first: true, last: false, controller: authController.otp1),
                otpBox(context, first: false, last: false, controller: authController.otp2),
                otpBox(context, first: false, last: false, controller: authController.otp3),
                otpBox(context, first: false, last: true, controller: authController.otp4),
              ],
            ),
            const Spacer(),
            //Send otp again
            Obx(() => Column(
              children: [
                GestureDetector(
                  onTap: authController.canResend.value
                      ? () => authController.resendOTP()
                      : null,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AllThemes.greyColor,
                      ),
                      children: [
                        TextSpan(
                          text: authController.canResend.value
                              ? "Resend code"
                              : "Resend code in ",
                        ),
                        if (!authController.canResend.value)
                          TextSpan(
                            text: authController.timerText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AllThemes.blackColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (authController.isLoading.value)
                   Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child:SpinKitFadingCircle(
                        color: AllThemes.blueColor,
                        size: 10.w,
                      ),
                    )
                  ),
                SizedBox(height: 4.h),
              ],
            )),

          ],
        ),
      ),
    );
  }

  // Helper widget to show/hide the dot properly
  otpBox(BuildContext context, {required bool first, required bool last, required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: AllThemes.whiteColor,
        border: Border.all(
          color: AllThemes.greyColor.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // This builder shows the dot ONLY when the field is empty
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return value.text.isEmpty
                  ? Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AllThemes.blackColor,
                  shape: BoxShape.circle,
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
          TextField(
            autofocus: first,
            controller: controller,
            onChanged: (value) {
              if (value.length == 1 && !last) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && !first) {
                FocusScope.of(context).previousFocus();
              }
              if (value.length == 1 && last) {
                FocusScope.of(context).unfocus();
                // Calling API
                authController.verifyOTP(
                  onSuccess: () => showSuccessDialog(context),
                );
              }
            },
            showCursor: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: GoogleFonts.inter(
              fontSize: 2.5.h,
              fontWeight: FontWeight.bold,
              color: AllThemes.blackColor,
            ),
            decoration:  InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 5),
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  // Success Dialog with star positions
  showSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: AllThemes.whiteColor,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: AllThemes.greyColor),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: AllThemes.blueColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: AllThemes.blueColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset("assets/auth/success.jpg", height: 12.h),
                        ),
                      ),
                      // Star Positions
                      Positioned(top: -10, left: -10, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor.withOpacity(0.4), size: 18)),
                      Positioned(top: 15, right: -25, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor.withOpacity(0.3), size: 14)),
                      Positioned(top: 60, left: -40, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor, size: 22)),
                      Positioned(bottom: 50, right: -40, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor, size: 20)),
                      Positioned(bottom: 0, left: -5, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor, size: 16)),
                      Positioned(bottom: 10, right: -5, child: Icon(Icons.auto_awesome, color: AllThemes.blueColor.withOpacity(0.5), size: 12)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Successfully Registered",
                    style: GoogleFonts.inter(
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                      color: AllThemes.blackColor,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Your account has been registered\nsuccessfully, now let's enjoy our features!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      color: AllThemes.greyColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    height: 6.5.h,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllThemes.blueColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Get.offAll(()=>EnableLocation(),duration: Duration(milliseconds: 500),
                            transition: Transition.fade,curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          "Continue",
                          style: GoogleFonts.inter(
                            fontSize: 2.h,
                            fontWeight: FontWeight.w600,
                            color: AllThemes.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          );
        });
  }
}
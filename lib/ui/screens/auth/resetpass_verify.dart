import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ui/screens/auth/signin.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/forgetpass_controller.dart';

class ResetpassVerify extends StatelessWidget {
  ResetpassVerify({super.key});
  final forgetpassController = Get.put(ForgetpassController());

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return PopScope(
        onPopInvoked: (didPop) {
          forgetpassController.clearOtp();
          },
          child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                        text: forgetpassController.resetPassEmail.text.isNotEmpty
                            ? forgetpassController.resetPassEmail.text
                            : "pristia@gmail.com",
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
                  otpBox(context, first: true, last: false, controller: forgetpassController.otpReset1),
                  otpBox(context, first: false, last: false, controller: forgetpassController.otpReset2),
                  otpBox(context, first: false, last: false, controller: forgetpassController.otpReset3),
                  otpBox(context, first: false, last: true, controller: forgetpassController.otpReset4),
                ],
              ),
              const Spacer(),
      
              Obx(() => GestureDetector(
                onTap: () {
                  if (forgetpassController.timerSeconds.value == 0) {
                    forgetpassController.forgetPassSendOtp();
                  }
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: forgetpassController.timerSeconds.value == 0
                          ? AllThemes.blueColor
                          : AllThemes.greyColor,
                    ),
                    children: [
                      TextSpan(
                          text: forgetpassController.timerSeconds.value == 0
                              ? "Resend code"
                              : "Resend code in "
                      ),
                      if (forgetpassController.timerSeconds.value > 0)
                        TextSpan(
                          text: forgetpassController.formattedTime,
                          style: TextStyle(
                            color: AllThemes.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              )),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to show/hide the dot properly
  otpBox(BuildContext context, {required bool first, required bool last, required TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.only(bottom: 2.w),
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
                // Verifies code immediately when the 4th digit is typed
                forgetpassController.ForgetPassOtp();
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
            decoration: const InputDecoration(
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
                          decoration: BoxDecoration(
                            color: AllThemes.noColor,
                          ),
                          width: 30.w,
                          height: 20.w,
                          child: Image.asset("assets/auth/list.jpg", height: 12.h),
                        ),
                      ]
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Success",
                    style: GoogleFonts.inter(
                      fontSize: 3.h,
                      fontWeight: FontWeight.bold,
                      color: AllThemes.blackColor,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Your password is succesfully\ncreated",
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
                      onPressed: () {
                        // After success, go completely back to Signin Screen
                        Get.offAll(()=>Signin(), duration: const Duration(milliseconds: 500),
                            transition: Transition.fade, curve: Curves.easeIn);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllThemes.blueColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
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
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          );
        });
  }
}
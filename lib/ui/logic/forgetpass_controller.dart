import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task/data/services/auth_services.dart';
import 'package:task/ui/screens/auth/resetpass.dart';
import '../../core/all_themes.dart';
import '../screens/auth/resetpass_verify.dart';

class ForgetpassController extends GetxController {
  var isLoading = false.obs;

  // For Verify OTP
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();

  // For Verify reset password OTP
  final otpReset1 = TextEditingController();
  final otpReset2 = TextEditingController();
  final otpReset3 = TextEditingController();
  final otpReset4 = TextEditingController();

  // Reset email
  final resetPassEmail = TextEditingController();
  final resetPassEmailGlobalKey = GlobalKey<FormState>();

  // Visibility states for passwords
  var isObscure = true.obs;
  var isConfirmObscure = true.obs;

  void toggleObscure() => isObscure.value = !isObscure.value;
  void toggleConfirmObscure() => isConfirmObscure.value = !isConfirmObscure.value;

  // Reset pass logic
  final resetPassClt = TextEditingController();
  final confirmResetPassClt = TextEditingController();
  final resetPassGlobalKey = GlobalKey<FormState>();

  // Timer
  var timerSeconds = 60.obs;
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    int minutes = timerSeconds.value ~/ 60;
    int seconds = timerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  forgetPassSendOtp() async {
    try {
      isLoading.value = true;
      var response = await AuthServices().forgotPassword(resetPassEmail.text.trim());
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 || data['success'] == true) {
        startTimer();
        Get.to(() => Resetpass(), duration: const Duration(milliseconds: 500),
          transition: Transition.fade, curve: Curves.easeIn,);
      } else {
        throw data['message'] ?? "Failed to send OTP";
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AllThemes.whiteColor, backgroundColor: AllThemes.redColor);
    } finally {
      isLoading.value = false;
    }
  }

  resetPassword() {
    if (resetPassGlobalKey.currentState!.validate()) {
      if (resetPassClt.text != confirmResetPassClt.text) {
        Get.snackbar("Error", "Passwords do not match",
            colorText: AllThemes.whiteColor, backgroundColor: AllThemes.redColor);
        return;
      }

      Get.to(() => ResetpassVerify(), duration: const Duration(milliseconds: 500),
        transition: Transition.fade, curve: Curves.easeIn,);
    }
  }

  ForgetPassOtp() async {
    try {
      isLoading.value = true;
      String otpCode = otpReset1.text + otpReset2.text + otpReset3.text + otpReset4.text;

      if(otpCode.length < 4) throw "Please enter full 4-digit OTP";

      var verifyResponse = await AuthServices().verifyOtp(resetPassEmail.text.trim(), otpCode);
      var verifyData = jsonDecode(verifyResponse.body);

      if (verifyResponse.statusCode == 200 || verifyData['success'] == true) {
        _timer?.cancel(); // Stop timer when OTP is successfully verified
        var resetResponse = await AuthServices().resetPassword(
            resetPassEmail.text.trim(),
            resetPassClt.text.trim()
        );
        var resetData = jsonDecode(resetResponse.body);

        if (resetResponse.statusCode == 200 || resetData['success'] == true) {

          ResetpassVerify().showSuccessDialog(Get.context!);

        } else {
          throw resetData['message'] ?? "Failed to reset password on backend";
        }

      } else {
        throw verifyData['message'] ?? "Invalid OTP";
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AllThemes.whiteColor, backgroundColor: AllThemes.redColor);
    } finally {
      isLoading.value = false;
    }
  }

  void clearOtp() {
    otpReset1.clear();
    otpReset2.clear();
    otpReset3.clear();
    otpReset4.clear();
  }


}
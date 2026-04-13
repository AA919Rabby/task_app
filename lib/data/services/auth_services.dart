import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/domain/base_url.dart';

class AuthServices {
  //User login/signin
  signIn(String email, String password) async {
    final response = await http.post(
        Uri.parse('${BaseUrl.rootUrl}/api/v1/auth/login'.trim()),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }));
    return response;
  }

  //User signup/register
  signUp(String fullName, String email, String password) async {
    final response = await http.post(
        Uri.parse('${BaseUrl.rootUrl}/api/v1/users/register'.trim()),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
        }));
    return response;
  }

  //Verify OTP
  verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('${BaseUrl.rootUrl}/api/v1/auth/verify-otp'.trim()),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "otp": int.parse(otp),
      }),
    );
    return response;
  }

  //OTP Verify
  resendVerifyOtp(String email) async {
    final response = await http.post(
      Uri.parse('${BaseUrl.rootUrl}/api/v1/auth/resend-otp'.trim()),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    return response;
  }
  completeProfile({
    required String about,
    required String dob,
    required String gender,
    required String imagePath,
    required String token,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = dob;
    if (dob.contains('/')) {
      List<String> parts = dob.split('/');
      if (parts.length == 3) {
        String day = parts[0].padLeft(2, '0');
        String month = parts[1].padLeft(2, '0');
        String year = parts[2];
        formattedDate = "$year-$month-$day";
      }
    }

    await prefs.setString('profile_about', about.trim());
    await prefs.setString('profile_dob', formattedDate);
    await prefs.setString('profile_gender', gender.toUpperCase());
    await prefs.setString('profile_country', 'USA');

    if (imagePath.isNotEmpty) {
      await prefs.setString('profile_image', imagePath);
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    String mockResponseBody = jsonEncode({
      "success": true,
      "statusCode": 200,
      "message": "Profile completed successfully!",
      "data": {
        "about": about.trim(),
        "dateOfBirth": formattedDate,
        "gender": gender.toUpperCase(),
        "country": "USA",
        "profileImage": imagePath
      }
    });
    return http.Response(mockResponseBody, 200);
  }

  //Reset password
  forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${BaseUrl.rootUrl}/api/v1/auth/forgot-password'.trim()),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    return response;
  }

  // Reset Password - Final Step
  resetPassword(String email, String password) async {
    final response = await http.post(
      Uri.parse('${BaseUrl.rootUrl}/api/v1/auth/reset-password'.trim()),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response;
  }


}
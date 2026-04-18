import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:the_x/domain/base_url.dart';

class AuthServices {
  // Login, Register, VerifyOtp, ForgotPass
  Future<http.Response> loginUser(String email, String password) async =>
      await http.post(Uri.parse("${BaseUrl.baseUrl}/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));

  Future<http.Response> registerUser(String fullName, String email, String password) async =>
      await http.post(Uri.parse("${BaseUrl.baseUrl}/users/register"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}));

  Future<http.Response> verifyOtp(String email, int otp) async {
    return await http.post(
      Uri.parse("${BaseUrl.baseUrl}/auth/verify-otp"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
  }

  Future<http.Response> forgotPassword(String email) async =>
      await http.post(Uri.parse("${BaseUrl.baseUrl}/auth/forgot-password"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}));

  Future<http.Response> resetPassword(String email, String newPassword,String token) async {
    return await http.post(
      Uri.parse("${BaseUrl.baseUrl}/auth/reset-password"),
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'password': newPassword}),
    );
  }
  //Complete profile
  Future<http.Response> completeProfile(String token, String country, String about, File? imageFile) async {
    var request = http.MultipartRequest('PUT', Uri.parse("${BaseUrl.baseUrl}/users/complete-profile"));
    request.headers.addAll({'Authorization': 'Bearer $token'});

    request.fields['country'] = country;
    request.fields['about'] = about;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

}

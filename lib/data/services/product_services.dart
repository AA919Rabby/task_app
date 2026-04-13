import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/base_url.dart';

class ProductServices {
  // Get all products
  Future<http.Response> getProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${BaseUrl.rootUrl}/api/v1/products'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  // Create a new product with Image Upload
  Future<http.StreamedResponse> createProduct(Map<String, String> data, File? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${BaseUrl.rootUrl}/api/v1/products'),
    );

    // Add Headers
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    // Add Form Text Fields
    request.fields.addAll(data);

    // Add Image File if selected
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // The key expected by the backend
          imageFile.path,
        ),
      );
    }

    // Send Request
    var response = await request.send();
    return response;
  }
}
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:the_x/domain/base_url.dart';

class ProductServices {
  Future<http.Response> getProducts(String token) async {
    return await http.get(
      Uri.parse("${BaseUrl.baseUrl}/products"),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> createProduct(String token, Map<String, String> data, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse("${BaseUrl.baseUrl}/products"));
    request.headers.addAll({'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'});
    request.fields.addAll(data);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> updateProduct(String token, String id, Map<String, String> data, File? image) async {
    var request = http.MultipartRequest('PUT', Uri.parse("${BaseUrl.baseUrl}/products/$id"));
    request.headers.addAll({'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'});
    request.fields.addAll(data);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> deleteProduct(String token, String id) async {
    return await http.delete(
      Uri.parse("${BaseUrl.baseUrl}/products/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur API");
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String rootApi;

  ApiHelper({required this.rootApi});

  //Fetch all data from the given endpoint
  Future<List<dynamic>> fetchAllData(String endpoint) async {
    final Uri url = Uri.parse('$rootApi$endpoint');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
          'Failed to fetch data. Status Code: ${response.statusCode}');
    }
  }

//Fetch data with query parameters
  Future<Map<String, dynamic>> fetchDataWithQuery(
      String endpoint, Map<String, String> queryParams) async {
    final Uri url =
        Uri.parse('$rootApi$endpoint').replace(queryParameters: queryParams);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to fetch data. Status Code: ${response.statusCode}');
    }
  }

//Edit data using PUT or PATCH request
  Future<Map<String, dynamic>> editData(
      String endpoint, Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$rootApi$endpoint');

    final response = await http.put(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200 || response.statusCode == 204) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to edit data. Status Code : ${response.statusCode}');
    }
  }

//Delete data using PUT or PATCH request
  Future<bool> deleteData(String endpoint) async {
    final Uri url = Uri.parse('$rootApi$endpoint');

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
          'Failed to delete data. Status Code : ${response.statusCode}');
    }
  }
}

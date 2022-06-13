import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<data> getData(String imageString, int products, List allergens) async {
  final response = await http.post(Uri.parse('http://10.20.25.178:5000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        "image_string": imageString,
        "products": products,
        "allergens": allergens
      }));

  if (response.statusCode == 200) {
    return data.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get data');
  }
}

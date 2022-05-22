import 'model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<data> getData(String imageString) async {
  final response = await http.post(Uri.parse('http://10.20.22.200:5000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{"image_string": imageString}));

  if (response.statusCode == 200) {
    return data.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get data');
  }
}

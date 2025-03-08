import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const _apiKey = 'replace_with_your_hugging_face_api_key';
  static const _apiUrl =
      'https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'inputs': message}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0] is Map) {
          return data[0]['generated_text'] ?? 'No response generated';
        }
      }

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      throw Exception('Failed to get response: ${response.statusCode}');
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error: $e');
    }
  }
}

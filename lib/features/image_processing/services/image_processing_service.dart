import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ImageProcessingService {
  static const _apiKey = 'replace_with_your_hugging_face_api_key';
  static const _apiUrl =
      'https://api-inference.huggingface.co/models/google/vit-base-patch16-224';

  Future<List<Map<String, dynamic>>> classifyImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      throw Exception('Failed to process image: ${response.statusCode}');
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error: $e');
    }
  }
}

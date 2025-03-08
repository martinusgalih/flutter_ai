import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  static const _clientId = 'be99e71da923364';
  static const _apiUrl = 'https://api.imgur.com/3/image';

  static Future<String?> uploadImage(XFile image) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl))
        ..headers['Authorization'] = 'Client-ID $_clientId'
        ..files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      print('Imgur Response: $jsonData');

      if (response.statusCode == 200) {
        return jsonData['data']['link'] as String;
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}

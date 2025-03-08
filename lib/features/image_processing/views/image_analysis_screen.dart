import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_processing_service.dart';
import 'dart:io';

class ImageAnalysisScreen extends ConsumerStatefulWidget {
  const ImageAnalysisScreen({super.key});

  @override
  ConsumerState<ImageAnalysisScreen> createState() =>
      _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends ConsumerState<ImageAnalysisScreen> {
  File? _image;
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = [];
  final _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _results = [];
        });
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);
    try {
      final service = ImageProcessingService();
      final results = await service.classifyImage(_image!.path);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _image!,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _isLoading ? null : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _isLoading ? null : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_results.isNotEmpty) ...[
              const Text(
                'Analysis Results:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(_results.map((result) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(result['label']),
                      trailing: Text(
                        '${(result['score'] * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))),
            ],
          ],
        ),
      ),
    );
  }
}

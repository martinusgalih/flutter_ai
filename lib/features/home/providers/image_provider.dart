import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_upload_service.dart';

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, AsyncValue<String?>>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<AsyncValue<String?>> {
  ImagePickerNotifier() : super(const AsyncValue.data(null));
  final _picker = ImagePicker();

  Future<String?> pickImage() async {
    try {
      state = const AsyncValue.loading();

      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        state = const AsyncValue.data(null);
        return null;
      }

      final imageUrl = await ImageUploadService.uploadImage(pickedFile);
      state = AsyncValue.data(imageUrl);
      return imageUrl;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

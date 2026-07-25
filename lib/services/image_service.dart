import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService._();

  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (file == null) return null;

    return file.path;
  }
}

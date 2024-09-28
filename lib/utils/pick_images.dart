import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
  return pickedImage;
}

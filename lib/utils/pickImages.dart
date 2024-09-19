import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File> pickImages() async {
  late File image;
  try {
    FilePickerResult? file = await FilePicker.platform.pickFiles(type: FileType.image);
    if (file != null) {
      image = File(file.files.single.path!);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return image;
}

import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class FileManager {
  Future<String?> saveFile(String fileName, String content) async {
    // Web: Use FilePicker to save (download)
    final bytes = utf8.encode(content);
    await FilePicker.platform.saveFile(
      dialogTitle: 'Save Game',
      fileName: fileName,
      bytes: Uint8List.fromList(bytes),
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    return 'Download';
  }

  Future<List<String>> listSavedFiles() async {
    // Web cannot list local files
    return [];
  }

  Future<String> readFile(String path) async {
    // Web cannot read by path string unless it's a blob url, but for now we assume this is not called
    // or we handle it via pickFiles logic in UI.
    throw UnimplementedError("Web cannot read file by path");
  }

  Future<String> readPlatformFile(PlatformFile file) async {
    if (file.bytes != null) {
      return utf8.decode(file.bytes!);
    }
    throw Exception('File bytes are null');
  }
}

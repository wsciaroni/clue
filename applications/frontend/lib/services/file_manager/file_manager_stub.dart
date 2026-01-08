import 'package:file_picker/file_picker.dart';

class FileManager {
  Future<String?> saveFile(String fileName, String content) async {
    throw UnimplementedError();
  }

  Future<List<String>> listSavedFiles() async {
    throw UnimplementedError();
  }

  Future<String> readFile(String path) async {
    throw UnimplementedError();
  }

  Future<String> readPlatformFile(PlatformFile file) async {
    throw UnimplementedError();
  }
}

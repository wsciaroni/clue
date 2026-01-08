import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  Future<String?> saveFile(String fileName, String content) async {
    // Desktop: Use FilePicker to pick location
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Game',
        fileName: fileName,
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(content);
        return outputFile;
      }
      return null;
    } else {
      // Mobile: Save to App Documents
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsString(content);
      return path;
    }
  }

  Future<List<String>> listSavedFiles() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final dir = Directory(directory.path);
        final List<FileSystemEntity> entities = await dir.list().toList();
        return entities
            .whereType<File>()
            .where((f) => f.path.endsWith('.json'))
            .map((f) => f.path)
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String> readFile(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  Future<String> readPlatformFile(PlatformFile file) async {
    if (file.path != null) {
      return await readFile(file.path!);
    }
    throw Exception('File path is null');
  }
}

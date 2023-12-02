import 'dart:io';

Future<List<String>> readLinesFromFile(String filePath) async {
  try {
    return await File(filePath).readAsLines();
  } catch (e) {
    print('Error reading file: $e');
    return [];
  }
}

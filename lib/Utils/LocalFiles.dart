

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalFiles{

  Future<File> _getTempFile(String file) async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$file.json");
  }

  Future<String> readData2(String fileName) async {
    try {
      final file = await _getTempFile(fileName);
      return file.readAsString();
    } catch (e) {
      print("erro");
      return "erro";
    }
  }

  Future<File> saveTempFile(Map<String,dynamic>val,String fileName) async {
    String data = json.encode(val);
    final file = await _getTempFile(fileName);
    return file.writeAsString(data);
  }


}
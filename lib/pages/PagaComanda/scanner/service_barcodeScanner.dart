import 'dart:math';

import 'package:flutter/services.dart';

class BarcodeScannerService {
  final _platform = const MethodChannel('samples.flutter.elgin/Printer');

  Future<String> initializeScanner() async {
    Map<String, dynamic> mapParam = new Map();
    return await _platform.invokeMethod("scanner", {"args": mapParam});
  }
}

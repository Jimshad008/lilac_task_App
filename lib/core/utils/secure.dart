import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> securescreen() async {
  try {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  } on PlatformException catch (e) {
    // Handle exceptions (e.g., platform not supported)
    print(e);
  }
}
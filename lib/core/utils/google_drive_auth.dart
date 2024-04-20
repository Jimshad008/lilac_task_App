import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadGoogleDriveAuthConfig() async {
  String jsonString = await rootBundle.loadString('assets/google-drive-auth.json');
  return json.decode(jsonString);
}
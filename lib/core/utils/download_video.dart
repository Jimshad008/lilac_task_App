import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
final key = Key.fromUtf8('your_encryption_key'); // 32 bytes
final iv = IV.fromUtf8('your_initialization_vector'); // 16 bytes

Future<void> downloadAndEncryptVideo(String downloadUrl, String videoId) async {
  final dio = Dio();
  final progress = StreamController<double>();

  try {
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/lilac/downloads/$videoId.mp4.enc';

    await dio.download(
      downloadUrl,
      savePath,
      onReceiveProgress: (received, total) {
        progress.add(received / total);
      },
    );

    // Read downloaded video
    final bytes = await File(savePath).readAsBytes();

    // Encrypt video
    final encrypter = Encrypter(AES(key, mode:AESMode.cbc)); // Use CBC mode
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);

    // Write encrypted video
    await File(savePath).writeAsBytes(encrypted.bytes);

    progress.add(1.0); // Signal download completion
    print('Download and encryption completed successfully!');
  } on DioError catch (e) {
    print('Download error: $e');
    progress.addError(e);
  } catch (err) {
    print('Error: $err');
    progress.addError(err);
  } finally {
    progress.close();
  }
}
File encryptVideo(File videoFile) {
  // Encrypt video using a key (you should store this securely)
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encryptedVideoBytes = encrypter.encryptBytes(videoFile.readAsBytesSync(), iv: iv);
  final encryptedVideoFile = File('${videoFile.path}.encrypted');
  encryptedVideoFile.writeAsBytesSync(encryptedVideoBytes.bytes);
  return encryptedVideoFile;
}
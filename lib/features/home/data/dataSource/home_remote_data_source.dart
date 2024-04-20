import 'dart:convert';

import '../../../../core/constant/global constant.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
abstract interface class HomeRemoteDataSource {
  Future<Map<String, List>> fetchVideo();

}
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource{
  @override
  Future<Map<String, List>> fetchVideo() async {


    try {
      Map<String,List> result={};
      const String apiUrl =
          'https://www.googleapis.com/drive/v3/files?q=\'$folderId\'+in+parents&fields=files(id, name, webContentLink)&key=AIzaSyDFoxn2Tqrn-WNW--bmdf8EqrJYCRX-1vE';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> files = jsonData['files'];


         result["url"]= files
              .where((file) => file['name'].toString().toLowerCase().endsWith('.mp4'))
              .map<String>((file) => file['webContentLink'])
              .toList();
        result["id"]=files
              .where((file) => file['name'].toString().toLowerCase().endsWith('.mp4'))
              .map<String>((file) => file['id'])
              .toList();
        result["name"]=files
            .where((file) => file['name'].toString().toLowerCase().endsWith('.mp4'))
            .map<String>((file) => file['name'])
            .toList();
        return result;
      } else {
        throw const ServerException( message: 'Failed to load videos');
      }

    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

}
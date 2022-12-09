import 'dart:convert';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:csv/csv.dart';

class importcsv {
  static Future<List> getcsvdata() async {
    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String file = "$dir";
    final input = new File(file + "/yourfantasy.csv").openRead();
    if (File(file + "/yourfantasy.csv").existsSync()) {
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      return fields;
    } else {
      return null;
    }
  }
}

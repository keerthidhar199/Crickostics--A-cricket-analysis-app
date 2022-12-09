import 'dart:io';

import 'package:datascrap/analysis.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:csv/csv.dart';

class exportcsv {
  static Future<void> getcsv() async {
    List<Map<String, List<dynamic>>> associateList1 = [
      Analysis.battersmap,
      Analysis.bowlersmap,
      Analysis.partnershipsmap
    ];
    List<dynamic> associateList = [
      {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
    ];

    List<List<dynamic>> rows = [];
    List<List<dynamic>> existing_table_rows = [];

    List<dynamic> row = [];
    row.add("Player Stats");
    row.add("Category");
    row.add("Team");
    row.add('League');
    rows.add(row);
    existing_table_rows.add([]);
    for (int i = 0; i < associateList1.length; i++) {
      for (var j in associateList1[i].keys) {
        List<dynamic> row = [];
        var league, team, category;
        league = j.toString().split('_')[0];
        team = j.toString().split('_')[1];
        category = j.toString().split('_')[2];
        row.add(associateList1[i][j]);
        row.add(category);
        row.add(team);
        row.add(league);
        existing_table_rows.add(row);

        rows.add(row);
      }
      print(rows);
    }

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File(file + "/yourfantasy.csv");
    var isempty = await f.length == 0;
    if (!(f.existsSync())) {
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv, mode: FileMode.write);
    } else {
      if (!isempty) {
        String csv1 = const ListToCsvConverter().convert(existing_table_rows);
        print('$csv1');
        f.writeAsString(csv1, mode: FileMode.append);
      } else {
        print("Nooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      }
    }
  }
}

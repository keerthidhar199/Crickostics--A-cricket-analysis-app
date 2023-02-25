import 'dart:io';

import 'package:datascrap/analysis.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:csv/csv.dart';
import 'package:datascrap/globals.dart' as globals;

class exportcsv {
  static Future<void> getcsv() async {
    List<Map<String, List<dynamic>>> associateList1 = [
      Analysis.battersmap,
      Analysis.bowlersmap,
      Analysis.partnershipsmap
    ];
    var finalMap = {}
      ..addAll(associateList1[0])
      ..addAll(associateList1[1])
      ..addAll(associateList1[2]);

    print('ik1 $finalMap');

    List<List<dynamic>> rows = [];
    List<List<dynamic>> existing_table_rows = [];
    Set distinct_teams = {};
    Map<String, List<dynamic>> mapteamwise = {};
    List<dynamic> row = [];
    List<String> teamlogos = [globals.team1logo, globals.team2logo];
    row.add("Team");

    row.add('Player Stats');
    row.add('Teamlogo');
    rows.add(row);

    existing_table_rows.add([]);
    for (var j in finalMap.keys) {
      var league, team, vs;
      print(j);
      league = j.toString().split('_')[0];
      vs = j.toString().split('_')[1];
      team = j.toString().split('_')[2];
      distinct_teams.add(league + '_' + vs + '_' + team);
    }
    for (var k in distinct_teams) {
      List teamwise = [];
      List<dynamic> row = [];
      for (var j in finalMap.keys) {
        if (j.toString().contains(k)) {
          var category = j.toString().split('_')[3][0].toUpperCase() +
              j.toString().split('_')[3].substring(1).toLowerCase();
          teamwise.add(finalMap[j] + [category]);
        }
      }
      // print('ik1 ${distinct_teams.toList().indexOf(k)}');
      mapteamwise[k] = teamwise;

      row.add(k);
      row.add(teamwise);
      row.add(teamlogos[distinct_teams.toList().indexOf(k)]);
      existing_table_rows.add(row);
      rows.add(row);
    }
    print('rows $rows');

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

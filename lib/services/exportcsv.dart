import 'dart:convert';
import 'dart:io';

import 'package:datascrap/analysis.dart';
import 'package:external_path/external_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Set distinct_teams = {};
    Map<String, List<dynamic>> mapteamwise = {};
    List<dynamic> row = [];
    List<String> teamlogos = [globals.team1logo, globals.team2logo];
    row.add("Team");
    row.add('Player Stats');
    row.add('Teamlogo');
    rows.add(row);
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
      mapteamwise[k] = teamwise;
      row.add(k);
      row.add(teamwise);
      row.add(teamlogos[distinct_teams.toList().indexOf(k)]);
      rows.add(row);
    }
    print('export_datayu $rows');

    final prefs = await SharedPreferences.getInstance();
    bool ifavail = prefs.containsKey('FantasyData');
    if (ifavail) {
      Map<String, dynamic> sp = {};
      var fields1 = jsonDecode(prefs.getString('FantasyData'));
      print('SP $fields1');
      for (int i = 0; i < fields1.keys.length; i++) {
        print('SP ${fields1.keys.toList()}');
        sp[fields1.keys.toList()[i]] = fields1[fields1.keys.toList()[i]];
      }
      String counter = (fields1.keys.length + 1).toString();
      sp['Result' + counter] = rows;
      String encodedata;
      print('SP $sp');
      encodedata = jsonEncode(sp);
      await prefs.setString('FantasyData', encodedata);
    } else {
      Map<String, List<List<dynamic>>> sp = {};
      sp['Result'] = rows;
      String encodedata;
      encodedata = jsonEncode(sp);
      await prefs.setString('FantasyData', encodedata);
    }
  }
}

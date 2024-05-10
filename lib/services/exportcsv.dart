import 'dart:convert';

import 'package:datascrap/analysis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:datascrap/globals.dart' as globals;

class ExportCsv {
  static Future<void> getcsv() async {
    List<Map<String, List<dynamic>>> associateList1 = [
      Analysis.battersmap,
      Analysis.bowlersmap,
      Analysis.partnershipsmap,
      Analysis.previousmatchmap
    ];
    var finalMap = {}
      ..addAll(associateList1[0])
      ..addAll(associateList1[1])
      ..addAll(associateList1[2])
      ..addAll(associateList1[3]);

    print('ik1 $finalMap');

    List<List<dynamic>> rows = [];
    Set<String> distinctTeams = {};
    Map<String, List<dynamic>> mapteamwise = {};
    List<dynamic> row = [];
    List<String?> teamlogos = [globals.team1logo, globals.team2logo];
    row.add("Team");
    row.add('Player Stats');
    row.add('Teamlogo');
    rows.add(row);
    for (var j in finalMap.keys) {
      String league, team, vs;
      print(j);
      league = j.toString().split('_')[0];
      vs = j.toString().split('_')[1];
      team = j.toString().split('_')[2];
      distinctTeams.add('${league}_${vs}_$team');
    }
    for (var k in distinctTeams) {
      List teamwise = [];
      List<dynamic> row = [];
      for (var j in finalMap.keys) {
        if (j.toString().contains(k)) {
          String category;

          category = j.toString().split('_')[3][0].toUpperCase() +
              j.toString().split('_')[3].substring(1).toLowerCase();

          teamwise.add(finalMap[j] + [category]);
        }
      }
      mapteamwise[k] = teamwise;
      row.add(k);
      row.add(teamwise);
      // row.add(teamlogos[distinct_teams.toList().indexOf(k)]);
      rows.add(row);
    }
    print('export_datayu $rows');

    final prefs = await SharedPreferences.getInstance();
    bool ifavail = prefs.containsKey('FantasyData');
    if (ifavail) {
      Map<String, dynamic> sp = {};
      var fields1 = jsonDecode(prefs.getString('FantasyData') ?? '{}');
      print('SP $fields1');
      for (var key in fields1.keys) {
        sp[key] = fields1[key];
      }
      String counter = (fields1.length + 1).toString();
      sp['Result$counter'] = rows;
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

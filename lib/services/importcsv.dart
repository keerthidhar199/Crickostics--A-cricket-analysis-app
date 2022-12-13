import 'dart:convert';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:csv/csv.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class importcsv {
  // csvOutput=[[PHKD Mendis 19 211.11, C Karunaratne* 26 162.5, Batting],
  //[PWH de Silva 4.0 6.5, FA Allen 4.0 5.75, Bowling],
  //[P Nissanka, PHKD Mendis &36, KNA Bandara, C Karunaratne &42, Partnership]]

  static Future<Map<String, List<dynamic>>> getcsvdata() async {
    Map<String, List<dynamic>> parseData(league_name, team, csvOutput) {
      int index1, index2, index3;

      List batting = [], bowling = [], partnerships = [];
      Map<String, List<dynamic>> playerstats = {};
      List players = csvOutput
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');

      for (var i in players) {
        players[players.indexOf(i)] = i.trim();
      }
      print('ik2 $players');

      index1 = players.indexOf('Batting');
      index2 = players.indexOf('Bowling');
      index3 = players.indexOf('Partnership');

      for (int i = 1; i < index1; i++) {
        batting.add(players[i]);
      }
      for (int i = index1 + 1; i < index2; i++) {
        bowling.add(players[i]);
      }
      for (int i = index2 + 1; i < index3; i++) {
        partnerships.add(players[i]);
      }

      playerstats['Batting'] = batting;
      playerstats['Bowling'] = bowling;
      playerstats['Partnerships'] = partnerships;

      return playerstats;
    }

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String file = "$dir";
    final input = new File(file + "/yourfantasy.csv").openRead();

    if (File(file + "/yourfantasy.csv").existsSync()) {
      var fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(fieldDelimiter: ','))
          .toList();
      print('ik11 ${fields}');
      print('ik11 ${fields[0]}');
      List<Map<String, List<dynamic>>> result = [];
      Map<String, List<dynamic>> league_data = {};
      Set distinct_leagues = {};
      Map<String, List<dynamic>> dummy = {};

      for (int i = 1; i < fields.length; i++) {
        //map {Lanka Premier League_Galle GladiatorsvsColombo Stars:[parseData[1],parseData[2]]
        // }
        print('-------------------------------------');
        var team_of_the_league = fields[i][0].split('_').last;

        var league_name_and_vs = fields[i][0].toString().split('_')[0] +
            '_' +
            fields[i][0].toString().split('_')[1];
        league_data[league_name_and_vs] = [];

        // if (distinct_leagues.toList().contains(league_name_and_vs)) {}
        dummy[team_of_the_league] = [
          parseData(league_name_and_vs, team_of_the_league, fields[i][1])
        ];
        for (int i = 1; i < fields.length; i++) {
          var league_name_and_vs = fields[i][0].toString().split('_')[0] +
              '_' +
              fields[i][0].toString().split('_')[1];
          league_data[league_name_and_vs] = [];
          for (var j in dummy.keys) {
            if (league_name_and_vs.contains(j)) {
              league_data[league_name_and_vs] += dummy[j];
            }
            // distinct_leagues.add(fields[i][0].toString().split('_')[0] +
            //     '_' +
            //     fields[i][0].toString().split('_')[1]);
          }
        }
      }

      print('chus ${league_data[league_data.keys.toList()[0]].length}');
      return league_data;
    } else {
      return null;
    }
  }
}

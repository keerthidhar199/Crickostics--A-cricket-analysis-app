import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:external_path/external_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class importcsv {
  // csvOutput=[[PHKD Mendis 19 211.11, C Karunaratne* 26 162.5, Batting],
  //[PWH de Silva 4.0 6.5, FA Allen 4.0 5.75, Bowling],
  //[P Nissanka, PHKD Mendis &36, KNA Bandara, C Karunaratne &42, Partnership]]

  static Future<Map<String, List<dynamic>>> getcsvdata() async {
    Map<String, List<dynamic>> parseData(league_name, team, csvOutput, logo) {
      int index1, index2, index3;

      List batting = [], bowling = [], partnerships = [];
      Map<String, List<dynamic>> playerstats = {};
      print('ik22 csvoutput $csvOutput');
      List players = csvOutput
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');
      print('ik22 $players');
      for (var i in players) {
        players[players.indexOf(i)] = i.trim();
      }
      print('ik2 $players');

      index1 = players.indexOf('Batting');
      index2 = players.indexOf('Bowling');
      index3 = players.indexOf('Partnership');
      for (int i = 0; i < index1; i++) {
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
      playerstats['Logo'] = [logo];
      return playerstats;
    }

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    String file = "$dir";
    final prefs = await SharedPreferences.getInstance();
    var SharedPrefData = jsonDecode(prefs.getString('FantasyData'));
    print('SharedPrefData $SharedPrefData');
    // List<dynamic> un = [
    //   ['Team', 'Player Stats', 'Teamlogo'],
    //   [
    //     'Pakistan Super League_Lahore QalandarsvsMultan Sultans_Lahore Qalandars',
    //     [
    //       ['Fakhar Zaman 96 213.33', 'Sikandar Raza* 71 208.82', 'Batting'],
    //       ['Shaheen Shah Afridi 4.0 10.0', 'Rashid Khan 4.0 3.75', 'Bowling'],
    //       [
    //         'Fakhar Zaman',
    //         'Abdullah Shafique &120',
    //         'Fakhar Zaman',
    //         'SW Billings &88',
    //         'Partnership'
    //       ]
    //     ],
    //     '/db/PICTURES/CMS/313500/313523.logo.png'
    //   ],
    //   [
    //     'Pakistan Super League_Lahore QalandarsvsMultan Sultans_Multan Sultans',
    //     [
    //       ['KA Pollard 39 139.28', 'Mohammad Rizwan 30 111.11', 'Batting'],
    //       ['KA Pollard 2.0 8.0', 'Anwar Ali 3.0 7.0', 'Bowling'],
    //       [
    //         'KA Pollard',
    //         'Anwar Ali &49',
    //         'Shan Masood',
    //         'Mohammad Rizwan &48',
    //         'Partnership'
    //       ]
    //     ],
    //     '/db/PICTURES/CMS/313500/313550.logo.png'
    //   ]
    // ];

    // fields1['Result'] = fields1['Results'] + un;
    var SharedPrefDatatoList = [];
    for (var j in SharedPrefData.keys) {
      SharedPrefDatatoList.add(SharedPrefData[j]);
    }
    print('ik11 ${SharedPrefDatatoList}');

    List<Map<String, List<dynamic>>> result = [];
    Map<String, List<dynamic>> league_data = {};
    Set distinct_leagues = {};
    Map<String, List<dynamic>> dummy = {};
    if (SharedPrefDatatoList.isNotEmpty) {
      for (var fields in SharedPrefDatatoList) {
        for (int i = 1; i < fields.length; i++) {
          //map {Lanka Premier League_Galle GladiatorsvsColombo Stars:[parseData[1],parseData[2]]
          // }
          print('-------------------------------------');
          var team_of_the_league = fields[i][0].split('_').last;

          var league_name_and_vs = fields[i][0].toString().split('_')[0] +
              '_' +
              fields[i][0].toString().split('_')[1];
          league_data[league_name_and_vs] = [];

          dummy[team_of_the_league] = [
            parseData(league_name_and_vs, team_of_the_league, fields[i][1],
                fields[i][2])
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
      }
      // print('import_datayu $league_data');
      return league_data;
    } else {
      return null;
    }
  }
}

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

  static Future<List<Map<String, List<dynamic>>>> getcsvdata() async {
    Map<String, List<dynamic>> parseData(league_name, team, csvOutput) {
      int index1, index2, index3;

      List batting = [], bowling = [], partnerships = [];
      Map<String, List<dynamic>> playerstats = {};
      print('thecsvoutput $csvOutput');
      List players = csvOutput
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');
      for (var i in players) {
        players[players.indexOf(i)] = i.trim();
      }
      print('brudh $players');

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
      // playerstats['Logo'] = [logo];
      return playerstats;
    }

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    String file = "$dir";
    final prefs = await SharedPreferences.getInstance();
    var SharedPrefData = jsonDecode(prefs.getString('FantasyData'));
    print('SharedPrefData ${SharedPrefData}');
    //[[Team, Player Stats, Teamlogo],
    //[The Ford Trophy_Central DistrictsvsCanterbury_Central Districts,
    // [[TC Bruce 80 121.21, WA Young 71 98.61, Batting],
    //[JA Clarkson 3 2.5, SHA Rance 2 6.0, Bowling],
    //[JCT Boyle, TC Bruce &57, Partnership]], /db/PICTURES/CMS/313300/313331.logo.png],
    //[The Ford Trophy_Central DistrictsvsCanterbury_headtohead,
    //[[D Cleaver 60 88.23, KJ McClure* 100 78.74, Batting],
    //[BG Randell 10.0 2 2.9, Bowling],
    //[JCT Boyle, BD Schmulian &27, W Clark, BG Randell &18, BD Schmulian, JA Clarkson &5, JCT Boyle, BS Smith &26, Partnership]], /db/PICTURES/CMS/313300/313330.logo.png]]

    var SharedPrefDatatoList = [];
    for (var j in SharedPrefData.keys) {
      SharedPrefDatatoList.add(SharedPrefData[j]);
    }
    print('ik11 ${SharedPrefDatatoList}');

    List<Map<String, List<dynamic>>> result = [];
    Map<String, List<dynamic>> league_data = {};
    Map<String, List<dynamic>> previous_clashes_data = {};
    Set distinct_leagues = {};
    Map<String, List<dynamic>> dummy = {};
    if (SharedPrefDatatoList.isNotEmpty) {
      for (var fields in SharedPrefDatatoList) {
        print('fiels $fields');
        for (int i = 1; i < fields.length; i++) {
          //map {Lanka Premier League_Galle GladiatorsvsColombo Stars:[parseData[1],parseData[2]]
          // }
          print('-------------------------------------');
          var team_of_the_league = fields[i][0].split('_').last;

          var league_name_and_vs = fields[i][0].toString().split('_')[0] +
              '_' +
              fields[i][0].toString().split('_')[1];
          league_data[league_name_and_vs] = [];
          previous_clashes_data['headtohead'] = [];
          dummy[team_of_the_league] = [
            parseData(league_name_and_vs, team_of_the_league, fields[i][1])
          ];
          print('what si dummy $dummy');
          for (int i = 1; i < fields.length; i++) {
            var league_name_and_vs = fields[i][0].toString().split('_')[0] +
                '_' +
                fields[i][0].toString().split('_')[1];
            league_data[league_name_and_vs] = [];
            for (var j in dummy.keys) {
              if (league_name_and_vs.contains(j)) {
                league_data[league_name_and_vs] += dummy[j];
              } else if (j == 'headtohead') {
                previous_clashes_data['headtohead'] = dummy[j];
              }
              // distinct_leagues.add(fields[i][0].toString().split('_')[0] +
              //     '_' +
              //     fields[i][0].toString().split('_')[1]);
            }
          }
        }
      }
      print('import_datayu $league_data');
      return [league_data, previous_clashes_data];
    } else {
      return null;
    }
  }
}

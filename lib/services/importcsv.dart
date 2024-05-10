import 'dart:convert';
import 'package:external_path/external_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportCsv {
  static Future<List<Map<String, List<dynamic>>>?> getcsvdata() async {
    Map<String, List<dynamic>> parseData(
        String leagueName, String team, dynamic csvOutput) {
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

      return playerstats;
    }

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final prefs = await SharedPreferences.getInstance();
    var sharedPrefData = jsonDecode(prefs.getString('FantasyData') ?? '[]');

    List<Map<String, List<dynamic>>> result = [];
    Map<String, List<dynamic>> leagueData = {};
    Map<String, List<dynamic>> previousClashesData = {};

    if (sharedPrefData.isNotEmpty) {
      for (var fields in sharedPrefData) {
        for (var data in fields) {
          var leagueNameAndVs =
              '${data[0].split('_')[0]}_${data[0].split('_')[1]}';
          var teamOfTheLeague = data[0].split('_').last;

          var leagueDataItem =
              parseData(leagueNameAndVs, teamOfTheLeague, data[1]);

          if (teamOfTheLeague == 'headtohead') {
            previousClashesData['headtohead'] = [leagueDataItem];
          } else {
            leagueData
                .putIfAbsent(leagueNameAndVs, () => [])
                .add(leagueDataItem);
          }
        }
      }

      return [leagueData, previousClashesData];
    } else {
      return null;
    }
  }
}

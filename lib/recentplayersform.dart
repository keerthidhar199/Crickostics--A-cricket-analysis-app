import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class gettingplayers {
  Future<List<Map<String, List<dynamic>>>> getplayersinForm(
      allmatchlinks, teamname, longteamname) async {
    List<Map<String, List<dynamic>>> listofallplayersform = [];
    for (var matchlink in allmatchlinks) {
      String editmathclink =
          matchlink.replaceAll(matchlink.split('/').last, 'live-cricket-score');
      var response = await http.Client()
          .get(Uri.parse('https://www.espncricinfo.com$editmathclink'));

      print('fuic https://www.espncricinfo.com$editmathclink');
      dom.Document document = parser.parse(response.body);
      var fuic = document
          .getElementsByClassName(
              'ds-text-tight-s ds-font-regular ds-capitalize ds-bg-fill-content-alternate ds-px-3 ds-py-1')
          .first
          .parent!
          .children[1]
          .children; //"Scorecard Summary" table

      Map<String, List<dynamic>> teamrecentplayers = {};
      List<String> team1 = [];
      List<String> batters = [];
      List<String> bowlers = [];

      for (var i in fuic) {
        String teamandinnings = i.children[0].text.split('•').first.trim();
        var players = i.children[1].children;

        // print('nuvvu ${teamandinnings.split('•').first}');

        for (var batter in players) {
          if (teamandinnings == teamname || teamandinnings == longteamname) {
            print('nuvvu $teamname $teamandinnings');

            team1.add(batter.children[0].text);
          } else {
            print('nuvvu $teamname $teamandinnings');

            team1.add(batter.children[1].text);
          }
        }
        for (var i in team1) {
          if (i.contains('/')) {
            var bowlerName = i.split(RegExp(r'[0-9]')).first;
            bowlers.add(bowlerName + i.replaceAll(bowlerName, '- ').trim());
          } else {
            if (i.contains('*')) {
              var batterName = i.split('*').first.trim();
              var batterScore = i.replaceAll(batterName, '-').trim();
              batters.add(batterName + batterScore);
            } else {
              var batterName = i.split(RegExp(r'[0-9]')).first.trim();
              var batterScore = i.replaceAll(batterName, '-').trim();
              batters.add(batterName + batterScore);
            }
          }
        }
        teamrecentplayers['Batters${allmatchlinks.indexOf(matchlink) + 1}'] =
            batters.toSet().toList();
        teamrecentplayers['Bowlers${allmatchlinks.indexOf(matchlink) + 1}'] =
            bowlers.toSet().toList();

        print('shuffle $teamrecentplayers');
        // teamrecentplayers[globals.team2_name] = team2;
      }

      listofallplayersform.add(teamrecentplayers);
    }
    print('fuicTeam $listofallplayersform');
    return listofallplayersform;
  }

  Map<String, int> getTopPlayers(e) {
    Map<String, int> countofplayer = {};
    for (int i = 0; i < e['matches_details'].length; i++) {
      List<String> batters = e['listofallrecentplayers'][i]['Batters${i + 1}'];
      List<String> bowlers = e['listofallrecentplayers'][i]['Bowlers${i + 1}'];
      for (var element in batters) {
        var batterName = element.split('-').first;
        if (!countofplayer.containsKey(batterName)) {
          countofplayer[batterName] = 1;
        } else {
          countofplayer[batterName] = countofplayer[batterName]! + 1;
        }
      }
      for (var element in bowlers) {
        var bowlerName = element.split('-').first;
        if (!countofplayer.containsKey(bowlerName)) {
          countofplayer[bowlerName] = 1;
        } else {
          countofplayer[bowlerName] = countofplayer[bowlerName]! + 1;
        }
      }
      countofplayer = Map.fromEntries(countofplayer.entries.toList()
        ..sort((e2, e1) => e1.value.compareTo(e2.value)));
    }
    countofplayer.removeWhere((key, value) => value == 1);
    return countofplayer;
  }
}

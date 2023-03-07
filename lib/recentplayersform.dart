import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;

class gettingplayers {
  Future<List<Map<String, List<dynamic>>>> getplayersinForm(
      allmatchlinks, teamname, longteamname) async {
    List<Map<String, List<dynamic>>> listofallplayersform = [];
    for (var matchlink in allmatchlinks) {
      String editmathclink =
          matchlink.replaceAll(matchlink.split('/').last, 'live-cricket-score');
      var response = await http.Client()
          .get(Uri.parse('https://www.espncricinfo.com/' + editmathclink));

      dom.Document document = parser.parse(response.body);
      var fuic = document
          .getElementsByClassName(
              'ds-text-tight-s ds-font-regular ds-uppercase ds-bg-fill-content-alternate ds-p-3')
          .first
          .parent
          .children[1]
          .children;

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
            var bowler_name = i.split(RegExp(r'[0-9]')).first;
            bowlers.add(bowler_name + i.replaceAll(bowler_name, '- ').trim());
          } else {
            if (i.contains('*')) {
              var batter_name = i.split('*').first.trim();
              var batter_score = i.replaceAll(batter_name, '-').trim();
              batters.add(batter_name + batter_score);
            } else {
              var batter_name = i.split(RegExp(r'[0-9]')).first.trim();
              var batter_score = i.replaceAll(batter_name, '-').trim();
              batters.add(batter_name + batter_score);
            }
          }
        }
        teamrecentplayers[
                'Batters' + (allmatchlinks.indexOf(matchlink) + 1).toString()] =
            batters.toSet().toList();
        teamrecentplayers[
                'Bowlers' + (allmatchlinks.indexOf(matchlink) + 1).toString()] =
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
      List<String> batters =
          e['listofallrecentplayers'][i]['Batters' + (i + 1).toString()];
      List<String> bowlers =
          e['listofallrecentplayers'][i]['Bowlers' + (i + 1).toString()];
      batters.forEach((element) {
        var batter_name = element.split('-').first;
        if (!countofplayer.containsKey(batter_name)) {
          countofplayer[batter_name] = 1;
        } else {
          countofplayer[batter_name] += 1;
        }
      });
      bowlers.forEach((element) {
        var bowler_name = element.split('-').first;
        if (!countofplayer.containsKey(bowler_name)) {
          countofplayer[bowler_name] = 1;
        } else {
          countofplayer[bowler_name] += 1;
        }
      });
      countofplayer = Map.fromEntries(countofplayer.entries.toList()
        ..sort((e2, e1) => e1.value.compareTo(e2.value)));
    }
    countofplayer.removeWhere((key, value) => value == 1);
    return countofplayer;
  }
}

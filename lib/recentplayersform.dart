import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datascrap/recent_stats_testing.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/typeofstats.dart';
import 'package:datascrap/views/fantasy_players_UI.dart';
import 'package:datascrap/webscrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:page_transition/page_transition.dart';
import 'globals.dart' as globals;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:skeletons/skeletons.dart';

class gettingplayers {
  Future<List<Map<String, List<dynamic>>>> getplayersinForm(matchlink1) async {
    String editmathclink =
        matchlink1.replaceAll(matchlink1.split('/').last, 'live-cricket-score');
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

    Map<String, List<dynamic>> batrecentplayers = {};
    Map<String, List<dynamic>> bowlrecentplayers = {};
    for (var i in fuic) {
      String teamandinnings = i.children[0].text;
      var players = i.children[1].children;
      List<String> batters = [];
      List<String> bowlers = [];

      for (var batter in players) {
        batters.add(batter.children[0].text);
        bowlers.add(batter.children[1].text);
      }
      batrecentplayers[teamandinnings] = batters;
      bowlrecentplayers[teamandinnings] = bowlers;
      print('fuicBAT $batrecentplayers');
      print('fuicBOWL $bowlrecentplayers');
    }
    return [batrecentplayers, bowlrecentplayers];
  }
}

class recentplayersform extends StatefulWidget {
  final listofrecentplayers;

  const recentplayersform({Key key, this.listofrecentplayers})
      : super(key: key);

  @override
  State<recentplayersform> createState() =>
      _recentplayersformState(this.listofrecentplayers);
}

class _recentplayersformState extends State<recentplayersform> {
  List<Map<String, List<dynamic>>> listofrecentplayers;

  _recentplayersformState(listofrecentplayers);

  @override
  Widget build(BuildContext context) {
    print('listofrecentplayers $listofrecentplayers');
    return listofrecentplayers.isEmpty
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: listofrecentplayers
                .map((e) => Container(
                      child: Text(e.values.toString()),
                    ))
                .toList(),
          );
  }
}





// class RecentPlayersinForm extends StatefulWidget {
//   final listofrecentplayers;
//   const RecentPlayersinForm({Key key, this.listofrecentplayers}) : super(key: key);

//   @override
//   State<RecentPlayersinForm> createState() =>
//       _RecentPlayersinFormState(this.listofrecentplayers);
// }

// class _RecentPlayersinFormState extends State<RecentPlayersinForm> {
//   String listofrecentplayers;

//   _RecentPlayersinFormState(listofrecentplayers);

//   @override
//   Widget build(BuildContext context) {
//     print('listofrecentplayers $listofrecentplayers');

//     // getplayersinForm(listofrecentplayers).then((value) {
//     //   print('listofrecentplayers $listofrecentplayers');
//     // });
//     return Container();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;

class gettingplayers {
  Future<Map<String, List<dynamic>>> getplayersinForm(
      matchlink1, teamname) async {
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

    Map<String, List<dynamic>> teamrecentplayers = {};
    List<String> team1 = [];
    List<String> team2 = [];

    for (var i in fuic) {
      String teamandinnings = i.children[0].text.split('•').first.trim();
      var players = i.children[1].children;

      // print('nuvvu ${teamandinnings.split('•').first}');

      for (var batter in players) {
        if (teamandinnings == teamname) {
          print('nuvvu $teamname $teamandinnings');

          team1.add(batter.children[0].text);
          team2.add(batter.children[1].text);
        } else {
          team2.add(batter.children[0].text);
          team1.add(batter.children[1].text);
        }
      }
      teamrecentplayers[teamname] = team1;
      // teamrecentplayers[globals.team2_name] = team2;
    }
    print('fuicTeam $teamrecentplayers');
    return teamrecentplayers;
  }
}

class recentplayersform extends StatelessWidget {
  final listofrecentplayers;
  final teamname;
  const recentplayersform({Key key, this.listofrecentplayers, this.teamname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> listofrecentplayers = this.listofrecentplayers;
    print('listofrecentplayers $listofrecentplayers');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Batters', style: globals.Louisgeorge),
            Text('Bowlers', style: globals.Louisgeorge),
          ],
        ),
        FittedBox(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listofrecentplayers[teamname]
                      .map((e) => !e.toString().contains('/')
                          ? Text(
                              e.toString(),
                              style: globals.Louisgeorge,
                            )
                          : Container())
                      .toList(),
                ),
                VerticalDivider(
                  thickness: 3,
                  color: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listofrecentplayers[teamname]
                      .map((e) => e.toString().contains('/')
                          ? Text(
                              e.toString().split(RegExp(r'[0-9]')).first +
                                  ' - ' +
                                  e.toString().replaceAll(
                                      e
                                          .toString()
                                          .split(RegExp(r'[0-9]'))
                                          .first,
                                      ''),
                              style: globals.Louisgeorge)
                          : Container())
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // Text(listofrecentplayers.keys .toString()),
    // Text(listofrecentplayers.values.toString()),
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

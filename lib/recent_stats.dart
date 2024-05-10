// ignore_for_file: unused_local_variable, unnecessary_null_comparison, camel_case_types, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:datascrap/recent_stats_expansionblock.dart';
import 'package:datascrap/recentplayersform.dart';
import 'package:datascrap/skeleton.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';

class recentmatchdata extends StatefulWidget {
  const recentmatchdata({Key? key}) : super(key: key);
  @override
  State<recentmatchdata> createState() => _recentmatchdataState();
}

class _recentmatchdataState extends State<recentmatchdata> {
  var themecolor = Colors.white;
  var darkcolor = Colors.black;

  Future<String> getlogos(String leaguename) async {
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    List imglogosdata =
        json.decode(document.getElementById('__NEXT_DATA__')!.text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    List imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__')!.text)['props']
            ['appPageProps']['data']['content']['matches'];
    List takethisimglogosdata = List.from(imglogosdata)..addAll(imglogosdata1);
    String seriesname = '';
    for (var i in takethisimglogosdata) {
      if (i['teams'][0]['team']['longName'].toString().trim() == leaguename) {
        seriesname = i['teams'][0]['team']['image']['url'].toString();
      } else if (i['teams'][1]['team']['longName'].toString().trim() ==
          leaguename) {
        seriesname = i['teams'][1]['team']['image']['url'].toString();
      }
    }
    //print('imglogosdata12 $seriesname');
    return seriesname;
  }

  Future<List<Map<String, List<dynamic>>>> getrecentstats() async {
    List<Map<String, List<dynamic>>> bothteams = [];
    Map<String, List<dynamic>> team2 = {};
    dom.Document link2doc;
    var link2address = globals.league_page_address;
    var team1names = [globals.team1_name, globals.team2_name];
    var team1shortnames = [
      globals.team1__short_name,
      globals.team2__short_name
    ];

    // var link2address =
    //     'https://www.espncricinfo.com/series/england-in-bangladesh-2022-23-1351394/bangladesh-vs-england-2nd-odi-1351398/match-preview';

    link2address.toString().replaceAll(
        link2address.toString().split('/').last, 'points-table-standings');
    var forlink2 = await http.Client().get(Uri.parse(link2address));
    print('object $link2address');
    link2doc = parser.parse(forlink2.body);
    for (var i in team1names) {
      Map<String, List<dynamic>>? team1 = {};

      var team1past = link2doc
          .querySelector('table')!
          .getElementsByTagName('tbody>tr')
          .where((element) => (element.text.contains(i)));
      for (var i in team1past.first.parent!.children) {
        print('team1past.first ${i}');
      }
      int team1index = link2doc
          .querySelector('table')!
          .getElementsByTagName('tbody>tr')
          .indexWhere((element) => element.text.contains(i));
      RegExp regExp = RegExp(r'^[AWLD]*$');
      print(regExp.hasMatch('WWWWW'));
      print(regExp.hasMatch('WLLLW '));
      print(regExp.hasMatch('WDDDW'));
      print(regExp.hasMatch('LLLL'));
      print(regExp.hasMatch('DDDD'));
      print(regExp.hasMatch('LDDDL '));

      var team1pastname = (team1past.first.children
          .where((element) => (regExp.hasMatch(element.text))));
      team1['Name'] = [i];
      team1['winsloss'] = [team1pastname.first.text];
      List<List<List<String?>>> matchText = team1past
          .first.parent!.children[team1index + 1]
          .getElementsByTagName('a')
          .map((e) => e.nodes[0].children
              .toList()
              .map((element) => element.nodes.map((e) => e.text).toList())
              .toList())
          .toList()
          .sublist(0, 5);
      List<String> dateAndMatchList = [];
      List<String> resultList = [];
      List<String> teamsList = [];
      for (var i in matchText) {
        List<String> parts = i[1][0]!.split(", ");
        String dateAndMatch = parts[0] + ", " + parts[1] + ", " + parts[2];
        String result = i[1][1]!.split(', ')[0];
        String teams = parts[3];
        dateAndMatchList.add(dateAndMatch);
        resultList.add(result);
        teamsList.add(teams);
      }
      team1['vs'] = teamsList;
      team1['matches_details'] = dateAndMatchList;
      team1['match_winner'] = resultList;
      print('sully ${team1['winsloss']}');

      team1['scoreboard_for_matches_links'] = team1past
          .first.parent!.children[team1index + 1]
          .getElementsByTagName('a')
          .map((e) => e.attributes['href'])
          .toList()
          .sublist(0, 5);

      team1['listofallrecentplayers'] = await gettingplayers().getplayersinForm(
          team1['scoreboard_for_matches_links'], team1['Name'], i);

      //   team1['listofallrecentplayers'] = await gettingplayers()
      //       .getplayersinForm(
      //           matches_played_links1, team1_recentname, globals.team1_name);

      bothteams.add(team1);
    }
    print('team1pastname $bothteams');

    link2doc = parser.parse(forlink2.body);
    return bothteams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2B2B28),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFB72B),
        title: const Text(
          'Recent stats',
          style:
              TextStyle(fontFamily: 'Montserrat-Black', color: Colors.black87),
        ),
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder<List<Map<String, List<dynamic>>>>(
        future: getrecentstats(), // async work
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, List<dynamic>>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  color: const Color(0xff2B2B28),
                  child: SkeletonTheme(
                      shimmerGradient: LinearGradient(colors: [
                        const Color(0xff1A3263).withOpacity(0.8),
                        const Color(0xff1A3263),
                        const Color(0xff1A3263),
                        const Color(0xff1A3263).withOpacity(0.8),
                      ]),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            const NewsCardSkelton(),
                      )));
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return Container(
                    color: const Color(0xff2B2B28),
                    child: SkeletonTheme(
                        shimmerGradient: LinearGradient(colors: [
                          const Color(0xff1A3263).withOpacity(0.8),
                          const Color(0xff1A3263),
                          const Color(0xff1A3263),
                          const Color(0xff1A3263).withOpacity(0.8),
                        ]),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) =>
                              const NewsCardSkelton(),
                        )));
              } else {
                if (snapshot.data!.isEmpty) {
                  return Container(
                    color: const Color(0xff2B2B28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('  Oh My CrickOh! ',
                            style: TextStyle(
                              fontFamily: 'Montserrat-Black',
                              fontSize: 20.0,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Stats not available.',
                            style: TextStyle(
                              fontFamily: 'Montserrat-Black',
                              fontSize: 20.0,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Image.asset(
                                  'logos/ball.png',
                                ),
                                onPressed: null),
                            const Flexible(
                              child: Text(
                                  'The league might have started recently due to which enough data is not found.',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Black',
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  String rootLogo =
                      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
                  List<String> teamnames = [
                    globals.team1_name,
                    globals.team2_name
                  ];
                  List<String> teamlogos = [
                    globals.team1logo,
                    globals.team2logo
                  ];
                  List<Map<String, List<dynamic>>> recentplayers = [];
                  FlipCardController flipcardcontrol = FlipCardController();
                  // return Text(snapshot.data[1].toString());
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                          children: snapshot.data!.map((e) {
                        return Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff005874),
                                  Color(0xff1C819E),
                                ],
                              )),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      teamlogos[snapshot.data!.indexOf(e)] !=
                                              null
                                          ? Image.network(
                                              rootLogo +
                                                  teamlogos[snapshot.data!
                                                          .indexOf(e)]
                                                      .toString(),
                                              width: 32,
                                              height: 32,
                                            )
                                          : IconButton(
                                              icon: Image.asset(
                                                  'logos/team${snapshot.data!.indexOf(e) + 1}.png'),
                                              onPressed: null),
                                      GestureDetector(
                                        onTap: () {},
                                        child: SizedBox(
                                          height: 40.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              '${e['Name']![0].trim()}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Montserrat-Black',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: e['winsloss']![0]
                                          .toString()
                                          .characters
                                          .map((character) => Row(
                                                children: [
                                                  const Text('-'),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: character == 'W'
                                                          ? Colors.green
                                                          : character == 'L'
                                                              ? Colors.red
                                                              : Colors.grey,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      character,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Montserrat-Black',
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text('-'),
                                                  // SizedBox(
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           18,
                                                  // )
                                                ],
                                              ))
                                          .toList()),
                                ],
                              ),
                            ),
                            expansionTile(
                              e: e,
                              countofPlayers: gettingplayers().getTopPlayers(e),
                            )
                          ],
                        );
                      }).toList()),
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, duplicate_ignore, library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/services/get_player_pic.dart';
import 'package:datascrap/views/previous_clashes_UI.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dream11_team.dart';

import 'views/batting_table_UI.dart';
import 'views/bowling_table_UI.dart';

class Analysis extends StatefulWidget {
  static Map<String, List> battersmap = {};

  static Map<String, List> bowlersmap = {};

  static Map<String, List> partnershipsmap = {};

  static Map<String, List> previousmatchmap = {};

  /// Creates the home page.
  const Analysis({Key? key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  late bool addtofantasyteam;
  Tuple3<
      Tuple2<List<String>, List<Batting_player>>,
      Tuple2<List<String>, List<Player>>,
      Tuple2<List<String>, List<Partnership>>>? snapshot;
  List<List<String>> topBatters = [];
  int topbat = 0;
  int tophthbat = 0;
  int tophthbowl = 0;

  List<List<String>> topBowlers = [];

  List<List<String>> topheadtoheadbatters = [];
  List<List<String>> topheadtoheadbowlers = [];

  List<List<String>> headtoheadbolwers = [];
  int topbowl = 0;
  int topheadtohead = 0;

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        snapshot = value;
      });
      Map<String, List<String>> playerRuns = {};
      Map<String, List<String>> playerRunshth = {};

      for (var i in snapshot!.item1.item2) {
        print('batters ${i.team} ${globals.ground}');
        if ((((globals.team1_name.contains(i.team)) ||
                    globals.team1__short_name.contains(i.team)) &&
                ((globals.team2_name)
                        .contains(i.opposition.replaceAll('v', '').trim()) ||
                    globals.team2__short_name
                        .contains(i.opposition.replaceAll('v', '').trim()))) ||
            ((globals.team2_name.contains(i.team) ||
                        globals.team2__short_name.contains(i.team)) &&
                    (globals.team1_name.contains(
                            i.opposition.replaceAll('v', '').trim()) ||
                        globals.team1__short_name.contains(
                            i.opposition.replaceAll('v', '').trim()))) &&
                tophthbat < 4) {
          List<String> headtoheadbatters = [];
          headtoheadbatters.add(i.player);
          headtoheadbatters.add(i.runs.toString());
          headtoheadbatters.add(i.balls.toString());
          headtoheadbatters.add(i.sr.toString());
          headtoheadbatters.add(i.player_link);
          print('headtoheadbatters $headtoheadbatters');
          topheadtoheadbatters.add(headtoheadbatters);
          for (var item in topheadtoheadbatters) {
            if (!playerRunshth.containsKey(item[0])) {
              tophthbat += 1;
              playerRunshth[item[0]] = item;
            } else {
              if (int.parse(item[1]) > int.parse(playerRunshth[item[0]]![1])) {
                playerRunshth[item[0]] = item;
              }
            }
          }
          topheadtoheadbatters = playerRunshth.values.toList();
        }
        if (i.ground == globals.ground && topbat < 5) {
          List<String> batters = [];
          batters.add(i.player);
          batters.add(i.runs.toString());
          batters.add(i.balls.toString());
          batters.add(i.sr.toString());
          batters.add(i.player_link);
          print('batters $batters');
          topBatters.add(batters);
          for (var item in topBatters) {
            if (!playerRuns.containsKey(item[0])) {
              topbat += 1;
              playerRuns[item[0]] = item;
            } else {
              if (int.parse(item[1]) > int.parse(playerRuns[item[0]]![1])) {
                playerRuns[item[0]] = item;
              }
            }
          }
          topBatters = playerRuns.values.toList();
        }
      }
      Map<String, List<String>> playerWicketshth = {};
      Map<String, List<String>> playerWickets = {};

      for (var i in snapshot!.item2.item2) {
        if (((globals.team1_name.contains(i.team)) &&
                ((globals.team2_name)
                        .contains(i.opposition.replaceAll('v', '').trim()) ||
                    globals.team2__short_name
                        .contains(i.opposition.replaceAll('v', '').trim()))) ||
            (globals.team2_name.contains(i.team) &&
                    (globals.team1_name.contains(
                            i.opposition.replaceAll('v', '').trim()) ||
                        globals.team1__short_name.contains(
                            i.opposition.replaceAll('v', '').trim()))) &&
                tophthbowl < 4) {
          List<String> headtoheadbowlers = [];
          headtoheadbowlers.add(i.player);
          headtoheadbowlers.add(i.runs.toString());
          headtoheadbowlers.add(i.wickets.toString());
          headtoheadbowlers.add(i.econ.toString());
          headtoheadbowlers.add(i.player_link);
          topheadtoheadbowlers.add(headtoheadbowlers);
          for (var item in topheadtoheadbowlers) {
            if (!playerWicketshth.containsKey(item[0])) {
              tophthbowl += 1;
              playerWicketshth[item[0]] = item;
            } else {
              if (double.parse(item[3]) >
                  double.parse(playerWicketshth[item[0]]![3])) {
                playerWicketshth[item[0]] = item;
              }
            }
          }
          topheadtoheadbowlers = playerWicketshth.values.toList();
        }
        print('topheadtoheadbowlers $topheadtoheadbowlers');

        print('bowlers ${i.ground} ${globals.ground}');

        if (i.ground == globals.ground && topbowl < 5) {
          List<String> bowlers = [];
          bowlers.add(i.player);
          bowlers.add(i.runs.toString());
          bowlers.add(i.wickets.toString());
          bowlers.add(i.econ.toString());
          bowlers.add(i.player_link);
          topBowlers.add(bowlers);
          for (var item in topBowlers) {
            if (!playerWickets.containsKey(item[0])) {
              topbowl += 1;
              playerWickets[item[0]] = item;
            } else {
              if (double.parse(item[3]) >
                  double.parse(playerWickets[item[0]]![3])) {
                playerWickets[item[0]] = item;
              }
            }
          }
          topBowlers = playerWickets.values.toList();
        }
      }

      get_players_pics(topBowlers).then((value) {
        setState(() {
          topBowlers = value;
        });
      });
      get_players_pics(topBatters).then((value) {
        setState(() {
          topBatters = value;
        });
      });
      get_players_pics(topheadtoheadbatters).then((value) {
        topheadtoheadbatters = value;
      });

      get_players_pics(topheadtoheadbowlers).then((value) {
        topheadtoheadbowlers = value;
      });
    });

    super.initState();
  }

  late bowlingDataSource bowlingData;

  List<String> names = [
    'batting',
    'bowling',
    'partnerships',
    'previous clashes'
  ];

  List<String> teamnames = [globals.team1_name, globals.team2_name];
  List<String> teamlogos = [globals.team1logo, globals.team2logo];
  int _currentSlide = 0;
  final CarouselController _controller = CarouselController();
  List<String> matchstatetitle = ['Batting', 'Bowling', 'Head to Head'];

  @override
  Widget build(BuildContext context) {
    print('assa11endva ${snapshot}');
    Analysis.battersmap.clear();
    Analysis.bowlersmap.clear();
    Analysis.partnershipsmap.clear();
    Analysis.previousmatchmap.clear();
    Widget batting = widgetbatting(
      snapshot: snapshot,
    );
    Widget bowling = widgetbowling(
      snapshot: snapshot,
    );
    // Widget partnership = widgetpartnership(
    //   snapshot: snapshot,
    // );

    List<Widget> categories = [
      batting,
      bowling,
      // partnership,
      pastmatches(
        snapshot: snapshot,
      )
    ];

    print('stop $topBowlers $topBatters');

    List<Widget> list = categories
        .map(
          (e) => Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              (topBatters.isEmpty && topBowlers.isEmpty)
                  ? Container()
                  : Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade700,
                            ),
                            child: Text('Top Performers at this Venue',
                                textAlign: TextAlign.center,
                                style: globals.cocosharp)),
                        player_pic(
                          categories: categories,
                          e: e,
                          topBatters: topBatters,
                          topBowlers: topBowlers,
                          topheadtoheadbatters: topheadtoheadbatters,
                          topheadtoheadbowlers: topheadtoheadbowlers,
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "Once all players are selected, Click Submit on the top to save all your selected players.",
                    style: globals.smallcocosharp),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  // shadowColor: Colors.blue,
                  child: Column(
                    children: [
                      categories.indexOf(e) == 2
                          ? previous_clashes_header()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white38,
                                      Colors.white60,
                                    ],
                                  )),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${globals.capitalize(names[categories.indexOf(e)])}',
                                        style: const TextStyle(
                                          fontFamily: 'Cocosharp',
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.asset(
                                        'logos/${names[categories.indexOf(e)]}.png',
                                        color: Colors.black,
                                        width: 100,
                                        height: 100,
                                      ),
                                      Text(
                                        'In ${globals.ground}',
                                        style: const TextStyle(
                                          fontFamily: 'Cocosharp',
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      e
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xffFFB72B),
          title: const Text(
            'Stack',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
                color: Colors.black,
                icon: const Icon(Icons.done_all),
                onPressed: () {
                  // Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => Dream11TeamGenerator(batsmen: snapshot!.item1.item2
                  //               .where((element) =>
                  //                   element.team == globals.team1__short_name &&
                  //                   element.ground == globals.ground)
                  //               .toList(),),
                  //           ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dream11TeamGenerator(
                              batters: topBatters,
                              bowlers: topBowlers,
                            )),
                  );

                  // ExportCsv.getcsv().then((value) => null);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       duration: const Duration(seconds: 3),
                  //       behavior: SnackBarBehavior.floating,
                  //       content: Row(children: [
                  //         Image.asset(
                  //           'logos/my_fantasy.png',
                  //           width: 50,
                  //           height: 50,
                  //         ),
                  //         Text(
                  //             "Cricked !!\n"
                  //             "Added to your Fantasy lot\n"
                  //             "You can view these in 'Your Fantasy' tab.",
                  //             style: globals.cocosharpblack),
                  //       ]),
                  //       backgroundColor: Colors.amberAccent,
                  //       padding: const EdgeInsets.all(8),
                  //       margin: EdgeInsetsDirectional.only(
                  //         bottom: MediaQuery.of(context).size.height / 2,
                  //       )),
                  // );
                }),
          ],
        ),
        body: snapshot?.item1 == null
            ? Container(
                color: const Color(0xff2B2B28),
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xffFFB72B),
                  ),
                ),
              )
            : Stack(children: [
                SingleChildScrollView(
                  child: Container(
                      color: const Color(0xff2B2B28),
                      height: MediaQuery.of(context).size.height * 3,
                      child: CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          aspectRatio: 2,
                          height: MediaQuery.of(context).size.height * 3,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          // autoPlay: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentSlide = index;
                            });
                          },
                        ),
                        items: list,
                      )),
                ),
                Container(
                  color: const Color(0xff2B2B28),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: matchstatetitle
                          .map(
                            (e) => Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom:
                                    _currentSlide == matchstatetitle.indexOf(e)
                                        ? const BorderSide(
                                            //                   <--- right side
                                            color: Colors.white,
                                            width: 3.0,
                                          )
                                        : BorderSide.none,
                              )),
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  _controller
                                      .jumpToPage(matchstatetitle.indexOf(e));
                                  setState(() {
                                    _currentSlide = matchstatetitle.indexOf(e);
                                  });
                                },
                                child: Text(
                                  e.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Cocosharp',
                                    fontSize: 15.0,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ]));
  }

  Future<
      Tuple3<
          Tuple2<List<String>, List<Batting_player>>,
          Tuple2<List<String>, List<Player>>,
          Tuple2<List<String>, List<Partnership>>>> getData() async {
    var bowling = 'bowling-best-figures-innings';
    var batting = 'batting-highest-strike-rate-innings';
    var partnership = 'fow-highest-partnerships-for-any-wicket';
    List<List<String>> teamsBowling = [];
    List<String> teamsBowlingHeadings = [];
    List<List<String>> teamsBatting = [];
    List<String> teamsBattingHeadings = [];

//BATTING*******************************************************
    print('Manali ${globals.team1_stats_link}');
    var root = 'https://www.espncricinfo.com';
    dom.Document document;
    Tuple3<
        Tuple2<List<String>, List<Batting_player>>,
        Tuple2<List<String>, List<Player>>,
        Tuple2<List<String>, List<Partnership>>> overallData;
    //TEAM1
    http.Response responseTeam1;
    if (globals.team1_stats_link.startsWith('https')) {
      responseTeam1 =
          await http.Client().get(Uri.parse(globals.team1_stats_link));
      document = parser.parse(responseTeam1.body);
    } else {
      responseTeam1 =
          await http.Client().get(Uri.parse(root + globals.team1_stats_link));
      document = parser.parse(responseTeam1.body);
    }

    var team1BattingTable = document.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']!
            .contains(batting));
    print(
        'team1_batting_table1 ${team1BattingTable.first.getElementsByTagName('a')[0].attributes['href']}');
    var team1BowlingTable = document.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(bowling));
    print(
        'team1_bowling_table ${team1BowlingTable.first.getElementsByTagName('a')[0].attributes['href']}');

    var team1PartnershipTable = document.querySelectorAll('li').where(
        (element) => element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(partnership));

    if (team1BattingTable.isEmpty ||
        team1BowlingTable.isEmpty ||
        team1PartnershipTable.isEmpty) {
      // ignore: prefer_const_constructors
      overallData = Tuple3<
              Tuple2<List<String>, List<Batting_player>>,
              Tuple2<List<String>, List<Player>>,
              Tuple2<List<String>, List<Partnership>>>(
          Tuple2<List<String>, List<Batting_player>>([], []),
          Tuple2<List<String>, List<Player>>([], []),
          Tuple2<List<String>, List<Partnership>>([], []));
      return overallData;
    }
    //TEAM2
    dom.Document document1;

    http.Response responseTeam2;
    if (globals.team2_stats_link.startsWith('https')) {
      responseTeam2 =
          await http.Client().get(Uri.parse(globals.team2_stats_link));
      document1 = parser.parse(responseTeam2.body);
    } else {
      responseTeam2 =
          await http.Client().get(Uri.parse(root + globals.team2_stats_link));
      document1 = parser.parse(responseTeam2.body);
    }

    var team2BattingTable = document1.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']!
            .contains(batting));
    var team2BowlingTable = document1.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(bowling));

    document1.querySelectorAll('li').where((element) => element
        .getElementsByTagName('a')[0]
        .attributes['href']
        .toString()
        .contains(partnership));

    var team1InfoBatting = await http.Client().get(Uri.parse(root +
        team1BattingTable.first
            .getElementsByTagName('a')[0]
            .attributes['href']!));
    var team2InfoBatting = await http.Client().get(Uri.parse(root +
        team2BattingTable.first
            .getElementsByTagName('a')[0]
            .attributes['href']!));
    var value1 = await batting_teams_info(team1InfoBatting, globals.team1_name);
    var value2 = await batting_teams_info(team2InfoBatting, globals.team2_name);
    teamsBattingHeadings = value1.item1;

    List<Batting_player>? battingPlayersdata1 = [];
    if (value1.item1 == null || value2.item1 == null) {
      battingPlayersdata1 = null;
    } else {
      teamsBatting = List.from(value1.item2)..addAll(value2.item2);

      for (var i in teamsBatting) {
        if (i.toString().contains('-')) {
          if (i.indexWhere((element) => element.contains('-')) !=
              11) //except the player link
          {
            i[i.indexWhere((element) => element.contains('-'))] = '0.0';
          }
        }
      }
      print('teams_batting $teamsBatting');
      for (var i in teamsBatting) {
        if (i[1].trim().contains('*')) {
          battingPlayersdata1.add(Batting_player(
              '${i[0].trim()}*',
              int.parse(i[1].replaceAll('*', '').trim()),
              int.parse(i[2].trim()),
              i[3].trim() == '0.0' ? 0 : int.parse(i[3].trim()),
              i[4].trim() == '0.0' ? 0 : int.parse(i[4].trim()),
              double.parse(i[5].trim()),
              i[6].trim(),
              i[7].trim(),
              i[8].trim(),
              i[9].trim(),
              i[10].trim(),
              i[11].toString()));
        } else {
          battingPlayersdata1.add(Batting_player(
              i[0].trim(),
              int.parse(i[1].trim()),
              int.parse(i[2].trim()),
              i[3].trim() == '0.0' || i[3].trim() == '-'
                  ? 0
                  : int.parse(i[3].trim()),
              i[4].trim() == '0.0' || i[4].trim() == '-'
                  ? 0
                  : int.parse(i[4].trim()),
              double.parse(i[5].trim()),
              i[6].trim(),
              i[7].trim(),
              i[8].trim(),
              i[9].trim(),
              i[10].trim(),
              i[11].trim()));
        }
      }
      // batting_playersdata1.forEach((element) {
      //   print('playersdata ${element.player}');
      //   print('playersdata ${element.runs}');

      //   print('playersdata ${element.balls}');
      //   print('playersdata ${element.fours}');
      //   print('playersdata ${element.sixes}');
      //   print('playersdata ${element.sr}');
      //   print('playersdata ${element.team}');
      //   print('playersdata ${element.opposition}');
      //   print('playersdata ${element.ground}');
      //   print('playersdata ${element.match_date}');
      //   print('playersdata ${element.score_card}');
      //   print('playersdata ${element.player_link}');
      // });

      // return Tuple2(teams_batting_headings, batting_playersdata1);
    }

//BOWLING*******************************************************

    var team1InfoBowling = await http.Client().get(Uri.parse(root +
        team1BowlingTable.first
            .getElementsByTagName('a')[0]
            .attributes['href']!));
    var team2InfoBowling = await http.Client().get(Uri.parse(root +
        team2BowlingTable.first
            .getElementsByTagName('a')[0]
            .attributes['href']!));
    var value3 = await bowling_teams_info(team1InfoBowling, globals.team1_name);
    var value4 = await bowling_teams_info(team2InfoBowling, globals.team2_name);

    teamsBowlingHeadings = value3.item1;
    List<Player>? bowlingPlayersdata1 = [];
    if (value3.item1 == null || value4.item1 == null) {
      print('Reppa ${value3.item1}');
      bowlingPlayersdata1 = null;
    } else {
      teamsBowling = List.from(value3.item2)..addAll(value4.item2);
      for (var i in teamsBowling) {
        bowlingPlayersdata1.add(Player(
            i[0].trim(),
            double.parse(i[1].trim()),
            int.parse(i[2].trim()),
            int.parse(i[3].trim()),
            double.parse(i[4].trim()),
            i[5].trim(),
            i[6].trim(),
            i[7].trim(),
            i[8].trim(),
            i[9].trim(),
            i[10].trim()));
      }
      for (var element in bowlingPlayersdata1) {
        print('playersdata ${element.player}');
        print('playersdata ${element.wickets}');

        print('playersdata ${element.econ}');
        print('playersdata ${element.team}');
        print('playersdata ${element.opposition}');
        print('playersdata ${element.ground}');
        print('playersdata ${element.match_date}');
        print('playersdata ${element.score_card}');
        print('playersdata ${element.player_link}');
      }
    }

//PARTNERSHIPS*******************************************************
    // var team1_info_partnerships = await http.Client().get(Uri.parse(root +
    //     team1_partnership_table.first
    //         .getElementsByTagName('a')[0]
    //         .attributes['href']));
    // var team2_info_partnerships = await http.Client().get(Uri.parse(root +
    //     team2_partnership_table.first
    //         .getElementsByTagName('a')[0]
    //         .attributes['href']));

    // var value5 = await partnership_teams_info(
    //     team1_info_partnerships, globals.team1_name);
    // var value6 = await partnership_teams_info(
    //     team2_info_partnerships, globals.team2_name);
    // partnerships_headings = value5.item1;

    // print('partnerships $partnerships_headings');
    // List<Partnership> partnership_playersdata = [];
    // if (value5.item1 == null || value6.item1 == null) {
    //   partnership_playersdata = null;
    // } else {
    //   partnerships = new List.from(value5.item2)..addAll(value6.item2);

    //   for (var i in partnerships) {
    //     if (i[1].trim().contains('*')) {
    //       partnership_playersdata.add(Partnership(
    //         i[0].trim() + '*',
    //         int.parse(i[1].replaceAll('*', '').trim()),
    //         i[2].trim(),
    //         i[3].trim(),
    //         i[4].trim(),
    //         i[5].trim(),
    //         i[6].trim(),
    //       ));
    //     } else {
    //       partnership_playersdata.add(Partnership(
    //         i[0].trim(),
    //         int.parse(i[1].trim()),
    //         i[2].trim(),
    //         i[3].trim(),
    //         i[4].trim(),
    //         i[5].trim(),
    //         i[6].trim(),
    //       ));
    //     }
    //   }
    //   print('playersdata $partnership_playersdata');
    //   // return Tuple2(teams_batting_headings, batting_playersdata1);
    // }
    Tuple2<List<String>, List<Player>> bowlingdataheadings = Tuple2(
        teamsBowlingHeadings, bowlingPlayersdata1!); //bowling data overall
    Tuple2<List<String>, List<Batting_player>> battingdataheadings = Tuple2(
        teamsBattingHeadings, battingPlayersdata1!); // batting data overall
    // Tuple2<List<String>, List<Partnership>> partnershipsdataheadings = Tuple2(
    //     partnerships_headings, partnership_playersdata); // partnership data overall

    // overall_data = Tuple3(
    //     battingdataheadings, bowlingdataheadings, partnershipsdataheadings);
    overallData =
        Tuple3(battingdataheadings, bowlingdataheadings, const Tuple2([], []));

    return overallData; //((batting_headers_table,batting_players),(bowling_headers_table,bowling_players))
  }
}

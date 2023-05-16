import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/services/exportcsv.dart';
import 'package:datascrap/services/get_player_pic.dart';
import 'package:datascrap/views/previous_clashes_UI.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'views/batting_table_UI.dart';
import 'views/bowling_table_UI.dart';
import 'views/partnerships_table_UI.dart';

class Analysis extends StatefulWidget {
  static Map<String, List> battersmap = {};

  static Map<String, List> bowlersmap = {};

  static Map<String, List> partnershipsmap = {};

  static Map<String, List> previousmatchmap = {};

  /// Creates the home page.
  Analysis({Key key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  bool _isButtonDisabled;
  bool addtofantasyteam;
  Tuple3<
      Tuple2<List<String>, List<Batting_player>>,
      Tuple2<List<String>, List<Player>>,
      Tuple2<List<String>, List<Partnership>>> snapshot;
  @override
  void initState() {
    getData().then((value) {
      if (value == null) {
        snapshot = null;
      } else {
        setState(() {
          snapshot = value;
        });
        Map<String, List<String>> playerRuns = {};

        for (var i in snapshot.item1.item2) {
          print('batters ${i.ground} ${globals.ground}');

          if (i.ground == globals.ground && topbat < 4) {
            List<String> batters = [];
            batters.add(i.player);
            batters.add(i.runs.toString());
            batters.add(i.balls.toString());
            batters.add(i.sr.toString());
            batters.add(i.player_link);
            print('batters $batters');
            topBatters.add(batters);
            topBatters.forEach((item) {
              if (!playerRuns.containsKey(item[0])) {
                topbat += 1;
                playerRuns[item[0]] = item;
              } else {
                if (int.parse(item[1]) > int.parse(playerRuns[item[0]][1])) {
                  playerRuns[item[0]] = item;
                }
              }
            });
            topBatters = playerRuns.values.toList();
          }
        }
        Map<String, List<String>> playerWickets = {};
        for (var i in snapshot.item2.item2) {
          print('bowlers ${i.ground} ${globals.ground}');

          if (i.ground == globals.ground && topbowl < 4) {
            List<String> bowlers = [];
            bowlers.add(i.player);
            bowlers.add(i.runs.toString());
            bowlers.add(i.wickets.toString());
            bowlers.add(i.econ.toString());
            bowlers.add(i.player_link);
            topBowlers.add(bowlers);
            topBowlers.forEach((item) {
              if (!playerWickets.containsKey(item[0])) {
                topbowl += 1;
                playerWickets[item[0]] = item;
              } else {
                if (double.parse(item[3]) >
                    double.parse(playerWickets[item[0]][3])) {
                  playerWickets[item[0]] = item;
                }
              }
            });
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
      }
    });

    _isButtonDisabled = true;
    super.initState();
  }

  bowlingDataSource bowlingData;

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
  List<List<String>> topBatters = [];
  int topbat = 0;
  List<List<String>> topBowlers = [];
  int topbowl = 0;

  @override
  Widget build(BuildContext context) {
    print('assa11endva ${Analysis.battersmap}');
    Analysis.battersmap.clear();
    Analysis.bowlersmap.clear();
    Analysis.partnershipsmap.clear();
    Analysis.previousmatchmap.clear();
    if (snapshot == null) {
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
                  exportcsv.getcsv().then((value) => null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        content: Row(children: [
                          Image.asset(
                            'logos/my_fantasy.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                              "Cricked !!\n"
                              "Added to your Fantasy lot\n"
                              "You can view these in 'Your Fantasy' tab.",
                              style: globals.nobleblack),
                        ]),
                        backgroundColor: Colors.amberAccent,
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsetsDirectional.only(
                          bottom: MediaQuery.of(context).size.height / 2,
                        )),
                  );
                }),
          ],
        ),
        body: Container(
            color: const Color(0xff2B2B28),
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Container(
              color: const Color(0xff2B2B28),
              child: Lottie.asset(
                'logos/loading_anim.json',
                filterQuality: FilterQuality.high,
              ),
            ))),
      );
    } else {
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
                                  style: globals.noble)),
                          player_pic(
                            categories: categories,
                            e: e,
                            topBatters: topBatters,
                            topBowlers: topBowlers,
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "Once all players are selected, Click Submit on the top to save all your selected players.",
                      style: globals.smallnoble),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        )),
                    color: Colors.white,
                    elevation: 10,
                    shadowColor: Colors.blue,
                    child: Container(
                      child: Column(
                        children: [
                          categories.indexOf(e) == 2
                              ? const previous_clashes_header()
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            'logos/' +
                                                '${names[categories.indexOf(e)]}' +
                                                '.png',
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
                    exportcsv.getcsv().then((value) => null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          content: Row(children: [
                            Image.asset(
                              'logos/my_fantasy.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                                "Cricked !!\n"
                                "Added to your Fantasy lot\n"
                                "You can view these in 'Your Fantasy' tab.",
                                style: globals.nobleblack),
                          ]),
                          backgroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsetsDirectional.only(
                            bottom: MediaQuery.of(context).size.height / 2,
                          )),
                    );
                  }),
            ],
          ),
          body: Stack(children: [
            SingleChildScrollView(
              child: Container(
                  color: const Color(0xff2B2B28),
                  height: MediaQuery.of(context).size.height * 2,
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      aspectRatio: 2,
                      height: MediaQuery.of(context).size.height * 2,
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
                            bottom: _currentSlide == matchstatetitle.indexOf(e)
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
  }

  Future<
      Tuple3<
          Tuple2<List<String>, List<Batting_player>>,
          Tuple2<List<String>, List<Player>>,
          Tuple2<List<String>, List<Partnership>>>> getData() async {
    var bowling = 'bowling-best-figures-innings';
    var batting = 'batting-highest-strike-rate-innings';
    var partnership = 'fow-highest-partnerships-for-any-wicket';
    List<List<String>> teams_bowling = [];
    List<String> teams_bowling_headings = [];
    List<List<String>> teams_batting = [];
    List<String> teams_batting_headings = [];
    List<List<String>> partnerships = [];
    List<String> partnerships_headings = [];

//BATTING*******************************************************
    print('Manali ${globals.team1_stats_link}');
    var root = 'https://www.espncricinfo.com';
    dom.Document document;
    String containing;
    Tuple3<
        Tuple2<List<String>, List<Batting_player>>,
        Tuple2<List<String>, List<Player>>,
        Tuple2<List<String>, List<Partnership>>> overall_data;
    //TEAM1
    var response_team1;
    if (globals.team1_stats_link.startsWith('https')) {
      response_team1 =
          await http.Client().get(Uri.parse(globals.team1_stats_link));
      document = parser.parse(response_team1.body);
    } else {
      response_team1 =
          await http.Client().get(Uri.parse(root + globals.team1_stats_link));
      document = parser.parse(response_team1.body);
    }

    var team1_batting_table = document.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .contains(batting));
    print(
        'team1_batting_table1 ${team1_batting_table.first.getElementsByTagName('a')[0].attributes['href']}');
    var team1_bowling_table = document.querySelectorAll('li').where((element) =>
        element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(bowling));
    print(
        'team1_bowling_table ${team1_bowling_table.first.getElementsByTagName('a')[0].attributes['href']}');

    var team1_partnership_table = document.querySelectorAll('li').where(
        (element) => element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(partnership));

    if (team1_batting_table.isEmpty ||
        team1_bowling_table.isEmpty ||
        team1_partnership_table.isEmpty) {
      overall_data = const Tuple3(null, null, null);
      return overall_data;
    }
    //TEAM2
    dom.Document document1;

    var response_team2;
    if (globals.team2_stats_link.startsWith('https')) {
      response_team2 =
          await http.Client().get(Uri.parse(globals.team2_stats_link));
      document1 = parser.parse(response_team2.body);
    } else {
      response_team2 =
          await http.Client().get(Uri.parse(root + globals.team2_stats_link));
      document1 = parser.parse(response_team2.body);
    }

    var team2_batting_table = document1.querySelectorAll('li').where(
        (element) => element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .contains(batting));
    var team2_bowling_table = document1.querySelectorAll('li').where(
        (element) => element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(bowling));

    var team2_partnership_table = document1.querySelectorAll('li').where(
        (element) => element
            .getElementsByTagName('a')[0]
            .attributes['href']
            .toString()
            .contains(partnership));
    if (team2_batting_table.isEmpty == null ||
        team2_bowling_table.isEmpty == null ||
        team2_partnership_table.isEmpty == null) {
      overall_data = const Tuple3(null, null, null);
      return overall_data;
    }

    var team1_info_batting = await http.Client().get(Uri.parse(root +
        team1_batting_table.first
            .getElementsByTagName('a')[0]
            .attributes['href']));
    var team2_info_batting = await http.Client().get(Uri.parse(root +
        team2_batting_table.first
            .getElementsByTagName('a')[0]
            .attributes['href']));
    var value1 =
        await batting_teams_info(team1_info_batting, globals.team1_name);
    var value2 =
        await batting_teams_info(team2_info_batting, globals.team2_name);
    teams_batting_headings = value1.item1;

    List<Batting_player> batting_playersdata1 = [];
    if (value1.item1 == null || value2.item1 == null) {
      batting_playersdata1 = null;
    } else {
      teams_batting = List.from(value1.item2)..addAll(value2.item2);

      for (var i in teams_batting) {
        if (i.toString().contains('-')) {
          if (i.indexWhere((element) => element.contains('-')) !=
              10) //except the player link
          {
            i[i.indexWhere((element) => element.contains('-'))] = '0.0';
          }
        }
      }
      print('teams_batting $teams_batting');
      for (var i in teams_batting) {
        if (i[1].trim().contains('*')) {
          batting_playersdata1.add(Batting_player(
              i[0].trim() + '*',
              int.parse(i[1].replaceAll('*', '').trim()),
              int.parse(i[2].trim()),
              i[3].trim() == '0.0' ? 0 : int.parse(i[3].trim()),
              i[4].trim() == '0.0' ? 0 : int.parse(i[4].trim()),
              double.parse(i[5].trim()),
              i[6].trim(),
              i[7].trim(),
              i[8].trim(),
              i[9].trim(),
              i[10].trim()));
        } else {
          batting_playersdata1.add(Batting_player(
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
              i[10].trim()));
        }
      }
      print('playersdata $batting_playersdata1');
      // return Tuple2(teams_batting_headings, batting_playersdata1);
    }

//BOWLING*******************************************************

    var team1_info_bowling = await http.Client().get(Uri.parse(root +
        team1_bowling_table.first
            .getElementsByTagName('a')[0]
            .attributes['href']));
    var team2_info_bowling = await http.Client().get(Uri.parse(root +
        team2_bowling_table.first
            .getElementsByTagName('a')[0]
            .attributes['href']));
    var value3 =
        await bowling_teams_info(team1_info_bowling, globals.team1_name);
    var value4 =
        await bowling_teams_info(team2_info_bowling, globals.team2_name);

    teams_bowling_headings = value3.item1;
    List<Player> bowling_playersdata1 = [];
    if (value3.item1 == null || value4.item1 == null) {
      print('Reppa ${value3.item1}');
      bowling_playersdata1 = null;
    } else {
      teams_bowling = new List.from(value3.item2)..addAll(value4.item2);
      for (var i in teams_bowling) {
        bowling_playersdata1.add(Player(
            i[0].trim(),
            double.parse(i[1].trim()),
            int.parse(i[2].trim()),
            int.parse(i[3].trim()),
            double.parse(i[4].trim()),
            i[5].trim(),
            i[6].trim(),
            i[7].trim(),
            i[8].trim(),
            i[9].trim()));
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
        teams_bowling_headings, bowling_playersdata1); //bowling data overall
    Tuple2<List<String>, List<Batting_player>> battingdataheadings = Tuple2(
        teams_batting_headings, batting_playersdata1); // batting data overall
    // Tuple2<List<String>, List<Partnership>> partnershipsdataheadings = Tuple2(
    //     partnerships_headings, partnership_playersdata); // partnership data overall

    // overall_data = Tuple3(
    //     battingdataheadings, bowlingdataheadings, partnershipsdataheadings);
    overall_data =
        Tuple3(battingdataheadings, bowlingdataheadings, const Tuple2([], []));

    return overall_data; //((batting_headers_table,batting_players),(bowling_headers_table,bowling_players))
  }
}

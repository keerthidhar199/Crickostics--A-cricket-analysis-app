import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/views/previous_clashes_UI.dart';
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

  /// Creates the home page.
  Analysis({Key key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

capitalize(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

getAbbreviation(String s) {
  var l = s.split(' ');
  String res = '';
  for (var i in l) {
    res += i[0].toUpperCase();
  }
  return res;
}

int checkpastmatches(
  String team1,
  String team2,
) {
  team2 = team2.replaceAll('v', '').trim();
  int count = 0;

  if (globals.team2_name.contains('Bangalore') ||
      globals.team2_name.contains('Kolkata')) {
    globals.team2_name = getAbbreviation(globals.team2_name).trim();
  }
  if (globals.team1_name.contains(team1) &&
      globals.team2_name.contains(team2)) {
    return count;
  } else {
    return 0;
  }
}

class _AnalysisState extends State<Analysis> {
  bool _isButtonDisabled;
  bool addtofantasyteam;

  @override
  void initState() {
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

  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

  List<String> teamnames = [globals.team1_name, globals.team2_name];
  List<String> teamlogos = [globals.team1logo, globals.team2logo];
  @override
  Widget build(BuildContext context) {
    print('assa11endva ${Analysis.battersmap}');
    List<List<dynamic>> bowlers = [];
    List<List<dynamic>> partnerships = [];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: const Text(
            'Stack',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          color: Color(0xff2B2B28),
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<
              Tuple3<
                  Tuple2<List<String>, List<Batting_player>>,
                  Tuple2<List<String>, List<Player>>,
                  Tuple2<List<String>, List<Partnership>>>>(
            future: getData(), // async work
            builder: (BuildContext context,
                AsyncSnapshot<
                        Tuple3<
                            Tuple2<List<String>, List<Batting_player>>,
                            Tuple2<List<String>, List<Player>>,
                            Tuple2<List<String>, List<Partnership>>>>
                    snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: Container(
                          color: Color(0xff2B2B28),
                          child: Stack(
                            children: [
                              Image.asset(
                                'logos/bars.png',
                                width: 480,
                                height: 230,
                              ),
                              Image.asset(
                                'logos/comp1with.gif',
                                filterQuality: FilterQuality.high,
                              ),
                            ],
                          )));
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Widget batting = widgetbatting(
                      snapshot: snapshot,
                    );
                    Widget bowling = widgetbowling(
                      snapshot: snapshot,
                    );
                    Widget partnership = widgetpartnership(
                      snapshot: snapshot,
                    );

                    List<Widget> categories = [
                      batting,
                      bowling,
                      partnership,
                    ];
                    List<Widget> list = categories
                        .map(
                          (e) => SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 15,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        )),
                                    color: Colors.white,
                                    elevation: 10,
                                    shadowColor: Colors.blue,
                                    child: SingleChildScrollView(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  gradient: LinearGradient(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${capitalize(names[categories.indexOf(e)])}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Cocosharp',
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Cocosharp',
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList();
                    Widget d = SingleChildScrollView(
                      child: pastmatches(
                        snapshot: snapshot,
                      ),
                    );
                    list.add(d);
                    return Builder(
                      builder: (context) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2,
                            height: MediaQuery.of(context).size.height,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            // autoPlay: false,
                          ),
                          items: list,
                        );
                      },
                    );
                  }
              }
            },
          ),
        ));
  }

  Future<
      Tuple3<
          Tuple2<List<String>, List<Batting_player>>,
          Tuple2<List<String>, List<Player>>,
          Tuple2<List<String>, List<Partnership>>>> getData() async {
    var bowling = 'bowling/best_figures_innings';
    var batting = 'batting/highest_strike_rate_innings';
    var partnership = 'fow/highest_partnerships_for_any_wicket';
    List<List<String>> teams_bowling = [];
    List<String> teams_bowling_headings = [];
    List<List<String>> teams_batting = [];
    List<String> teams_batting_headings = [];
    List<List<String>> partnerships = [];
    List<String> partnerships_headings = [];

//BATTING*******************************************************
    print('Manali ${globals.team1_stats_link}');
    var root = 'https://stats.espncricinfo.com';
    dom.Document document;
    String containing;
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

    var team1_batting_table = document.querySelectorAll('a').where(
        (element) => element.attributes['href'].toString().contains(batting));
    print('team1_batting_table $team1_batting_table');
    var team1_bowling_table = document.querySelectorAll('a').where(
        (element) => element.attributes['href'].toString().contains(bowling));
    var team1_partnership_table = document.querySelectorAll('a').where(
        (element) =>
            element.attributes['href'].toString().contains(partnership));

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

    var team2_batting_table = document1.querySelectorAll('a').where(
        (element) => element.attributes['href'].toString().contains(batting));
    var team2_bowling_table = document1.querySelectorAll('a').where(
        (element) => element.attributes['href'].toString().contains(bowling));

    var team2_partnership_table = document1.querySelectorAll('a').where(
        (element) =>
            element.attributes['href'].toString().contains(partnership));

    var team1_info_batting = await http.Client().get(Uri.parse(
        root + team1_batting_table.first.attributes['href'].toString()));
    var team2_info_batting = await http.Client().get(Uri.parse(
        root + team2_batting_table.first.attributes['href'].toString()));
    var value1 =
        await batting_teams_info(team1_info_batting, globals.team1_name);
    var value2 =
        await batting_teams_info(team2_info_batting, globals.team2_name);
    teams_batting_headings = value1.item1;

    List<Batting_player> batting_playersdata1 = [];
    if (value1.item1 == null || value2.item1 == null) {
      batting_playersdata1 = null;
    } else {
      teams_batting = new List.from(value1.item2)..addAll(value2.item2);

      for (var i in teams_batting) {
        if (i.toString().contains('-')) {
          i[i.indexWhere((element) => element.contains('-'))] = '0.0';
        }
      }
      print('teams_batting $teams_batting');
      for (var i in teams_batting) {
        if (i[1].trim().contains('*')) {
          batting_playersdata1.add(Batting_player(
              i[0].trim() + '*',
              int.parse(i[1].replaceAll('*', '').trim()),
              int.parse(i[2].trim()),
              int.parse(i[3].trim()),
              int.parse(i[4].trim()),
              double.parse(i[5].trim()),
              i[6].trim(),
              i[7].trim(),
              i[8].trim(),
              i[9].trim()));
        } else {
          batting_playersdata1.add(Batting_player(
              i[0].trim(),
              int.parse(i[1].trim()),
              int.parse(i[2].trim()),
              int.parse(i[3].trim()),
              int.parse(i[4].trim()),
              double.parse(i[5].trim()),
              i[6].trim(),
              i[7].trim(),
              i[8].trim(),
              i[9].trim()));
        }
      }
      print('playersdata $batting_playersdata1');
      // return Tuple2(teams_batting_headings, batting_playersdata1);
    }

//BOWLING*******************************************************

    var team1_info_bowling = await http.Client().get(Uri.parse(
        root + team1_bowling_table.first.attributes['href'].toString()));
    var team2_info_bowling = await http.Client().get(Uri.parse(
        root + team2_bowling_table.first.attributes['href'].toString()));
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
            i[8].trim()));
      }
    }
//PARTNERSHIPS*******************************************************
    var team1_info_partnerships = await http.Client().get(Uri.parse(
        root + team1_partnership_table.first.attributes['href'].toString()));
    var team2_info_partnerships = await http.Client().get(Uri.parse(
        root + team2_partnership_table.first.attributes['href'].toString()));

    var value5 = await partnership_teams_info(
        team1_info_partnerships, globals.team1_name);
    var value6 = await partnership_teams_info(
        team2_info_partnerships, globals.team2_name);
    partnerships_headings = value5.item1;

    print('partnerships $partnerships_headings');
    List<Partnership> partnership_playersdata = [];
    if (value5.item1 == null || value6.item1 == null) {
      partnership_playersdata = null;
    } else {
      partnerships = new List.from(value5.item2)..addAll(value6.item2);

      for (var i in partnerships) {
        if (i[1].trim().contains('*')) {
          partnership_playersdata.add(Partnership(
            i[0].trim() + '*',
            int.parse(i[1].replaceAll('*', '').trim()),
            i[2].trim(),
            i[3].trim(),
            i[4].trim(),
            i[5].trim(),
            i[6].trim(),
          ));
        } else {
          partnership_playersdata.add(Partnership(
            i[0].trim(),
            int.parse(i[1].trim()),
            i[2].trim(),
            i[3].trim(),
            i[4].trim(),
            i[5].trim(),
            i[6].trim(),
          ));
        }
      }
      print('playersdata $partnership_playersdata');
      // return Tuple2(teams_batting_headings, batting_playersdata1);
    }
    Tuple2<List<String>, List<Player>> bowlingdataheadings = Tuple2(
        teams_bowling_headings, bowling_playersdata1); //bowling data overall
    Tuple2<List<String>, List<Batting_player>> battingdataheadings = Tuple2(
        teams_batting_headings, batting_playersdata1); // batting data overall
    Tuple2<List<String>, List<Partnership>> partnershipsdataheadings = Tuple2(
        partnerships_headings, partnership_playersdata); // batting data overall

    Tuple3<
            Tuple2<List<String>, List<Batting_player>>,
            Tuple2<List<String>, List<Player>>,
            Tuple2<List<String>, List<Partnership>>> overall_data =
        Tuple3(
            battingdataheadings, bowlingdataheadings, partnershipsdataheadings);
    return overall_data; //((batting_headers_table,batting_players),(bowling_headers_table,bowling_players))
  }
}

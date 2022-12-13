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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AnimatedSplashScreen(
      splashIconSize: double.infinity,
      duration: 2000,
      splash: Container(
        color: Color(0xff2B2B28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'logos/crickostics.png',
              filterQuality: FilterQuality.high,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CRICKOSTICS',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'RestaurantMenu',
                      fontSize: 50),
                ),
              ),
            )
          ],
        ),
      ),
      nextScreen: Homepage(),
      splashTransition: SplashTransition.fadeTransition,
      // backgroundColor: Colors.indigoAccent,
    ));
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String website;
  String route = 'https://www.espncricinfo.com';
  var linkdetails = [];
  List match_leagues = [];
  List match_leagues_refresh = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicator =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<dynamic>> getValidMatches() async {
    List validMatches = [];

    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    List imglogosdata =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    List imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['content']['matches'];
    List takethisimglogosdata = new List.from(imglogosdata)
      ..addAll(imglogosdata1);
    ;

    var parentdata =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['navigation']['links'][1]['links'];

    for (var i in takethisimglogosdata) {
      if (!i['status'].toString().startsWith('Not covered') &&
          (i['statusText'].toString().startsWith('Match starts') ||
              i['statusText'].toString().startsWith('Match yet'))) {
        // var objectid = i['series']['objectId'];
        // var link = 'https://www.espncricinfo.com/ci/engine/series/' +
        //     objectid.toString() +
        //     '.html?view=records';
        // validMatches.add(i['series']['longName']);
        // var teamstats = await http.Client().get(Uri.parse(link));
        // dom.Document teamstatsdoc = parser.parse(teamstats.body);
        // var rec1 = teamstatsdoc
        //     .getElementsByClassName('RecBulAro')
        //     .where((element) => element.text == 'Records by team');
        // var rec2 = teamstatsdoc
        //     .getElementsByClassName('RecBulAro')
        //     .where((element) => element.text == 'Records by team');
        // if (rec1.toList().isNotEmpty && rec2.toList().isNotEmpty) {
        //   print(i['series']['longName']);
        //   print(i['series']['longName']);
        //   validMatches.add(i['series']['longName']);
        // }
        validMatches.add(i['series']['longName']);
      }
    }
    print(validMatches);
    return validMatches.toSet().toList();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicator.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() {
      getValidMatches().then((value) {
        setState(() {
          match_leagues_refresh = value;
        });
      });
      return Future.delayed(Duration(microseconds: 1));
      // return
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: Text(
            'Playing Leagues',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => fantasyteam(),
                    ));
              },
              child: Container(
                  child: Text(
                    'Your fantasy',
                    style: TextStyle(
                        fontFamily: 'Cocosharp', color: Colors.black87),
                  ),
                  color: Colors.orange),
            ),
          ],
        ),
        body: RefreshIndicator(
          color: Color(0xffFFB72B),
          backgroundColor: Color(0xff2B2B28),
          key: _refreshIndicator,
          onRefresh: _refresh,
          child: FutureBuilder<List<dynamic>>(
              future: getValidMatches(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        color: Color(0xff2B2B28),
                        // child: Text('Loading ${snapshot.data}'),
                        child: SkeletonTheme(
                            shimmerGradient: LinearGradient(colors: [
                              Color(0xff1A3263).withOpacity(0.8),
                              Color(0xff1A3263),
                              Color(0xff1A3263),
                              Color(0xff1A3263).withOpacity(0.8),
                            ]),
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) =>
                                  PlayingLeaguesSkelton(),
                            )));
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return Container(
                        color: Color(0xff2B2B28),
                        child: AnimationLimiter(
                          child: AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 500),
                            position: 1,
                            child: ScaleAnimation(
                              child: SlideAnimation(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Choose your League :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Louisgeorge',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // TextButton(
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 recentmatchtestdata(),
                                    //           ));
                                    //     },
                                    //     child: Container(
                                    //       color: Color(0xffFFB72B),
                                    //     )),

                                    AnimationLimiter(
                                      child: Expanded(
                                        child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return AnimationConfiguration
                                                .staggeredList(
                                              duration: const Duration(
                                                  milliseconds: 900),
                                              position: index,
                                              child: ScaleAnimation(
                                                child: FadeInAnimation(
                                                  curve: Curves.easeInExpo,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.4))),
                                                    elevation: 10,
                                                    child: new InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          globals.league_page =
                                                              snapshot
                                                                  .data[index];
                                                          print(
                                                              'Globals ${globals.league_page}');
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      datascrap(),
                                                            ));
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                    colors: [
                                                                      Color(
                                                                          0xff1A3263),
                                                                      Color(0xff1A3263)
                                                                          .withOpacity(
                                                                              0.8),
                                                                    ],
                                                                  )),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                30,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            height: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    snapshot
                                                                        .data
                                                                        .length) -
                                                                15,
                                                            child: Center(
                                                              child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Louisgeorge',
                                                                  fontSize:
                                                                      20.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                }
              }),
        ));
  }
}

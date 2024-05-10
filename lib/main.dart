// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/splashscreen.dart';
import 'package:datascrap/views/fantasy_players_UI.dart';
import 'package:datascrap/webscrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashPage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String website;
  String route = 'https://www.espncricinfo.com';
  var linkdetails = [];
  List match_leagues = [];
  List<List<dynamic>> match_leagues_refresh = [];

  final CarouselController _controller = CarouselController();
  int _currentSlide = 0;

  Future<List<List<dynamic>>> getValidMatches() async {
    List validMatches = [];
    List ongoingmatches = [];
    List finishedmatches = [];
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

    for (var i in takethisimglogosdata) {
      if (!i['status'].toString().startsWith('Not covered')) {
        if ((i['state'].toString() == 'PRE')) {
          validMatches.add(i['series']['longName']);
        } else {
          // var objectid = i['series']['objectId'];
          // var link = 'https://www.espncricinfo.com/ci/engine/series/' +
          //     objectid.toString() +
          //     '.html?view=records';
          // var teamstats = await http.Client().get(Uri.parse(link));
          // dom.Document teamstatsdoc = parser.parse(teamstats.body);
          // var rec1 = teamstatsdoc
          //     .getElementsByClassName('RecBulAro')
          //     .where((element) => element.text == 'Records by team');
          // var rec2 = teamstatsdoc
          //     .getElementsByClassName('RecBulAro')
          //     .where((element) => element.text == 'Records by team');
          // if (rec1.toList().isNotEmpty && rec2.toList().isNotEmpty) {
          if (i['state'].toString() == 'POST') {
            finishedmatches.add(i['series']['longName']);
          } else if (i['state'].toString() == 'LIVE') {
            ongoingmatches.add(i['series']['longName']);

            // print(i['series']['longName']);
            // print(i['series']['longName']);
            // validMatches.add(i['series']['longName']);
          }
        }
      }
    }
    print(ongoingmatches);
    return [
      validMatches.toSet().toList(),
      ongoingmatches.toSet().toList(),
      finishedmatches.toSet().toList(),
    ];
  }

  @override
  void initState() {
    super.initState();
    getValidMatches().then((value) {
      setState(() {
        match_leagues_refresh = value;
      });
    });
  }

  List<String> matchstatetitle = ['Upcoming', 'Ongoing', 'Completed'];
  GlobalKey<RefreshIndicatorState> _refreshIndicator =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    List<BorderSide> borderside = List.filled(3, BorderSide.none);
    List<List<dynamic>> matchLeaguesRefresh1 = [];

    Future<void> refresh() async {
      await Future.delayed(const Duration(seconds: 1));
      getValidMatches().then((value) {
        setState(() {
          _refreshIndicator = GlobalKey<RefreshIndicatorState>();
          matchLeaguesRefresh1 = value;
          match_leagues_refresh = matchLeaguesRefresh1;
        });
      });
      // return
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffFFB72B),
          title: const Text(
            'Playing Leagues',
            style: TextStyle(
                fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const fantasyteam(),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff2B2B28)),
                child: Row(
                  children: [
                    const Text(
                      'Your Fantasy',
                      style: TextStyle(
                          fontFamily: 'Cocosharp', color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'logos/my_fantasy.png',
                      width: 15,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
            key: _refreshIndicator,
            color: const Color(0xffFFB72B),
            backgroundColor: const Color(0xff2B2B28),
            onRefresh: refresh,
            child: match_leagues_refresh.isEmpty
                ? Container(
                    color: const Color(0xff2B2B28),
                    // child: Text('Loading ${snapshot.data}'),
                    child: SkeletonTheme(
                        shimmerGradient: LinearGradient(colors: [
                          const Color(0xff1A3263).withOpacity(0.8),
                          const Color(0xff1A3263),
                          const Color(0xff1A3263),
                          const Color(0xff1A3263).withOpacity(0.8),
                        ]),
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) =>
                              const PlayingLeaguesSkelton(),
                        )))
                : Container(
                    color: const Color(0xff2B2B28),
                    child: AnimationLimiter(
                      child: AnimationConfiguration.staggeredList(
                        duration: const Duration(milliseconds: 700),
                        position: 1,
                        child: ScaleAnimation(
                          child: SlideAnimation(
                            child: (match_leagues_refresh[0].isEmpty &&
                                    match_leagues_refresh[1].isEmpty &&
                                    match_leagues_refresh[2].isEmpty)
                                ? Center(
                                    child: Container(
                                      color: const Color(0xff2B2B28),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('  Oh My CrickOh! ',
                                              style: TextStyle(
                                                fontFamily: 'Cocosharp',
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              )),
                                          const SizedBox(
                                            height: 5,
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
                                                    'No Scheduled matches as of now. Matches appear before 10-12hr of the match start time.',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Cocosharp',
                                                      fontSize: 17.0,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Choose your league',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Cocosharp',
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
                                          //             builder: (BuildContext
                                          //                     context) =>
                                          //                 NotificationsBar(),
                                          //           ));
                                          //     },
                                          //     child: Container(
                                          //       color: Color(0xffFFB72B),
                                          //     )),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: matchstatetitle
                                                  .map(
                                                    (e) => Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                        bottom: _currentSlide ==
                                                                matchstatetitle
                                                                    .indexOf(e)
                                                            ? const BorderSide(
                                                                //                   <--- right side
                                                                color: Colors
                                                                    .white,
                                                                width: 3.0,
                                                              )
                                                            : BorderSide.none,
                                                      )),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          _controller.jumpToPage(
                                                              matchstatetitle
                                                                  .indexOf(e));
                                                          setState(() {
                                                            _currentSlide =
                                                                matchstatetitle
                                                                    .indexOf(e);
                                                          });
                                                        },
                                                        child: Text(
                                                          e.toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Cocosharp',
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList()),

                                          CarouselSlider(
                                            carouselController: _controller,
                                            options: CarouselOptions(
                                              initialPage: _currentSlide,
                                              enableInfiniteScroll: false,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              viewportFraction: 1,
                                              enlargeCenterPage: false,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentSlide = index;
                                                });
                                              },

                                              // autoPlay: false,
                                            ),
                                            items: match_leagues_refresh
                                                .map(
                                                  (matchstate) => Container(
                                                    child: Column(
                                                        children:
                                                            matchstate.map((e) {
                                                      return AnimationConfiguration
                                                          .staggeredList(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        position: matchstate
                                                            .indexOf(e),
                                                        child: ScaleAnimation(
                                                          child:
                                                              FadeInAnimation(
                                                            curve: Curves
                                                                .easeInExpo,
                                                            child: SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  matchstate
                                                                      .length,
                                                              child: Card(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.4))),
                                                                elevation: 10,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      globals.league_page =
                                                                          e;

                                                                      print(
                                                                          'Globals ${globals.league_page}');
                                                                    });

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              datascrap(),
                                                                        ));
                                                                  },
                                                                  child: Container(
                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                      height: 100,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                            colors: [
                                                                              const Color(0xff1A3263),
                                                                              const Color(0xff1A3263).withOpacity(0.8),
                                                                            ],
                                                                          )),
                                                                      child: Center(
                                                                        child:
                                                                            Text(
                                                                          e.toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'Cocosharp',
                                                                            fontSize:
                                                                                20.0,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList()),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ]),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )));
  }
}

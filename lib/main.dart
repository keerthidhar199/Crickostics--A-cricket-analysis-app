import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/notificationview.dart';
import 'package:datascrap/recent_stats_testing.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/splashscreen.dart';
import 'package:datascrap/typeofstats.dart';
import 'package:datascrap/views/fantasy_players_UI.dart';
import 'package:datascrap/webscrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    return MaterialApp(home: SplashPage()

        //     AnimatedSplashScreen(
        // duration: 3000,
        // backgroundColor: Color(0xff2B2B28),
        // splashIconSize: double.infinity,
        // splash: Image.asset(
        //   'logos/intro.gif',
        //   filterQuality: FilterQuality.high,
        // ),
        // Container(
        //   color: Color(0xff2B2B28),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       Image.asset(
        //         'logos/intro.gif',
        //         filterQuality: FilterQuality.high,
        //       ),
        //       Flexible(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             'CRICKOSTICS',
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontFamily: 'RestaurantMenu',
        //                 fontSize: 50),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        //   nextScreen: Homepage(),
        //   // backgroundColor: Colors.indigoAccent,
        // )
        );
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
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    List imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['content']['matches'];
    List takethisimglogosdata = new List.from(imglogosdata)
      ..addAll(imglogosdata1);

    for (var i in takethisimglogosdata) {
      if (!i['status'].toString().startsWith('Not covered') &&
          (i['state'].toString() == 'PRE')) {
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
    List<List<dynamic>> match_leagues_refresh1 = [];

    Future<void> _refresh() async {
      await Future.delayed(Duration(seconds: 1));
      getValidMatches().then((value) {
        setState(() {
          _refreshIndicator = GlobalKey<RefreshIndicatorState>();
          match_leagues_refresh1 = value;
          match_leagues_refresh = match_leagues_refresh1;
        });
      });
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
            key: _refreshIndicator,
            color: Color(0xffFFB72B),
            backgroundColor: Color(0xff2B2B28),
            onRefresh: _refresh,
            child: match_leagues_refresh.isEmpty
                ? Container(
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
                        )))
                : Container(
                    height: MediaQuery.of(context).size.height,
                    color: Color(0xff2B2B28),
                    child: AnimationLimiter(
                      child: AnimationConfiguration.staggeredList(
                        duration: const Duration(milliseconds: 900),
                        position: 1,
                        child: ScaleAnimation(
                          child: SlideAnimation(
                            child: match_leagues_refresh[0].isEmpty
                                ? Center(
                                    child: Container(
                                      color: Color(0xff2B2B28),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('  Oh My CrickOh! ',
                                              style: TextStyle(
                                                fontFamily: 'Louisgeorge',
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  icon: Image.asset(
                                                    'logos/ball.png',
                                                  ),
                                                  onPressed: null),
                                              Flexible(
                                                child: Text(
                                                    'No Scheduled matches as of now. Matches appear before 10-12hr of the match start time.',
                                                    style: TextStyle(
                                                      fontFamily: 'Louisgeorge',
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Choose your league',
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: matchstatetitle
                                                  .map(
                                                    (e) => Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                        bottom: _currentSlide ==
                                                                matchstatetitle
                                                                    .indexOf(e)
                                                            ? BorderSide(
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
                                                                'Louisgeorge',
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
                                                enlargeCenterPage: true,
                                                viewportFraction: 1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.80,

                                                // autoPlay: false,
                                              ),
                                              items: [
                                                ...match_leagues_refresh
                                                    .map(
                                                      (matchstate) =>
                                                          AnimationLimiter(
                                                        child: Column(
                                                            children: matchstate
                                                                .map((e) {
                                                          return AnimationConfiguration
                                                              .staggeredList(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        650),
                                                            position: matchstate
                                                                .indexOf(e),
                                                            child:
                                                                ScaleAnimation(
                                                              child:
                                                                  FadeInAnimation(
                                                                curve: Curves
                                                                    .easeInExpo,
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
                                                                  child:
                                                                      new InkWell(
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
                                                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                                        height: 100,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                            gradient: LinearGradient(
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight,
                                                                              colors: [
                                                                                Color(0xff1A3263),
                                                                                Color(0xff1A3263).withOpacity(0.8),
                                                                              ],
                                                                            )),
                                                                        child: Center(
                                                                          child:
                                                                              Text(
                                                                            e.toString(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Louisgeorge',
                                                                              fontSize: 20.0,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
                                                      ),
                                                    )
                                                    .toList(),
                                              ]),
                                        ]),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )));
  }
}

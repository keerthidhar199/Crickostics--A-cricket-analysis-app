import 'dart:async';
import 'dart:convert';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/webscrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
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
            Text(
              'CRICKOSTICS',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'RestaurantMenu',
                  fontSize: 70),
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

// Map<String, int> team_codes = {
//   'Chennai Super Kings': 4343,
//   'Delhi Capitals': 4344,
//   'Gujarat Titans': 6904,
//   'Kolkata Knight Riders': 4341,
//   'Lucknow Super Giants': 6903,
//   'Mumbai Indians': 4346,
//   'Punjab Kings': 4342,
//   'Rajasthan Royals': 4345,
//   'Royal Challengers Bangalore': 4340,
//   'Sunrisers Hyderabad': 5143,
// };

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicator =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicator.currentState.show());
  }

  Future<List> getmatchcategs() async {
    List leagues = [];
    List leagues1 = [];

    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    var imglogosdata =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    var imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['content']['matches'];

    for (var i in imglogosdata1) {
      leagues1.add(i['series']['longName']);
    }
    for (var i in imglogosdata) {
      leagues.add(i['series']['longName']);
    }

    // for (int k = 0;
    //     k < document.getElementsByClassName('ds-px-4 ds-py-3').length;
    //     k++) {
    //   Map<String, String> iplmatch = {};
    //   var matchdetails =
    //       await document.getElementsByClassName('ds-px-4 ds-py-3')[k];
    //   for (var y
    //       in matchdetails.getElementsByClassName('ds-text-compact-xxs')) {
    //     var match_det1 = y.getElementsByClassName(
    //         'ds-text-tight-xs ds-truncate ds-text-ui-typo-mid')[0];
    //     leagues.add(match_det1.text.split(',').last);
    //   }
    // }
    return (leagues1.toSet().union(leagues.toSet())).toList();
  }

  Future<Null> _refresh() {
    return getmatchcategs().then((value) {
      setState(() {
        match_leagues = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: Text(
            'Playing Leagues',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
        ),
        body: RefreshIndicator(
          color: Color(0xffFFB72B),
          backgroundColor: Color(0xff2B2B28),
          key: _refreshIndicator,
          onRefresh: _refresh,
          child: FutureBuilder<List<dynamic>>(
              future: getmatchcategs(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      color: Color(0xff2B2B28),
                      // child: SkeletonTheme(
                      //     shimmerGradient: LinearGradient(colors: [
                      //       Color(0xff1A3263).withOpacity(0.8),
                      //       Color(0xff1A3263),
                      //       Color(0xff1A3263),
                      //       Color(0xff1A3263).withOpacity(0.8),
                      //     ]),
                      //     child: ListView.builder(
                      //       itemCount: 10,
                      //       itemBuilder: (context, index) =>
                      //           PlayingLeaguesSkelton(),
                      //     ))
                    );
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
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      child: Text(
                                        'Choose your league to continue:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Louisgeorge',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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

import 'dart:async';
import 'dart:convert';
import 'package:datascrap/analysis.dart';
import 'package:datascrap/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class datascrap extends StatefulWidget {
  const datascrap({Key key}) : super(key: key);
  @override
  State<datascrap> createState() => _datascrapState();
}

class _datascrapState extends State<datascrap> {
  var themecolor = Colors.white;
  var darkcolor = Colors.black;

  Future<String> getlogos(String leaguename) async {
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    var imglogosdata =
        json.decode(document.getElementById('__NEXT_DATA__').innerHtml)['props']
            ['editionDetails']['trendingMatches']['matches'];
    String seriesname = '';
    for (var i in imglogosdata) {
      if (i['teams'][0]['team']['longName'].toString().trim() == leaguename) {
        seriesname = i['teams'][0]['team']['image']['url'].toString();
      } else if (i['teams'][1]['team']['longName'].toString().trim() ==
          leaguename) {
        seriesname = i['teams'][1]['team']['image']['url'].toString();
      }
    }
    print('imglogosdata12 $seriesname');
    return seriesname;
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicator =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicator.currentState.show());

    super.initState();
  }

  Future<List<Map<String, String>>> getlivematches(String league) async {
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    // print(document
    //     .querySelectorAll('table.engineTable>tbody')[1]
    //     .text
    //     .contains('Records'));
    List<Map<String, String>> matches = []; //

    for (int k = 0;
        k < document.getElementsByClassName('ds-px-4 ds-py-3').length;
        k++) {
      Map<String, String> iplmatch = {};

      var matchdetails =
          await document.getElementsByClassName('ds-px-4 ds-py-3')[k];
      print('matchdetais ${matchdetails.text}');
      // if (matchdetails.querySelectorAll('a').isNotEmpty) {
      if (matchdetails.text.contains(league)) {
        var link1 = matchdetails.querySelectorAll('a')[0];
        print('link1 ${link1.attributes["href"]}');
        var forlink2 = await http.Client().get(Uri.parse(
            'https://www.espncricinfo.com' +
                link1.attributes["href"].toString()));
        dom.Document link2doc = parser.parse(forlink2.body);
        if (link2doc
            .getElementsByClassName(
                'ds-text-tight-m ds-font-regular ds-text-ui-typo-mid')
            .toList()
            .isNotEmpty) {
          var link2 = link2doc
              .getElementsByClassName(
                  'ds-text-tight-m ds-font-regular ds-text-ui-typo-mid')[0]
              .querySelector('a'); //
          print('link2 ${link2.attributes["href"]}');

          var forlink3 = await http.Client().get(Uri.parse(
              'https://www.espncricinfo.com' +
                  link2.attributes["href"].toString()));
          dom.Document link3doc = parser.parse(forlink3.body);
          var link3 = link3doc
              .getElementsByClassName('ds-px-3 ds-py-2')
              .where((element) => element.text == 'Stats');

          // print('link3 ${link3.toList()[0].attributes["href"]}');
          if (link3.toList().isNotEmpty) {
            var teamstats = await http.Client().get(
                Uri.parse(link3.toList()[0].attributes["href"].toString()));
            dom.Document teamstatsdoc = parser.parse(teamstats.body);

            for (var y
                in matchdetails.getElementsByClassName('ds-text-compact-xxs')) {
              var match_det =
                  y.getElementsByClassName('ds-flex ds-justify-between')[0];
              if (!match_det.text.toLowerCase().contains('covered')) {
                var match_det1 = y.getElementsByClassName(
                    'ds-text-tight-xs ds-truncate ds-text-ui-typo-mid')[0];
                var teams1 = y
                    .getElementsByClassName(
                        'ci-team-score ds-flex ds-justify-between ds-items-center ds-text-typo-title ds-mt-1 ds-mb-1')[0]
                    .querySelector('p')
                    .text;
                var teams2 = y
                    .getElementsByClassName(
                        'ci-team-score ds-flex ds-justify-between ds-items-center ds-text-typo-title ds-mt-1 ds-mb-1')[1]
                    .querySelector('p')
                    .text; //teams 1 and 2
                var teamscore = y.getElementsByClassName(
                    'ds-text-compact-s ds-text-typo-title');
                var stauts = y.getElementsByClassName(
                    'ds-text-tight-s ds-font-regular ds-truncate ds-text-typo-title')[0];
                var response1 = await http.Client().get(Uri.parse(
                    'https://www.espncricinfo.com/live-cricket-score'));
                dom.Document document1 = parser.parse(response1.body);
                var imglogosdata1 = json.decode(
                        document1.getElementById('__NEXT_DATA__').text)['props']
                    ['appPageProps']['data']['content']['matches'];
                var imglogosdata = json.decode(
                        document1.getElementById('__NEXT_DATA__').text)['props']
                    ['editionDetails']['trendingMatches']['matches'];

                for (var i in imglogosdata) {
                  if ((i['teams'][0]['team']['longName']
                          .toString()
                          .trim()
                          .contains(teams1)) &&
                      (i['teams'][1]['team']['longName']
                          .toString()
                          .trim()
                          .contains(teams2))) {
                    iplmatch['team1logo'] =
                        i['teams'][0]['team']['image']['url'].toString();
                    iplmatch['team2logo'] =
                        i['teams'][1]['team']['image']['url'].toString();
                  } else {
                    for (var i in imglogosdata1) {
                      if ((i['teams'][0]['team']['longName']
                              .toString()
                              .trim()
                              .contains(teams1)) &&
                          (i['teams'][1]['team']['longName']
                              .toString()
                              .trim()
                              .contains(teams2))) {
                        iplmatch['team1logo'] =
                            i['teams'][0]['team']['image']['url'].toString();
                        iplmatch['team2logo'] =
                            i['teams'][1]['team']['image']['url'].toString();
                      }
                    }
                  }
                }
                print('hero team1: ${teams1}');
                print('hero match_det: ${match_det.text}');
                print('hero match_det1: ${match_det1.text}');
                print('hero team2: ${teams2}');
                // print('hero teamscore: ${teamscore[0].text}');
                // print('hero teamscore: ${teamscore[1].text}');
                print('hero stauts: ${stauts.text}');
                iplmatch['Time'] = match_det.text;
                iplmatch['Match_name'] = match_det1.text.split(',').last;
                iplmatch['Team1'] = teams1;
                iplmatch['Team2'] = teams2;
                iplmatch['MatchStarts'] = stauts.text;
                iplmatch['Details'] = match_det1.text;
                iplmatch['Ground'] = match_det1.text.split(',')[1].trim();
                if (teamscore.length == 2) {
                  iplmatch['team1_score'] = teamscore[0].text.trim();
                  iplmatch['team2_score'] = teamscore[1].text.trim();
                } else if (teamscore.length == 1) {
                  iplmatch['team1_score'] = teamscore[0].text.trim();
                  iplmatch['team2_score'] = '';
                } else {
                  iplmatch['team1_score'] = '';
                  iplmatch['team2_score'] = '';
                }

//                    hero team1: Kolkata Knight Riders
//                    hero match_det: Live
//                     hero match_det1: 61st Match (N), Pune, May 14, 2022, Indian Premier League
//                     hero team2: Sunrisers Hyderabad
//                     hero teamscore: 177/6
//                    hero teamscore: (17.6/20 ov, T:178) 113/7
//                     hero stauts: Sunrisers need 65 runs in 12 balls.

              }
            }
            var rec1 = teamstatsdoc
                .getElementsByClassName('RecBulAro')
                .where((element) => element.text == 'Records by team');
            var rec2 = teamstatsdoc
                .getElementsByClassName('RecBulAro')
                .where((element) => element.text == 'Records by team');
            if (rec1.length != 0) {
              rec1 = rec1
                  .toList()[0]
                  .parentNode
                  .children[2]
                  .getElementsByClassName('RecordLinks')
                  .where((element) => element.text == iplmatch["Team1"]);

              if (rec1.length != 0) {
                iplmatch['team1_stats_link'] =
                    rec1.first.attributes["href"].toString();
                print('rec1 ${rec1.first.attributes["href"]}');
                matches.add(iplmatch);
              }
            }
            if (rec2.length != 0) {
              rec2 = rec2
                  .toList()[0]
                  .parentNode
                  .children[2]
                  .getElementsByClassName('RecordLinks')
                  .where((element) => element.text == iplmatch["Team2"]);

              if (rec2.length != 0) {
                iplmatch['team2_stats_link'] =
                    rec2.first.attributes["href"].toString();
                print('rec2 ${rec2.first.attributes["href"]}');
                matches.add(iplmatch);
              }
            }
          }
        }
      }
    }
    print(matches);
    return matches.toSet().toList();
  }

  Future<List<Map<String, String>>> variable;

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      setState(() {
        variable = getlivematches(globals.league_page);
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffFFB72B),
        title: Text(
          'Current/Upcoming Matches',
          style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
        ),
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: RefreshIndicator(
        color: Color(0xffFFB72B),
        backgroundColor: Color(0xff2B2B28),
        key: _refreshIndicator,
        onRefresh: _refresh,
        child: FutureBuilder<List<Map<String, String>>>(
          future: variable, // async work
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, String>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    color: Color(0xff2B2B28),
                    child: SkeletonTheme(
                        shimmerGradient: LinearGradient(colors: [
                          Color(0xff1A3263).withOpacity(0.8),
                          Color(0xff1A3263),
                          Color(0xff1A3263),
                          Color(0xff1A3263).withOpacity(0.8),
                        ]),
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => NewsCardSkelton(),
                        )));
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.data == null) {
                  return Container(
                      color: Color(0xff2B2B28),
                      child: SkeletonTheme(
                          shimmerGradient: LinearGradient(colors: [
                            Color(0xff1A3263).withOpacity(0.8),
                            Color(0xff1A3263),
                            Color(0xff1A3263),
                            Color(0xff1A3263).withOpacity(0.8),
                          ]),
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) => NewsCardSkelton(),
                          )));
                } else {
                  if (snapshot.data.isEmpty) {
                    return Container(
                      color: Color(0xff2B2B28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('  Oh My CrickOh! ',
                              style: TextStyle(
                                fontFamily: 'Louisgeorge',
                                fontSize: 20.0,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Stats not available. It may be because of :',
                              style: TextStyle(
                                fontFamily: 'Louisgeorge',
                                fontSize: 20.0,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 10,
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
                                    'The league might started recently due to which enough data is not found',
                                    style: TextStyle(
                                      fontFamily: 'Louisgeorge',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                    'logos/ball.png',
                                  ),
                                  onPressed: null),
                              Text(
                                  'Live Stream for this league is not available ',
                                  style: TextStyle(
                                    fontFamily: 'Louisgeorge',
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    String root_logo =
                        'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
                    return AnimationLimiter(
                      child: Container(
                        color: Color(0xff2B2B28),
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int i) =>
                              AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 570),
                            position: i,
                            child: FadeInAnimation(
                              child: SlideAnimation(
                                verticalOffset: -900,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: Colors.white
                                                  .withOpacity(0.4))),
                                      color: themecolor,
                                      elevation: 10,
                                      shadowColor: Colors.white,
                                      child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            globals.team1_name = snapshot
                                                .data[i]['Team1']
                                                .trim();
                                            globals.team2_name = snapshot
                                                .data[i]['Team2']
                                                .trim();
                                            globals.team1_stats_link = snapshot
                                                .data[i]['team1_stats_link'];
                                            globals.team2_stats_link = snapshot
                                                .data[i]['team2_stats_link'];
                                            globals.ground = snapshot.data[i]
                                                    ['Ground']
                                                .toString()
                                                .trim();
                                            globals.team1logo =
                                                snapshot.data[i]['team1logo'];
                                            globals.team2logo =
                                                snapshot.data[i]['team2logo'];
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Analysis(),
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xff1A3263),
                                                  Color(0xff1A3263)
                                                      .withOpacity(0.8),
                                                ],
                                              )),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                    snapshot.data[i]['Details'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Louisgeorge',
                                                      fontSize: 15.0,
                                                      color: themecolor,
                                                    )),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                  color: snapshot.data[i]
                                                              ['Time']
                                                          .toLowerCase()
                                                          .contains('result')
                                                      ? Colors.green
                                                      : snapshot.data[i]['Time']
                                                              .toLowerCase()
                                                              .contains('live')
                                                          ? Colors.black38
                                                          : Colors.red,
                                                ),
                                                child: Text(
                                                    snapshot.data[i]['Time'][0]
                                                            .toUpperCase() +
                                                        snapshot.data[i]['Time']
                                                            .substring(1)
                                                            .toLowerCase(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Louisgeorge',
                                                        fontSize: 15.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Divider(
                                                color: darkcolor,
                                                thickness: 2,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          icon:
                                                              CachedNetworkImage(
                                                            imageUrl: root_logo +
                                                                snapshot.data[i]
                                                                    [
                                                                    'team1logo'],
                                                          ),
                                                          onPressed: null),
                                                      Text(
                                                          snapshot.data[i]
                                                              ['Team1'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          )),
                                                      Text(
                                                          ' - ' +
                                                              snapshot.data[i][
                                                                  'team1_score'],
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          icon:
                                                              CachedNetworkImage(
                                                            imageUrl: root_logo +
                                                                snapshot.data[i]
                                                                    [
                                                                    'team2logo'],
                                                          ),
                                                          onPressed: null),
                                                      Text(
                                                          snapshot.data[i]
                                                                  ['Team2']
                                                              .trim(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          )),
                                                      Text(
                                                          ' - ' +
                                                              snapshot.data[i][
                                                                  'team2_score'],
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: (snapshot.data[i]
                                                            ['MatchStarts']
                                                        .toString()
                                                        .contains('won'))
                                                    ? Text(snapshot.data[i]['MatchStarts'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 20.0,
                                                            color: Colors
                                                                .greenAccent,
                                                            fontWeight: FontWeight
                                                                .bold))
                                                    : Text(
                                                        snapshot.data[i]
                                                            ['MatchStarts'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 20.0,
                                                            color: Colors.amberAccent,
                                                            fontWeight: FontWeight.bold)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:datascrap/analysis.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/team_results.dart';
import 'package:datascrap/tosswin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';
import 'globals.dart' as globals;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:web_scraper/web_scraper.dart';
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

Map<String, int> team_codes = {
  'Chennai Super Kings': 4343,
  'Delhi Capitals': 4344,
  'Gujarat Titans': 6904,
  'Kolkata Knight Riders': 4341,
  'Lucknow Super Giants': 6903,
  'Mumbai Indians': 4346,
  'Punjab Kings': 4342,
  'Rajasthan Royals': 4345,
  'Royal Challengers Bangalore': 4340,
  'Sunrisers Hyderabad': 5143,
};

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String website;
  String route = 'https://www.espncricinfo.com';
  var linkdetails = [];
  var themecolor = Colors.white;
  var darkcolor = Colors.black;
  Future<String> getImages() async {
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    for (int k = 0;
        k < document.getElementsByClassName('ds-px-4 ds-py-3').length;
        k++) {
      Map<String, String> iplmatch = {};
      var matchdetails =
          await document.getElementsByClassName('ds-px-4 ds-py-3')[k];

      var pics = await matchdetails.querySelectorAll('img');
      for (var e in pics) {
        if (e.attributes["src"].contains('lazy')) {
          print('logoimagesif ${e}');
        } else {
          print('logoimages ${e.outerHtml}');
        }
      }
    }
  }

  Future<List<Map<String, String>>> getlivematches() async {
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

      if (matchdetails.text.contains('Indian Premier League')) {
        var link1 = matchdetails.querySelectorAll('a')[0];
        print('link1 ${link1.attributes["href"]}');
        var forlink2 = await http.Client().get(Uri.parse(
            'https://www.espncricinfo.com' +
                link1.attributes["href"].toString()));
        dom.Document link2doc = parser.parse(forlink2.body);
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

        print('link3 ${link3.toList()[0].attributes["href"]}');
        var teamstats = await http.Client()
            .get(Uri.parse(link3.toList()[0].attributes["href"].toString()));
        dom.Document teamstatsdoc = parser.parse(teamstats.body);
        globals.league_page = teamstatsdoc;

        print(k);
        var time_of_match, team1, team2, status_of_match, stadium, details;
        var time_today = matchdetails
            .querySelectorAll('div.ds-flex.ds-justify-between'); //in GMT
        print('Time today');
        for (int i = 0; i < time_today.length; i++) {
          print(time_today[i].text.toString() + i.toString());
          if (time_today[0].text.toString().contains('Live') |
              time_today[0].text.toString().contains('RESULT')) {
            time_of_match = time_today[0].text.toString(); //Live
            team1 = (time_today[1].text.toString()); //Chennai Super Kings216/4
            team2 = (time_today[2].text.toString());
            //Royal Challengers Bangalore(18.3/20 ov, T:217) 176/9
            iplmatch['Time'] = time_of_match;
            iplmatch['Team1'] = team1;
            iplmatch['Team2'] = team2;
          }
          // if (time_today[i].text.toString().contains('Strategic Timeout')) {
          //   print(time_today[i].text.toString());
          //   time_of_match = time_today[0].text.toString(); //Live
          //   team1 = (time_today[1].text.toString()); //Chennai Super Kings216/4
          //   team2 = (time_today[2].text.toString());
          //   //Royal Challengers Bangalore(18.3/20 ov, T:217) 176/9
          //   iplmatch['Time'] = time_of_match;
          //   iplmatch['Team1'] = team1;
          //   iplmatch['Team2'] = team2;}
          else {
            if (time_today[0].text.split(',')[1].contains('2')) {
              time_of_match =
                  time_today[0].text.split(',')[0].toString() + ' 7:30PM';
            } else if (time_today[0].text.toString().contains('Strategic')) {
              time_of_match =
                  time_today[0].text.split(',')[0].toString() + ' 7:30PM';
            } else {
              time_of_match =
                  time_today[0].text.split(',')[0].toString() + ' 3:30PM';
            }
            //Time: Tomorrow, 2:00 PM
            team1 = (time_today[1].text.toString().trim()); //Mumbai Indians,
            team2 = (time_today[2].text.toString().trim());
            //Punjab Kings
            iplmatch['Time'] = time_of_match;
            iplmatch['Team1'] = team1;
            iplmatch['Team2'] = team2;
          }
        }

        var matchtime = matchdetails.querySelectorAll('p');
        print('Match time');
        for (int i = 0; i < matchtime.length; i++) {
          status_of_match = (matchtime[2].text.toString());
          // RCB need 41 runs in 9 balls.
          iplmatch['MatchStarts'] = status_of_match;
        }

        print('Venue');
        var venue = matchdetails.querySelectorAll(
            'div > div > div.ds-text-tight-xs.ds-truncate.ds-text-ui-typo-mid');
        for (int i = 0; i < venue.length; i++) {
          print(venue[i].text.toString());
          stadium = venue[0].text.toString().split(',')[1].trim(); //Pune
          details = venue[0].text.toString().replaceAll('Indian Premier League',
              'IPL'); //23rd Match (N), Pune, April 13, 2022, IPL,
          iplmatch['Details'] = details;
          iplmatch['Ground'] = stadium;
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
    print(matches);
    return matches.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffFFB72B),
        title: Text(
          'Current/Upcoming Matches',
          style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: getlivematches(), // async work
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
              else
                return Container(
                  color: Color(0xff2B2B28),
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (BuildContext context) =>
                          //           TossAnalysis(),
                          //     ));
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          child: Image.asset(
                            'logos/IPL.png',
                            color: Color(0xffF8F1F1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var i in snapshot.data)
                        Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.4))),
                              color: themecolor,
                              elevation: 10,
                              shadowColor: Colors.white,
                              child: new InkWell(
                                onTap: () {
                                  var team1_code;
                                  var team2_code;
                                  var team1, team2;
                                  if (i['Team1'].contains('(')) {
                                    if (i['Team2'].contains(RegExp(r"[0-9]"))) {
                                      team1 = i['Team1']
                                          .split('(')[0]
                                          .toString()
                                          .trim();
                                      team2 = i['Team2']
                                          .split(new RegExp(r"[0-9]"))[0]
                                          .toString();
                                      team2_code = team_codes[team2];
                                      team1_code = team_codes[team1];
                                    } else {
                                      print('Highkey');

                                      print(i['Team1'].toString());
                                      team1 = i['Team1']
                                          .split('(')[0]
                                          .toString()
                                          .trim();
                                      team1_code = team_codes[team1];
                                      team2_code =
                                          team_codes[i['Team2'].trim()];
                                    }
                                  } else if (i['Team2'].contains('(')) {
                                    if (i['Team1'].contains(RegExp(r"[0-9]"))) {
                                      print('Monkey');
                                      team2 = i['Team2']
                                          .split('(')[0]
                                          .toString()
                                          .trim();
                                      team1 = i['Team1']
                                          .split(new RegExp(r"[0-9]"))[0]
                                          .toString();
                                      team2_code = team_codes[team2];
                                      team1_code = team_codes[team1];
                                    } else {
                                      print('Lowkey');
                                      team2 = i['Team2']
                                          .split('(')[0]
                                          .toString()
                                          .trim();

                                      team2_code = team_codes[team2];
                                      team1_code =
                                          team_codes[i['Team1'].trim()];
                                    }
                                  } else {
                                    team1 = i['Team1'].trim();
                                    team2 = i['Team2'].trim();
                                    team1_code = team_codes[team1];
                                    team2_code = team_codes[team2];
                                  }

                                  setState(() {
                                    globals.team1_name = team1;
                                    globals.team2_name = team2;
                                    globals.team_code1 = team1_code;
                                    globals.team_code2 = team2_code;
                                    globals.team1_stats_link =
                                        i['team1_stats_link'];
                                    globals.team2_stats_link =
                                        i['team2_stats_link'];

                                    globals.ground =
                                        i['Ground'].toString().trim();
                                    print('team_code ${globals.team1_name}');
                                    print('team_code ${globals.team2_name}');
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Analysis(),
                                      ));
                                },
                                child: Container(
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(i['Details'],
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: themecolor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(height: 5),
                                      Text(i['Time'],
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: themecolor,
                                              fontWeight: FontWeight.bold)),
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
                                              i['Team1']
                                                      .toString()
                                                      .contains('(')
                                                  ? IconButton(
                                                      icon: Image.asset(
                                                          'logos/' +
                                                              i['Team1']
                                                                  .split('(')[0]
                                                                  .toString() +
                                                              '.png'),
                                                      onPressed: null)
                                                  : IconButton(
                                                      icon: Image.asset('logos/' +
                                                          i['Team1']
                                                              .split(new RegExp(
                                                                  r"[0-9]"))[0]
                                                              .toString() +
                                                          '.png'),
                                                      onPressed: null),
                                              i['Team1']
                                                      .toString()
                                                      .contains('(')
                                                  ? Text(i['Team1'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Louisgeorge',
                                                        fontSize: 15.0,
                                                        color: themecolor,
                                                      ))
                                                  : Text(
                                                      i['Team1'].split(
                                                                  new RegExp(
                                                                      r"[0-9]"))[
                                                              0] +
                                                          ' - ' +
                                                          i['Team1'].replaceAll(
                                                              i['Team1'].split(
                                                                  new RegExp(
                                                                      r"[0-9]"))[0],
                                                              ''),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Louisgeorge',
                                                        fontSize: 15.0,
                                                        color: themecolor,
                                                      ))
                                            ],
                                          ),
                                          i['Team2'].toString().contains('(')
                                              ? Row(
                                                  children: [
                                                    IconButton(
                                                        icon: Image.asset(
                                                            'logos/' +
                                                                i['Team2']
                                                                    .split(
                                                                        '(')[0]
                                                                    .toString() +
                                                                '.png'),
                                                        onPressed: null),
                                                    Flexible(
                                                      child: Text(
                                                          i['Team2'].split(
                                                                  '(')[0] +
                                                              '  (' +
                                                              i['Team2'].split(
                                                                  '(')[1],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          )),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    IconButton(
                                                        icon: Image.asset('logos/' +
                                                            i['Team2']
                                                                .split(new RegExp(
                                                                    r"[0-9]"))[0]
                                                                .toString() +
                                                            '.png'),
                                                        onPressed: null),
                                                    Flexible(
                                                      child: Text(
                                                          i['Team2'].trim(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            fontSize: 15.0,
                                                            color: themecolor,
                                                          )),
                                                    )
                                                  ],
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: (i['MatchStarts']
                                                .toString()
                                                .contains('won'))
                                            ? Text(i['MatchStarts'],
                                                style: TextStyle(
                                                    fontFamily: 'Louisgeorge',
                                                    fontSize: 20.0,
                                                    color: Colors.greenAccent,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Text(i['MatchStarts'],
                                                style: TextStyle(
                                                    fontFamily: 'Louisgeorge',
                                                    fontSize: 20.0,
                                                    color: themecolor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                    ],
                  ),
                );
          }
        },
      ),
    );
  }
}

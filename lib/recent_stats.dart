import 'dart:async';
import 'dart:convert';
import 'package:datascrap/analysis.dart';
import 'package:datascrap/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class recentmatchdata extends StatefulWidget {
  const recentmatchdata({Key key}) : super(key: key);
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
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    List imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['content']['matches'];
    List takethisimglogosdata = new List.from(imglogosdata)
      ..addAll(imglogosdata1);
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

  Future<List<Map<String, List<String>>>> getrecentstats() async {
    List<Map<String, List<String>>> bothteams = [];
    Map<String, List<String>> team1 = {};
    Map<String, List<String>> team2 = {};
    dom.Document link2doc;
    var link2address = globals.ontap;
    if (link2address.toString().split('/').last != 'live-cricket-score') {
      var forlink2 = await http.Client().get(Uri.parse(link2address));
      dom.Document link2doc1 = parser.parse(forlink2.body);
      var link_correction = link2doc1
          .getElementsByClassName('ds-h-10')[0]
          .attributes['href']
          .toString();
      var forlink21 = await http.Client()
          .get(Uri.parse('https://www.espncricinfo.com' + link_correction));
      link2doc = parser.parse(forlink21.body);
    } else {
      var forlink2 = await http.Client().get(Uri.parse(link2address));
      link2doc = parser.parse(forlink2.body);
    }

    // print('link11 ${link_correction}');

    if (link2doc
        .getElementsByClassName(
            'ds-text-tight-m ds-font-regular ds-text-ui-typo-mid')
        .toList()
        .isNotEmpty) {
      var recent_perform =
          link2doc.getElementsByClassName('ds-p-0')[1].querySelector('table');

      // recent_perform.querySelectorAll('tbody')[1].clone(true);

      var team1_recent = recent_perform.querySelectorAll('tbody>tr')[0];
      var team1_recentname = team1_recent
          .querySelector(
              'tr>td>div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-col.ds-grow.ds-justify-center > span > span')
          .text;

      print('asa11 ${team1_recentname}');
      var team1_recentform = team1_recent.querySelectorAll(
          'td>div > div.ReactCollapse--collapse > div > div > a');
      var team1_winsloss = team1_recent
          .querySelector(
              'tr>td>div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-row.ds-items-center > span > div')
          .text;

      var team2_recent = recent_perform.querySelectorAll('tbody>tr')[1];
      var team2_recentname = team2_recent
          .querySelector(
              'td>div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-col.ds-grow.ds-justify-center > span > span')
          .text;
      print('asa12 ${team2_recentname}');

      var team2_recentform = team2_recent.querySelectorAll(
          'tr>td>div > div.ReactCollapse--collapse > div > div > a');
      var team2_winsloss = team2_recent
          .querySelector(
              'tr>td>div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-row.ds-items-center > span > div')
          .text;
      if (team1_recentname != null && team2_recentname != null) {
        List<String> matches_played_details1 = [];
        List<String> matches_played_links1 = [];
        List<String> match_winner1 = [];
        List<String> matches_played_details2 = [];
        List<String> matches_played_links2 = [];
        List<String> match_winner2 = [];

        team1['Name'] = [team1_recentname];
        team1['winsloss'] = [team1_winsloss];
        team2['Name'] = [team2_recentname];
        team2['winsloss'] = [team2_winsloss];

        for (int i = 0; i < team1_recentform.length; i++) {
          var justanothevar = team1_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-font-medium");
          var justanothevar1 = team1_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-text-ui-typo-mid.ds-text-left");
          matches_played_details1.add(justanothevar.text);
          match_winner1.add(justanothevar1.text);

          matches_played_links1.add(team1_recentform[i].attributes['href']);
        }
        team1['matches_details'] = matches_played_details1;
        team1['scoreboard_for_matches_links'] = matches_played_links1;
        team1['match_winner'] = match_winner1;

        for (int i = 0; i < team2_recentform.length; i++) {
          var justanothevar = team2_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-font-medium");
          var justanothevar1 = team2_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-text-ui-typo-mid.ds-text-left");
          matches_played_details2.add(justanothevar.text);
          match_winner2.add(justanothevar1.text);
          matches_played_links2.add(team2_recentform[i].attributes['href']);
        }
        team2['matches_details'] = matches_played_details2;
        team2['scoreboard_for_matches_links'] = matches_played_links2;
        team2['match_winner'] = match_winner2;
      }
    }

    print('asa11tap ${globals.ontap}');
    bothteams.add(team1);
    bothteams.add(team2);
    print('asa11 ${team1}'); //teamname
    print('asa11 ${team2}'); //LWLLL
    return bothteams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2B2B28),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffFFB72B),
        title: Text(
          'Recent stats',
          style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
        ),
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder<List<Map<String, List<String>>>>(
        future: getrecentstats(), // async work
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, List<String>>>> snapshot) {
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
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
                        Text('Stats not available.',
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
                                  'The league might have started recently due to which enough data is not found.',
                                  style: TextStyle(
                                    fontFamily: 'Louisgeorge',
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
                  String root_logo =
                      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
                  List<String> teamnames = [
                    globals.team1_name,
                    globals.team2_name
                  ];
                  List<String> teamlogos = [
                    globals.team1logo,
                    globals.team2logo
                  ];
                  IconData gun = Icons.arrow_drop_down_circle;

                  // return Text(snapshot.data[1].toString());
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                          children: snapshot.data.map((e) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff19388A),
                                  Color(0xff4F91CD),
                                ],
                              )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                      height: 40.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          '${e['Name'][0].trim()}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                      children: e['winsloss'][0]
                                          .toString()
                                          .characters
                                          .map((character) {
                                    return Container(
                                      child: Text(
                                        '${character}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(10.0)),
                                        color: character == 'W'
                                            ? Colors.green
                                            : character == 'L'
                                                ? Colors.red
                                                : Colors.grey,
                                      ),
                                      padding: new EdgeInsets.all(5),
                                    );
                                  }).toList()),
                                ],
                              ),
                            ),
                            ExpansionTile(
                              trailing: Icon(
                                gun,
                                color: Colors.yellowAccent,
                                size: 25,
                              ),
                              title: Text(
                                'Click for more details',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.yellowAccent,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                for (var i = 0;
                                    i < e['matches_details'].length;
                                    i++)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Text(
                                                  e['matches_details'][i]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 4,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Text(
                                                  e['match_winner'][i]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  maxLines: 4,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Text(
                                              '${e['winsloss'][0].toString()[i]}',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            decoration: new BoxDecoration(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(10.0)),
                                              color: e['winsloss'][0]
                                                          .toString()[i] ==
                                                      'W'
                                                  ? Colors.green
                                                  : e['winsloss'][0]
                                                              .toString()[i] ==
                                                          'L'
                                                      ? Colors.red
                                                      : Colors.grey,
                                            ),
                                            padding: new EdgeInsets.all(8),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
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

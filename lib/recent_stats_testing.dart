import 'dart:async';
import 'dart:convert';
import 'package:datascrap/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';

class recentmatchtestdata extends StatefulWidget {
  const recentmatchtestdata({Key key}) : super(key: key);
  @override
  State<recentmatchtestdata> createState() => _recentmatchtestdataState();
}

class _recentmatchtestdataState extends State<recentmatchtestdata> {
  var themecolor = Colors.white;
  var darkcolor = Colors.black;

  Future<List<Map<String, List<String>>>> getrecentstats() async {
    List<Map<String, List<String>>> bothteams = [];
    Map<String, List<String>> team1 = {};
    Map<String, List<String>> team2 = {};
    dom.Document link2doc;
    var link2address =
        'https://www.espncricinfo.com/series/world-cup-league-2-2019-2023-1196667/united-arab-emirates-vs-papua-new-guinea-130th-match-1358082/live-cricket-score';
    var forlink2 = await http.Client().get(Uri.parse(link2address));
    link2doc = parser.parse(forlink2.body);

    // print('link11 ${link_correction}');

    if (link2doc
        .getElementsByClassName(
            'ds-text-tight-m ds-font-regular ds-text-typo-mid3')
        .toList()
        .isNotEmpty) {
      var recent_perform =
          link2doc.getElementsByClassName('ds-p-0')[1].querySelector('table');

      // recent_perform.querySelectorAll('tbody')[1].clone(true);

      var team1_recent = recent_perform.querySelectorAll('tbody>tr')[0];
      var team1_recentname = team1_recent
          .querySelector(
              'tr>td > div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-col.ds-grow.ds-justify-center > span > span')
          .text;
      print('team1_recentname $team1_recentname');

      print('asa11 ${team1_recentname}');
      var team1_recentform = team1_recent.querySelectorAll(
          'td>div > div.ReactCollapse--collapse > div > div > a');
      var winsloss1 = team1_recent
          .querySelector(
              'tr>td > div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-row.ds-items-center > span > div')
          .children;

      List team1_winsloss = [];
      String d = '';
      for (var i = 0; i < winsloss1.length; i++) {
        team1_winsloss.add(winsloss1[i].text.trim());
      }
      var team2_recent = recent_perform.querySelectorAll('tbody>tr')[1];
      var team2_recentname = team2_recent
          .querySelector(
              'tr>td > div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-col.ds-grow.ds-justify-center > span > span')
          .text;
      print('asa12 ${team2_recentname}');

      var team2_recentform = team2_recent.querySelectorAll(
          'tr>td>div > div.ReactCollapse--collapse > div > div > a');
      var winsloss2 = team2_recent
          .querySelector(
              'tr>td > div > div.ds-flex.ds-items-center.ds-cursor-pointer > div.ds-grow > div > div.ds-flex.ds-flex-row.ds-items-center > span > div')
          .children;

      print('winlloss $winsloss1 $winsloss2');
      List team2_winsloss = [];
      for (var i = 0; i < winsloss2.length; i++) {
        team2_winsloss.add(winsloss2[i].text.trim());
      }
      if (team1_recentname != null && team2_recentname != null) {
        List<String> matches_played_details1 = [];
        List<String> matches_played_links1 = [];
        List<String> match_winner1 = [];
        List<String> matches_played_details2 = [];
        List<String> matches_played_links2 = [];
        List<String> match_winner2 = [];

        team1['Name'] = [team1_recentname];
        team1['winsloss'] = [
          team1_winsloss
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll(' ', '')
        ];
        team2['Name'] = [team2_recentname];
        team2['winsloss'] = [
          team2_winsloss
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll(' ', '')
        ];

        for (int i = 0; i < team1_recentform.length; i++) {
          var justanothevar = team1_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-font-medium");
          var justanothevar1 = team1_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-text-typo-mid3.ds-text-left");

          matches_played_details1.add(justanothevar.text.split(',').last +
              ', ' +
              justanothevar.text
                  .replaceAll((justanothevar.text.split(',').last), ''));

          match_winner1.add(justanothevar1.text);

          matches_played_links1.add(team1_recentform[i].attributes['href']);
        }
        team1['matches_details'] = matches_played_details1;
        team1['scoreboard_for_matches_links'] = matches_played_links1;
        team1['match_winner'] = match_winner1;

        for (int i = 0; i < team2_recentform.length; i++) {
          var justanothevar = team2_recentform[i].querySelector(
              "div > div.ds-flex.ds-flex-col > span.ds-text-compact-xs.ds-font-medium");
          var justanothevar1 = team2_recentform[i]
              .getElementsByClassName(
                  'ds-text-compact-xs ds-text-typo-mid3 ds-text-left')[0]
              .text;
          print('justanothevar1 $justanothevar1');
          matches_played_details2.add(justanothevar.text.split(',').last +
              ', ' +
              justanothevar.text
                  .replaceAll((justanothevar.text.split(',').last), ''));

          match_winner2.add(justanothevar1);
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
                              fontFamily: 'Litsans',
                              fontSize: 20.0,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Stats not available.',
                            style: TextStyle(
                              fontFamily: 'Litsans',
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
                                    fontFamily: 'Litsans',
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      teamlogos[snapshot.data.indexOf(e)] !=
                                              null
                                          ? Image.network(
                                              root_logo +
                                                  teamlogos[snapshot.data
                                                          .indexOf(e)]
                                                      .toString(),
                                              width: 32,
                                              height: 32,
                                            )
                                          : IconButton(
                                              icon: Image.asset('logos/team' +
                                                  (snapshot.data.indexOf(e) + 1)
                                                      .toString() +
                                                  '.png'),
                                              onPressed: null),
                                      GestureDetector(
                                        onTap: () {},
                                        child: SizedBox(
                                          height: 40.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              '${e['Name'][0].trim()}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Cocosharp',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: e['winsloss'][0]
                                          .toString()
                                          .split(',')
                                          .map((character) => Row(
                                                children: [
                                                  Text('-'),
                                                  Container(
                                                    child: Text(
                                                      '${character}',
                                                      style: TextStyle(
                                                        fontFamily: 'Cocosharp',
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    decoration:
                                                        new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: character == 'W'
                                                          ? Colors.green
                                                          : character == 'L'
                                                              ? Colors.red
                                                              : Colors.grey,
                                                    ),
                                                    padding:
                                                        new EdgeInsets.all(10),
                                                  ),
                                                  Text('-'),
                                                  // SizedBox(
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           18,
                                                  // )
                                                ],
                                              ))
                                          .toList()),
                                ],
                              ),
                            ),
                            ExpansionTile(
                              // trailing: Icon(
                              //   Icons.arrow_drop_down_circle,
                              //   color: Colors.yellow.shade300,
                              //   size: 25,
                              // ),
                              title: Text("More details",
                                  style: TextStyle(
                                    fontFamily: 'Cocosharp',
                                    color: Colors.yellow.shade300,
                                  )),
                              children: [
                                for (var i = 0;
                                    i < e['matches_details'].length;
                                    i++)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //Faceoff
                                              Container(
                                                decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                10.0)),
                                                    color: Colors.white60),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TextButton(
                                                  child: Text(
                                                    e['matches_details'][i]
                                                        .toString()
                                                        .split(',')
                                                        .first,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'Cocosharp',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                    maxLines: 4,
                                                  ),
                                                  onPressed: () {
                                                    print(
                                                        e['scoreboard_for_matches_links']
                                                                [i]
                                                            .toString());
                                                  },
                                                ),
                                              ),
                                              //Date of the match happened
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${e['matches_details'][i].replaceAll(e['matches_details'][i].split(',').first, '').substring(1).trim()}",
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              //Winner of the match
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                          e['winsloss'][0]
                                              .split(',')
                                              .map((character) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(
                                                  '${character}',
                                                  style: TextStyle(
                                                    fontFamily: 'Cocosharp',
                                                    fontSize: 20.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: character == 'W'
                                                      ? Colors.green
                                                      : character == 'L'
                                                          ? Colors.red
                                                          : Colors.grey,
                                                ),
                                                padding: new EdgeInsets.all(10),
                                              ),
                                            );
                                          }).toList()[i]
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

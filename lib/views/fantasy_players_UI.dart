import 'dart:math';

import 'package:datascrap/services/importcsv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:datascrap/globals.dart' as globals;

class fantasyteam extends StatefulWidget {
  const fantasyteam({Key key}) : super(key: key);

  @override
  State<fantasyteam> createState() => _fantasyteamState();
}

class _fantasyteamState extends State<fantasyteam> {
  Map<String, List<dynamic>> fantasydata = {};
  Set distinct_leagues = {};
  Set distinct_teams = {};

  List randomColors = [
    Color(0xff5983F3),
    Color(0xff9259F3),
    Color(0xffF37C59),
    Color(0xffF35983),
    Color(0xffF37C59),
    Color(0xffF35996),
    Color(0xff35AF62),
    Color(0xff7DC696),
    Color(0xff80B665),
    Color(0xffF3596F),
    Color(0xff78A6BC),
    Color(0xff7A6DD0),
  ];
  final _random = new Random();

  _fantasyteamState() {
    importcsv.getcsvdata().then((value) {
      setState(() {
        if (value != null) {
          fantasydata = value;

          print('Kingu ${fantasydata[0]}');
        } else {
          fantasydata = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var fantasyiterator = fantasydata.keys.iterator;
    while (fantasyiterator.moveNext()) {
      setState(() {
        distinct_leagues
            .add(fantasyiterator.current.toString().split('_').first);
      });
    }
    print('object $distinct_leagues');
    randomColors = randomColors..shuffle();
    var Color1;

    return Scaffold(
        backgroundColor: Color(0xff2B2B28),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: Text(
            'Your Fantasy',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: fantasydata == null
            ? Container(
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
                    Text('No Fantasy players added !',
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
                              'Select your players and click on +Add to fantasy to add players in the Fantasy Lot.',
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
              )
            : fantasydata != null
                ? GroupedListView<dynamic, String>(
                    elements: fantasydata.keys.toList(),
                    groupBy: (element) => element.toString().split('_').first,
                    groupHeaderBuilder: (e) {
                      Color1 = randomColors[distinct_leagues
                          .toList()
                          .indexOf(e.toString().split('_').first)];
                      return Container(
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20.0),
                        //     gradient: LinearGradient(
                        //       begin: Alignment.bottomLeft,
                        //       end: Alignment.topRight,
                        //       colors: [
                        //         Color1,
                        //         Color1.withOpacity(0.85),

                        //       ],
                        //     )),
                        child: Text(
                          e.toString().split('_').first,
                          style: globals.noble,
                          textScaleFactor: 1.255,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    indexedItemBuilder: (context, e, index) {
                      Color1 = randomColors[distinct_leagues
                          .toList()
                          .indexOf(e.toString().split('_').first)];
                      List teamsplit = e.toString().split('_')[1].split('vs');
                      String vs = teamsplit[0] + ' vs ' + teamsplit[1];
                      return Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color1,
                                    Color1.withOpacity(0.85),
                                  ],
                                )),
                            child: ExpansionTile(
                                trailing: Icon(
                                  Icons.arrow_drop_down,
                                  size: 25,
                                ),
                                title: Text(
                                  vs,
                                  style: globals.noble,
                                ),
                                children: fantasydata[e].map((eachteam) {
                                  return Column(
                                    children: [
                                      Text(
                                        teamsplit[fantasydata[e]
                                            .toList()
                                            .indexOf(eachteam)],
                                        style: globals.noble,
                                      ), //Team1 and team2  title
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: [
                                                    Color1.withOpacity(0.55),
                                                    Color1.withOpacity(0.8),
                                                  ],
                                                )),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Your Selection',
                                                  style: globals.noble,
                                                ),
                                                for (var as in eachteam.keys)
                                                  Column(
                                                    children: [
                                                      Text(
                                                        as.toString(),
                                                        style: globals
                                                            .noble, //Category of the player
                                                      ),
                                                      for (var player
                                                          in eachteam[as])
                                                        Column(
                                                          children: [
                                                            Text(player
                                                                .toString()), //Each player and their stats
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ), //Selected players and their data both team1 and team2
                                    ],
                                  );
                                }).toList())),
                        SizedBox(
                          height: 10,
                        )
                      ]);
                      // return Text(element.toString());
                    })
                : CircularProgressIndicator());
  }
}

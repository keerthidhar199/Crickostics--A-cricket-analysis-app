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
    if (fantasydata == null) {
      return Scaffold(
          backgroundColor: Color(0xff2B2B28),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Fantasy',
                style: TextStyle(
                  fontFamily: 'Cocosharp',
                  fontSize: 20.0,
                  color: Colors.black,
                )),
            backgroundColor: Color(0xffFFB72B),
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Container(
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
          ));
    }
    var fantasyiterator = fantasydata.keys.iterator;
    while (fantasyiterator.moveNext()) {
      setState(() {
        distinct_leagues
            .add(fantasyiterator.current.toString().split('_').first);
      });
    }
    String root_logo =
        'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

    print('object $distinct_leagues');
    randomColors = randomColors..shuffle();
    var Color1;

    return Scaffold(
        backgroundColor: Color(0xff2B2B28),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Fantasy',
              style: TextStyle(
                fontFamily: 'Cocosharp',
                fontSize: 20.0,
                color: Colors.black,
              )),
          backgroundColor: Color(0xffFFB72B),
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(alignment: AlignmentDirectional.center, children: [
                  Divider(
                    color: Colors.white,
                    thickness: 5,
                  ),
                  Image.asset(
                    'logos/my_fantasy.png',
                    filterQuality: FilterQuality.high,
                    width: 75,
                    height: 75,
                    fit: BoxFit.scaleDown,
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Expanded(
              child: GroupedListView<dynamic, String>(
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
                        style: TextStyle(
                            fontFamily: 'NewAthletic', color: Colors.white),
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
                              // trailing: Icon(
                              //   Icons.arrow_drop_down,
                              //   size: 25,
                              // ),
                              title: Text(
                                vs,
                                style: globals.noble,
                              ),
                              children: fantasydata[e].map((eachteam) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          teamsplit[fantasydata[e]
                                              .toList()
                                              .indexOf(eachteam)],
                                          style: globals.noble,
                                        ),
                                        eachteam['Logo'][0] != null
                                            ? Image.network(
                                                root_logo +
                                                    eachteam['Logo'][0]
                                                        .toString(),
                                                width: 32,
                                                height: 32,
                                                colorBlendMode: BlendMode.dst,
                                              )
                                            : IconButton(
                                                icon: Image.asset('logos/team' +
                                                    (fantasydata[e]
                                                                .toList()
                                                                .indexOf(
                                                                    eachteam) +
                                                            1)
                                                        .toString() +
                                                    '.png'),
                                                onPressed: null)
                                      ],
                                    ), //Team1 and team2  title
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Your Selection',
                                                style: globals.noble,
                                              ),
                                              for (var as in eachteam.keys)
                                                (as.toString() == 'Batting' ||
                                                        as.toString() ==
                                                            'Bowling')
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Color1,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  Image.asset(
                                                                'logos/' +
                                                                    '${as.toString().toLowerCase()}' +
                                                                    '.png',
                                                                color: Colors
                                                                    .white,
                                                                width: 50,
                                                                height: 50,
                                                              ) //Category of the player
                                                              ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3,
                                                                child: Text(
                                                                  'Player',
                                                                  style: globals
                                                                      .Louisgeorge,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3,
                                                                child: Text(
                                                                  as.toString() ==
                                                                          'Batting'
                                                                      ? 'Runs'
                                                                      : 'Wickets',
                                                                  style: globals
                                                                      .Louisgeorge,
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  as.toString() ==
                                                                          'Batting'
                                                                      ? 'Strike Rate'
                                                                      : 'Economy',
                                                                  style: globals
                                                                      .Louisgeorge,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          for (var player
                                                              in eachteam[as])
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          Text(
                                                                        player
                                                                            .toString()
                                                                            .split(
                                                                                ' ')
                                                                            .where((element) =>
                                                                                element.startsWith(RegExp(r'[A-Z]')))
                                                                            .join(' '),
                                                                        style: globals
                                                                            .LouisgeorgeBOLD,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          Text(
                                                                        player
                                                                            .toString()
                                                                            .split(
                                                                                ' ')
                                                                            .where((element) =>
                                                                                element.startsWith(RegExp(r'[0-9]')))
                                                                            .first
                                                                            .trim(),
                                                                        style: globals
                                                                            .Louisgeorge,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        player
                                                                            .toString()
                                                                            .split(
                                                                                ' ')
                                                                            .where((element) =>
                                                                                element.startsWith(RegExp(r'[0-9]')))
                                                                            .last,
                                                                        style: globals
                                                                            .Louisgeorge,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ), //Each player and their stats
                                                              ],
                                                            )
                                                        ],
                                                      )
                                                    : as.toString() ==
                                                            'Partnerships'
                                                        ? Column(
                                                            children: [
                                                              Container(
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                    'logos/' +
                                                                        '${as.toString().toLowerCase()}' +
                                                                        '.png',
                                                                    color:
                                                                        Color1,
                                                                    width: 50,
                                                                    height: 50,
                                                                  ) //Category of the player
                                                                  ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.5,
                                                                    child: Text(
                                                                      'Players',
                                                                      style: globals
                                                                          .Louisgeorge,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      'Runs',
                                                                      style: globals
                                                                          .Louisgeorge,
                                                                    ),
                                                                  ),
                                                                  //Each player and their stats
                                                                ],
                                                              ),
                                                              for (int i = 0;
                                                                  i <
                                                                      eachteam[
                                                                              as]
                                                                          .length;
                                                                  i += 2)
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 1.5,
                                                                          child:
                                                                              Text(
                                                                            eachteam[as][i].toString() +
                                                                                ', ' +
                                                                                eachteam[as][i + 1].toString().split('&')[0],
                                                                            //  + player.toString().split('&')[1][0],

                                                                            style:
                                                                                globals.LouisgeorgeBOLD,
                                                                          ),
                                                                        ),
                                                                        // Text(eachteam[as].toString()),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            eachteam[as][i + 1].toString().split('&')[1],
                                                                            style:
                                                                                globals.Louisgeorge,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          )
                                                        : Container()
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
                  }),
            ),
          ],
        ));
  }
}

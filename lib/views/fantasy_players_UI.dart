import 'dart:math';

import 'package:datascrap/services/importcsv.dart';
import 'package:datascrap/views/fantasy_for_prev_clash.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:datascrap/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class fantasyteam extends StatefulWidget {
  const fantasyteam({Key? key}) : super(key: key);

  @override
  State<fantasyteam> createState() => _fantasyteamState();
}

class _fantasyteamState extends State<fantasyteam> {
  Map<String, List<dynamic>> fantasydata = {};
  Map<String, List<dynamic>> previous_clashes = {};

  Set distinct_leagues = {};
  Set distinct_teams = {};

  List randomColors = [
    const Color(0xff5983F3),
    const Color(0xff9259F3),
    const Color(0xffF37C59),
    const Color(0xffF35983),
    const Color(0xffF37C59),
    const Color(0xffF35996),
    const Color(0xff35AF62),
    const Color(0xff7DC696),
    const Color(0xff80B665),
    const Color(0xffF3596F),
    const Color(0xff78A6BC),
    const Color(0xff7A6DD0),
  ];
  final _random = Random();
  Future<void> removeFantasyData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('FantasyData');
  }

  RecheckAlert(BuildContext context) {
    // set up the buttons
    BuildContext? dialogContext;
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: globals.cocosharpblack),
      onPressed: () {
        Navigator.pop(dialogContext!);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Proceed", style: globals.cocosharpblack),
      onPressed: () {
        removeFantasyData().then((value) {
          setState(() {
            fantasydata = {};
          });
        });
        Navigator.pop(dialogContext!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              content: Row(children: [
                Image.asset(
                  'logos/my_fantasy.png',
                  width: 50,
                  height: 50,
                ),
                Text("Cleared your Fantasy lot", style: globals.cocosharpblack),
              ]),
              backgroundColor: Colors.amberAccent,
              padding: const EdgeInsets.all(8),
              margin: EdgeInsetsDirectional.only(
                bottom: MediaQuery.of(context).size.height / 2,
              )),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amber,
      title: Text(
        "Confirm",
        style: globals.cocosharpblack,
      ),
      content: Text(
        "Are you sure you want to clear your fantasy lot ?",
        style: globals.cocosharpblack,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alert;
      },
    );
  }

  _fantasyteamState() {
    ImportCsv.getcsvdata().then((value) {
      setState(() {
        if (value != null) {
          fantasydata = value[0];
          previous_clashes = value[1];
          print('chalega1 $fantasydata');
        } else {
          // Handle the case when data is not available
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (fantasydata.isEmpty) {
      return Scaffold(
          backgroundColor: const Color(0xff2B2B28),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Fantasy',
                style: TextStyle(
                  fontFamily: 'Montserrat-Black',
                  fontSize: 20.0,
                  color: Colors.black,
                )),
            backgroundColor: const Color(0xffFFB72B),
            leading: IconButton(
                color: Colors.black,
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Container(
            color: const Color(0xff2B2B28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('  Oh My CrickOh! ',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Black',
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text('No Fantasy players added !',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Black',
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 10,
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
                          'Select your players and click on +Add to fantasy to add players in the Fantasy Lot.',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15.0,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ));
    } else {
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
          backgroundColor: const Color(0xff2B2B28),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Fantasy',
                style: TextStyle(
                  fontFamily: 'Montserrat-Black',
                  fontSize: 20.0,
                  color: Colors.black,
                )),
            backgroundColor: const Color(0xffFFB72B),
            leading: IconButton(
                color: Colors.black,
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(alignment: AlignmentDirectional.center, children: [
                    const Divider(
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
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: [
                      Text(
                        'Clear Teams',
                        style: globals.cocosharp,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.white,
                        onPressed: () {
                          RecheckAlert(context);
                        },
                      ),
                    ],
                  ),
                )
              ]),
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
                          style: const TextStyle(
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FantasyAnalysis(
                                        fantasydata: fantasydata,
                                        previous_clashes: previous_clashes,
                                        Color1: Color1,
                                        e: e,
                                      ),
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                child: Text(
                                  vs,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat-Black',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            )),
                        const SizedBox(
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
}

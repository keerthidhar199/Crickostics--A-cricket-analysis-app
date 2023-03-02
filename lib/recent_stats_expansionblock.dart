import 'dart:async';
import 'dart:convert';
import 'package:datascrap/recentplayersform.dart';
import 'package:datascrap/skeleton.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';
import 'package:flip_card/flip_card.dart';

class expansionTile extends StatefulWidget {
  final e;
  final snapshot;
  const expansionTile({Key key, this.e, this.snapshot}) : super(key: key);

  @override
  State<expansionTile> createState() =>
      _expansionTileState(this.e, this.snapshot);
}

class _expansionTileState extends State<expansionTile> {
  _expansionTileState(e, snapshot);

  List<String> teamnames = [globals.team1_name, globals.team2_name];
  String filterplayer = '';
  _onClick(String string) {
    setState(() {
      if (!string.contains('*')) {
        filterplayer = string.toString().split(RegExp(r'[0-9]')).first.trim();
      } else {
        filterplayer = string.toString().split('*').first.trim();
      }
    });
    // print('$filterplayer');
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> e = widget.e;
    List<Map<String, List<dynamic>>> snapshot = widget.snapshot;
    return ExpansionTile(
      initiallyExpanded: true,
      trailing: Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.yellow.shade300,
        size: 25,
      ),
      title: Text("More details",
          style: TextStyle(
            fontFamily: 'Cocosharp',
            color: Colors.yellow.shade300,
          )),
      children: [
        for (var i = 0; i < e['matches_details'].length; i++)
          AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 700),
              position: i,
              child: ScaleAnimation(
                child: SlideAnimation(
                  child: FlipCard(
                      fill: Fill
                          .none, // Fill the back side of the card to make in the same size as the front.
                      direction: FlipDirection.HORIZONTAL, // default
                      side: CardSide.FRONT,
                      //front of the card MAP format
                      // [{Name: [England],
                      //winsloss: [W,W,L,L,L],
                      //matches_details:
                      //[England vs Bangladesh,  March 01, 2023, 1st ODI,,
                      //England vs South Africa, February 01, 2023, 3rd ODI,,
                      //England vs South Africa, January 29, 2023, 2nd ODI,,
                      //England vs South Africa, January 27, 2023, 1st ODI,,
                      //England vs Australia, November 22, 2022, 3rd ODI,],
                      //scoreboard_for_matches_links: [/series/england-in-bangladesh-2022-23-1351394/bangladesh-vs-england-1st-odi-1351397/full-scorecard, /series/england-in-south-africa-2022-23-1339564/south-africa-vs-england-3rd-odi-1339597/full-scorecard, /series/england-in-south-africa-2022-23-1339564/south-africa-vs-england-2nd-odi-1339596/full-scorecard, /series/england-in-south-africa-2022-23-1339564/south-africa-vs-england-1st-odi-1339595/full-scorecard, /series/england-in-australia-2022-23-1317467/australia-vs-england-3rd-odi-1317491/full-scorecard]
                      //listofallrecentplayers: [{Match1: [Jofra Archer2/37 (10), Mark Wood2/34 (8), Dawid Malan *114 (145), Will Jacks 26 (31)]}, {Match2:
                      front: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white54),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(10.0)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff005874),
                                  Color(0xff1C819E),

                                  // Colors.white38,
                                ],
                              )),
                          child: Column(
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
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(10.0)),
                                            color: Colors.white60),
                                        child: Text(
                                          e['matches_details'][i]
                                              .toString()
                                              .split(',')
                                              .first,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Cocosharp',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      //Date of the match happened
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${e['matches_details'][i].replaceAll(e['matches_details'][i].split(',').first, '').substring(1).trim()}",
                                          style: TextStyle(
                                            fontFamily: 'Louisgeorge',
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      //Winner of the match
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          e['match_winner'][i].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Louisgeorge',
                                              color: Colors.teal.shade500,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            'Tap to view top performers of this match.',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Louisgeorge',
                                                color: Colors.white24)),
                                      )
                                    ],
                                  ),
                                  e['winsloss'][0].split(',').map((character) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                              // Divider(
                              //   color: Colors.white,
                              // ),
                            ],
                          ),
                        ),
                      ),

                      // back of the card MAP format for the recent five matches
                      //[{Match1: [Jofra Archer2/37 (10), Mark Wood2/34 (8), Dawid Malan *114 (145), Will Jacks 26 (31)]},
                      //{Match2: [Jos Buttler 131 (127), Dawid Malan 118 (114), Jofra Archer6/40 (9.1), Adil Rashid3/68 (10)]},
                      //{Match3: [Jos Buttler *94 (81), Harry Brook 80 (75), Olly Stone2/48 (10), Adil Rashid2/72 (10)]},
                      // {Match4: [Sam Curran3/35 (9), Olly Stone1/37 (7), Jason Roy 113 (91), Dawid Malan 59 (55)]},
                      // {Match5: [Olly Stone4/85 (10), Liam Dawson1/75 (10), Jason Roy 33 (48), James Vince 22 (45)]}]
                      back: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                            decoration: new BoxDecoration(
                                border: Border.all(color: Colors.white54),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(10.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff005874),
                                    Color(0xff1C819E),

                                    // Colors.white38,
                                  ],
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Batters', style: globals.Louisgeorge),
                                    Text('Bowlers', style: globals.Louisgeorge),
                                  ],
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        //batters
                                        //if the element in the array dont have a / mark they are batters
                                        Column(
                                          children: e['listofallrecentplayers']
                                                      [i]
                                                  ['Match' + (i + 1).toString()]
                                              .map<Widget>(
                                                  (recentplayer) =>
                                                      !recentplayer
                                                              .toString()
                                                              .contains('/')
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      backgroundColor: (filterplayer.isNotEmpty &&
                                                                              (recentplayer.toString().split(RegExp(r'[0-9]')).first.trim() == filterplayer ||
                                                                                  recentplayer.toString().split('*').first.trim() ==
                                                                                      filterplayer)) //check if the clicked name is common in batters and bowlers
                                                                          ? Colors
                                                                              .green // and highlight the name that is clicked
                                                                          : Colors
                                                                              .transparent,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      minimumSize:
                                                                          Size(
                                                                              50,
                                                                              30),
                                                                      tapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft),
                                                              onPressed: () {
                                                                print(
                                                                    'sug ${recentplayer.toString().split('*').first.trim().length} ${filterplayer.length}');

                                                                _onClick(
                                                                    recentplayer
                                                                        .toString()
                                                                        .trim());
                                                              },
                                                              child: Text(
                                                                recentplayer
                                                                    .toString(),
                                                                style: globals
                                                                    .Louisgeorge,
                                                              ),
                                                            )
                                                          : Container())
                                              .toList(),
                                        ),
                                        VerticalDivider(
                                          thickness: 3,
                                          color: Colors.white,
                                        ),
                                        //bowlers
                                        //if the element in the array  have a / mark they are bowlers
                                        Column(
                                          children: e['listofallrecentplayers']
                                                      [i]
                                                  ['Match' + (i + 1).toString()]
                                              .map<Widget>(
                                                  (recentplayer) =>
                                                      recentplayer
                                                              .toString()
                                                              .contains('/')
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      backgroundColor: (filterplayer.isNotEmpty &&
                                                                              recentplayer.toString().split(RegExp(r'[0-9]')).first.trim() ==
                                                                                  filterplayer) //check if the clicked name is common in batters and bowlers
                                                                          ? Colors
                                                                              .green // and highlight the name that is clicked
                                                                          : Colors
                                                                              .transparent,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      minimumSize:
                                                                          Size(
                                                                              50,
                                                                              30),
                                                                      tapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft),
                                                              onPressed: () {
                                                                _onClick(
                                                                    recentplayer
                                                                        .toString()
                                                                        .trim());
                                                              },
                                                              child: Text(
                                                                  recentplayer
                                                                          .toString()
                                                                          .split(RegExp(
                                                                              r'[0-9]'))
                                                                          .first +
                                                                      ' - ' +
                                                                      recentplayer.toString().replaceAll(
                                                                          recentplayer
                                                                              .toString()
                                                                              .split(RegExp(
                                                                                  r'[0-9]'))
                                                                              .first,
                                                                          ''),
                                                                  style: globals
                                                                      .Louisgeorge),
                                                            )
                                                          : Container())
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )),
                ),
              ),
            ),
          )
      ],
    );
  }
}

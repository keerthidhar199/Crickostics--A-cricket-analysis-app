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
                          .fillBack, // Fill the back side of the card to make in the same size as the front.
                      direction: FlipDirection.HORIZONTAL, // default
                      side: CardSide.FRONT,
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
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        //batters
                                        Column(
                                          children: e['listofallrecentplayers']
                                                      [i]
                                                  ['Match' + (i + 1).toString()]
                                              .map<Widget>((recentplayer) =>
                                                  !recentplayer
                                                          .toString()
                                                          .contains('/')
                                                      ? TextButton(
                                                          style: TextButton.styleFrom(
                                                              backgroundColor: (filterplayer
                                                                          .isNotEmpty &&
                                                                      (recentplayer.toString().split(RegExp(r'[0-9]')).first.trim() ==
                                                                              filterplayer ||
                                                                          recentplayer.toString().split('*').first.trim() ==
                                                                              filterplayer))
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .transparent,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              minimumSize:
                                                                  Size(50, 30),
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              alignment: Alignment
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
                                                              style: TextButton.styleFrom(
                                                                  backgroundColor: (filterplayer
                                                                              .isNotEmpty &&
                                                                          recentplayer.toString().split(RegExp(r'[0-9]')).first.trim() ==
                                                                              filterplayer)
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .transparent,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  minimumSize:
                                                                      Size(50,
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

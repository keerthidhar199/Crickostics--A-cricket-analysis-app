import 'dart:async';
import 'dart:convert';
import 'package:datascrap/recentplayersform.dart';
import 'package:datascrap/skeleton.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  final countofPlayers;
  const expansionTile({Key key, this.e, this.countofPlayers}) : super(key: key);

  @override
  State<expansionTile> createState() =>
      _expansionTileState(this.e, this.countofPlayers);
}

class _expansionTileState extends State<expansionTile> {
  _expansionTileState(e, snapshot);
  List<FlipCardController> _controller = List.filled(5, FlipCardController());
  List<GlobalKey<FlipCardState>> cardKeys = List.generate(
    5,
    (index) => GlobalKey<FlipCardState>(),
  );

  bool isBack = false;
  bool expandTile = false;

  @override
  void initState() {
    super.initState();
  }

  List<String> teamnames = [globals.team1_name, globals.team2_name];
  String filterplayer = '';
  _onClick(String string) {
    setState(() {
      this.filterplayer = string.toString().split('-').first.trim();
    });
    // print('$filterplayer');
  }

  List<Color> onPlayerclicked = List.filled(20, Color(0xff005874));

  void toggleSwitch(bool value) {
    if (isBack == false) {
      setState(() {
        isBack = true; //shows back of the card
        for (int i = 0; i < 5; i++) {
          // _controller[i].toggleCard();
          cardKeys[i].currentState.toggleCard();
        }
      });
      print('Card showing Front');
    } else {
      setState(() {
        isBack = false; //shows front of the card
        for (int i = 0; i < 5; i++) {
          // _controller[i].toggleCard();
          cardKeys[i].currentState.toggleCard();
        }
      });
      print('Card showing Back');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> e = widget.e;
    Map<String, int> countofplayer = widget.countofPlayers;

    for (int i = 0; i < e['matches_details'].length; i++) {
      _controller[i] = FlipCardController();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Top players in the last five matches',
            style: TextStyle(
              fontFamily: 'Cocosharp',
              fontSize: 15,
              color: Colors.yellow.shade300,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: countofplayer.entries
                  .map((player) => GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(10.0)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  onPlayerclicked[countofplayer.keys
                                      .toList()
                                      .indexOf(player
                                          .key)], //change color when clicked on that player
                                  Color(0xff1C819E),

                                  // Colors.white38,
                                ],
                              )),
                          child: Text(player.key, style: globals.Louisgeorge),
                        ),
                        onTap: () {
                          //open the expansion tile to show more details
                          for (int i = 0; i < 5; i++) {
                            if (expandTile == true) {
                              //if expand tille is open
                              if (cardKeys[i].currentState.isFront == true) {
                                //if any of the five cards is not like the rest of the cards.
                                setState(() {
                                  cardKeys[i]
                                      .currentState
                                      .toggleCard(); //toggle all the cards to back
                                }); //and turn the switch as well and show the player details
                              } else {
                                //if tile is open and all the cards are back faced, just assign the player value
                                setState(() {
                                  onPlayerclicked[countofplayer.keys
                                      .toList()
                                      .indexOf(player.key)] = Colors.green;
                                  filterplayer = player.key.trim();
                                });
                              }
                            } else {
                              setState(() {
                                // tapon = true; //tap to expand the tile
                                expandTile = true;
                                isBack = true;
                                onPlayerclicked[countofplayer.keys
                                    .toList()
                                    .indexOf(player.key)] = Colors.green;

                                filterplayer = player.key.trim();
                              });
                            }
                            print(onPlayerclicked);
                          }

                          // print(isBack);
                        },
                      ))
                  .toList()),
        ),
        ExpansionTile(
          // onExpansionChanged: (value) {
          //   print(value);
          //   if (value) {
          //     setState(() {
          //       expandTile = true;
          //     });
          //   } else {
          //     setState(() {
          //       expandTile = true;
          //     });
          //   }
          // },
          initiallyExpanded: true,
          tilePadding: EdgeInsets.all(0.0),
          // trailing: const SizedBox(),
          title: GestureDetector(
            onTap: () {
              setState(() {
                //when clicking on MORE DETAILS
                if (expandTile == false) {
                  // if expansion closed
                  if (isBack == true) {
                    //and the the flipcards are all back side faced
                    setState(() {
                      expandTile = true; //open the expansion
                      isBack = false; //flip and show the front face
                    });
                  } else {
                    setState(() {
                      expandTile =
                          true; //if the flipcards are all front faced just open the expansion,thats it.
                    });
                  }
                } else {
                  setState(() {
                    // if expansion is open
                    expandTile = false; //just close it
                    isBack = false; //and bring all the flip cards to front face
                  });
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.teal.shade300, width: 2)),
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("More details",
                        style: TextStyle(
                          fontFamily: 'Cocosharp',
                          color: Colors.yellow.shade300,
                        )),
                  ),
                  Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.yellow.shade300,
                    size: 25,
                  )
                ],
              ),
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: expandTile,
              child: Switch(
                dragStartBehavior: DragStartBehavior.down,
                // overrides the default green color of the track
                activeColor: Colors.yellow.shade800,
                // color of the round icon, which moves from right to left
                // when the switch is off
                // boolean variable value
                onChanged: toggleSwitch,
                value: isBack,
              ),
            ),
            for (var i = 0; i < e['matches_details'].length; i++)
              Visibility(
                visible: expandTile,
                child: AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 700),
                    position: i,
                    child: ScaleAnimation(
                      child: SlideAnimation(
                        child: Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 3.5 / 16,
                              child: FlipCard(
                                  // controller: _controller[i],
                                  key: cardKeys[i],
                                  // autoFlipDuration: flipduration ,
                                  // Fill the back side of the card to make in the same size as the front.
                                  direction:
                                      FlipDirection.HORIZONTAL, // default
                                  side: isBack == true
                                      ? CardSide.BACK
                                      : CardSide.FRONT,

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
                                      decoration:
                                          globals.recentStatePage_Decoration,
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
                                                  //Which team vs which
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: new BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .all(new Radius
                                                                    .circular(
                                                                10.0)),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                  //Date of the match happened
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "${e['matches_details'][i].replaceAll(e['matches_details'][i].split(',').first, '').substring(1).trim()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Louisgeorge',
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  //Winner of the match
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      e['match_winner'][i]
                                                          .toString(),
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Louisgeorge',
                                                          color: Colors.teal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        'Tap to view top performers of this match.',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Louisgeorge',
                                                            color: Colors
                                                                .white24)),
                                                  )
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
                                        decoration:
                                            globals.recentStatePage_Decoration,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text('Batters',
                                                    style: globals.Louisgeorge),
                                                Text('Bowlers',
                                                    style: globals.Louisgeorge),
                                              ],
                                            ),
                                            FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    //batters
                                                    //if the element in the array dont have a / mark they are batters
                                                    Column(
                                                      children: e['listofallrecentplayers']
                                                                  [i][
                                                              'Batters' +
                                                                  (i + 1)
                                                                      .toString()]
                                                          .map<Widget>(
                                                              (recentplayer) =>
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        backgroundColor: (filterplayer.isNotEmpty && recentplayer.split('-').first.trim() == filterplayer) //check if the clicked name is common in batters and bowlers
                                                                            ? Colors.green // and highlight the name that is clicked
                                                                            : Colors.transparent,
                                                                        padding: EdgeInsets.zero,
                                                                        minimumSize: Size(50, 30),
                                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                        alignment: Alignment.centerLeft),
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          'sug ${recentplayer.toString().split('-').first.trim().length} ${filterplayer.length}');

                                                                      _onClick(recentplayer
                                                                          .toString()
                                                                          .trim());
                                                                    },
                                                                    child: Text(
                                                                      recentplayer
                                                                          .toString(),
                                                                      style: globals
                                                                          .Louisgeorge,
                                                                    ),
                                                                  ))
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
                                                                  [i][
                                                              'Bowlers' +
                                                                  (i + 1)
                                                                      .toString()]
                                                          .map<Widget>(
                                                              (recentplayer) =>
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        backgroundColor: (filterplayer.isNotEmpty && recentplayer.toString().split('-').first.trim() == filterplayer) //check if the clicked name is common in batters and bowlers
                                                                            ? Colors.green // and highlight the name that is clicked
                                                                            : Colors.transparent,
                                                                        padding: EdgeInsets.zero,
                                                                        minimumSize: Size(50, 30),
                                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                        alignment: Alignment.centerLeft),
                                                                    onPressed:
                                                                        () {
                                                                      _onClick(recentplayer
                                                                          .toString()
                                                                          .trim());
                                                                    },
                                                                    child: Text(
                                                                        recentplayer
                                                                            .toString(),
                                                                        style: globals
                                                                            .Louisgeorge),
                                                                  ))
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}

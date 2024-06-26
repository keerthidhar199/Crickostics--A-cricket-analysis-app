// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'globals.dart' as globals;
import 'package:flip_card/flip_card.dart';

class expansionTile extends StatefulWidget {
  final e;
  final countofPlayers;
  const expansionTile({Key? key, this.e, this.countofPlayers})
      : super(key: key);

  @override
  State<expansionTile> createState() => _expansionTileState(e, countofPlayers);
}

class _expansionTileState extends State<expansionTile> {
  _expansionTileState(e, snapshot);
  final List<FlipCardController> _controller =
      List.filled(5, FlipCardController());
  List<GlobalKey<FlipCardState>> cardKeys = List.generate(
    5,
    (index) => GlobalKey<FlipCardState>(),
  );

  bool isBack = false;
  bool expandTile = false;
  List<Color> onPlayerclicked = List.filled(20, const Color(0xff005874));
  List<bool> tapon = List.filled(20, false);

  @override
  void initState() {
    super.initState();
  }

  List<String> teamnames = [globals.team1_name, globals.team2_name];
  List<String> filterplayer = [];
  _onClick(String string) {
    setState(() {
      filterplayer.add(string.toString().split('-').first.trim());
    });
    // print('$filterplayer');
  }

  void toggleSwitch(bool value) {
    if (isBack == false) {
      setState(() {
        isBack = true; //shows back of the card
        for (int i = 0; i < 5; i++) {
          // _controller[i].toggleCard();
          cardKeys[i].currentState!.toggleCard();
        }
      });
      print('Card showing Front');
    } else {
      setState(() {
        isBack = false; //shows front of the card
        for (int i = 0; i < 5; i++) {
          // _controller[i].toggleCard();
          cardKeys[i].currentState!.toggleCard();
        }
      });
      print('Card showing Back');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> e = widget.e;
    Map<String, int> countofplayer = widget.countofPlayers;

    for (int i = 0; i < e['matches_details']!.length; i++) {
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
              children: [
                ...countofplayer.entries.map((player) => GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                onPlayerclicked[countofplayer.keys
                                    .toList()
                                    .indexOf(player
                                        .key)], //change color when clicked on that player
                                const Color(0xff1C819E),

                                // Colors.white38,
                              ],
                            )),
                        child: Wrap(
                          children: [
                            Text(player.key, style: globals.Litsans),
                            tapon[countofplayer.keys
                                        .toList()
                                        .indexOf(player.key)] ==
                                    true
                                ? const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : const Icon(
                                    null,
                                    size: 5,
                                  )
                          ],
                        ),
                      ),
                      onTap: () {
                        int topplayer =
                            countofplayer.keys.toList().indexOf(player.key);
                        //open the expansion tile to show more details
                        for (int i = 0; i < 5; i++) {
                          if (expandTile == true) {
                            //if expand tille is open
                            if (cardKeys[i].currentState!.isFront == true) {
                              //card(s) are front faced
                              setState(() {
                                tapon[topplayer] = true;
                                onPlayerclicked[topplayer] = Colors.green;
                                filterplayer.add(player.key.trim());
                                isBack = true;
                                cardKeys[i]
                                    .currentState!
                                    .toggleCard(); //toggle all the cards to back
                              }); //and turn the switch as well and show the player details
                            } else {
                              //if tile is open and the player is clicked again close the expansion tile
                              if (tapon[topplayer] == true) {
                                setState(() {
                                  tapon[topplayer] = false;
                                  filterplayer.removeWhere((element) =>
                                      element == player.key.trim());
                                  onPlayerclicked[topplayer] =
                                      const Color(0xff005874);
                                });
                                //if tile is open and all the cards are back faced, just assign the player value
                              } else {
                                setState(() {
                                  tapon[topplayer] = true;
                                  onPlayerclicked[topplayer] = Colors.green;
                                  filterplayer.add(player.key.trim());
                                });
                              }
                            }
                          } else {
                            setState(() {
                              tapon[topplayer] = true; //tap to expand the tile
                              expandTile = true;
                              isBack = true;
                              onPlayerclicked[topplayer] = Colors.green;

                              filterplayer.add(player.key.trim());
                            });
                          }
                        }
                        setState(() {
                          filterplayer = filterplayer.toSet().toList();
                        });
                        print('$filterplayer  $tapon');
                        // print(isBack);
                      },
                    )),
                filterplayer.isNotEmpty
                    ? GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: globals.recentStatePage_Decoration,
                          child: Text('Clear', style: globals.Litsanswhite),
                        ),
                        onTap: () {
                          setState(() {
                            //Clear all the players, their colours and tapons
                            onPlayerclicked =
                                List.filled(20, const Color(0xff005874));
                            tapon = List.filled(20, false);
                            filterplayer.clear();
                          });
                        },
                      )
                    : Container()
              ]),
        ),
        ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.all(0.0),
          trailing: const SizedBox(),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("More details",
                    style: TextStyle(
                      fontFamily: 'Cocosharp',
                      color: Colors.yellow.shade300,
                    )),
                Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.yellow.shade300,
                  size: 25,
                )
              ],
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.end,
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
            for (var i = 0; i < e['listofallrecentplayers']!.length; i++)
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
                            SizedBox(
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
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        color: Colors.white60),
                                                    child: Text(
                                                      e['vs']![i]
                                                          .toString()
                                                          .split(',')
                                                          .first,
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontFamily: 'Cocosharp',
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),

                                                  //Date of the match happened
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "${e['matches_details']![i]}}",
                                                      style: const TextStyle(
                                                        fontFamily: 'Litsans',
                                                        color: Colors.white70,
                                                        fontSize: 12,
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
                                                      e['match_winner']![i]
                                                          .toString(),
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Litsans',
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
                                                    child: const Text(
                                                        'Tap to view top performers of this match.',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Litsans',
                                                            color: Colors
                                                                .white24)),
                                                  )
                                                ],
                                              ),
                                              e['winsloss']![0]
                                                  .toString()
                                                  .characters
                                                  .map((character) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: character == 'W'
                                                          ? Colors.green
                                                          : character == 'L'
                                                              ? Colors.red
                                                              : Colors.grey,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      character,
                                                      style: const TextStyle(
                                                        fontFamily: 'Cocosharp',
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                                    style: globals.Litsans),
                                                Text('Bowlers',
                                                    style: globals.Litsans),
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
                                                      children: e['listofallrecentplayers']![
                                                                  i][
                                                              'Batters${i + 1}']
                                                          .map<Widget>(
                                                              (recentplayer) =>
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        backgroundColor: (filterplayer.isNotEmpty && filterplayer.contains(recentplayer.split('-').first.trim())) //check if the clicked name is common in batters and bowlers
                                                                            ? Colors.green // and highlight the name that is clicked
                                                                            : Colors.transparent,
                                                                        padding: EdgeInsets.zero,
                                                                        minimumSize: const Size(50, 30),
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
                                                                          .Litsans,
                                                                    ),
                                                                  ))
                                                          .toList(),
                                                    ),
                                                    const VerticalDivider(
                                                      thickness: 3,
                                                      color: Colors.white,
                                                    ),
                                                    //bowlers
                                                    //if the element in the array  have a / mark they are bowlers
                                                    Column(
                                                      children: e['listofallrecentplayers']![
                                                                  i][
                                                              'Bowlers${i + 1}']
                                                          .map<Widget>(
                                                              (recentplayer) =>
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        backgroundColor: (filterplayer.isNotEmpty && filterplayer.contains(recentplayer.split('-').first.trim())) //check if the clicked name is common in batters and bowlers
                                                                            ? Colors.green // and highlight the name that is clicked
                                                                            : Colors.transparent,
                                                                        padding: EdgeInsets.zero,
                                                                        minimumSize: const Size(50, 30),
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
                                                                            .Litsans),
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

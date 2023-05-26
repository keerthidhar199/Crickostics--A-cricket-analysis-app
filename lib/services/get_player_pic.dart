import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/splashscreen.dart';
import 'package:datascrap/views/fantasy_players_UI.dart';
import 'package:datascrap/webscrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:skeletons/skeletons.dart';
import 'package:datascrap/globals.dart' as globals;

class player_pic extends StatefulWidget {
  final categories;
  final topBatters;
  final topBowlers;
  final topheadtoheadbowlers;
  final topheadtoheadbatters;
  final e;
  const player_pic(
      {Key key,
      this.categories,
      this.topBatters,
      this.topBowlers,
      this.e,
      this.topheadtoheadbatters,
      this.topheadtoheadbowlers})
      : super(key: key);

  @override
  State<player_pic> createState() => _player_picState();
}

class _player_picState extends State<player_pic> {
  final List<Color> cardColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> headtohead = [
      ...widget.topheadtoheadbatters,
      ...widget.topheadtoheadbowlers
    ];

    print('headtohead $headtohead');

    return CarouselSlider.builder(
      itemCount: widget.categories.indexOf(widget.e) == 0
          ? widget.topBatters.length
          : widget.categories.indexOf(widget.e) == 1
              ? widget.topBowlers.length
              : headtohead.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final player = widget.categories.indexOf(widget.e) == 0
            ? widget.topBatters[index]
            : widget.categories.indexOf(widget.e) == 1
                ? widget.topBowlers[index]
                : headtohead[index];
        final color = cardColors[index % cardColors.length];

        return Stack(
          alignment: Alignment.topRight,
          fit: StackFit.passthrough,
          children: [
            Card(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      child: ClipOval(
                        child: player[4] == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.black45,
                              )
                            : Image.network(
                                player[4],
                                width: 100,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    child: const CircularProgressIndicator(
                                      color: Colors.redAccent,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player[0],
                          style: globals.Litsanswhite,
                        ),
                        const SizedBox(height: 8),
                        if (widget.categories.indexOf(widget.e) == 0)
                          Column(
                            children: [
                              Text(
                                '${player[1]}' ' (${player[2]})',
                                style: globals.Litsanswhite,
                              ),
                              Text(
                                'Strike rate: ${player[3]}',
                                style: globals.Litsanswhite,
                              )
                            ],
                          )
                        else if (widget.categories.indexOf(widget.e) == 1)
                          Column(
                            children: [
                              Text(
                                '${player[2]}-' '${player[1]}',
                                style: globals.Litsanswhite,
                              ),
                              Text(
                                'Economy: ${player[3]}',
                                style: globals.Litsanswhite,
                              ),
                            ],
                          )
                        else if (widget.categories.indexOf(widget.e) == 2)
                          Column(
                            children: [
                              Text(
                                '${player[2]}-' '${player[1]}',
                                style: globals.Litsanswhite,
                              ),
                              Text(
                                'Economy: ${player[3]}',
                                style: globals.Litsanswhite,
                              ),
                            ],
                          )
                        // Column(
                        //   children: [
                        //     Text(
                        //       '${player[1]}' ' (${player[2]})',
                        //       style: globals.Litsanswhite,
                        //     ),
                        //     Text(
                        //       'Strike rate: ${player[3]}',
                        //       style: globals.Litsanswhite,
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'logos/Rank' + (index + 1).toString() + '.png',
              width: 60,
              height: 60,
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 150,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

Future<List<List<String>>> get_players_pics(
    List<List<String>> playersinfo) async {
  List<String> imgsdata = [];
  String root = 'https://www.espncricinfo.com';
  String imgroot =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320/lsci';
  List<String> playerslinks = [];
  for (var i in playersinfo) {
    playerslinks.add(i.last);
  }
  for (var i in playerslinks) {
    http.Response response;
    print(root + i);
    response = await http.Client().get(Uri.parse(root + i));

    dom.Document document = parser.parse(response.body);
    if (json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['player']['headshotImage'] !=
        null) {
      imgsdata.add(imgroot +
          json
              .decode(document.getElementById('__NEXT_DATA__').text)['props']
                  ['appPageProps']['data']['player']['headshotImage']['url']
              .toString());
    } else {
      imgsdata.add(null);
    }
  }
  for (var i in playersinfo) {
    i.last = imgsdata[playersinfo.indexOf(i)];
  }

  return playersinfo;
}

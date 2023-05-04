import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/analysis.dart';
import 'package:datascrap/skeleton.dart';
import 'package:datascrap/typeofstats.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'globals.dart' as globals;
import 'package:skeletons/skeletons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'models/points_table_class.dart';
import 'views/points_table_UI.dart';

class datascrap extends StatefulWidget {
  const datascrap({Key key}) : super(key: key);
  @override
  State<datascrap> createState() => _datascrapState();
}

class _datascrapState extends State<datascrap> {
  var themecolor = Colors.white;
  var darkcolor = Colors.black;
  var link2doc1;
  final CarouselController _controller = CarouselController();
  int _currentSlide = 0;

  List<List<dynamic>> tableinfo = [];
  List<Map<String, String>> variable = [];
  List<Map<String, String>> snapshot = [];

  String rootLogo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
  bool tableshow = false;
  UTCtoLocal(String s) {
    var a = s.split(RegExp(r'[0-9]')).first;
    s = s.replaceAll(a, '');

    DateFormat inputFormat = DateFormat('HH:mm a');

    s = s.contains('pm')
        ? s.replaceAll('pm', 'PM')
        : s.replaceAll('am', 'AM').trim();

    var dateValue = DateFormat("hh:mm a").parseUTC(s).toLocal();
    // String amPm = dateValue.hour < 12 ? 'AM' : 'PM';
    // dateValue = DateFormat("HH:mm a")
    //     .parse('${dateValue.hour}:${dateValue.minute} $amPm')
    //     .toLocal();
    // String formattedTime =
    //     '${dateValue.hour.toString().padLeft(2, '0')}:${dateValue.minute.toString().padLeft(2, '0')}';

    // print('formattedDate = ' + formattedTime.toString());

    String formattedDate = DateFormat('hh:mm a').format(dateValue);
    String nowTime = DateFormat('hh:mm a').format(DateTime.now());
    DateTime dateTime1 = inputFormat.parse(formattedDate);
    DateTime dateTime2 = inputFormat.parse(nowTime);
    print('formattedDate = ' + formattedDate.toString() + nowTime);

// Calculate the difference between the two DateTime objects
    Duration difference = dateTime1.difference(dateTime2).abs();
    formattedDate =
        "In ${difference.inHours} hrs, ${difference.inMinutes.remainder(60)} mins";
    return formattedDate;
  }

  GlobalKey<RefreshIndicatorState> _refreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  GlobalKey row1 = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicator.currentState.show());

    super.initState();
    getlivematches(globals.league_page).then((value) {
      setState(() {
        snapshot = value;
      });
    });
  }

  Future<List<Map<String, String>>> getlivematches(String league) async {
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    // print(document
    //     .querySelectorAll('table.engineTable>tbody')[1]
    //     .text
    //     .contains('Records'));
    List<Map<String, String>> matches = []; //

    for (int k = 0;
        k < document.getElementsByClassName('ds-px-4 ds-py-3').length;
        k++) {
      Map<String, String> iplmatch = {};

      var matchdetails = document.getElementsByClassName('ds-px-4 ds-py-3')[k];
      // print('matchdetais ${matchdetails.text}');
      // if (matchdetails.querySelectorAll('a').isNotEmpty) {
      if (matchdetails.text.contains(league)) {
        var link1 = matchdetails.querySelectorAll('a')[0];

        var link1update = link1.attributes["href"].toString();
        var matchaddress = 'https://www.espncricinfo.com' + link1update;
        link1update = link1update.replaceAll(
            link1update.split('/')[3] + '/' + link1update.split('/').last, '');
        print('link1update1 ${link1update}');

        var link2address = 'https://www.espncricinfo.com' + link1update;
        var forlink2 = await http.Client().get(Uri.parse(link2address));
        dom.Document link2doc = parser.parse(forlink2.body);

        var formatch2 = await http.Client().get(Uri.parse(matchaddress));
        dom.Document match2doc = parser.parse(formatch2.body);

        setState(() {
          globals.league_page_address = matchaddress;
        });
        if (match2doc
            .getElementsByClassName('ds-shrink-0')
            .where((element) => element.text == 'Table')
            .isEmpty) {
          setState(() {
            tableshow = false;
          });
        } else {
          setState(() {
            tableshow = true;
          });
        }

        var forlink3 = await http.Client()
            .get(Uri.parse('https://www.espncricinfo.com' + link1update));
        dom.Document link3doc = parser.parse(forlink3.body);

        var link3 = link3doc
            .getElementsByClassName('ds-px-3 ds-py-2')
            .where((element) => element.text == 'Stats');
        print('link3 ${link3.toList()[0].attributes['href']}');

        for (var y
            in matchdetails.getElementsByClassName('ds-text-compact-xxs')) {
          var matchDet =
              y.getElementsByClassName('ds-flex ds-justify-between')[0];
          if (!matchDet.text.toLowerCase().contains('covered')) {
            var matchDet1 = y.getElementsByClassName(
                    'ds-text-tight-xs ds-truncate ds-text-typo-mid3')[
                0]; // 11th Match (N), DY Patil, March 13, 2023, Women's Premier League
            var teams1 = y
                .getElementsByClassName(
                    'ci-team-score ds-flex ds-justify-between ds-items-center ds-text-typo ds-my-1')[0]
                .querySelector('p')
                .text; //team1 name Mumbai Indians Women
            var teams2 = y
                .getElementsByClassName(
                    'ci-team-score ds-flex ds-justify-between ds-items-center ds-text-typo ds-my-1')[1]
                .querySelector('p')
                .text; //team2 name Gujarat Giants Women
            var teamscore = y.getElementsByClassName(
                'ds-text-compact-s ds-text-typo ds-text-right ds-whitespace-nowrap');
            String stauts;
            if (y
                .getElementsByClassName(
                    'ds-text-tight-s ds-font-regular ds-truncate ds-text-typo')
                .isEmpty) {
              stauts = '';
            } else {
              stauts = y
                  .getElementsByClassName(
                      'ds-text-tight-s ds-font-regular ds-truncate ds-text-typo')[0]
                  .text;
            }
            var response1 = await http.Client().get(
                Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
            dom.Document document1 = parser.parse(response1.body);
            List imglogosdata = json.decode(
                    document1.getElementById('__NEXT_DATA__').text)['props']
                ['editionDetails']['trendingMatches']['matches'];
            List imglogosdata1 = json.decode(
                    document1.getElementById('__NEXT_DATA__').text)['props']
                ['appPageProps']['data']['content']['matches'];
            List takethisimglogosdata = List.from(imglogosdata)
              ..addAll(imglogosdata1);

            for (var i in takethisimglogosdata) {
              if ((i['teams'][0]['team']['name'] == teams1) &&
                  (i['teams'][1]['team']['name'] == teams2)) {
                iplmatch['linkaddress'] = matchaddress;
                iplmatch['Team1'] = teams1;
                iplmatch['Team2'] = teams2;
                iplmatch['Team1_short'] =
                    i['teams'][0]['team']['longName'].toString();
                iplmatch['Team2_short'] =
                    i['teams'][1]['team']['longName'].toString();
                if (i['teams'][0]['team']['image'] == null ||
                    i['teams'][1]['team']['image'] == null) {
                  iplmatch['team1logo'] = null;

                  iplmatch['team2logo'] = null;
                } else {
                  iplmatch['team1logo'] =
                      i['teams'][0]['team']['image']['url'].toString();
                  iplmatch['team2logo'] =
                      i['teams'][1]['team']['image']['url'].toString();
                }
              } else {
                if ((i['teams'][0]['team']['longName'] == teams1) &&
                    (i['teams'][1]['team']['longName'] == teams2)) {
                  iplmatch['linkaddress'] = matchaddress;
                  iplmatch['Team1'] = teams1;
                  iplmatch['Team2'] = teams2;
                  iplmatch['Team1_short'] =
                      i['teams'][0]['team']['name'].toString();
                  iplmatch['Team2_short'] =
                      i['teams'][1]['team']['name'].toString();

                  if (i['teams'][0]['team']['image'] == null ||
                      i['teams'][1]['team']['image'] == null) {
                    iplmatch['team1logo'] = null;

                    iplmatch['team2logo'] = null;
                  } else {
                    iplmatch['team1logo'] =
                        i['teams'][0]['team']['image']['url'].toString();
                    iplmatch['team2logo'] =
                        i['teams'][1]['team']['image']['url'].toString();
                  }
                }
              }
            }
            //print('hero team1: ${teams1}');
            //print('hero match_det: ${match_det.text}');
            //print('hero match_det1: ${match_det1.text}');
            //print('hero team2: ${teams2}');
            // //print('hero teamscore: ${teamscore[0].text}');
            // //print('hero teamscore: ${teamscore[1].text}');
            //print('hero stauts: ${stauts.text}');

            iplmatch['Time'] = matchDet.text;
            iplmatch['Match_name'] = matchDet1.text.split(',').last;

            iplmatch['MatchStarts'] = stauts;
            iplmatch['Details'] = matchDet1.text;

            final DateTime today = DateTime.now();
            final DateFormat format2 = DateFormat('MMMM');
            //print(format2.format(
            // today));
            //getting current month name like January, February...
            var detailslist = matchDet1.text.split(',');

            print('bass' + detailslist.toString());
            for (var k in detailslist) {
              print('bass' + k.toString());
              if (k.contains(format2.format(today).toString())) {
                iplmatch['Ground'] =
                    detailslist[detailslist.indexOf(k) - 1].trim();
                //taking the ground name from the list which is the one before Date details
              } else {}
            }
            print('assa1' + iplmatch.toString());

            if (teamscore.length == 2) {
              iplmatch['team1_score'] = teamscore[0].text.trim();
              iplmatch['team2_score'] = teamscore[1].text.trim();
            } else if (teamscore.length == 1) {
              iplmatch['team1_score'] = teamscore[0].text.trim();
              iplmatch['team2_score'] = '';
            } else {
              iplmatch['team1_score'] = '';
              iplmatch['team2_score'] = '';
            }

//                    hero team1: Kolkata Knight Riders
//                    hero match_det: Live
//                     hero match_det1: 61st Match (N), Pune, May 14, 2022, Indian Premier League
//                     hero team2: Sunrisers Hyderabad
//                     hero teamscore: 177/6
//                    hero teamscore: (17.6/20 ov, T:178) 113/7
//                     hero stauts: Sunrisers need 65 runs in 12 balls.
          }
        }
        if (link3.toList().isNotEmpty) {
          var teamstats = await http.Client().get(Uri.parse(
              'https://www.espncricinfo.com' +
                  link3.toList()[0].attributes["href"].toString()));
          dom.Document viewstatsdoc = parser.parse(teamstats.body);
          var viewstats = viewstatsdoc
              .getElementsByClassName('ds-flex')
              .where((element) => element.text == 'View all stats');
          teamstats = await http.Client().get(Uri.parse(
              'https://www.espncricinfo.com' +
                  viewstats.last.attributes['href'].toString()));
          print('viewstast ${viewstats.last.attributes['href'].toString()}');
          // ('assa1 ' + link3.toList()[0].attributes["href"].toString());
          dom.Document teamstatsdoc = parser.parse(teamstats.body);

          var rec1 = teamstatsdoc
              .getElementsByClassName(
                  'ds-flex ds-items-center ds-cursor-pointer ds-px-4 ds-py-3')
              .where((element) => element.text == 'Records by team');
          var rec2 = teamstatsdoc
              .getElementsByClassName(
                  'ds-flex ds-items-center ds-cursor-pointer ds-px-4 ds-py-3')
              .where((element) => element.text == 'Records by team');
          if (rec1.isNotEmpty) {
            rec1 = rec1.first.parentNode.children.last
                .getElementsByTagName('li')
                .where((element) => (element.text == iplmatch["Team1"] ||
                    element.text == iplmatch["Team1_short"]));
            if (rec1.isNotEmpty) {
              iplmatch['team1_stats_link'] =
                  rec1.first.getElementsByTagName('a')[0].attributes['href'];
              // print('rec1 ${rec1.first.attributes["href"]}');
              matches.add(iplmatch);
            }
          } else if (rec1.isEmpty) {
            iplmatch['team1_stats_link'] =
                link3.toList()[0].attributes["href"].toString();
            matches.add(iplmatch);
          }
          print(
              'rec11 ${rec1.first.text} ${rec1.first.getElementsByTagName('a')[0].attributes['href']} ');

          if (rec2.isNotEmpty) {
            rec2 = rec2.first.parentNode.children.last
                .getElementsByTagName('li')
                .where((element) => (element.text == iplmatch["Team2"] ||
                    element.text == iplmatch["Team2_short"]));

            if (rec2.isNotEmpty) {
              iplmatch['team2_stats_link'] =
                  rec1.first.getElementsByTagName('a')[0].attributes['href'];
              //print('rec2 ${rec2.first.attributes["href"]}');
              matches.add(iplmatch);
            }
          } else if (rec2.isEmpty) {
            iplmatch['team2_stats_link'] =
                link3.toList()[0].attributes["href"].toString();
            matches.add(iplmatch);
          }
        }
      }
    }
    print('asa11 ${matches.toSet().toList()}');
    return matches.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> matchstatetitle =
        (tableshow == true) ? ['Matches', 'Points table'] : ['Matches'];

    double screenheight = MediaQuery.of(context).size.height;

    // UTCtoLocal('Today, 3:15 am');
    Future<void> _refresh() async {
      snapshot = [];
      await Future.delayed(const Duration(milliseconds: 5));
      getlivematches(globals.league_page).then((value) {
        setState(() {
          _refreshIndicator = GlobalKey<RefreshIndicatorState>();
          variable = value;
          snapshot = variable;
        });
      });
    }

    var AppBar1 = AppBar(
      backgroundColor: const Color(0xffFFB72B),
      // title: const Text(
      //   'Current/Upcoming Matches',
      //   style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
      // ),
      leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
    return Scaffold(
        appBar: AppBar1,
        body: Builder(builder: (context) {
          return RefreshIndicator(
            key: _refreshIndicator,
            color: const Color(0xffFFB72B),
            backgroundColor: const Color(0xff2B2B28),
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xff2B2B28),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: matchstatetitle
                              .map(
                                (e) => Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: _currentSlide ==
                                            matchstatetitle.indexOf(e)
                                        ? const BorderSide(
                                            //                   <--- right side
                                            color: Colors.white,
                                            width: 3.0,
                                          )
                                        : BorderSide.none,
                                  )),
                                  child: TextButton(
                                    onPressed: () {
                                      _controller.jumpToPage(
                                          matchstatetitle.indexOf(e));
                                      setState(() {
                                        _currentSlide =
                                            matchstatetitle.indexOf(e);
                                      });
                                    },
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Cocosharp',
                                        fontSize: 15.0,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        initialPage: _currentSlide,
                        height: _currentSlide == 0
                            ? (screenheight > (snapshot.length * 310.0))
                                ? screenheight
                                : snapshot.length * 310.0
                            : screenheight,

                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },

                        // autoPlay: false,
                      ),
                      items: [
                        snapshot.isEmpty
                            ? Container(
                                color: const Color(0xff2B2B28),
                                child: SkeletonTheme(
                                    shimmerGradient: LinearGradient(colors: [
                                      const Color(0xff1A3263).withOpacity(0.8),
                                      const Color(0xff1A3263),
                                      const Color(0xff1A3263),
                                      const Color(0xff1A3263).withOpacity(0.8),
                                    ]),
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (context, index) =>
                                          NewsCardSkelton(),
                                    )))
                            : snapshot == null
                                ? Container(
                                    color: const Color(0xff2B2B28),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('  Oh My CrickOh! ',
                                            style: TextStyle(
                                              fontFamily: 'Litsans',
                                              fontSize: 20.0,
                                              color: Colors.white,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text('Stats not available.',
                                            style: TextStyle(
                                              fontFamily: 'Litsans',
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
                                  )
                                : Column(
                                    children: snapshot
                                        .map(
                                          (e) => AnimationConfiguration
                                              .staggeredList(
                                            duration: const Duration(
                                                milliseconds: 570),
                                            position: snapshot.indexOf(e),
                                            child: FadeInAnimation(
                                              child: SlideAnimation(
                                                verticalOffset: -900,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 310,
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.4))),
                                                        color: themecolor,
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.white,
                                                        child: InkWell(
                                                          onTap: () {
                                                            // if (e['team1_score']
                                                            //         .isEmpty &&
                                                            //     e['team2_score']
                                                            //         .isEmpty) {
                                                            //   Navigator.push(
                                                            //       context,
                                                            //       MaterialPageRoute(
                                                            //         builder: (context) =>
                                                            //             const typeofstats(
                                                            //           disablerecentstats: false,
                                                            //         ),
                                                            //       ));
                                                            // } else {
                                                            //   ScaffoldMessenger.of(context)
                                                            //       .showSnackBar(const SnackBar(
                                                            //     backgroundColor: Colors.grey,
                                                            //     duration: Duration(seconds: 2),
                                                            //     content: Text(
                                                            //       'Stats are not shown once the match has started/completed !!',
                                                            //       style: TextStyle(
                                                            //           fontSize: 14,
                                                            //           color: Colors.black,
                                                            //           fontFamily: 'Cocosharp'),
                                                            //     ),
                                                            //   ));
                                                            //   // Navigator.push(
                                                            //   //     context,
                                                            //   //     MaterialPageRoute(
                                                            //   //       builder: (context) =>
                                                            //   //           typeofstats(
                                                            //   //         disablerecentstats: true,
                                                            //   //       ),
                                                            //   //     ));
                                                            // }
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const typeofstats(
                                                                    disablerecentstats:
                                                                        false,
                                                                  ),
                                                                ));
                                                            setState(() {
                                                              globals.team1_name =
                                                                  e['Team1']
                                                                      .trim();
                                                              globals.team2_name =
                                                                  e['Team2']
                                                                      .trim();
                                                              globals.team1__short_name =
                                                                  e['Team1_short']
                                                                      .trim();
                                                              globals.team2__short_name =
                                                                  e['Team2_short']
                                                                      .trim();
                                                              globals.team1_stats_link =
                                                                  e['team1_stats_link'];
                                                              globals.team2_stats_link =
                                                                  e['team2_stats_link'];
                                                              globals
                                                                  .ground = e[
                                                                      'Ground']
                                                                  .toString()
                                                                  .trim();
                                                              globals.team1logo =
                                                                  e['team1logo'];
                                                              globals.team2logo =
                                                                  e['team2logo'];
                                                              globals.ontap = e[
                                                                  'linkaddress'];
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                      colors: [
                                                                        const Color(
                                                                            0xff1A3263),
                                                                        const Color(0xff1A3263)
                                                                            .withOpacity(0.8),
                                                                      ],
                                                                    )),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          30,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child: Text(
                                                                          e[
                                                                              'Details'],
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Litsans',
                                                                            fontSize:
                                                                                15.0,
                                                                            color:
                                                                                themecolor,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  color:
                                                                      darkcolor,
                                                                  thickness: 2,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        e['team1logo'] !=
                                                                                null
                                                                            ? IconButton(
                                                                                icon: CachedNetworkImage(
                                                                                  imageUrl: rootLogo + e['team1logo'],
                                                                                ),
                                                                                onPressed: null)
                                                                            : IconButton(icon: Image.asset('logos/team1.png'), onPressed: null),
                                                                        Flexible(
                                                                          child: Text(
                                                                              e['Team1'],
                                                                              style: TextStyle(
                                                                                fontFamily: 'Litsans',
                                                                                fontSize: 15.0,
                                                                                color: themecolor,
                                                                              )),
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              ' - ',
                                                                              style: TextStyle(
                                                                                fontSize: 25.0,
                                                                                color: themecolor,
                                                                              )),
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              e['team1_score'],
                                                                              style: globals.Litsanswhite),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        e['team1logo'] !=
                                                                                null
                                                                            ? IconButton(
                                                                                icon: CachedNetworkImage(
                                                                                  imageUrl: rootLogo + e['team2logo'],
                                                                                ),
                                                                                onPressed: null)
                                                                            : IconButton(icon: Image.asset('logos/team2.png'), onPressed: null),
                                                                        Flexible(
                                                                          child: Text(
                                                                              e['Team2'].trim(),
                                                                              style: TextStyle(
                                                                                fontFamily: 'Litsans',
                                                                                fontSize: 15.0,
                                                                                color: themecolor,
                                                                              )),
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              ' - ',
                                                                              style: TextStyle(
                                                                                fontSize: 25.0,
                                                                                color: themecolor,
                                                                              )),
                                                                        ),
                                                                        Text(
                                                                          e['team2_score'],
                                                                          style:
                                                                              globals.Litsanswhite,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: (e['MatchStarts']
                                                                          .toString()
                                                                          .contains(
                                                                              'won'))
                                                                      ? Text(
                                                                          e[
                                                                              'MatchStarts'],
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'Litsans',
                                                                            fontSize:
                                                                                20.0,
                                                                            color:
                                                                                Colors.greenAccent,
                                                                          ))
                                                                      : Text(
                                                                          e[
                                                                              'MatchStarts'],
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'Litsans',
                                                                            fontSize:
                                                                                20.0,
                                                                            color:
                                                                                Colors.amberAccent,
                                                                          )),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()),
                        tableshow == true
                            ? Container(
                                // height: screenheight,
                                color: const Color(0xff2B2B28),
                                child: const pointsTableUI())
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

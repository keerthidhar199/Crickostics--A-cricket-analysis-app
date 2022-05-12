import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/result_class.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;

class team_results extends StatefulWidget {
  /// Creates the home page.
  team_results({Key key}) : super(key: key);

  @override
  _team_resultsState createState() => _team_resultsState();
}

class _team_resultsState extends State<team_results> {
  TeamResultsDataSource teamResultsDataSource;
  HistoryDataSource historyDataSource;
  getAbbreviation(String s) {
    var l = s.split(' ');
    String res = '';
    for (var i in l) {
      res += i[0].toUpperCase();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Color(0xffFFB72B),
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Container(
          color: Color(0xff2B2B28),
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<Tuple2<List<String>, List<Result>>>(
            future: getData(), // async work
            builder: (BuildContext context,
                AsyncSnapshot<Tuple2<List<String>, List<Result>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> thetwoteams = [
                      globals.team1_name,
                      globals.team2_name
                    ];
                    List<Widget> category = [];

                    for (int k = 0; k < thetwoteams.length; k++) {
                      Map<String, List<dynamic>> won = {};
                      Map<String, List<dynamic>> lost = {};
                      if (thetwoteams[k].contains('Bangalore') ||
                          thetwoteams[k].contains('Kolkata')) {
                        thetwoteams[k] = getAbbreviation(thetwoteams[k]).trim();
                      }
                      // Bombarding the original list into those which are won and lost by the globals.team1 and globals.team2
                      // (which are taken from the homepage card )
                      List<Result> winning =
                          snapshot.data.item2.where((element) {
                        return thetwoteams[k].contains(element.winner);
                      }).toList(); // winning list
                      List<Result> losing =
                          snapshot.data.item2.where((element) {
                        return (thetwoteams[k].contains(element.team1) ||
                                thetwoteams[k].contains(element.team2)) &&
                            (!thetwoteams[k].contains(element.winner));
                      }).toList(); //losing list

                      //Now converting these lists into maps that has the same data categorized based on ground/venue played
                      for (var element in winning) {
                        String which = (thetwoteams[k].contains(element.team2)
                            ? element.team1
                            : element.team2);
                        ;
                        if (!won.containsKey(element.ground)) {
                          won[element.ground] = [1];

                          won[element.ground].add(which);
                        } else {
                          won[element.ground][0] += 1;
                          won[element.ground][1] += ', ' + (which);
                        }
                      } // won={Brabourne: [2, Super Kings, Mumbai], DY Patil: [2, Sunrisers, Capitals]}
                      for (var element in losing) {
                        String which = (thetwoteams[k].contains(element.team2)
                            ? element.team1
                            : element.team2);
                        ;
                        if (!lost.containsKey(element.ground)) {
                          lost[element.ground] = [1];
                          lost[element.ground].add(which);
                        } else {
                          lost[element.ground][0] += 1;
                          lost[element.ground][1] += ', ' + (which);
                        }
                      } // lost {Wankhede: [2, Titans, Royals]}

                      //To get the table form of these map data we need to again convert them to lists and assign classes for them
                      //since wondata and lostdata has the same number of parameters creating class for any one of them is sufficient. I did using class Won.
                      List<Won> wonData = won.entries
                          .map((entry) => Won(
                              entry.value[0].toString(),
                              entry.key.toString(), //
                              entry.value.sublist(1).toString()))
                          .toList(); // objects for class Won created like Won(Brabourne,2,;)
                      List<Won> lostData = lost.entries
                          .map((entry) => Won(
                              entry.value[0].toString(),
                              entry.key.toString(), //
                              entry.value.sublist(1).toString()))
                          .toList();
                      print('ground_based_history $won');
                      print('ground_based_history $lost');
                      List<List<Won>> array = [wonData, lostData];
                      List<String> coltitles = ['Matches Won', 'Matches Lost'];
                      List<String> headings = ['Wins', 'Lost'];

                      //table details of the team
                      Widget bowling = Column(
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
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Image.asset(
                                        'logos/' + thetwoteams[k] + '.png'),
                                    onPressed: null),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    print('Clicked');
                                  },
                                  child: SizedBox(
                                    height: 40.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        '${thetwoteams[k]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Cocosharp',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SfDataGrid(
                              verticalScrollPhysics:
                                  NeverScrollableScrollPhysics(),
                              rowHeight: 35.0,
                              shrinkWrapRows: true,
                              allowSorting: true,
                              source: TeamResultsDataSource(
                                  teamResultsDataSource:
                                      snapshot.data.item2.where((element) {
                                return (thetwoteams[k]
                                        .contains(element.team1) ||
                                    thetwoteams[k].contains(element.team2));
                              }).toList()),
                              columnWidthMode: ColumnWidthMode.auto,
                              selectionMode: SelectionMode.multiple,
                              columns: snapshot.data.item1.map((headings) {
                                return GridColumn(
                                    columnName: headings.toLowerCase(),
                                    label: Container(
                                        padding: EdgeInsets.all(16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          headings.trim()[0].toUpperCase() +
                                              headings
                                                  .trim()
                                                  .substring(1)
                                                  .toLowerCase(),
                                        )));
                              }).toList()),
                        ],
                      );
                      //table details of the team1
                      Widget history = Container(
                        child: Column(
                          children: [
                            for (var i = 0; i < array.length; i++)
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff19388A),
                                        Color(0xff4F91CD),
                                      ],
                                    )),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          '${headings[i]}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: 'Cocosharp',
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SfDataGrid(
                                    verticalScrollPhysics:
                                        NeverScrollableScrollPhysics(),
                                    rowHeight: 35.0,
                                    shrinkWrapRows: true,
                                    allowSorting: true,
                                    source: HistoryDataSource(
                                        historyDataSource: array[i]),
                                    columnWidthMode: ColumnWidthMode.auto,
                                    selectionMode: SelectionMode.multiple,
                                    columns: [
                                      GridColumn(
                                          columnName: 'ground',
                                          label: Container(
                                              padding: EdgeInsets.all(16.0),
                                              alignment: Alignment.center,
                                              child: Text('Ground'))),
                                      GridColumn(
                                          columnName: 'matches_won',
                                          label: Container(
                                              padding: EdgeInsets.all(16.0),
                                              alignment: Alignment.center,
                                              child: Text(coltitles[i]))),
                                      GridColumn(
                                          columnName: 'opposition',
                                          label: Container(
                                              padding: EdgeInsets.all(16.0),
                                              alignment: Alignment.center,
                                              child: Text('Opposition'))),
                                    ],
                                  )
                                ],
                              ),
                          ],
                        ),
                      );
                      //table details of the team1
                      category.add(Container(
                        width: MediaQuery.of(context).size.width - 15,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              )),
                          color: Colors.white,
                          elevation: 10,
                          shadowColor: Colors.blue,
                          child: SingleChildScrollView(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white38,
                                      Colors.white60,
                                    ],
                                  )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            'Team History ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Cocosharp',
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'logos/bowling.png',
                                        color: Colors.black,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                                bowling,
                                history
                              ],
                            ),
                          )),
                        ),
                      ));
                    }
                    List<Widget> list = category;
                    return Builder(
                      builder: (context) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: MediaQuery.of(context).size.height,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            // autoPlay: false,
                          ),
                          items: list,
                        );
                      },
                    );
                  }
              }
            },
          ),
        ));
  }

  //WEBSCRAPING

//Loading the above data to Future function
  Future<Tuple2<List<String>, List<Result>>> getData() async {
    List<List<String>> teams_results = [];
    List<String> team_results_headings = [];
    // return Tuple2(teams_batting_headings, batting_playersdata1);
    var root = 'https://stats.espncricinfo.com';

    var league_page = globals.league_page
        .getElementsByClassName("RecordLinks")
        .where(
            (element) => element.attributes['href'].contains('match_results'));
    print(league_page);
    if (league_page.length != 0) {
      print('lqeu');
      print('league1 ${league_page.first.attributes["href"]}');
    }
    var team_result_info = await http.Client()
        .get(Uri.parse(root + league_page.first.attributes["href"]));

    var value3 = await teams_results_info(team_result_info, globals.team1_name);
    teams_results = value3.item2;
    team_results_headings = value3.item1;

    List<Result> team_results = [];
    print('teams_results $teams_results');
    for (var i in teams_results) {
      print(i);
      if (i[2].toString().contains('-')) {
        team_results.add(Result(
          i[0].toString().trim(),
          i[1].toString().trim(),
          'Ongoing',
          'Ongoing',
          i[3].toString().trim(),
          i[4].toString().trim(),
          i[5].toString().trim(),
        ));
      } else {
        team_results.add(Result(
          i[0].toString().trim(),
          i[1].toString().trim(),
          i[2].toString().trim(),
          i[3].toString().trim(),
          i[4].toString().trim(),
          i[5].toString().trim(),
          i[6].toString().trim(),
        ));
      }
    }
    Tuple2<List<String>, List<Result>> hun =
        Tuple2(team_results_headings, team_results); //bowling data overall
    print(hun);

    return hun; //((batting_headers_table,batting_players),(bowling_headers_table,bowling_players))
  }
}

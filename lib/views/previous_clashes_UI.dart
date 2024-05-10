import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:datascrap/globals.dart' as globals;

import '../analysis.dart';

class pastmatches extends StatefulWidget {
  final snapshot;
  const pastmatches({Key? key, this.snapshot}) : super(key: key);

  @override
  State<pastmatches> createState() => _pastmatchesState(snapshot);
}

class _pastmatchesState extends State<pastmatches> {
  Tuple3<
      Tuple2<List<String>, List<Batting_player>>,
      Tuple2<List<String>, List<Player>>,
      Tuple2<List<String>, List<Partnership>>> snapshot;
  final DataGridController dataGridController = DataGridController();
  final DataGridController dataGridController1 = DataGridController();

  final DataGridController dataGridController2 = DataGridController();

  List<String> battinghiddenColumns = [
    'fours',
    'sixes',
    'Opposition',
    'Ground',
    'Match Date',
    'Team'
  ];
  List<String> bowlinghiddenColumns = [
    'Opposition',
    'Ground',
    'Match Date',
    'Team'
  ];

  _pastmatchesState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    Widget previousClashes = Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
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
                SizedBox(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Batting',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Montserrat-Black',
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          (snapshot.item1 == null)
              ? const Text('Not yet batted')
              : Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          List previousmatchfantasy = [];
                          for (var k in dataGridController.selectedRows) {
                            var acc = k.getCells();
                            previousmatchfantasy.add(
                                '${acc[0].value} ${acc[1].value} ${acc[5].value}');
                          }
                          Analysis.previousmatchmap[
                                  '${'${globals.league_page +
                              '_' +
                              globals.team1_name}vs' + globals.team2_name}_headtohead_batting'] =
                              previousmatchfantasy;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepOrange),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      child: const Text('+Add to Fantasy',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SfDataGrid(
                        verticalScrollPhysics:
                            const NeverScrollableScrollPhysics(),
                        rowHeight: 35.0,
                        shrinkWrapRows: true,
                        checkboxColumnSettings:
                            const DataGridCheckboxColumnSettings(
                                showCheckboxOnHeader: false),
                        showCheckboxColumn: true,
                        allowSorting: true,
                        controller: dataGridController,
                        source: BattingDataSource(
                            batData: snapshot.item1.item2.where((element) {
                          //Just having a check with both the name and the abbreviation of the team.
                          // For example, both 'United States of America' and 'U.S.A'
                          return ((((globals.team1_name.contains(element.team)) ||
                      globals.team1__short_name.contains(element.team)) &&
                                  ((globals.team2_name).contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()) ||
                                      globals.team2__short_name.contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()))) ||
                              ((globals.team2_name.contains(element.team)) ||
                      globals.team2__short_name.contains(element.team) &&
                                  (globals.team1_name.contains(element.opposition
                                          .replaceAll('v', '')
                                          .trim()) ||
                                      globals.team1__short_name.contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()))));
                        }).toList()),
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                        selectionMode: SelectionMode.multiple,
                        columns: snapshot.item1.item1.map((headings) {
                          return GridColumn(
                              columnName: headings.toLowerCase(),
                              label: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    headings.trim()[0].toUpperCase() +
                                        headings
                                            .trim()
                                            .substring(1)
                                            .toLowerCase(),
                                  )),
                              visible: !battinghiddenColumns.contains(headings));
                        }).toList()),
                  ],
                ),
          Container(
            decoration: const BoxDecoration(
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
                SizedBox(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Bowling',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Montserrat-Black',
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          (snapshot.item2 == null)
              ? const Text('Not yet bowled')
              : Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          List previousmatchfantasy = [];
      
                          for (var k in dataGridController1.selectedRows) {
                            var acc = k.getCells();
                            previousmatchfantasy.add(
                                '${acc[0].value} ${acc[1].value} ${acc[3].value} ${acc[4].value}');
                          }
                          Analysis.previousmatchmap[
                                  '${'${globals.league_page +
                              '_' +
                              globals.team1_name}vs' + globals.team2_name}_headtohead_bowling'] =
                              previousmatchfantasy;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepOrange),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      child: const Text('+Add to Fantasy',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SfDataGrid(
                        verticalScrollPhysics:
                            const NeverScrollableScrollPhysics(),
                        rowHeight: 35.0,
                        shrinkWrapRows: true,
                        checkboxColumnSettings:
                            const DataGridCheckboxColumnSettings(
                                showCheckboxOnHeader: false),
                        showCheckboxColumn: true,
                        controller: dataGridController1,
                        allowSorting: true,
                        source: bowlingDataSource(
                            bowlingData: snapshot.item2.item2.where((element) {
                          return ((((globals.team1_name.contains(element.team)) ||
                      globals.team1__short_name.contains(element.team))&&
                                  ((globals.team2_name).contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()) ||
                                      globals.team2__short_name.contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()))) ||
                            ((globals.team2_name.contains(element.team)) ||
                      globals.team2__short_name.contains(element.team) &&
                                  (globals.team1_name.contains(element.opposition
                                          .replaceAll('v', '')
                                          .trim()) ||
                                      globals.team1__short_name.contains(element
                                          .opposition
                                          .replaceAll('v', '')
                                          .trim()))));
                        }).toList()),
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                        selectionMode: SelectionMode.multiple,
                        columns: snapshot.item2.item1.map((headings) {
                          return GridColumn(
                              columnName: headings.toLowerCase(),
                              label: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    headings.trim()[0].toUpperCase() +
                                        headings
                                            .trim()
                                            .substring(1)
                                            .toLowerCase(),
                                  )),
                              visible: !bowlinghiddenColumns.contains(headings));
                        }).toList()),
                  ],
                ),
          // Container(
          //   decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color(0xff19388A),
          //       Color(0xff4F91CD),
          //     ],
          //   )),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         height: 40.0,
          //         width: MediaQuery.of(context).size.width * 0.6,
          //         child: const Padding(
          //           padding: EdgeInsets.all(6.0),
          //           child: Text(
          //             'Partnerships',
          //             textAlign: TextAlign.left,
          //             style: TextStyle(
          //               fontFamily: 'Montserrat-Black',
          //               fontSize: 20.0,
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // (snapshot == null ||
          //         snapshot.item3 == null ||
          //         snapshot.item3.item2 == null)
          //     ? const Text('No partnerships so far')
          //     : Column(
          //         children: [
          //           TextButton(
          //             onPressed: () {
          //               setState(() {
          //                 List previousmatchfantasy = [];
      
          //                 for (var k in dataGridController2.selectedRows) {
          //                   var acc = k.getCells();
          //                   previousmatchfantasy
          //                       .add('${acc[0].value} &${acc[1].value}');
          //                 }
          //                 Analysis.previousmatchmap[globals.league_page +
          //                     '_' +
          //                     globals.team1_name +
          //                     'vs' +
          //                     globals.team2_name +
          //                     '_headtohead_partnership'] = previousmatchfantasy;
          //               });
          //               print('Previous clashes ${Analysis.previousmatchmap}');
          //             },
          //             style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.all(Colors.deepOrange),
          //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(20.0),
          //                 ))),
          //             child: const Text('+Add to Fantasy',
          //                 style: TextStyle(
          //                   fontFamily: 'Montserrat-Black',
          //                   fontSize: 15,
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                 )),
          //           ),
          //           SfDataGrid(
          //               verticalScrollPhysics:
          //                   const NeverScrollableScrollPhysics(),
          //               rowHeight: 35.0,
          //               shrinkWrapRows: true,
          //               showCheckboxColumn: true,
          //               checkboxColumnSettings:
          //                   const DataGridCheckboxColumnSettings(
          //                       showCheckboxOnHeader: false),
          //               allowSorting: true,
          //               controller: dataGridController2,
          //               source: PartnershipDataSource(
          //                   Data: snapshot.item3.item2.where((element) {
          //                 return (((globals.team1_name.contains(element.team)) &&
          //                         ((globals.team2_name).contains(element
          //                                 .opposition
          //                                 .replaceAll('v', '')
          //                                 .trim()) ||
          //                             globals.team2__short_name.contains(element
          //                                 .opposition
          //                                 .replaceAll('v', '')
          //                                 .trim()))) ||
          //                     (globals.team2_name.contains(element.team) &&
          //                         (globals.team1_name.contains(element.opposition
          //                                 .replaceAll('v', '')
          //                                 .trim()) ||
          //                             globals.team1__short_name.contains(element
          //                                 .opposition
          //                                 .replaceAll('v', '')
          //                                 .trim()))));
          //               }).toList()),
          //               columnWidthMode: ColumnWidthMode.auto,
          //               selectionMode: SelectionMode.multiple,
          //               columns: snapshot.item3.item1.map((headings) {
          //                 return GridColumn(
          //                     columnName: headings.toLowerCase(),
          //                     label: Container(
          //                         padding: const EdgeInsets.all(16.0),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           headings.trim()[0].toUpperCase() +
          //                               headings
          //                                   .trim()
          //                                   .substring(1)
          //                                   .toLowerCase(),
          //                         )));
          //               }).toList()),
          //         ],
          //       ),
        ],
      ),
    );

    return previousClashes;
  }
}

class previous_clashes_header extends StatefulWidget {
  const previous_clashes_header({Key? key}) : super(key: key);

  @override
  State<previous_clashes_header> createState() =>
      _previous_clashes_headerState();
}

class _previous_clashes_headerState extends State<previous_clashes_header> {
  List<String> teamlogos = [globals.team1logo, globals.team2logo];
  List<String> teamnames = [globals.team1_name, globals.team2_name];
  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

  @override
  Widget build(BuildContext context) {
    Widget previousClashesHeader = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: 'Montserrat-Black',
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                teamlogos[0] != null
                    ? Image.network(
                        root_logo + teamlogos[0].toString(),
                        width: 32,
                        height: 32,
                      )
                    : IconButton(
                        icon: Image.asset('logos/team1.png'), onPressed: null),
              ],
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset(
                  'logos/previous clashes.png',
                  color: Colors.black,
                  width: 100,
                  height: 100,
                ),
                const Text('VS',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Black',
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Clashes',
                  style: TextStyle(
                    fontFamily: 'Montserrat-Black',
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                teamlogos[1] != null
                    ? Image.network(
                        root_logo + teamlogos[1].toString(),
                        width: 32,
                        height: 32,
                      )
                    : IconButton(
                        icon: Image.asset('logos/team2.png'), onPressed: null),
              ],
            ),
          ],
        ),
      ],
    );

    return previousClashesHeader;
  }
}

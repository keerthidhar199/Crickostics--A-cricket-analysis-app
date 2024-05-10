// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:datascrap/analysis.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/team_results.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;

class widgetbatting extends StatefulWidget {
  final snapshot;

  const widgetbatting({Key? key, this.snapshot}) : super(key: key);

  @override
  State<widgetbatting> createState() => _widgetbattingState(snapshot);
}

class _widgetbattingState extends State<widgetbatting> {
  Tuple3<
      Tuple2<List<String>, List<Batting_player>>,
      Tuple2<List<String>, List<Player>>,
      Tuple2<List<String>, List<Partnership>>> snapshot;
  List<String> short_teamnames = [
    globals.team1__short_name,
    globals.team2__short_name
  ];
  List<String> long_teamnames = [globals.team1_name, globals.team2_name];
  List<String> teamlogos = [globals.team1logo, globals.team2logo];

  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

  _widgetbattingState(this.snapshot);
  List<String> hiddenColumns = [
    'fours',
    'sixes',
    'Opposition',
    'Ground',
    'Match Date',
    'Team',
    'Player Link'
  ];
  @override
  Widget build(BuildContext context) {
    for (var i in snapshot.item1.item2) {
      if (i.ground == globals.ground && i.team == globals.team1_name) {
        print('snapsot ${i.player} ');
      }
    }
    // print(
    //     'snapsot ${snapshot.item1.item2.where((element) => element.ground == globals.ground && element.team == globals.team2__short_name).toList()}');
    DataGridController dataGridController = DataGridController();
    DataGridController dataGridController1 = DataGridController();
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (var i in short_teamnames)
            Column(
              children: [
                short_teamnames.indexOf(i) == 0
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            List team1Batfantasy = [];
                            print(
                                'assa11end1 ${dataGridController.selectedRows}');

                            for (var k in dataGridController.selectedRows) {
                              var acc = k.getCells();

                              print(
                                  'assa11end1 ${acc[0].value} ${acc[1].value} ${acc[5].value}');
                              team1Batfantasy.add(
                                  '${acc[0].value} ${acc[1].value} ${acc[5].value}');
                            }
                            Analysis.battersmap[
                                    '${'${globals.league_page + '_' + globals.team1_name + 'vs' + globals.team2_name}_' + globals.team1_name}_batting'] =
                                team1Batfantasy;

                            print('assa11end12 ${Analysis.battersmap}');
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepOrange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                        child: const Text('+Add to Fantasy',
                            style: TextStyle(
                              fontFamily: 'Montserrat-Black',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    : TextButton(
                        onPressed: () {
                          print(
                              'assa11end1 ${dataGridController1.selectedRows}');
                          setState(() {
                            List team2Batfantasy = [];
                            for (var k in dataGridController1.selectedRows) {
                              var acc = k.getCells();

                              print(
                                  'assa11end1 ${acc[0].value} ${acc[1].value} ${acc[5].value}');
                              team2Batfantasy.add(
                                  '${acc[0].value} ${acc[1].value} ${acc[5].value}');
                            }
                            Analysis.battersmap[
                                    '${'${globals.league_page + '_' + globals.team1_name + 'vs' + globals.team2_name}_' + globals.team2_name}_batting'] =
                                team2Batfantasy;
                            print('assa11end12 ${Analysis.battersmap}');
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepOrange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
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
                      teamlogos[short_teamnames.indexOf(i)] != null
                          ? Image.network(
                              root_logo +
                                  teamlogos[short_teamnames.indexOf(i)]
                                      .toString(),
                              width: 32,
                              height: 32,
                            )
                          : IconButton(
                              icon: Image.asset(
                                  'logos/team${short_teamnames.indexOf(i) + 1}.png'),
                              onPressed: null),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const team_results(),
                              ));
                        },
                        child: SizedBox(
                          height: 40.0,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              long_teamnames[short_teamnames.indexOf(i)],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: 'Montserrat-Black',
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
                (snapshot.item1 == null)
                    ? const Text('Not batted yet')
                    : SfDataGrid(
                        verticalScrollPhysics:
                            const NeverScrollableScrollPhysics(),
                        isScrollbarAlwaysShown: true,
                        showCheckboxColumn: true,
                        rowHeight: 35.0,
                        shrinkWrapRows: true,
                        controller: short_teamnames.indexOf(i) == 0
                            ? dataGridController
                            : dataGridController1,
                        sortingGestureType: SortingGestureType.tap,
                        allowSorting: true,
                        checkboxColumnSettings:
                            const DataGridCheckboxColumnSettings(
                                showCheckboxOnHeader: false),
                        source: BattingDataSource(
                            batData: snapshot.item1.item2
                                .where((element) =>
                                    element.ground == globals.ground &&
                                    (element.team == i ||
                                        element.team ==
                                            long_teamnames[
                                                short_teamnames.indexOf(i)]))
                                .toList()),
                        columnWidthMode: ColumnWidthMode.auto,
                        selectionMode: SelectionMode.multiple,
                        columns: snapshot.item1.item1.map(
                          (headings) {
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
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Montserrat-Black'),
                                    )),
                                visible: !hiddenColumns.contains(headings));
                          },
                        ).toList(),
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

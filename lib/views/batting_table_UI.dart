import 'package:datascrap/analysis.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/team_results.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;

class widgetbatting extends StatefulWidget {
  final snapshot;

  const widgetbatting({Key key, this.snapshot}) : super(key: key);

  @override
  State<widgetbatting> createState() => _widgetbattingState(this.snapshot);
}

class _widgetbattingState extends State<widgetbatting> {
  AsyncSnapshot<
      Tuple3<
          Tuple2<List<String>, List<Batting_player>>,
          Tuple2<List<String>, List<Player>>,
          Tuple2<List<String>, List<Partnership>>>> snapshot;
  List<String> teamnames = [globals.team1_name, globals.team2_name];
  List<String> teamlogos = [globals.team1logo, globals.team2logo];

  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

  _widgetbattingState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    DataGridController dataGridController = DataGridController();
    DataGridController dataGridController1 = DataGridController();
    return Column(
      children: [
        for (var i in teamnames)
          Column(
            children: [
              teamnames.indexOf(i) == 0
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          List team1_batfantasy = [];
                          print(
                              'assa11end1 ${dataGridController.selectedRows}');

                          for (var k in dataGridController.selectedRows) {
                            var acc = k.getCells();

                            print(
                                'assa11end1 ${acc[0].value} ${acc[1].value} ${acc[5].value}');
                            team1_batfantasy.add(
                                '${acc[0].value} ${acc[1].value} ${acc[5].value}');
                          }
                          Analysis.battersmap[globals.league_page +
                              '_' +
                              globals.team1_name +
                              '_batting'] = team1_batfantasy;
                          ;
                          print('assa11end12 ${Analysis.battersmap}');
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepOrange),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      child: const Text('+Add to Fantasy',
                          style: TextStyle(
                            fontFamily: 'Cocosharp',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  : TextButton(
                      onPressed: () {
                        print('assa11end1 ${dataGridController1.selectedRows}');
                        setState(() {
                          List team2_batfantasy = [];
                          for (var k in dataGridController1.selectedRows) {
                            var acc = k.getCells();

                            print(
                                'assa11end1 ${acc[0].value} ${acc[1].value} ${acc[5].value}');
                            team2_batfantasy.add(
                                '${acc[0].value} ${acc[1].value} ${acc[5].value}');
                          }
                          Analysis.battersmap[globals.league_page +
                              '_' +
                              globals.team2_name +
                              '_batting'] = team2_batfantasy;
                          print('assa11end12 ${Analysis.battersmap}');
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepOrange),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      child: const Text('+Add to Fantasy',
                          style: TextStyle(
                            fontFamily: 'Cocosharp',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
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
                    teamlogos[teamnames.indexOf(i)] != null
                        ? Image.network(
                            root_logo +
                                teamlogos[teamnames.indexOf(i)].toString(),
                            width: 32,
                            height: 32,
                          )
                        : IconButton(
                            icon: Image.asset('logos/team' +
                                (teamnames.indexOf(i) + 1).toString() +
                                '.png'),
                            onPressed: null),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => team_results(),
                            ));
                      },
                      child: SizedBox(
                        height: 40.0,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '${i}',
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
              snapshot.data.item1.item2 == null
                  ? Text('Not batted yet')
                  : SfDataGrid(
                      verticalScrollPhysics: NeverScrollableScrollPhysics(),
                      isScrollbarAlwaysShown: true,
                      showCheckboxColumn: true,
                      rowHeight: 35.0,
                      shrinkWrapRows: true,
                      controller: teamnames.indexOf(i) == 0
                          ? dataGridController
                          : dataGridController1,
                      sortingGestureType: SortingGestureType.tap,
                      allowSorting: true,
                      checkboxColumnSettings: DataGridCheckboxColumnSettings(
                          showCheckboxOnHeader: false),
                      source: BattingDataSource(
                          batData: snapshot.data.item1.item2
                              .where((element) =>
                                  element.team == i &&
                                  element.ground == globals.ground)
                              .toList()),
                      columnWidthMode: ColumnWidthMode.auto,
                      selectionMode: SelectionMode.multiple,
                      columns: snapshot.data.item1.item1.map(
                        (headings) {
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
                        },
                      ).toList(),
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
      ],
    );
  }
}

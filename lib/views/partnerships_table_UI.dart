import 'package:datascrap/analysis.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/team_results.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;

class widgetpartnership extends StatefulWidget {
  final snapshot;

  const widgetpartnership({Key? key, this.snapshot}) : super(key: key);

  @override
  State<widgetpartnership> createState() =>
      _widgetpartnershipState(snapshot);
}

class _widgetpartnershipState extends State<widgetpartnership> {
  Tuple3<
      Tuple2<List<String>, List<Batting_player>>,
      Tuple2<List<String>, List<Player>>,
      Tuple2<List<String>, List<Partnership>>> snapshot;
  final DataGridController dataGridController = DataGridController();
  final DataGridController dataGridController1 = DataGridController();
  List<String> teamnames = [globals.team1_name, globals.team2_name];
  List<String> teamlogos = [globals.team1logo, globals.team2logo];

  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';

  _widgetpartnershipState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i in teamnames)
          Column(
            children: [
              teamnames.indexOf(i) == 0
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          List team1Partnershipfantasy = [];
                          print(
                              'assa11end1 ${dataGridController.selectedRows}');

                          for (var k in dataGridController.selectedRows) {
                            var acc = k.getCells();

                            print(
                                'assa11end1 ${acc[0].value} &${acc[1].value}');
                            team1Partnershipfantasy
                                .add('${acc[0].value} &${acc[1].value}');
                          }
                          Analysis.partnershipsmap[
                                  '${'${globals.league_page +
                              '_' +
                              globals.team1_name +
                              'vs' +
                              globals.team2_name}_' + globals.team1_name}_partnership'] =
                              team1Partnershipfantasy;
                          print('assa11end12 ${Analysis.partnershipsmap}');
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
                          List team2Partnershipfantasy = [];
                          for (var k in dataGridController1.selectedRows) {
                            var acc = k.getCells();

                            print(
                                'assa11end1 ${acc[0].value} &${acc[1].value}}');
                            team2Partnershipfantasy
                                .add('${acc[0].value} &${acc[1].value}');
                          }
                          Analysis.partnershipsmap[
                                  '${'${globals.league_page +
                              '_' +
                              globals.team1_name +
                              'vs' +
                              globals.team2_name}_' + globals.team2_name}_partnership'] =
                              team2Partnershipfantasy;
                          print('assa11end12 ${Analysis.partnershipsmap}');
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
                    teamlogos[teamnames.indexOf(i)] != null
                        ? Image.network(
                            root_logo +
                                teamlogos[teamnames.indexOf(i)].toString(),
                            width: 32,
                            height: 32,
                          )
                        : IconButton(
                            icon: Image.asset(
                                'logos/team${teamnames.indexOf(i) + 1}.png'),
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
                            i,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
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
              (snapshot.item3 == null)
                  ? const Text('No partnerships so far')
                  : SfDataGrid(
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      isScrollbarAlwaysShown: true,
                      rowHeight: 35.0,
                      shrinkWrapRows: true,
                      showCheckboxColumn: true,
                      controller: teamnames.indexOf(i) == 0
                          ? dataGridController
                          : dataGridController1,
                      sortingGestureType: SortingGestureType.tap,
                      allowSorting: true,
                      checkboxColumnSettings:
                          const DataGridCheckboxColumnSettings(
                              showCheckboxOnHeader: false),
                      source: PartnershipDataSource(
                          Data: snapshot.item3.item2
                              .where((element) =>
                                  element.team == i &&
                                  element.ground == globals.ground)
                              .toList()),
                      columnWidthMode: ColumnWidthMode.auto,
                      selectionMode: SelectionMode.multiple,
                      columns: snapshot.item3.item1.map((headings) {
                        return GridColumn(
                            columnName: headings.toLowerCase(),
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  globals.capitalize(headings),
                                  style: const TextStyle(
                                      fontFamily: 'Cocosharp'),
                                )));
                      }).toList()),
              const SizedBox(
                height: 20,
              ),
            ],
          )
      ],
    );
  }
}

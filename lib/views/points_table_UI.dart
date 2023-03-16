import 'package:datascrap/analysis.dart';
import 'package:datascrap/models/bowling_class.dart';
import 'package:datascrap/models/partnership_class.dart';
import 'package:datascrap/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:datascrap/models/batting_class.dart';
import 'package:datascrap/team_results.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;

import '../models/points_table_class.dart';

class pointsTableUI extends StatelessWidget {
  const pointsTableUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple2<List<String>, List<PointsTable>>>(
      future: point_teams_info(globals.league_page_address), // async work
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<List<String>, List<PointsTable>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff19388A),
                        Color(0xff4F91CD),
                      ],
                    )),
                    child: Text(
                      '${globals.league_page} \n Points Table',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Cocosharp'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SfDataGrid(
                    verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                    horizontalScrollPhysics:
                        const NeverScrollableScrollPhysics(),
                    rowHeight: 35.0,
                    shrinkWrapRows: true,
                    allowSorting: true,
                    source: PointsTableSource(pointsData: snapshot.data.item2),
                    columnWidthMode: ColumnWidthMode.auto,
                    selectionMode: SelectionMode.multiple,
                    columns: snapshot.data.item1.map(
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
                                      color: Colors.white,
                                      fontFamily: 'NewAthletic'),
                                )));
                      },
                    ).toList(),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}

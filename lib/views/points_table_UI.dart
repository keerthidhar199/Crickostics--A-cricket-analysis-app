import 'dart:convert';

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
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
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
            if (snapshot.data == null) {
              return Center(
                  child: Container(
                      color: Colors.blueGrey,
                      child: const Text(
                        'Table Data not available',
                        style: TextStyle(
                            fontFamily: 'NewAthletic',
                            fontSize: 25,
                            color: Colors.white),
                      )));
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
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
                  Expanded(
                    child: SfDataGrid(
                      shrinkWrapRows: true,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      source:
                          PointsTableSource(pointsData: snapshot.data.item2),
                      defaultColumnWidth: 150,
                      rowHeight: 100,
                      // columnWidthMode: ColumnWidthMode.fill,
                      selectionMode: SelectionMode.multiple,
                      columns: snapshot.data.item1.map(
                        (headings) {
                          return GridColumn(
                              columnName: headings.toLowerCase(),
                              columnWidthMode:
                                  snapshot.data.item1.indexOf(headings) != 0
                                      ? ColumnWidthMode.lastColumnFill
                                      : ColumnWidthMode.none,
                              label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    globals.capitalize(headings),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NewAthletic'),
                                  )));
                        },
                      ).toList(),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}

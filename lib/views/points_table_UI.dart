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
            {
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
                      // ignore: unnecessary_string_interpolations
                      '${globals.league_page}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Litsans'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: SfDataGrid(
                      horizontalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      source:
                          PointsTableSource(pointsData: snapshot.data.item2),
                      defaultColumnWidth:
                          MediaQuery.of(context).size.width * 0.32,
                      // columnWidthMode: ColumnWidthMode.fill,
                      selectionMode: SelectionMode.multiple,
                      columns: snapshot.data.item1.map(
                        (headings) {
                          return GridColumn(
                              columnName: headings.toLowerCase(),
                              columnWidthMode: [
                                1,
                                2
                              ].contains(snapshot.data.item1.indexOf(headings))
                                  ? ColumnWidthMode.fill
                                  : ColumnWidthMode.none,
                              label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    headings,
                                    style: const TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontFamily: 'Litsans'),
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

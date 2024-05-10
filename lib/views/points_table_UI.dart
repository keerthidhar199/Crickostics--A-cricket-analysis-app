// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;
import '../models/points_table_class.dart';

class pointsTableUI extends StatelessWidget {
  const pointsTableUI({Key? key}) : super(key: key);

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
              if (snapshot.data != null) {
                var data = snapshot.data!;
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
                        ),
                      ),
                      child: Text(
                        // ignore: unnecessary_string_interpolations
                        '${globals.league_page}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Montserrat-Black',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: SfDataGrid(
                        horizontalScrollPhysics:
                            const NeverScrollableScrollPhysics(),
                        source: PointsTableSource(pointsData: data.item2),
                        defaultColumnWidth:
                            MediaQuery.of(context).size.width * 0.32,
                        selectionMode: SelectionMode.multiple,
                        columns: data.item1.map(
                          (headings) {
                            return GridColumn(
                              columnName: headings.toLowerCase(),
                              columnWidthMode: [
                                1,
                                2
                              ].contains(data.item1.indexOf(headings))
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
                                    fontFamily: 'Montserrat-Black',
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('No data available'),
                );
              }
            }
        }
      },
    );
  }
}

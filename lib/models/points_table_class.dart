import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';
import 'package:datascrap/globals.dart' as globals;

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
///
class PointsTable {
  /// Creates the employee class with required details.
  PointsTable(this.teamname, this.points, this.nrr, this.seriesform);

  final String teamname;
  final int points;
  final double nrr;
  final String seriesform;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class PointsTableSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PointsTableSource({List<PointsTable> pointsData}) {
    _pointsData = pointsData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Team', value: e.teamname),
              DataGridCell<int>(columnName: 'Points', value: e.points),
              DataGridCell<double>(columnName: 'NRR', value: e.nrr),
              DataGridCell<String>(
                  columnName: 'Series Form', value: e.seriesform),
            ]))
        .toList();
  }
  String root_logo =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
  List<DataGridRow> _pointsData = [];

  @override
  List<DataGridRow> get rows => _pointsData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          style: TextStyle(color: Colors.black87),
        ),
      );
    }).toList());
  }
}

point_teams_info(String league_address) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];
  league_address = league_address.replaceAll(
      league_address.split('/').last, 'points-table-standings');
  var forlink2 = await http.Client().get(Uri.parse(league_address));
  dom.Document document1 = parser.parse(forlink2.body);
  // print(document
  //     .querySelectorAll('table.engineTable>tbody')[1]
  //     .text
  //     .contains('Records'));
  var headers1 = document1.querySelectorAll('table>thead>tr')[0];
  var titles1 = headers1.querySelectorAll('th');
  print('$titles1');

  titles1.removeWhere((element) => element.text.isEmpty);
  headings.add(titles1[0].text.toString().trim());
  headings.add(titles1[6].text.toString().trim());
  headings.add(titles1[7].text.toString().trim());
  headings.add(titles1[8].text.toString().trim());

  var element = document1.querySelectorAll('table>tbody')[0];
  var data = element.querySelectorAll('tr');
  data.removeWhere((element) => element.text.isEmpty);
  for (int i = 0; i < data.length; i++) {
    List<String> playerwise = [];
    print('----  ${data[i].children[0]}');
    // for (int j = 0; j < data[i].children.length; j++) {
    //   if (data[i].children[j].text.isNotEmpty) {
    //     playerwise.add(data[i].children[j].text.toString().trim());
    //   }
    // }
    // allplayers.add(playerwise);
  }

  // print(headings);
  // print(allplayers);
  // print(allplayers[0].length);
  // print(headings.length);
  // ground_based = allplayers
  //     .where((stats) => stats.elementAt(7) == globals.ground)
  //     .toList();
  return Tuple2(headings, allplayers);
}

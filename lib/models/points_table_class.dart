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
        color: Colors.grey.shade600,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value.toString().trim(),
          style:
              const TextStyle(color: Colors.white, fontFamily: 'NewAthletic'),
        ),
      );
    }).toList());
  }
}

Future<Tuple2<List<String>, List<PointsTable>>> point_teams_info(
    String league_address) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];

  List<PointsTable> pointstableinfo = [];
  List<String> pointstablehead = [];
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
  int index = titles1.indexWhere((element) => element.text == 'Series Form');
  headings.add(titles1[0].text.toString().trim());
  headings.add(titles1[index - 1].text.toString().trim());
  headings.add(titles1[index - 2].text.toString().trim());
  headings.add(titles1[index].text.toString().trim());

  var element = document1.querySelectorAll('table>tbody')[0];
  var data = element.querySelectorAll('tr');
  data.removeWhere((element) => element.text.isEmpty);
  for (int i = 0; i < data.length; i = i + 2) {
    List<String> playerwise = [];
    // print('----  ${data[i].children[0].text}');
    for (int j = 0; j < data[i].children.length; j++) {
      if (data[i].children[j].text.isNotEmpty) {
        if (j == 0) {
          print(
              '${data[i].children[j].text.split(RegExp(r'[0-9]')).last.toString().trim()}');
          playerwise.add(data[i]
              .children[j]
              .text
              .split(RegExp(r'[0-9]'))
              .last
              .toString()
              .trim());
        } else if ([index, index - 1, index - 2].contains(j)) {
          playerwise.add(data[i].children[j].text.toString().trim());
        }
      }
    }
    allplayers.add(playerwise);
  }

  for (var i in allplayers) {
    pointstableinfo
        .add(PointsTable(i[0], int.parse(i[1]), double.parse(i[2]), i[3]));
  }
  pointstablehead = headings;

  return Tuple2(pointstablehead, pointstableinfo);
}

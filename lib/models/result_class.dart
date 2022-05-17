import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:datascrap/globals.dart' as globals;

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.

class Result {
  /// Creates the employee class with required details.
  Result(this.team1, this.team2, this.winner, this.margin, this.ground,
      this.match_date, this.scorecard);
  final String team1;
  final String team2;
  final String winner;
  final String ground;
  final String match_date;
  final String margin;
  final String scorecard;
}

class Won {
  /// Creates the Won class with required details.
  Won(
    this.ground,
    this.matches_won,
    this.opposition,
  );
  final String opposition;
  final String matches_won;
  final String ground;
}

class HistoryDataSource extends DataGridSource {
  /// Creates the history data source class with required details.
  HistoryDataSource({List<Won> historyDataSource}) {
    _historyData = historyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'matches_won', value: e.matches_won),
              DataGridCell<String>(columnName: 'ground', value: e.ground),
              DataGridCell<String>(
                  columnName: 'opposition', value: e.opposition),
            ]))
        .toList();
  }

  List<DataGridRow> _historyData = [];

  @override
  List<DataGridRow> get rows => _historyData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        color: (globals.team1_name.contains(e.value.toString()))
            ? Colors.green
            : Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }).toList());
  }
}

class TeamResultsDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TeamResultsDataSource({List<Result> teamResultsDataSource}) {
    _teamResultsDataSource = teamResultsDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'team1', value: e.team1),
              DataGridCell<String>(columnName: 'team2', value: e.team2),
              DataGridCell<String>(columnName: 'winner', value: e.winner),
              DataGridCell<String>(columnName: 'margin', value: e.margin),
              DataGridCell<String>(columnName: 'ground', value: e.ground),
              DataGridCell<String>(
                  columnName: 'match_date', value: e.match_date),
              DataGridCell<String>(columnName: 'scorecard', value: e.scorecard),
            ]))
        .toList();
  }

  List<DataGridRow> _teamResultsDataSource = [];

  @override
  List<DataGridRow> get rows => _teamResultsDataSource;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

teams_results_info(var team1_info, String team1_name) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];
  dom.Document document1 = parser.parse(team1_info.body);
  // print(document
  //     .querySelectorAll('table.engineTable>tbody')[1]
  //     .text
  //     .contains('Records'));
  print(document1.text.toString());
  var headers1 = document1.querySelectorAll('table.engineTable>thead>tr')[0];
  var titles1 = headers1.querySelectorAll('th');
  titles1.removeWhere((element) => element.text.length == 0);
  for (int i = 0; i < titles1.length; i++) {
    headings.add(titles1[i].text.toString().trim());
  }

  var element = document1.querySelectorAll('table.engineTable>tbody')[0];
  var data = element.querySelectorAll('tr');
  data.removeWhere((element) => element.text.length == 0);
  for (int i = 0; i < data.length; i++) {
    List<String> playerwise = [];
    for (int j = 0; j < data[j].children.length; j++) {
      if (data[i].children[j].text.length != 0) {
        playerwise.add(data[i].children[j].text.toString().trim());
      }
    }

    allplayers.add(playerwise);
  }

  print(headings);
  print(allplayers);
  print(allplayers[0].length);
  print(headings.length);

  return Tuple2(headings, allplayers);
}

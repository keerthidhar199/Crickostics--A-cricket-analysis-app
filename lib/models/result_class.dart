// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
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
  final String margin;

  final String ground;
  final String match_date;
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
  HistoryDataSource({List<Won>? historyDataSource}) {
    _historyData = historyDataSource!
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
      print('naasas${row.getCells()[0].value}');

      if (globals.ground == row.getCells()[0].value) {
        return Container(
            alignment: Alignment.center,
            color: Colors.greenAccent,
            child: Text(
              e.value,
              style: globals.Litsans,
            ));
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
            style: globals.Litsans,
          ),
        );
      }
    }).toList());
  }
}

class TeamResultsDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TeamResultsDataSource({List<Result>? teamResultsDataSource}) {
    _teamResultsDataSource = teamResultsDataSource!
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
      if (((globals.team1_name.contains(row.getCells()[0].value.toString()) ||
                  globals.team1_name
                      .contains(row.getCells()[1].value.toString())) &&
              (globals.team2_name
                      .contains(row.getCells()[1].value.toString()) ||
                  globals.team2_name
                      .contains(row.getCells()[0].value.toString()))) ||
          (globals.team1__short_name
                      .contains(row.getCells()[0].value.toString()) ||
                  globals.team1__short_name
                      .contains(row.getCells()[1].value.toString())) &&
              (globals.team2__short_name
                      .contains(row.getCells()[1].value.toString()) ||
                  globals.team2__short_name
                      .contains(row.getCells()[0].value.toString()))) {
        return Container(
          color: Colors.greenAccent,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
            style: globals.Litsans,
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
            style: globals.Litsans,
          ),
        );
      }
    }).toList());
  }
}

teams_results_info() async {
  List<List<String>> teamresultsdatalist = [];
  List<String> headings = [];
  var category = 'team-match-results';
  var root = 'https://www.espncricinfo.com';
  //"/records/tournament/indian-premier-league-2023-15129?team=4344"  globals.team1_stats_link

  String originalUrl = globals.team1_stats_link;

  Uri parsedUri = Uri.parse(originalUrl);
  String path = parsedUri.path;
  String newPath = path.replaceFirst("/tournament/", "/tournament/$category/");

  Uri modifiedUri =
      parsedUri.replace(path: newPath, query: null, fragment: null);
  String modifiedUrl = modifiedUri.removeFragment().toString();

  var webpage = (root + modifiedUrl.split('?').first);
  print('webpage $webpage');
  var response = await http.Client().get(Uri.parse(webpage));
  dom.Document document = parser.parse(response.body);
  var teamresultsdata =
      json.decode(document.getElementById('__NEXT_DATA__')!.text)['props']
          ['appPageProps']['data']['data']['content']['tables'];
  List<String> headers = [];
  for (var i in teamresultsdata[0]['headers']) {
    headers.add(i['label']);
  }

  for (var players in teamresultsdata[0]['rows']) {
    List<String> playerteamresultsdata = [];

    for (var player in players['items']) {
      playerteamresultsdata.add(player['value'].toString());
    }

    teamresultsdatalist.add(playerteamresultsdata);
  }

  print('elaneel $headers');
  print('elaneel $teamresultsdatalist');
  // print(document
  //     .querySelectorAll('table.engineTable>tbody')[1]
  //     .text
  //     .contains('Records'));
  // print(document1.text.toString());
  // var headers1 = document1.querySelectorAll('table>thead>tr')[0];
  // var titles1 = headers1.querySelectorAll('th');
  // titles1.removeWhere((element) => element.text.isEmpty);
  // for (int i = 0; i < titles1.length; i++) {
  //   headings.add(titles1[i].text.toString().trim());
  // }

  // var element = document1.querySelectorAll('table>tbody')[0];
  // var data = element.querySelectorAll('tr');
  // data.removeWhere((element) => element.text.isEmpty);
  // for (int i = 0; i < data.length; i++) {
  //   List<String> playerwise = [];
  //   for (int j = 0; j < data[i].children.length; j++) {
  //     if (data[i].children[j].text.isNotEmpty ||
  //         data[i].children[j].text != null) {
  //       playerwise.add(data[i].children[j].text.toString().trim());
  //     }
  //   }

  //   allplayers.add(playerwise);
  // }

  // print(headings);
  // print(allplayers);
  // print(allplayers[0].length);
  // print(headings.length);

  return Tuple2(headers, teamresultsdatalist);
}

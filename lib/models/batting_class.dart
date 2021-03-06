import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
///
class Batting_player {
  /// Creates the employee class with required details.
  Batting_player(this.player, this.runs, this.balls, this.fours, this.sixes,
      this.sr, this.opposition, this.ground, this.match_date, this.team);

  final String player;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double sr;
  final String opposition;
  final String ground;
  final String match_date;
  final String team;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class BattingDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  BattingDataSource({List<Batting_player> batData}) {
    _batData = batData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'player', value: e.player),
              DataGridCell<int>(columnName: 'runs', value: e.runs),
              DataGridCell<int>(columnName: 'balls', value: e.balls),
              DataGridCell<int>(columnName: 'fours', value: e.fours),
              DataGridCell<int>(columnName: 'sixes', value: e.sixes),
              DataGridCell<double>(columnName: 'sr', value: e.sr),
              DataGridCell<String>(
                  columnName: 'opposition', value: e.opposition),
              DataGridCell<String>(columnName: 'ground', value: e.ground),
              DataGridCell<String>(
                  columnName: 'match date', value: e.match_date),
              DataGridCell<String>(columnName: 'team', value: e.team),
            ]))
        .toList();
  }

  List<DataGridRow> _batData = [];

  @override
  List<DataGridRow> get rows => _batData;

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

batting_teams_info(var team1_info, String team1_name) async {
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
    print(titles1[i].text.toString().trim());
    if (titles1[i].text.toString().trim().contains('4')) {
      headings.add('fours');
    } else if (titles1[i].text.toString().trim().contains('6')) {
      headings.add('sixes');
    } else {
      headings.add(titles1[i].text.toString().trim());
    }
  }
  headings.remove('Scorecard');
  headings.join(',');
  headings.insert(headings.length, "Team");

  var element = document1.querySelectorAll('table.engineTable>tbody')[0];
  var data = element.querySelectorAll('tr');
  data.removeWhere((element) => element.text.length == 0);
  for (int i = 0; i < data.length; i++) {
    List<String> playerwise = [];
    for (int j = 0; j < data[i].children.length; j++) {
      if (data[i].children[j].text.length != 0) {
        playerwise.add(data[i].children[j].text.toString().trim());
      }
    }

    playerwise.removeAt(9);
    playerwise.join(',');

    playerwise.insert(playerwise.length, team1_name);
    allplayers.add(playerwise);
  }

  print(headings);
  print(allplayers);
  print(allplayers[0].length);
  print(headings.length);
  // ground_based = allplayers
  //     .where((stats) => stats.elementAt(7) == globals.ground)
  //     .toList();
  return Tuple2(headings, allplayers);
}

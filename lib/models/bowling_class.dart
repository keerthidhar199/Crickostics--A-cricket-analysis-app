import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';

class Player {
  /// Creates the employee class with required details.
  Player(this.player, this.overs, this.runs, this.wickets, this.econ,
      this.opposition, this.ground, this.match_date, this.team);
  final String player;
  final double overs;
  final int runs;
  final int wickets;
  final double econ;
  final String opposition;
  final String ground;
  final String match_date;
  final String team;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class bowlingDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  bowlingDataSource({List<Player> bowlingData}) {
    _bowlingData = bowlingData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'player', value: e.player),
              DataGridCell<double>(columnName: 'overs', value: e.overs),
              DataGridCell<int>(columnName: 'runs', value: e.runs),
              DataGridCell<int>(columnName: 'wkts', value: e.wickets),
              DataGridCell<double>(columnName: 'econ', value: e.econ),
              DataGridCell<String>(
                  columnName: 'opposition', value: e.opposition),
              DataGridCell<String>(columnName: 'ground', value: e.ground),
              DataGridCell<String>(
                  columnName: 'match date', value: e.match_date),
              DataGridCell<String>(columnName: 'tean', value: e.team),
            ]))
        .toList();
  }

  List<DataGridRow> _bowlingData = [];

  @override
  List<DataGridRow> get rows => _bowlingData;

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

bowling_teams_info(var team1_info, String team1_name) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];
  List<List<String>> ground_based = [];
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
    headings.remove('Scorecard');
    headings.remove('Mdns');
    headings.join(',');
  }
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
    playerwise.removeAt(2);
    playerwise.removeAt(8);
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

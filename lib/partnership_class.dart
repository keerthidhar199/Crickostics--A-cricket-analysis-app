import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
///
class Partnership {
  /// Creates the employee class with required details.
  Partnership(this.partners, this.runs, this.wkts, this.opposition, this.ground,
      this.match_date, this.team);
  final String partners;
  final int runs;
  final String wkts;
  final String opposition;
  final String ground;
  final String match_date;
  final String team;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class PartnershipDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PartnershipDataSource({List<Partnership> Data}) {
    _Data = Data.map<DataGridRow>((e) => DataGridRow(cells: [
          DataGridCell<String>(columnName: 'partners', value: e.partners),
          DataGridCell<int>(columnName: 'runs', value: e.runs),
          DataGridCell<String>(columnName: 'wkts', value: e.wkts),
          DataGridCell<String>(columnName: 'opposition', value: e.opposition),
          DataGridCell<String>(columnName: 'ground', value: e.ground),
          DataGridCell<String>(columnName: 'match_date', value: e.match_date),
          DataGridCell<String>(columnName: 'team', value: e.team),
        ])).toList();
  }

  List<DataGridRow> _Data = [];

  @override
  List<DataGridRow> get rows => _Data;

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

partnership_teams_info(var team_info, String team1_name) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];
  dom.Document document1 = parser.parse(team_info.body);
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
    headings.add(titles1[i].text.toString().trim());
  }
  headings.remove('Scorecard');
  headings.join(',');
  headings.insert(headings.length, "Team");

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
    playerwise.removeAt(6);
    playerwise.join(',');
    playerwise.insert(playerwise.length, team1_name);
    allplayers.add(playerwise);
  }

  print(headings);
  print('Partnerships $allplayers');
  print(allplayers);
  print(headings.length);
  // ground_based = allplayers
  //     .where((stats) => stats.elementAt(7) == globals.ground)
  //     .toList();
  return Tuple2(headings, allplayers);
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';

class Player {
  /// Creates the employee class with required details.
  Player(
      this.player,
      this.overs,
      this.runs,
      this.wickets,
      this.econ,
      this.team,
      this.opposition,
      this.ground,
      this.match_date,
      this.score_card,
      this.player_link);
  final String player;
  final double overs;
  final int runs;
  final int wickets;
  final double econ;
  final String opposition;
  final String ground;
  final String match_date;
  final String team;
  final String score_card;

  final String player_link;
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
              DataGridCell<String>(columnName: 'team', value: e.team),
              DataGridCell<String>(
                  columnName: 'score card', value: e.score_card),
              DataGridCell<String>(
                  columnName: 'player link', value: e.player_link),
            ]))
        .toList();
  }
  @override
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
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontFamily: 'Litsans'),
        ),
      );
    }).toList());
  }
}

bowling_teams_info(var team1_info, String team1_name) async {
  List<List<String>> allplayers = [];
  List<String> headings = [];
  List<List<String>> ground_based = [];
  List<List<String>> allplayersscript = [];

  dom.Document document1 = parser.parse(team1_info.body);
  // print(document
  //     .querySelectorAll('table.engineTable>tbody')[1]
  //     .text
  //     .contains('Records'));
  // print('deppthy' + document1.text.toString());
  // var headers1 = document1.querySelectorAll('table>thead>tr')[0];
  // var titles1 = headers1.querySelectorAll('td');
  var bowlingdata =
      json.decode(document1.getElementById('__NEXT_DATA__').text)['props']
          ['appPageProps']['data']['data']['content']['tables'];
  // print(document
  //     .querySelectorAll('table.engineTable>tbody')[1]
  //     .text
  //     .contains('Records'));
  List<String> headers = [];
  for (var i in bowlingdata[0]['headers']) {
    headers.add(i['label']);
  }
  headers.insert(headers.length, 'Player Link');

  for (var players in bowlingdata[0]['rows']) {
    List<String> playerbowlingdata = [];

    for (var player in players['items']) {
      playerbowlingdata.add(player['value'].toString());
    }
    playerbowlingdata.insert(
        headers.indexOf('Player Link'), players['items'][0]['link'].toString());
    allplayersscript.add(playerbowlingdata);
  }
  if (headers.contains('Mdns')) {
    for (var element in allplayersscript) {
      element.removeAt(headers.indexOf('Mdns'));
    }
    headers.remove('Mdns');
    headers.join(',');
  }

  print('elaneel $headers');
  print('elaneel $allplayersscript');

  // titles1.removeWhere((element) => element.text.length == 0);
  // for (int i = 0; i < titles1.length; i++) {
  //   headings.add(titles1[i].text.toString().trim());
  // }
  // headings.insert(headings.length, "Team");
  // headings.insert(headings.length, 'Player Link');

  // var element = document1.querySelectorAll('table>tbody')[0];
  // var data = element.querySelectorAll('tr');
  // data.removeWhere((element) => element.text.isEmpty);
  // for (int i = 0; i < data.length; i++) {
  //   List<String> playerwise = [];
  //   for (int j = 0; j < data[i].children.length; j++) {
  //     if (data[i].children[j].text.isNotEmpty) {
  //       playerwise.add(data[i].children[j].text.toString().trim());
  //     }
  //   }

  //   playerwise.add(team1_name);
  //   playerwise.add(data[i].getElementsByTagName('a')[0].attributes['href']);

  //   allplayers.add(playerwise);
  // }
  // if (headings.contains('Mdns')) {
  //   for (var element in allplayers) {
  //     element.removeAt(2);
  //   }
  //   headings.remove('Mdns');
  //   headings.join(',');
  // }

  // print(headings);
  // print(allplayers);
  // print('bowling headers' + headings.toString());
  // print('bowling data' + allplayers.toString());
  // print(allplayers[0].length);
  // print(headings.length);
  // // ground_based = allplayers
  // //     .where((stats) => stats.elementAt(7) == globals.ground)
  // //     .toList();
  return Tuple2(headers, allplayersscript);
}

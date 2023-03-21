import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datascrap/models/Coloredrow.dart';
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

  List<DataGridRow> _pointsData = [];
  Future<String> getlogos(String leaguename) async {
    String root_logo =
        'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_80/lsci';
    var response = await http.Client()
        .get(Uri.parse('https://www.espncricinfo.com/live-cricket-score'));
    dom.Document document = parser.parse(response.body);
    List imglogosdata =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['editionDetails']['trendingMatches']['matches'];
    List imglogosdata1 =
        json.decode(document.getElementById('__NEXT_DATA__').text)['props']
            ['appPageProps']['data']['content']['matches'];
    List takethisimglogosdata = List.from(imglogosdata)..addAll(imglogosdata1);
    String seriesname = '';
    for (var i in takethisimglogosdata) {
      if (i['teams'][0]['team']['longName'].toString().trim() == leaguename) {
        seriesname = i['teams'][0]['team']['image']['url'].toString();
      } else if (i['teams'][1]['team']['longName'].toString().trim() ==
          leaguename) {
        seriesname = i['teams'][1]['team']['image']['url'].toString();
      }
    }
    //print('imglogosdata12 $seriesname');
    return root_logo + seriesname;
  }

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
        child: e.columnName == 'Series Form'
            ? ColoredRow(
                string: e.value,
              )
            : Container(
                width: double.infinity * 0.1,
                child: Text(
                  e.value.toString(),
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Litsans',
                  ),
                ),
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
  headings.add(titles1[index - 2].text.toString().trim());

  headings.add(titles1[index - 1].text.toString().trim());
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
// Widget showlogos(teamname){
//   return FutureBuilder<String>(
//                 future: getlogos(teamname.toString()), // async work
//                 builder:
//                     (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return CircularProgressIndicator();
//                     default:
//                       return Row(
//                         children: [
//                           IconButton(
//                               icon: CachedNetworkImage(
//                                 imageUrl: snapshot.data,
//                               ),
//                               onPressed: null),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: Text(
//                               teamname.toString(),
//                               softWrap: true,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: 'Litsans'),
//                             ),
//                           )
//                         ],
//                       );
//                   }
//                 },
//               );
            
// } 
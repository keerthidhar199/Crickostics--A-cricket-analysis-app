import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:datascrap/result_class.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'globals.dart' as globals;

class TossAnalysis extends StatefulWidget {
  const TossAnalysis({Key key}) : super(key: key);

  @override
  State<TossAnalysis> createState() => _TossAnalysisState();
}

String route = 'https://www.espncricinfo.com';
Future tosswin() async {
  String website;
  var linkdetails = [];
  var response =
      await http.Client().get(Uri.parse('https://www.espncricinfo.com/team'));
  dom.Document document = parser.parse(response.body);
  // for (int k = 0;
  //     k <
  //         document
  //             .getElementsByClassName(
  //                 'ds-grow')
  //             .length;
  //     k++) {
  var matchdetails = document.getElementsByClassName('ds-grow')[0];
  var listofteams = matchdetails.querySelectorAll('a');
  var team1 = 'Lucknow Super Giants';
  Map<String, List<String>> scorecardlinks = {};
  var mapping = [];
  for (var j in listofteams) {
    print(j.text);
    if (j.text.contains(team1)) {
      print(j.attributes['href'].toString());
      var response1 = await http.Client().get(Uri.parse(
          route + j.attributes['href'].toString() + '/match-results'));

      dom.Document document1 = parser.parse(response1.body);
      var scorecarddetails = document1
          .getElementsByClassName('ds-flex ds-flex-wrap')[0]
          .querySelectorAll('a');
      for (var i in scorecarddetails) {
        if (i.attributes['href'].toString().contains('scorecard') &&
            i.attributes['href'].toString().contains('2022')) {
          // print("scorecarddetails1 ${i.attributes['href']}");
          var scorecardpage = await http.Client()
              .get(Uri.parse(route + i.attributes['href'].toString()));
          dom.Document SCDocument = parser.parse(scorecardpage.body);
          var tossdetails = SCDocument.getElementsByClassName(
                  'ds-w-full ds-table ds-table-sm ds-table-auto')[0]
              .querySelectorAll('tr');
          var winnerteam = SCDocument.getElementsByClassName(
                  'ds-text-tight-m ds-font-regular ds-truncate ds-text-typo-title')[0]
              .text;
          var ru = [
            team1,
            tossdetails[1].text.toString().replaceAll('Toss', '').trim(),
            winnerteam.trim()
          ];
          if (!mapping.contains(ru)) {
            mapping.add(ru);
          }
        }
        mapping = 
        mapping.toSet().toList();
      }
      mapping = mapping.toSet().toList();
      print('scorecardlinks $mapping');
    }
  }
}

class _TossAnalysisState extends State<TossAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Color(0xffFFB72B),
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: FutureBuilder<dynamic>(
          future: tosswin(), // async work
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return Text('Result: ${snapshot.data}');
            }
          },
        ));
  }
}

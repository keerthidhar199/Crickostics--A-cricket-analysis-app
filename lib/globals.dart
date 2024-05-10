// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

String ground = '';
var team_code1;
var team_code2;
var team1_name;
var team2_name;
var team1__short_name;
var team2__short_name;
var team1_link;
var team2_link;
var ontap;
String team1_stats_link = '';
String team2_stats_link = '';
String league_page = '';
String team1logo = '';
String team2logo = '';
var league_page_address;
TextStyle cocosharp =
    const TextStyle(fontFamily: 'Cocosharp', color: Colors.white);
TextStyle cocosharpblack =
    const TextStyle(fontFamily: 'Cocosharp', color: Colors.black);
TextStyle Litsanswhite =
    const TextStyle(fontFamily: 'Litsans', color: Colors.white);
TextStyle Litsans = const TextStyle(
    fontFamily: 'Litsans',
  color: Colors.black,
    fontStyle: FontStyle.normal
);
TextStyle smallcocosharpblack =
    const TextStyle(fontFamily: 'Cocosharp', fontSize: 12, color: Colors.black);

TextStyle smallcocosharp =
    const TextStyle(fontFamily: 'Cocosharp', fontSize: 12, color: Colors.white);
BoxDecoration recentStatePage_Decoration = BoxDecoration(
    border: Border.all(color: Colors.white54),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xff005874),
        Color(0xff1C819E),

        // Colors.white38,
      ],
    ));
capitalize(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

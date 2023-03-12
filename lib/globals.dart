import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String ground;
var team_code1;
var team_code2;
var team1_name;
var team2_name;
var team1__short_name;
var team2__short_name;
var team1_link;
var team2_link;
var ontap;
String team1_stats_link;
String team2_stats_link;
String league_page;
String team1logo;
String team2logo;
TextStyle noble = TextStyle(fontFamily: 'Cocosharp', color: Colors.white);
TextStyle nobleblack = TextStyle(fontFamily: 'Cocosharp', color: Colors.black);
TextStyle Louisgeorgewhite = TextStyle(fontFamily: 'Louisgeorge', color: Colors.white);
TextStyle LouisgeorgeBOLD = TextStyle(
    fontFamily: 'Louisgeorge',
    color: Colors.black,
    fontWeight: FontWeight.w900);
TextStyle Louisgeorge = TextStyle(
  fontFamily: 'Louisgeorge',
  color: Colors.black,
);
TextStyle smallnobleblack =
    TextStyle(fontFamily: 'Cocosharp', fontSize: 12, color: Colors.black);

TextStyle smallnoble =
    TextStyle(fontFamily: 'Cocosharp', fontSize: 12, color: Colors.white);
BoxDecoration recentStatePage_Decoration = new BoxDecoration(
    border: Border.all(color: Colors.white54),
    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
    gradient: LinearGradient(
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
// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, no_logic_in_create_state, unused_import

import 'dart:ui';

import 'package:datascrap/services/get_player_pic.dart';
import 'package:flutter/material.dart';
import 'models/bowling_class.dart';
import 'package:datascrap/globals.dart' as globals;

class Dream11TeamGenerator extends StatefulWidget {
  final List<List<String>> batters;

  final List<List<String>> bowlers;

  Dream11TeamGenerator({Key? key, required this.batters, required this.bowlers})
      : super(key: key);

  @override
  State<Dream11TeamGenerator> createState() =>
      _Dream11TeamGenerator1State(batters, bowlers);
}

class _Dream11TeamGenerator1State extends State<Dream11TeamGenerator> {
  _Dream11TeamGenerator1State(batters, bowlers);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('DER ${widget.batters}');

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xffFFB72B),
          title: const Text(
            'Top Performers',
            style: TextStyle(fontFamily: 'Litsanswhite', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
                color: Colors.black,
                icon: const Icon(Icons.done_all),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        body: (widget.batters.isEmpty && widget.bowlers.isEmpty)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0xff2B2B28),
                  child: Column(
                    children: [
                      Image.asset(
                        'logos/bowling.png',
                        color: Colors.white,
                        width: 100,
                        height: 100,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.bowlers.length,
                          itemBuilder: (context, index) {
                            final team = widget.bowlers[index];
                            return ListTile(
                              leading: team[4].isEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Icon(
                                          Icons.person,
                                          size: 55,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.matrix(
                                              Matrix4.rotationZ(0.2).storage),
                                          child: Image.network(
                                            team[4],
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.redAccent,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                              title: Text(
                                team[0],
                                style: globals.Litsanswhite,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Economy: ${team[3]}',
                                    style: globals.Litsanswhite,
                                  ),
                                  Text(
                                    'Wickets: ${team[2]}',
                                    style: globals.Litsanswhite,
                                  ),
                                ],
                              ),
                            );
                          }),
                      Image.asset(
                        'logos/batting.png',
                        color: Colors.white,
                        width: 100,
                        height: 100,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.batters.length,
                          itemBuilder: (context, index) {
                            final team = widget.batters[index];
                            return ListTile(
                              leading: team[4].isEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Icon(
                                          Icons.person,
                                          size: 55,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          team[4],
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return SizedBox(
                                              child: CircularProgressIndicator(
                                                color: Colors.redAccent,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              title: Text(team[0], style: globals.Litsanswhite),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Runs: ${team[1]}(${team[2]})',
                                      style: globals.Litsanswhite),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ));
  }
}

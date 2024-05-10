// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, no_logic_in_create_state

import 'package:datascrap/services/get_player_pic.dart';
import 'package:flutter/material.dart';
import 'models/bowling_class.dart';

class Dream11TeamGenerator1 extends StatefulWidget {
  final List<List<String>> bowlers;

  Dream11TeamGenerator1({Key? key, required this.bowlers}) : super(key: key);

  @override
  State<Dream11TeamGenerator1> createState() =>
      _Dream11TeamGenerator1State(bowlers);
}

class _Dream11TeamGenerator1State extends State<Dream11TeamGenerator1> {
  _Dream11TeamGenerator1State(bowlers);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('DER ${widget.bowlers}');
    return Scaffold(
        appBar: AppBar(
          title: Text('Mutual Fund'),
        ),
        body: widget.bowlers.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.bowlers.length,
                itemBuilder: (context, index) {
                  final team = widget.bowlers[index];
                  return ListTile(
                    leading: Image.network(
                      team[4],
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        );
                      },
                    ),
                    title: Text(team[0]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Economy: ${team[3]}'),
                        Text('Wickets: ${team[2]}'),
                      ],
                    ),
                  );
                }));
  }
}

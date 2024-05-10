// ignore_for_file: prefer_const_constructors

import 'package:datascrap/analysis.dart';
import 'package:datascrap/recent_stats.dart';
import 'package:flutter/material.dart';

class typeofstats extends StatefulWidget {
  final disablerecentstats;
  const typeofstats({Key? key, this.disablerecentstats}) : super(key: key);

  @override
  State<typeofstats> createState() => _typeofstatsState(disablerecentstats);
}

class _typeofstatsState extends State<typeofstats> {
  _typeofstatsState(disablerecentstats);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff2B2B28),
        appBar: AppBar(
          backgroundColor: const Color(0xffFFB72B),
          title: const Text(
            'Type of Stats',
            style: TextStyle(
                fontFamily: 'Montserrat-Black', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff1A3263),
                        const Color(0xff1A3263).withOpacity(0.5),
                      ],
                    )),
                child: Row(
                  children: <Widget>[
                    const Flexible(
                      child: ListTile(
                        leading: Icon(
                          Icons.stacked_bar_chart,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          'Stats by Pitch',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '\nGives you an analysis of matches based on the venue played.',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 100),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      child: const Text(
                        'CRICKOLIZE',
                        style: TextStyle(
                          fontFamily: 'RestaurantMenu',
                          fontSize: 20.0,
                          color: Colors.white,
                          decorationColor: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Analysis(),
                            ));
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: 100,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff005874),
                        const Color(0xff005874).withOpacity(0.5),
                        // Color(0xff1A3263),
                        // Color(0xff1A3263).withOpacity(0.5),
                      ],
                    )),
                child: Row(
                  children: [
                    const Expanded(
                      child: ListTile(
                        leading: Icon(
                          Icons.pie_chart_outline_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          'Stats by Recent matches',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '\nGives you an analysis of report based upon the last five matches played by the each team.',
                          style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minimumSize: const Size(100, 150),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        'CRICKOLIZE',
                        style: TextStyle(
                          fontFamily: 'RestaurantMenu',
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (widget.disablerecentstats == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.grey,
                            duration: Duration(seconds: 2),
                            content: Text(
                              'Stats by Recent Matches can not be shown once the match has started !!',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat-Black'),
                            ),
                          ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => recentmatchdata(),
                              ));
                        }
                      },
                    ),
                    // const SizedBox(width: 8),
                  ],
                )),
          ],
        ));
  }
}

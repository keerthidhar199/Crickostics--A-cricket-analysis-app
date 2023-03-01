import 'package:datascrap/analysis.dart';
import 'package:datascrap/recent_stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class typeofstats extends StatefulWidget {
  const typeofstats({Key key}) : super(key: key);

  @override
  State<typeofstats> createState() => _typeofstatsState();
}

class _typeofstatsState extends State<typeofstats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff2B2B28),
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: Text(
            'Type of Stats',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff1A3263),
                        Color(0xff1A3263).withOpacity(0.5),
                      ],
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.stacked_bar_chart,
                        color: Colors.white,
                        size: 50,
                      ),
                      title: Text(
                        'Stats by Pitch',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Gives you an analysis of matches based on the venue played.',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        'CRICKOLIZE',
                        style: TextStyle(
                          fontFamily: 'RestaurantMenu',
                          fontSize: 20.0,
                          color: Colors.white,
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
                    const SizedBox(width: 8),
                  ],
                )),
            SizedBox(
              height: 100,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff005874),
                        Color(0xff005874).withOpacity(0.5),
                        // Color(0xff1A3263),
                        // Color(0xff1A3263).withOpacity(0.5),
                      ],
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.pie_chart_outline_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                      title: Text(
                        'Stats by Recent matches',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Gives you an analysis of report based upon the last five matches played by the each team.',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        'CRICKOLIZE',
                        style: TextStyle(
                          fontFamily: 'RestaurantMenu',
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => recentmatchdata(),
                            ));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
          ],
        ));
  }
}

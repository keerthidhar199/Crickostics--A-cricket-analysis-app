import 'package:datascrap/services/importcsv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class fantasyteam extends StatefulWidget {
  const fantasyteam({Key key}) : super(key: key);

  @override
  State<fantasyteam> createState() => _fantasyteamState();
}

class _fantasyteamState extends State<fantasyteam> {
  List fantasydata = [];

  @override
  Widget build(BuildContext context) {
    importcsv.getcsvdata().then((value) {
      setState(() {
        if (value != null) {
          fantasydata = value.sublist(1);
        } else {
          fantasydata = null;
        }
      });
    });
    return Scaffold(
        backgroundColor: Color(0xff2B2B28),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xffFFB72B),
          title: Text(
            'Your Fantasy',
            style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
          ),
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: fantasydata == null
            ? Container(
                color: Color(0xff2B2B28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('  Oh My CrickOh! ',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 20.0,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text('No Fantasy players added !',
                        style: TextStyle(
                          fontFamily: 'Louisgeorge',
                          fontSize: 20.0,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Image.asset(
                              'logos/ball.png',
                            ),
                            onPressed: null),
                        Flexible(
                          child: Text(
                              'Select your players and click on +Add to fantasy to add players in the Fantasy Lot.',
                              style: TextStyle(
                                fontFamily: 'Louisgeorge',
                                fontSize: 15.0,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : fantasydata != null
                ? GroupedListView<dynamic, String>(
                    elements: fantasydata,
                    groupBy: (element) => element[3],
                    groupSeparatorBuilder: (String groupByValue) =>
                        Text(groupByValue),
                    itemBuilder: (context, dynamic element) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(element[0]),
                            Text(element[1]),
                            Text(element[2]),
                          ],
                        ),
                      ),
                    ),
                  )
                : CircularProgressIndicator()

        // ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: fantasydata.length,
        //     itemBuilder: (context, index) {
        //       return Card(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(fantasydata[index][0]),
        //               Text(fantasydata[index][1]),
        //               Text(fantasydata[index][2]),
        //               Text(fantasydata[index][3]),
        //             ],
        //           ),
        //         ),
        //       );
        //     }),

        // Container(
        //   child: Text(
        //     fantasydata.toString(),
        //     style: TextStyle(fontFamily: 'Cocosharp', color: Colors.black87),
        //   ),
        // ),
        );
  }
}

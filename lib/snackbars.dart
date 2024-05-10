// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:datascrap/globals.dart' as globals;

// class AlertBoxes extends StatefulWidget {
//   final context;
//   const AlertBoxes({Key key, this.context}) : super(key: key);
//   @override
//   State<AlertBoxes> createState() => _AlertBoxesState();
// }

// class _AlertBoxesState extends State<AlertBoxes> {
//   BuildContext context;
//   _AlertBoxesState(this.context);
//   SnackBar playeradded = SnackBar(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(20.0),
//     ),
//     behavior: SnackBarBehavior.floating,
//     content: Container(
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Image.asset(
//           'logos/my_fantasy.png',
//           width: 50,
//           height: 50,
//         ),
//         Text("\n Player(s) Selected !!\n", style: globals.smallcocosharpblack),
//       ]),
//     ),
//     backgroundColor: Color(0xffFFB72B),
//     margin: EdgeInsetsDirectional.only(
//       start: 5,
//       end: 5,
//       bottom: MediaQuery.of(context).size.width * 0.85,
//     ),
//   );
// }

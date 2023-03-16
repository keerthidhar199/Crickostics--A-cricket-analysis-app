import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Homepage()), (e) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2B2B28),
      child: Lottie.asset('logos/logoanimation.json'),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:datascrap/services/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:datascrap/globals.dart' as globals;

class GradientImage extends StatelessWidget {
  final String imagePath;
  final LinearGradient gradient;

  GradientImage({required this.imagePath, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return gradient.createShader(bounds);
        },
        blendMode:
            BlendMode.srcATop, // Change the blend mode as per your requirement
        // ignore: prefer_const_constructors
        child: Icon(
          MyFlutterApp.award_1,
          size: 80,
        ));
  }
}

class RankEmblem extends StatelessWidget {
  final int rank;

  RankEmblem({required this.rank});

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient;
    Color textColor;

    if (rank == 1) {
      gradient = const LinearGradient(
        colors: [Colors.orangeAccent, Colors.yellow],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      textColor = Colors.black;
    } else if (rank == 2) {
      gradient = const LinearGradient(
        colors: [Colors.grey, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      textColor = Colors.black;
    } else if (rank == 3) {
      gradient = const LinearGradient(
        colors: [Colors.brown, Colors.brown],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      textColor = Colors.black;
    } else {
      gradient = LinearGradient(
        colors: [Colors.blue, Colors.blue[200]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      textColor = Colors.white;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        GradientImage(
          imagePath: 'logos/my_fantasy.png',
          gradient: gradient,
        ),
        Positioned(
            bottom: 76,
            left: (rank == 1 || rank == 7) ? 37 : 36,
            child: Text('$rank', style: globals.Litsanswhite)),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final LinearGradient gradient;

  CirclePainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerCircle = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final innerCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, outerCircle);
    canvas.drawCircle(center, radius - 6, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Rank Emblems'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RankEmblem(rank: 1),
            const SizedBox(height: 20.0),
            RankEmblem(rank: 2),
            const SizedBox(height: 20.0),
            RankEmblem(rank: 3),
            const SizedBox(height: 20.0),
            RankEmblem(rank: 4),
            const SizedBox(height: 20.0),
            RankEmblem(rank: 5),
          ],
        ),
      ),
    ),
  ));
}

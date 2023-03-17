import 'package:flutter/material.dart';

class ColoredRowCircle extends StatelessWidget {
  final String string;

  const ColoredRowCircle({Key key, this.string}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = string.split(',');
    return Stack(
      children: List.generate(
        list.length,
        (index) {
          final isLast = index == list.length - 1;
          final character = list[index];
          return Positioned(
            left: (index * 50).toDouble(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: character == 'W' ? Colors.green : Colors.red,
              ),
              child: Center(
                child: Text(
                  character,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      )..addAll(
          List.generate(
            list.length - 1,
            (index) => Positioned(
              left: (index * 50 + 40).toDouble(),
              child: Text(
                '-',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
    );
  }
}

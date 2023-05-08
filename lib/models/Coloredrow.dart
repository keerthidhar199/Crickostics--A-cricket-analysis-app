import 'package:flutter/material.dart';

class ColoredRow extends StatelessWidget {
  final String string;

  const ColoredRow({Key key, this.string}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    for (int i = 0; i < string.length; i++) {
      final char = string[i];
      if (char == 'W') {
        widgets.add(
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                char,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Litsans',
                ),
              ),
            ),
          ),
        );
      } else if (char == 'L') {
        widgets.add(
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                char,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Litsans',
                ),
              ),
            ),
          ),
        );
      } else if (char == 'N' && i < string.length - 1 && string[i + 1] == 'R') {
        widgets.add(
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'NR',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Litsans',
                ),
              ),
            ),
          ),
        );
        i++; // skip the next character (R)
      } else {
        widgets.add(
            const SizedBox()); // return empty SizedBox for unsupported characters
      }
    }
    return Row(
      children: widgets,
    );
  }
}

import 'package:flutter/material.dart';

class ColoredRow extends StatelessWidget {
  final String string;

  const ColoredRow({Key key, this.string}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        string.length,
        (index) => Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: string[index] == 'W'
                ? Colors.green
                : string[index] == 'L'
                    ? Colors.red
                    : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              string[index],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

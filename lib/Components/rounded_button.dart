import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final color; //Remember that stateless widget ki properties ni final chey.
  final String text;
  final Function function;
  RoundedButton({this.text, this.color, @required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: function,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

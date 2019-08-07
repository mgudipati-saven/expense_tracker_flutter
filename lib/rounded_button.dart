import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final bool selected;
  final GestureTapCallback onTap;

  const RoundedButton({Key key, this.text, this.selected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = selected ? Color(0xFF5EC4AC) : Colors.transparent;
    Color textColor = selected ? Colors.white : Colors.grey;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new InkWell(
          onTap: onTap,
          child: new Container(
            height: 36.0,
            decoration: new BoxDecoration(
              color: backgroundColor,
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: new Center(
              child: new Text(
                text,
                style: new TextStyle(color: textColor, fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
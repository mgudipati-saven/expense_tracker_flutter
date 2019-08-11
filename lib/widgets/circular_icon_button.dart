import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  CircularIconButton({
    @required this.icon,
    @required this.color,
    @required this.isSelected,
    @required this.label,
    @required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool isSelected;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Ink(
            decoration: ShapeDecoration(
              color: isSelected ? color : null,
              shape: CircleBorder(
                side: BorderSide(color: color, width: 2.0),
              ),
            ),
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.all(22.0),
              icon: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 32.0,
              ),
              onPressed: onTap,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
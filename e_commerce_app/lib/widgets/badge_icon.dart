import 'package:flutter/material.dart';

import '../utils/utils.dart';

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.value, required this.child})
      : super(key: key);
  final Widget child;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 4,
          top: 5,
          child: Container(
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(
              minHeight: 20,
              minWidth: 20,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPalette.buttonBackgroundColor,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ColorPalette {
  static Color bottomNavColor = Color.fromRGBO(13, 20, 34, 1);
  static Color buttonBackgroundColor = Color.fromRGBO(236, 152, 26, 1);
  static Color textSizeBackground = Color.fromRGBO(240, 220, 210, 1);
  static Color imageBackGround = Color.fromRGBO(247, 247, 247, 1);
}

const kTitleText = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 20,
);

const kPriceText = TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: 20,
);

const kTextField = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 20,
  ),
  labelText: 'Email',
  hintText: 'enter your email',

  prefixIcon: Icon(
    Icons.email,
    // color: Theme.of(context).iconTheme.color,
  ),
  // filled: true,
  // fillColor: Colors.amber,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(color: Colors.white, width: 1),
  ),
);

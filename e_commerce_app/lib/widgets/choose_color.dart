import 'package:flutter/material.dart';

class ChooseColor extends StatelessWidget {
  const ChooseColor({
    Key? key,
    required this.colors,
    required this.onChanged,
    required this.selectedColor,
    required this.index,
  }) : super(key: key);

  final Function() onChanged;
  final int selectedColor;
  final List<Color> colors;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        width: double.infinity,
        child: GestureDetector(
          onTap: onChanged,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedColor == index
                  ? colors[selectedColor].withOpacity(1)
                  : Theme.of(context).primaryColor,
              border: Border.all(
                color: selectedColor == index
                    ? colors[selectedColor].withOpacity(1)
                    : Theme.of(context).accentColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Center(
// child: Platform.isAndroid
// ? androidDropdownItem()
//     : Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 10, horizontal: 20),
// child: iosDropdownMenu(),
// ),
// ),

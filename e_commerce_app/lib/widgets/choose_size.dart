import 'package:flutter/material.dart';
import '../utils/utils.dart';

class SizesOptions extends StatelessWidget {
  const SizesOptions({
    Key? key,
    required this.currentIndex,
    required this.index,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final Function() onTap;
  final int currentIndex, index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: currentIndex == index
              ? ColorPalette.textSizeBackground
              : Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              title,
              style: kTitleText.copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
    );
  }
}

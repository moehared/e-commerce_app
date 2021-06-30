import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductImages extends StatefulWidget {
  const ProductImages(
      {Key? key, required this.images, required this.choosenColor})
      : super(key: key);

  final List<String> images;
  final int choosenColor;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: [
            if (widget.choosenColor != -1)
              Image.network(widget.images[widget.choosenColor]),
            ...widget.images
                .map<Widget>(
                  (image) => Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
          ],
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
                print(currentIndex);
              });
            },
            aspectRatio: 2.5,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Positioned(
          left: 200,
          bottom: 10,
          child: Row(
            children: List.generate(
              widget.images.length,
              (index) => BuildDot(currentIndex: currentIndex, index: index),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildDot extends StatelessWidget {
  const BuildDot({
    required this.currentIndex,
    required this.index,
  });
  final int index;
  final currentIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: index == currentIndex ? Colors.white : Colors.grey.shade900,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:e_commerce_app/data_source/dummy_data.dart';
import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/screen/cart_screen.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:e_commerce_app/widgets/badge_icon.dart';
import 'package:e_commerce_app/widgets/add_to_cart_button.dart';
import 'package:e_commerce_app/widgets/choose_color.dart';
import 'package:e_commerce_app/widgets/choose_size.dart';
import 'package:e_commerce_app/widgets/product_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = "/ProductDetailsScreen";
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var _chosenSize = 0;
  var _chosenColor = -1;
  List<Color> _colors = [];
  String? selectedColor = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getColors();
  }

  void getColors(product) {
    List<Color> colors = [];
    product.colors.forEach((element) {
      int value = int.parse(element);
      Color color = Color(value).withOpacity(1);
      // print('color: $color\n');
      colors.add(color);
    });
    setState(() {
      _colors = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    // print('detail id : $id\n');
    final product =
        Provider.of<Products>(context, listen: false).findProductByID(id);
    getColors(product);
    final _cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'product details',
        ),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Badge(value: _cart.count.toString(), child: child!);
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImages(
              images: product.images.toList(),
              choosenColor: _chosenColor,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                textWidget(product.title, kTitleText),
                Spacer(),
                textWidget("\$${product.price}", kPriceText)
              ],
            ),
            textWidget(product.description, kTitleText),
            Divider(),
            textWidget('Choose Size', kTitleText),
            Row(
                children: List.generate(
              product.size.length,
              (index) => SizesOptions(
                currentIndex: _chosenSize,
                index: index,
                onTap: () {
                  setState(() {
                    _chosenSize = index;
                    print('selected size: ${product.size.elementAt(index)}');
                  });
                },
                title: product.size.elementAt(index),
              ),
            )),
            SizedBox(height: 10),
            Divider(),
            textWidget('Choose Color', kTitleText),
            SizedBox(height: 10),
            Row(
              children: List.generate(
                _colors.length,
                (index) => ChooseColor(
                  colors: _colors,
                  onChanged: () {
                    setState(() {
                      _chosenColor = index;
                      // print(
                      //     lookUpColor.containsValue(_colors.elementAt(index)));

                      lookUpColor.keys.forEach((element) {
                        if (_colors.elementAt(index) == lookUpColor[element]) {
                          setState(() {
                            selectedColor = element;
                            print('selected color : $selectedColor\n');
                          });
                        }
                      });
                    });
                  },
                  selectedColor: _chosenColor,
                  index: index,
                ),
              ).toList(),
            ),
            SizedBox(height: 15),
            AddToCartButton(
              selectedColor: selectedColor!,
              chosenColorIndex: _chosenColor,
              chosenSizeIndex: _chosenSize,
              product: product,
              cart: _cart,
            ),
          ],
        ),
      ),
    );
  }
}

Widget textWidget(String text, style) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Text(
      text,
      style: style,
    ),
  );
}

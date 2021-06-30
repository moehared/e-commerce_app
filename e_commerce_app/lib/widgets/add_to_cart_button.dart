import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key? key,
    required this.chosenColorIndex,
    required this.chosenSizeIndex,
    required this.product,
    required this.cart,
    required this.selectedColor,
  }) : super(key: key);
  final int chosenSizeIndex, chosenColorIndex;
  final Product product;
  final String selectedColor;
  final cart;
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: ColorPalette.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: chosenSizeIndex != -1 && chosenColorIndex != -1
            ? () {
                final cartItem = CartItem(
                  title: product.title,
                  size: product.size.elementAt(chosenSizeIndex),
                  image: product.images.elementAt(chosenColorIndex),
                  price: product.price,
                  quantity: 1,
                  id: DateTime.now().toString(),
                  color: selectedColor,
                );
                cart.addToCart(product.id, cartItem);
                scaffoldMessenger.hideCurrentSnackBar();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text(
                      'Added to cart',
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(
                      onPressed: () => Provider.of<Cart>(context, listen: false)
                          .undoItem(product.id),
                      label: 'Undo',
                    ),
                  ),
                );
                print('title: ${cartItem.title}\n size : ${cartItem.size}\n'
                    'color: ${cartItem.color}\n price: ${cartItem.price}\n image: ${cartItem.image}\n');
              }
            : null,
        icon: Icon(
          Icons.shopping_cart,
          size: 30,
        ),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Add to Cart',
            style: kTitleText,
          ),
        ),
      ),
    );
  }
}

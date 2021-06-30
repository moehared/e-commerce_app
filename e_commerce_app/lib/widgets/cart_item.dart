import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/models/saved_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

import '../models/cart.dart' as cart;

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.cartItem,
    required this.productID,
  }) : super(key: key);

  final cart.CartItem cartItem;
  final String productID;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserImage(url: cartItem.image),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextButton(
                      onPressed: () {
                        final userProduct = UserWishListProductModel(
                            productID: productID,
                            title: cartItem.title,
                            imageURL: cartItem.image,
                            price: cartItem.price);
                        Provider.of<Cart>(context, listen: false)
                            .savedCartItem(userProduct);
                      },
                      child: Text(
                        'Save for Later',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPalette.buttonBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartItem.title),
                    SizedBox(height: 10),
                    Text('Price: \$${cartItem.price}'),
                    SizedBox(height: 10),
                    Text('Size: ${cartItem.size}'),
                    SizedBox(height: 10),
                    Text('Color: ${cartItem.color}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RawMaterialButton(
                          elevation: 0,
                          fillColor: Colors.grey.shade300,
                          onPressed: () =>
                              Provider.of<Cart>(context, listen: false)
                                  .updateQuantity(productID: productID),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.remove,
                          ),
                          constraints:
                              BoxConstraints(minWidth: 35, minHeight: 35),
                        ),
                        Text(
                          cartItem.quantity.toString(),
                          style: kTitleText,
                        ),
                        RawMaterialButton(
                          elevation: 0,
                          fillColor: Colors.grey.shade300,
                          onPressed: () =>
                              Provider.of<Cart>(context, listen: false)
                                  .updateQuantity(
                                      productID: productID, isIncrease: true),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add,
                          ),
                          constraints:
                              BoxConstraints(minWidth: 35, minHeight: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.redAccent,
              ),
              onPressed: () => Provider.of<Cart>(context, listen: false)
                  .removeItemFromCart(prodID: productID),
            )
          ],
        ),
      ),
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
        ),
      ),
    );
  }
}

// icon

// title:

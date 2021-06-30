import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/screen/wish_list_screen.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/badge_icon.dart';
import 'package:e_commerce_app/widgets/cart_item.dart';
import '../widgets/cart_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    Provider.of<Cart>(context, listen: false).getWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      drawer: AppDrawer(),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        title: Text(
          'Your Cart',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [
          Consumer<Cart>(
            builder: (ctx, savedItem, ch) => Badge(
              child: ch!,
              value: '${savedItem.savedItemCount}',
            ),
            child: IconButton(
              icon: Icon(
                Icons.bookmark_border_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(WishListProduct.routeName);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total:',
                  style: kPriceText.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Spacer(),
                Consumer<Cart>(
                  builder: (ctx, cart, _) => Text(
                    '\$${cartItem.total.toStringAsFixed(2)}',
                    style: kPriceText.copyWith(
                        color: Theme.of(context).accentColor),
                  ),
                ),
                SizedBox(width: 10),
                OrderButton(cartItem: cartItem),
              ],
            ),
          ),
          if (cartItem.count == 0)
            Center(
              child: Text(
                'You have empty cart. start shopping.',
                style: kTitleText,
              ),
            ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) {
              return Expanded(
                child: ListView.builder(
                  itemCount: cart.count,
                  itemBuilder: (BuildContext context, int index) {
                    return CartItem(
                      cartItem: cart.cart.values.toList()[index],
                      productID: cart.cart.keys.toList()[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final Cart cartItem;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (ctx, item, _) => ElevatedButton.icon(
        onPressed: widget.cartItem.total == 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Order>(context, listen: false).addOrders(
                    context,
                    widget.cartItem.cart.values.toList(),
                    widget.cartItem.total);
                setState(() {
                  _isLoading = false;
                });
                item.clear();
              },
        style: ElevatedButton.styleFrom(
          primary: ColorPalette.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(
          Icons.shopping_cart,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        label: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Order now',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
      ),
    );
  }
}

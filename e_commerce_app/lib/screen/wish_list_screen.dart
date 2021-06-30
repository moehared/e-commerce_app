import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/models/saved_item.dart';
import 'package:e_commerce_app/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListProduct extends StatelessWidget {
  static const routeName = '/WishListProduct';
  const WishListProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Cart>(context).savedItem;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wish List Item'),
      ),
      body: product.length == 0
          ? Center(
              child: Text('You have no wish list item added 🤭'),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return UserItem(
                    subTitle: '\$${product.values.toList()[i].price}',
                    imageURL: product.values.toList()[i].imageURL,
                    title: product.values.toList()[i].title,
                    id: product.values.toList()[i].productID);
              },
              itemCount: product.length,
            ),
    );
  }
}

// FutureBuilder<List<UserWishListProductModel>?>(
//           future: Provider.of<Cart>(context, listen: false).getWishList(),
//           builder: (ctx, savedSnapShot) {
//             if (savedSnapShot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (!savedSnapShot.hasError) {
//               return Center(
//                 child: Text(savedSnapShot.error.toString()),
//               );
//             } else if (savedSnapShot.data!.isEmpty) {
//               return Center(
//                 child: Text(savedSnapShot.data.toString()),
//               );
//             } else {
//               return ListView.builder(
//                 itemBuilder: (ctx, i) {
//                   final product = savedSnapShot.data;
//                   return UserItem(
//                       subTitle: '\$${product![i].price}',
//                       imageURL: product[i].imageURL,
//                       title: product[i].title,
//                       id: product[i].productID);
//                 },
//                 itemCount: savedSnapShot.data!.length,
//               );
//             }
//           },
//         ));

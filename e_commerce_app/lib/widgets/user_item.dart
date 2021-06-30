import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/screen/edit_product_screen.dart';
import 'package:e_commerce_app/screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final String imageURL;
  final String title;
  final String id;
  String subTitle = "";

  UserItem({
    required this.imageURL,
    required this.title,
    required this.id,
    this.subTitle = "",
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageURL),
            radius: 30,
            onBackgroundImageError: (dynamic, st) {
              print('something went wrong $st\n');
            },
          ),
          title: Text(title),
          subtitle: subTitle.isNotEmpty ? Text(subTitle) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subTitle.isEmpty)
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                ),
              if (subTitle.isNotEmpty)
                TextButton(
                  child: Text(
                    'view product',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        ProductDetailsScreen.routeName,
                        arguments: id);
                  },
                ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () async {
                    // delete item from user's product management
                    if (subTitle.isEmpty) {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(id, context);
                      } catch (e) {
                        scaffoldMessenger.hideCurrentSnackBar();
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            // duration: Duration(seconds: 1),
                            content: Text(
                              'Could not delete item',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    } else {
                      // remove item from wish list
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

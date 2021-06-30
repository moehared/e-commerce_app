import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/gridview_builder.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  static const routeName = '/FavouriteScreen';
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favItems = Provider.of<Products>(context, listen: false).favProduct;
    return Scaffold(
      drawer: AppDrawer(),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        title: Text(
          'Favourite',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Here Your favourite Item',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          if (favItems.isEmpty)
            Center(
                child: Text(
              'You have no Favourite product yet. 🥲',
              style: kTitleText,
            )),
          Expanded(
            child: GridViewBuilder(
              products: favItems,
            ),
          ),
        ],
      ),
    );
  }
}

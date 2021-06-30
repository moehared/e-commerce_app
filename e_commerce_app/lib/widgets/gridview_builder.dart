import 'dart:collection';

import 'package:e_commerce_app/data_source/dummy_data.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class GridViewBuilder extends StatelessWidget {
  GridViewBuilder({
    required this.products,
  });
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) =>
          // {
          //   final product = products[index];
          //   return ChangeNotifierProvider.(
          //     create: (ctx) => Product(
          //       id: product.id,
          //       title: product.title,
          //       price: product.price,
          //       categories: product.categories,
          //       images: product.images,
          //       size: product.size,
          //       colors: product.colors,
          //       description: product.description,
          //     ),
          //   );
          // },
          ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),

      itemCount: products.length,
    );
  }
}

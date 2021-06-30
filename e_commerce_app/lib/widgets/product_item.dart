import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/screen/product_details_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  ProductItem();
  // final Product product;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailsScreen.routeName,
                    arguments: product.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(product.images.elementAt(0)),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    print('tapped');

                    product.toggleIsFavourite(context);
                  },
                  child: Consumer<Product>(
                    builder: (ctx, prodData, _) => Icon(
                      prodData.isFavourite == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(product.title),
              Text(
                '\$${product.price}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

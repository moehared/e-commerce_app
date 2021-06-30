import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = '/UserProductScreen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchUserProduct(context);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final db = Provider.of<DatabaseServices>(context, listen: false);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: "");
              }),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : products.userProduct.length == 0
                    ? Center(
                        child: Text('You have no products. start adding now'),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProduct(context),
                        child:
                            // Consumer<Products>(
                            //   builder: (context, products, child) {
                            //     return ListView.builder(
                            //       itemBuilder: (_, i) => UserItem(
                            //           id: products.userProduct[i].id,
                            //           imageURL: products.userProduct[i].images
                            //               .elementAt(0),
                            //           title: products.userProduct[i].title),
                            //       // physics: BouncingScrollPhysics(), // not needed when referesh data
                            //       itemCount: products.userProduct.length,
                            //     );
                            //   },
                            // ),
                            StreamBuilder<QuerySnapshot>(
                          builder: (ctx, snapShot) {
                            List<Product> productList = [];
                            if (!snapShot.hasData) {
                              return Center(
                                child: Text('nothing to show yet'),
                              );
                            }
                            final productDoc = snapShot.data!.docs;

                            Product? product;
                            for (var item in productDoc) {
                              final data = item.data() as Map<String, dynamic>;
                              product = Product.fromJson(data);
                              productList.add(product);
                              // print(data);
                              print(
                                  'image at index 0 ${product.images.elementAt(0)}');
                              print('title ${product.title}');
                              print('id  ${product.id}');
                            }
                            // return Container();
                            return ListView.builder(
                              itemBuilder: (ctx, i) {
                                return UserItem(
                                  imageURL: productList[i].images.elementAt(0),
                                  title: productList[i].title,
                                  id: productList[i].id,
                                );
                              },
                              itemCount: productList.length,
                            );
                          },
                          stream: db.productCollection
                              .where('creatorID', isEqualTo: db.user.user!.uid)
                              .snapshots(),
                        ),
                      ),
      ),
    );
  }
}

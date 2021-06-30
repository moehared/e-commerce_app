import 'package:e_commerce_app/screen/cart_screen.dart';
import 'package:e_commerce_app/screen/favourite_screen.dart';
import 'package:e_commerce_app/screen/order_screen.dart';
import 'package:e_commerce_app/screen/product_overview.dart';
import 'package:e_commerce_app/screen/profile_screen.dart';
import 'package:e_commerce_app/screen/user_product_screen.dart';
import 'package:e_commerce_app/screen/wrapper_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:e_commerce_app/widgets/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                top: true,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 40,
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    // FutureBuilder(
                    //   future:
                    //       Provider.of<DatabaseServices>(context, listen: false)
                    //           .getUserInfo(),
                    //   builder: (ctx, data) {

                    //     return Text(data.data.toString());
                    //   },
                    // ),
                    Text(Provider.of<DatabaseServices>(context, listen: false)
                        .user
                        .user!
                        .displayName
                        .toString())
                  ],
                ),
              ),
            ),
            Divider(),
            // SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // BuildListTile(
                    //   iconData: Icons.person,
                    //   title: 'Profile',
                    //   onRoute: () {
                    //     print('profile tapped');
                    //     Navigator.pushReplacementNamed(
                    //         context, ProfileScreen.routeName);
                    //   },
                    // ),
                    BuildListTile(
                      iconData: Icons.favorite,
                      title: 'View Favourite Product',
                      onRoute: () {
                        Navigator.pushReplacementNamed(
                            context, FavouriteScreen.routeName);
                      },
                    ),
                    Divider(),
                    BuildListTile(
                      iconData: Icons.add_shopping_cart,
                      title: 'Shop',
                      onRoute: () {
                        Navigator.pushReplacementNamed(
                            context, ProductOverviewScreen.routeName);
                      },
                    ),
                    BuildListTile(
                      iconData: Icons.monetization_on,
                      title: 'Order',
                      onRoute: () {
                        print('profile tapped');
                        Navigator.pushReplacementNamed(
                            context, OrderScreen.routeName);
                      },
                    ),
                    BuildListTile(
                      iconData: Icons.shopping_cart_outlined,
                      title: 'Your Cart',
                      onRoute: () {
                        print('cart screen tapped');
                        Navigator.pushReplacementNamed(
                            context, CartScreen.routeName);
                      },
                    ),
                    BuildListTile(
                      iconData: Icons.edit,
                      title: 'Manage Product',
                      onRoute: () {
                        Navigator.pushReplacementNamed(
                            context, UserProductScreen.routeName);
                      },
                    ),
                    Divider(),
                    BuildListTile(
                      iconData: Icons.settings,
                      title: 'Setting',
                      onRoute: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Setting.routeName,
                        );
                      },
                    ),
                    BuildListTile(
                      iconData: Icons.exit_to_app,
                      title: 'sign out',
                      onRoute: () async {
                        print('current context: ->> $context\n');
                        await Provider.of<DatabaseServices>(context,
                                listen: false)
                            .signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WrapperAuthScreen()),
                          ModalRoute.withName(WrapperAuthScreen.routeName),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  const BuildListTile({
    required this.onRoute,
    required this.iconData,
    required this.title,
    Key? key,
  }) : super(key: key);
  final Function() onRoute;
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onRoute,
          leading: Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(title),
        ),
        // Divider(),
      ],
    );
  }
}

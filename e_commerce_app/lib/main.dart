import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/data_source/share_pref/dark_theme_manager.dart';
import 'package:e_commerce_app/data_source/share_pref/saved_wish_manager.dart';
import 'package:e_commerce_app/models/carts.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/screen/cart_screen.dart';
import 'package:e_commerce_app/screen/edit_product_screen.dart';
import 'package:e_commerce_app/screen/favourite_screen.dart';
import 'package:e_commerce_app/screen/order_screen.dart';

import 'package:e_commerce_app/screen/product_details_screen.dart';
import 'package:e_commerce_app/screen/product_overview.dart';
import 'package:e_commerce_app/screen/profile_screen.dart';
import 'package:e_commerce_app/screen/user_product_screen.dart';
import 'package:e_commerce_app/screen/wish_list_screen.dart';
import 'package:e_commerce_app/screen/wrapper_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:e_commerce_app/theme_mode/dark_theme.dart';
import 'package:e_commerce_app/widgets/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

final darkThemePref = DarkThemePreference.instance;
final wishListPref = SaveUserWishList.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<DatabaseServices>(context,listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyTheme()),
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Order()),
        ChangeNotifierProvider(
            create: (_) => DatabaseServices(FirebaseAuth.instance)),
      ],
      child: Consumer<DatabaseServices>(
        builder: (ctx, auth, _) {
          return Consumer<MyTheme>(
            builder: (ctx, theme, _) {
              return Listener(
                onPointerDown: (_) => auth.reload(),
                onPointerUp: (_) => auth.reload(),
                onPointerMove: (_) => auth.reload(),
                onPointerHover: (_) => auth.reload(),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: theme.theme,
                  theme: MyTheme.lightTheme,
                  darkTheme: MyTheme.darkTheme,
                  home: WrapperAuthScreen(),
                  routes: {
                    ProductDetailsScreen.routeName: (ctx) =>
                        ProductDetailsScreen(),
                    ProductOverviewScreen.routeName: (_) =>
                        ProductOverviewScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    FavouriteScreen.routeName: (ctx) => FavouriteScreen(),
                    ProfileScreen.routeName: (ctx) => ProfileScreen(),
                    OrderScreen.routeName: (ctx) => OrderScreen(),
                    Setting.routeName: (_) => Setting(),
                    EditProductScreen.routeName: (ctx) => EditProductScreen(),
                    UserProductScreen.routeName: (ctx) => UserProductScreen(),
                    WishListProduct.routeName: (_) => WishListProduct(),
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

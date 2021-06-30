import 'dart:convert';

import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/models/saved_item.dart';
import 'package:e_commerce_app/screen/wish_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserWishList {
  static const USER_WISH_KEY = "User_Item_wish_list";
  SaveUserWishList._init();
  static final SaveUserWishList _instance = SaveUserWishList._init();
  static SaveUserWishList get instance => _instance;

  Future<void> saveProduct(List<String> encodeProducts) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(USER_WISH_KEY, encodeProducts);
  }

  Future<Map<String, UserWishListProductModel>?> userWishList() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, UserWishListProductModel> savedProduct = {};
    if (!prefs.containsKey(USER_WISH_KEY)) {
      return null;
    }
    final savedList = prefs.getStringList(USER_WISH_KEY) ?? [];

    if (savedList.isNotEmpty) {
      savedList.forEach((element) {
        final decodedData = json.decode(element) as Map<String, dynamic>;
        final savedItem = UserWishListProductModel.fromJson(decodedData);
        savedProduct.putIfAbsent(savedItem.productID, () => savedItem);
        savedProduct.values.toList().forEach((element) {
          print('fetched saved item ---> ${element.title}\n');
        });
      });
    }

    return savedProduct;
  }

  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_WISH_KEY);
    print('removed user pref key\n');
  }
}

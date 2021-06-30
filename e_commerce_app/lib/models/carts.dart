import 'dart:collection';
import 'dart:convert';

import 'package:e_commerce_app/main.dart';
import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/models/saved_item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItem = {};

  Map<String, UserWishListProductModel> _savedCartItem = {};

  UnmodifiableMapView<String, CartItem> get cart {
    return UnmodifiableMapView(_cartItem);
  }

  UnmodifiableMapView<String, UserWishListProductModel> get savedItem {
    return UnmodifiableMapView(_savedCartItem);
  }

  int get count => _cartItem.length;
  double get total => _cartItem.values.toList().fold(
      0,
      (previousValue, element) =>
          previousValue + (element.price * element.quantity));

  // double get total2 {
  //   var sum = 0.0;
  //   for (var t in _cartItem.values.toList()) {
  //     sum += t.price * t.quantity;
  //   }
  //   return sum;
  // }
  void undoItem(String productID) {
    if (!_cartItem.containsKey(productID)) {
      return;
    } else if (_cartItem[productID]!.quantity > 1) {
      updateQuantity(productID: productID);
    } else {
      _cartItem.remove(productID);
    }
    notifyListeners();
  }

  void removeItemFromCart(
      {required String prodID, bool removedFromSavedItem = false}) {
    final item = removedFromSavedItem ? _savedCartItem : _cartItem;
    if (!item.containsKey(prodID)) {
      return;
    }
    item.remove(prodID);

    notifyListeners();
  }

  void savedCartItem(UserWishListProductModel savedProduct) {
    final List<String> _savedProductList = [];
    try {
      _savedCartItem.putIfAbsent(savedProduct.productID, () => savedProduct);
      _savedCartItem.values.toList().forEach((e) {
        final res = json.encode(e.toJson());
        _savedProductList.add(res);
      });

      notifyListeners();
      wishListPref.saveProduct(_savedProductList);
    } catch (e) {
      throw ('error occured while saving item $e');
    }
  }

  int get savedItemCount => _savedCartItem.length;

  Future<void> getWishList() async {
    final itemList = await wishListPref.userWishList();
    if (itemList == null) {
      return;
    }
    _savedCartItem = itemList;
    notifyListeners();
  }

  void updateQuantity({required String productID, bool isIncrease = false}) {
    if (!_cartItem.containsKey(productID)) {
      return;
    }
    if (isIncrease) {
      _cartItem.update(
        productID,
        (cart) => CartItem(
            id: cart.id,
            title: cart.title,
            size: cart.size,
            price: cart.price,
            color: cart.color,
            image: cart.image,
            quantity: cart.quantity + 1),
      );
    }
    if (_cartItem[productID]!.quantity > 1 && !isIncrease) {
      _cartItem.update(
        productID,
        (cart) => CartItem(
            id: cart.id,
            title: cart.title,
            size: cart.size,
            price: cart.price,
            color: cart.color,
            image: cart.image,
            quantity: cart.quantity - 1),
      );
    }
    notifyListeners();
  }

  // int quantity(productID) {
  //   if (_cartItem.containsKey(productID)) {
  //     return _cartItem[productID]!.quantity;
  //   }
  //   return -1;
  // }

  void addToCart(String productID, CartItem cartItem) {
    if (_cartItem.containsKey(productID)) {
      _cartItem.update(
        productID,
        (cart) => CartItem(
          color: cart.color,
          title: cart.title,
          size: cart.size,
          quantity: cart.quantity + 1,
          id: cart.id,
          image: cart.image,
          price: cart.price,
        ),
      );
    } else {
      _cartItem.putIfAbsent(productID, () => cartItem);
    }

    notifyListeners();
  }

  void clear() {
    _cartItem.clear();
    notifyListeners();
  }
}

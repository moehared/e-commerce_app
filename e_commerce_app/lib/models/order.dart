import 'dart:collection';

import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> cartItem;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.total,
    required this.cartItem,
    required this.dateTime,
  });

  OrderItem copyWith(
      {String? id,
      double? total,
      List<CartItem>? cartItem,
      DateTime? dateTime}) {
    return OrderItem(
      id: id ?? this.id,
      total: total ?? this.total,
      cartItem: cartItem ?? this.cartItem,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  OrderItem.fromJson(Map<String, dynamic> jsonData)
      : this.id = jsonData['id'],
        this.dateTime = DateTime.parse(jsonData['dateTime']),
        this.cartItem = (jsonData['products'] as List<dynamic>)
            .map((e) => CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title'],
                  size: e['size'],
                  image: e['image'],
                  color: e['color'],
                ))
            .toList(),
        this.total = jsonData['amount'];

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'amount': this.total,
      'products': this.cartItem.map((cartItem) => cartItem.toJson()).toList(),
      'dateTime': this.dateTime.toIso8601String()
    };
  }
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  UnmodifiableListView<OrderItem> get orders => UnmodifiableListView(_orders);

  Future<void> addOrders(context, List<CartItem> cart, double total) async {
    final database = Provider.of<DatabaseServices>(context, listen: false);
    final timeStamp = DateTime.now();
    var newOrder = OrderItem(
      id: Uuid().v4(),
      total: total,
      cartItem: cart,
      dateTime: timeStamp,
    );
    try {
      final orderCol = await database.orderCollection
          .doc(database.user.user!.uid)
          .collection('userOrder')
          // .where('author', isEqualTo: database.auth!.currentUser!.uid);
          .add(newOrder.toJson());

      newOrder = newOrder.copyWith(id: orderCol.id);
      orderCol.set(newOrder.toJson());
      print('new order id is : ${newOrder.id}\n');
      _orders.add(newOrder);
      print('added order successfully\n');
      notifyListeners();
    } catch (e) {
      throw ('error occurared while adding order $e \n');
    }
  }

  Future<void> fetchOrders(context) async {
    final database = Provider.of<DatabaseServices>(context, listen: false);
    final List<OrderItem> _loadedOrders = [];
    try {
      final orderCol = await database.orderCollection
          .doc(database.user.user!.uid)
          .collection('userOrder')
          .get();
      for (var doc in orderCol.docs) {
        final data = doc.data();
        _loadedOrders.add(OrderItem(
          id: doc.id,
          total: data['amount'],
          cartItem: (data['products'] as List<dynamic>)
              .map((e) => CartItem.fromJson(e))
              .toList(),
          dateTime: DateTime.parse(data['dateTime']),
        ));
        _orders = _loadedOrders;
        notifyListeners();
        print('order data is : $data');
      }
    } catch (e) {
      throw ('error happened while trying to fetch orders $e\n');
    }
  }
}

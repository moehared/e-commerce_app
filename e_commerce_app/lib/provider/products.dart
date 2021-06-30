import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../data_source/dummy_data.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';

// DatabaseServices _db = DatabaseServices(FirebaseAuth.instance);

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _userProduct = [];
  Set<Product> _recentQueryProduct = {};

  // final String userID;

  UnmodifiableListView<Product> get prodItem => UnmodifiableListView(_products);
  UnmodifiableListView<Product> get recentQueryItem =>
      UnmodifiableListView(_recentQueryProduct);
  UnmodifiableListView<Product> get userProduct =>
      UnmodifiableListView(_userProduct);
  UnmodifiableListView<Product> get favProduct {
    return UnmodifiableListView(
      _products.where((element) => element.isFavourite == true),
    );
  }

  void addRecentQuery(Product product) {
    _recentQueryProduct.add(product);
    print('added item to the recent list\n');
    notifyListeners();
  }

  UnmodifiableListView<Product> getCategoryItem(String id) {
    return UnmodifiableListView(
      _products.where((element) => element.categories.contains(id)).toList(),
    );
  }

  Product findProductByID(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product, context, id) async {
    product = product.copyWith(creatorID: id);
    print('added id is ${product.id}');
    final db = Provider.of<DatabaseServices>(context, listen: false);
    late final Product newProduct;
    try {
      final response = await db.productCollection.add(product.toJson());
      // await db.productCollection.doc().set(product.toJson());
      // final id = db.productCollection.doc().id;
      // print('id : $id');
      print(response.id);
      newProduct = Product(
        id: response.id,
        // id: id,
        title: product.title,
        price: product.price,
        creatorID: product.creatorID,
        categories: product.categories,
        images: product.images,
        size: product.size,
        colors: product.colors,
        description: product.description,
      );
      _products.add(newProduct);
      notifyListeners();
      db.productCollection.doc(response.id).set(newProduct.toJson());
      print('added product\n');
    } catch (e) {
      throw ('error occured. could not add product: Error ---> $e\n');
    }
  }

  Future<void> fetchUserProduct(context) async {
    List<Product> _loadedProduct = [];
    final db = Provider.of<DatabaseServices>(context, listen: false);
    print('current User logged in : ${db.user.user!.uid}\n');
    try {
      final query = await db.productCollection
          .where('creatorID', isEqualTo: db.user.user!.uid)
          .get();
      for (var doc in query.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _loadedProduct.insert(
          0,
          Product(
            id: doc.id,
            title: data['title'],
            price: data['price'],
            creatorID: data['creatorID']!,
            categories: (data['category'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            images: (data['images'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            size: (data['size'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            colors: (data['color'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            description: data['desc'],
          ),
        );
      }
      _userProduct = _loadedProduct;
      notifyListeners();
    } catch (e) {
      throw ('error occured while fetching user product $e');
    }
  }

  Future<void> fetchProduct(context) async {
    final List<Product> loadedProduct = [];

    final db = Provider.of<DatabaseServices>(context, listen: false);

    Map<String, bool> favProduct = {};
    final queryProduct = await db.productCollection.get();

    try {
      for (var doc in queryProduct.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final userFavQuery = await db.favCollection
            .doc(db.user.user!.uid)
            .collection(doc.id)
            .get();

        for (var favDoc in userFavQuery.docs) {
          final favData = favDoc.data();
          favProduct.putIfAbsent(doc.id, () => favData[doc.id] ?? false);
          // print('added favourite product is ${favProduct[doc.id]}\n');
        }

        loadedProduct.insert(
          0,
          Product(
            id: doc.id,
            title: data['title'],
            price: data['price'],
            creatorID: data['creatorID']!,
            categories: (data['category'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            images: (data['images'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            size: (data['size'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            colors: (data['color'] as List<dynamic>)
                .map((e) => e.toString())
                .toSet(),
            description: data['desc'],
            isFavourite: favProduct[doc.id] ?? false,
          ),
        );
        _products = loadedProduct;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product editProduct, context) async {
    final productIndex =
        _products.indexWhere((element) => element.id == editProduct.id);
    if (productIndex != -1) {
      final doc = Provider.of<DatabaseServices>(context, listen: false)
          .productCollection
          .doc(editProduct.id);
      try {
        await doc.update(editProduct.toJson());
      } catch (e) {
        throw ('error occured while trying to update database $e');
      }
      _products[productIndex] = editProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id, context) async {
    print('id is in delete func $id\n');
    final productCol =
        Provider.of<DatabaseServices>(context, listen: false).productCollection;
    final itemIndex = _userProduct.indexWhere(
        (element) => element.id == id); // find product index we want to delete
    var existingItem = _userProduct[
        itemIndex]; // cache product before we delete it in case of failure
    _userProduct.removeAt(itemIndex);
    notifyListeners();
    try {
      await productCol.doc(id).delete();
      print('id to be deleted is $id\n');
    } catch (e) {
      // if delete fails or any other error occurs then roll back to previous state
      _userProduct.insert(itemIndex, existingItem);
      notifyListeners();
      throw Exception('could not delete item');
    }
  }
}

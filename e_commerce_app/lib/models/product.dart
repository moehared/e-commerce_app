import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String title;
  final String id;
  final double price;
  final Set<String> images;
  final Set<String> size;
  final Set<String> colors;
  // final Map<String, Color> colors;
  final String description;
  final Set<String> categories;
  final String creatorID;
  bool isFavourite;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.creatorID,
    required this.categories,
    required this.images,
    required this.size,
    required this.colors,
    required this.description,
    this.isFavourite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    Set<String>? categories,
    Set<String>? images,
    Set<String>? size,
    Set<String>? colors,
    String? description,
    bool isFavourite = false,
    String? creatorID,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      size: size ?? this.size,
      colors: colors ?? this.colors,
      description: description ?? this.description,
      isFavourite: isFavourite,
      creatorID: creatorID ?? this.creatorID,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'price': this.price,
      'category': this.categories.toList(),
      'size': this.size.toList(),
      'desc': this.description,
      'color': this.colors.toList(),
      'images': this.images.toList(),
      'isFavourite': this.isFavourite,
      'creatorID': this.creatorID,
    };
  }

  Product.fromJson(Map<String, dynamic?> jsonData)
      : this.id = jsonData['id'] ?? "",
        this.title = jsonData['title'] ?? "",
        this.price = jsonData['price'] ?? 0.0,
        this.categories = (jsonData['category'] as List<dynamic>)
            .map((e) => e.toString())
            .toSet(),
        this.size = (jsonData['size'] as List<dynamic>)
            .map((e) => e.toString())
            .toSet(),
        this.description = jsonData['desc'],
        this.colors = (jsonData['color'] as List<dynamic>)
            .map((e) => e.toString())
            .toSet(),
        this.images = (jsonData['images'] as List<dynamic>)
            .map((e) => e.toString())
            .toSet(),
        this.isFavourite = jsonData['isFavourite'],
        this.creatorID = jsonData['creatorID'];

  void toggleIsFavourite(context) {
    final db = Provider.of<DatabaseServices>(context, listen: false);
    final favCollection = db.favCollection.doc(db.user.user!.uid);
    final oldValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response =
          favCollection.collection(id).doc(id).set({id: isFavourite});
      if (response.toString().isEmpty) {
        print('favourite response is empty\n');
        _rollBack(oldValue);
      }
    } catch (e) {
      _rollBack(oldValue);
    }
  }

  void _rollBack(bool value) {
    this.isFavourite = value;
    notifyListeners();
  }
}

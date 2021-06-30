import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/error/http_exceptions/http_exceptions.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as userModel;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseServices with ChangeNotifier {
  final FirebaseAuth? auth;
  userModel.User? userCredential;
  String? _token = "";
  DateTime? _expiryDate;
  Timer? _authTimer;
  UserCredential? _user;
  static const int TIME_EXTEND = 600;
  final _fireStore = FirebaseFirestore.instance;

  int? _timeToExpiry = 0;

  final _userCollection = FirebaseFirestore.instance.collection('user');
  final _productCollection = FirebaseFirestore.instance.collection('product');
  final _favCollection = FirebaseFirestore.instance.collection('userFavourite');
  final _orderCollection = FirebaseFirestore.instance.collection('Orders');
  final _storageRef = FirebaseStorage.instance.ref('userUploads');

  DatabaseServices(this.auth);

  CollectionReference get userCollection => _userCollection;
  CollectionReference get productCollection => _productCollection;
  CollectionReference get favCollection => _favCollection;
  CollectionReference get orderCollection => _orderCollection;
  Reference get storageRef => _storageRef;

  bool get isAuth {
    // print('isAuth value is $isValidToken\n');
    return isValidToken;
  }

  UserCredential get user => _user!;

  String get userID => user.user!.uid;
  String get token => _token!;

  Future<void> updateUserData(userModel.User user) async {
    return await _userCollection.doc(user.uuid).set(
          user.toJson(),
        );
  }

  bool get isValidToken {
    // print('user credentials inside valid token \n');
    // print('Token: $_token\nexpiryDate: $_expiryDate\n');
    return _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token!.isNotEmpty;
  }

  Future<void> _authenticate({
    bool isLogin = false,
    required userModel.User userCredential,
  }) async {
    try {
      if (isLogin) {
        _user = await auth!.signInWithEmailAndPassword(
          email: userCredential.email,
          password: userCredential.password,
        );

        print('display name: ${_user!.user!.displayName}\n');
      } else {
        // sign up here
        _user = await auth!.createUserWithEmailAndPassword(
          email: userCredential.email,
          password: userCredential.password,
        );

        userCredential = userCredential.copyWith(
          uuid: _user!.user!.uid,
          fullName: userCredential.fullName,
          email: userCredential.email,
          password: userCredential.password,
        );
        _user!.user!.updateProfile(displayName: userCredential.fullName);
        await updateUserData(userCredential);
      }

      final token = await _user!.user!.getIdTokenResult();
      _token = token.token;
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            token.expirationTime!.second.toString(),
          ),
        ),
      );

      print('Time expiration when user login/sign up !!\n');
      _timeToExpiry = _expiryDate!.second;
      print('time to expiry: ---> $_timeToExpiry');
      _autoLogOut();
      notifyListeners();
    } catch (e) {
      print('error occured in authentication: $e\n');
      throw HttpException(e.toString());
    }
  }

  Future<String> getUserInfo() async {
    final userInfo = await _userCollection.doc(user.user!.uid).get();
    return userInfo.data()!['fullName'];
    // print('user info is : ${userInfo.data()!['fullName']}');
  }

  Future<void> signIn(userModel.User user) async {
    return _authenticate(userCredential: user, isLogin: true);
  }

  Future<void> signUp(userModel.User user) async {
    return _authenticate(userCredential: user);
  }

  Future<void> signOut() async {
    await auth!.signOut();
    _token = "";
    _expiryDate = null;
    _authTimer != null ? _authTimer!.cancel() : null;
    notifyListeners();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final int? timeDiff =
        _expiryDate?.difference(DateTime.now()).inSeconds ?? -1;

    // print('Time to expiry diff is $timeDiff\n');

    if (timeDiff != -1) {
      _authTimer = Timer(Duration(seconds: timeDiff!), signOut);
    }
  }

  void reload() {
    if (_user != null) {
      if (_authTimer != null) {
        _authTimer!.cancel();
      }

      // final token = await _user!.user!.getIdTokenResult(true);
      _expiryDate = DateTime.now().add(Duration(
        seconds: TIME_EXTEND,
      ));

      // print(
      //     'time to extened is in reload method is  ${_expiryDate!.second} s \n');

      final int? timeToExpiry =
          _expiryDate?.difference(DateTime.now()).inSeconds ?? -1;

      if (timeToExpiry != -1) {
        // print('time diff in reload method is  $timeToExpiry s \n');
        _authTimer = Timer(Duration(seconds: timeToExpiry!), signOut);
      }
      // print('reloaded user activity!!\n');
      // print('expiryDate: ---> $_expiryDate\n\n');
      // notifyListeners();
    } else {
      // print('user not signed in yet\n');
      // notifyListeners();
    }
  }
}

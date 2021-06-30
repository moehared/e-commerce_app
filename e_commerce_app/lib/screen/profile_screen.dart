import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Center(
          child: Text("profile screen"),
        ),
      ),
    );
  }
}

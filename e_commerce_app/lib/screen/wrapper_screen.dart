import 'package:e_commerce_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'product_overview.dart';

class WrapperAuthScreen extends StatelessWidget {
  static const routeName = '/WrapperAuthScreen';
  const WrapperAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<DatabaseServices>(context);
    return auth.isAuth ? ProductOverviewScreen() : LoginScreen();
  }
}

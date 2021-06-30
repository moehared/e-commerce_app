import 'package:e_commerce_app/theme_mode/dark_theme.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  static const routeName = '/settings';
  const Setting();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<MyTheme>(context, listen: false);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text('setting'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode"),
                Switch.adaptive(
                  value: theme.isDark,
                  onChanged: (val) {
                    // print('inside setting screen\n\n');
                    // print('before theme is :${theme.currenTheme()}\n');
                    theme.switchTheme(val);
                    // print('after theme is :${theme.currenTheme()}\n');
                    // theme.
                    // print('current Theme is ${theme.darkTheme}');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

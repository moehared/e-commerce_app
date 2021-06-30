import 'package:e_commerce_app/data_source/dummy_data.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/provider/products.dart';
import 'package:e_commerce_app/screen/edit_product_screen.dart';
import 'package:e_commerce_app/services/database.dart';
import 'package:e_commerce_app/theme_mode/dark_theme.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/gridview_builder.dart';
import 'package:e_commerce_app/widgets/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductOverviewScreen';
  ProductOverviewScreen();

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  var isLoading = false;
  @override
  void initState() {
    _tabController =
        new TabController(length: categoryList.length, vsync: this);
    isLoading = true;

    Provider.of<DatabaseServices>(context, listen: false).getUserInfo();

    Provider.of<Products>(context, listen: false)
        .fetchProduct(context)
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // Future.delayed(Duration.zero).then((_) async {
    //   await Provider.of<DatabaseServices>(context, listen: false)
    //       .fetchProduct(context);
    // });
    super.initState();
  }

  // void getData() async {
  //   await Provider.of<DatabaseServices>(context, listen: false)
  //       .fetchProduct(context);
  // }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showModalBottom(context) {
    // _scaffoldKey.currentState!.showBottomSheet((context) => Setting());
    showModalBottomSheet(context: context, builder: (ctx) => Setting());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<MyTheme>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: theme.backgroundColor,
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          iconWidget(
            iconData: Icons.search,
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          iconWidget(
            // theme: theme,
            iconData: Icons.add,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: "");
            },
          ),
        ],
      ),

      body: SafeArea(
        top: true,
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10),
              // height: 70,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                // labelColor: Theme.of(context).accentColor,
                // indicatorWeight: 5,
                labelStyle: TextStyle(fontSize: 20),

                tabs: categoryList
                    .map<Widget>(
                      (e) => Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 5, bottom: 5),
                        child: Text(
                          e.title,
                        ),
                      ),
                    )
                    .toList(),
                indicator: BoxDecoration(
                  color: theme.currenTheme() == ThemeMode.dark
                      ? ColorPalette.buttonBackgroundColor
                      : ColorPalette.textSizeBackground,
                  // color: ColorPalette.textSizeBackground,
                  borderRadius: BorderRadius.circular(20),
                  // shape: BoxShape.rectangle,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Consumer<DatabaseServices>(
                builder: (ctx, db, _) => Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: categoryList.map<Widget>((e) {
                      final prod = Provider.of<Products>(context, listen: false)
                          .getCategoryItem(e.id);
                      return GridViewBuilder(products: prod);
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget iconWidget({
    // required MyTheme theme,
    required IconData iconData,
    required final Function() onPressed,
  }) =>
      IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          // color: theme.iconColor,
        ),
      );
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Theme.of(context).accentColor,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final prod = Provider.of<Products>(context, listen: false);
    final product = prod.recentQueryItem
        .where((element) => element.title.toLowerCase().contains(query))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridViewBuilder(products: product),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final prod = Provider.of<Products>(context, listen: true);
    final suggestionList = query.isEmpty
        ? prod.recentQueryItem
        : prod.prodItem
            .where((element) => element.title.toLowerCase().startsWith(query))
            .toList();
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
          onTap: () {
            prod.addRecentQuery(suggestionList[index]);
            showResults(context);
          },
          title: RichText(
            text: TextSpan(
                text: suggestionList[index]
                    .title
                    .toLowerCase()
                    .substring(0, query.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
                children: [
                  TextSpan(
                    text: suggestionList[index].title.substring(query.length),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ]),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}

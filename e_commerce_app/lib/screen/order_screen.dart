import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/screen/loading_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';

import '../widgets/order_item.dart' as orderWidget;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final orders;
  Future get getOrders =>
      Provider.of<Order>(context, listen: false).fetchOrders(context);

  @override
  void initState() {
    orders = getOrders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: orders,
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loading(),
            );
          } else if (data.error != null) {
            return Center(
              child: Text('error occured${data.error}'),
            );
          } else if (Provider.of<Order>(context, listen: false).orders.length ==
              0) {
            return Center(
              child: Text('You have no orders yet. start ordering now 😃'),
            );
          } else {
            return Consumer<Order>(
              builder: (context, orderItem, _) {
                return ListView.builder(
                  itemBuilder: (ctx, index) =>
                      orderWidget.OrderItem(orderItem.orders[index]),
                  itemCount: orderItem.orders.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}

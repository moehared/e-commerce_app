import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart' as order;

class OrderItem extends StatefulWidget {
  final order.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: isExpanded,
            // collapsedBackgroundColor: Colors.red,
            collapsedIconColor: Theme.of(context).accentColor,

            // expandedAlignment: Alignment.topLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.center,
            onExpansionChanged: (state) {
              setState(() {
                isExpanded = !state;
              });
            },
            childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              Container(
                height:
                    min(widget.orderItem.cartItem.length * 20.0 + 10.0, 100.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: widget.orderItem.cartItem
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              'quantity ${e.quantity}x \$${e.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            title: Text(
              '\$${widget.orderItem.total.toStringAsFixed(2)}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            subtitle: Text(
              '${DateFormat.yMMMEd().format(widget.orderItem.dateTime)}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
